"""Offline character editor, using the native ten-byte skill layout."""
from contextlib import closing
import hashlib
import json
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel, Field, ConfigDict


RACES = {
    1: [(1, "Arch Tuarek"), (2, "Tuarek"), (3, "Wrinkle Tuarek"), (4, "Puri Tuarek"), (6, "Kurian")],
    2: [(11, "Barbarian"), (12, "El Morad erkek"), (13, "El Morad kadın"), (14, "Porutu")],
}
JOBS = [
    ("Warrior", (1, 5, 6), {1: [1], 2: [11, 12, 13]}),
    ("Rogue", (2, 7, 8), {1: [2], 2: [12, 13]}),
    ("Mage", (3, 9, 10), {1: [3], 2: [12, 13]}),
    ("Priest", (4, 11, 12), {1: [2, 4], 2: [12, 13]}),
    ("Kurian / Porutu", (13, 14, 15), {1: [6], 2: [14]}),
]
STAGES = ["Başlangıç", "İlk meslek", "Master"]
CLASSES = {
    nation * 100 + suffix: {"id": nation * 100 + suffix, "nation": nation,
        "label": f"{job} · {STAGES[stage]}", "job": job, "stage": stage, "races": races[nation]}
    for nation in (1, 2) for job, suffixes, races in JOBS
    for stage, suffix in enumerate(suffixes)
}


class CharacterUpdate(BaseModel):
    model_config = ConfigDict(extra="forbid")
    character: str = Field(min_length=1, max_length=20, pattern=r"^[^\x00-\x1f]+$")
    revision: str = Field(min_length=64, max_length=64)
    level: int = Field(ge=1, le=83, strict=True)
    exp: int = Field(ge=0, le=9223372036854775807, strict=True)
    nation: int = Field(ge=1, le=2, strict=True)
    race: int = Field(ge=1, le=14, strict=True)
    class_id: int = Field(ge=101, le=215, strict=True)
    strong: int = Field(ge=1, le=255, strict=True)
    sta: int = Field(ge=1, le=255, strict=True)
    dex: int = Field(ge=1, le=255, strict=True)
    intel: int = Field(ge=1, le=255, strict=True)
    cha: int = Field(ge=1, le=255, strict=True)
    points: int = Field(ge=0, le=32767, strict=True)
    skill_free: int = Field(ge=0, le=255, strict=True)
    skill_1: int = Field(ge=0, le=83, strict=True)
    skill_2: int = Field(ge=0, le=83, strict=True)
    skill_3: int = Field(ge=0, le=83, strict=True)
    skill_master: int = Field(ge=0, le=23, strict=True)


def read_character(c, name, lock=False):
    hint = " WITH (UPDLOCK, HOLDLOCK)" if lock else ""
    c.execute(f"""SELECT strUserID, Nation, Race, Class, [Level], Exp, Points,
        Strong, Sta, Dex, Intel, Cha, bRebirthLevel, Knights, Zone, Face, HairRGB,
        CONVERT(varbinary(10), CONVERT(varchar(10), strSkill)) AS skill_bytes
        FROM USERDATA{hint} WHERE strUserID=?""", (name,))
    row = c.fetchone()
    if not row:
        raise HTTPException(404, "Karakter bulunamadı.")
    keys = ["character", "nation", "race", "class_id", "level", "exp", "points",
            "strong", "sta", "dex", "intel", "cha", "rebirth", "clan", "zone", "face", "hair", "skill_bytes"]
    state = dict(zip(keys, row))
    state["character"] = state["character"].strip()
    skill = bytes(state.pop("skill_bytes") or b"")
    if len(skill) != 10:
        raise HTTPException(409, "Skill kaydı beklenen 10 bayt biçiminde değil; kayıt otomatik değiştirilmedi.")
    state["skill_hex"] = skill.hex()
    for key, index in [("skill_free", 0), ("skill_1", 5), ("skill_2", 6), ("skill_3", 7), ("skill_master", 8)]:
        state[key] = skill[index]
    c.execute(f"""SELECT strAccountID, bNation, strCharID1, strCharID2, strCharID3, strCharID4
        FROM ACCOUNT_CHAR{hint} WHERE strCharID1=? OR strCharID2=? OR strCharID3=? OR strCharID4=?""", (name,) * 4)
    account = c.fetchone()
    if not account:
        raise HTTPException(409, "Karakterin hesap kaydı bulunamadı.")
    state["account"] = account[0].strip()
    state["account_nation"] = account[1]
    state["account_characters"] = [v.strip() for v in account[2:] if v and v.strip()]
    # Include the whole account: another logged-in character can overwrite account state.
    c.execute(f"SELECT TOP 1 strCharID FROM CURRENTUSER{hint} WHERE strAccountID=? OR strCharID=?", (state["account"], name))
    state["is_online"] = c.fetchone() is not None
    revision_fields = {k: v for k, v in state.items() if k != "is_online"}
    state["revision"] = hashlib.sha256(json.dumps(revision_fields, sort_keys=True, ensure_ascii=False).encode("utf8")).hexdigest()
    c.execute("SELECT exp FROM LEVEL_UP WHERE [level]=? AND rebithlevel=?", (state["level"], state["rebirth"]))
    exp_row = c.fetchone()
    state["exp_to_next"] = int(exp_row[0]) if exp_row else None
    return state


def validate_update(req, old, exp_limit):
    job = CLASSES.get(req.class_id)
    if not job or job["nation"] != req.nation or req.race not in job["races"]:
        raise HTTPException(422, "Ülke, ırk ve sınıf birbiriyle uyumlu değil.")
    if job["stage"] == 1 and req.level < 10:
        raise HTTPException(422, "İlk meslek için seviye en az 10 olmalı.")
    if job["stage"] == 2 and req.level < 60:
        raise HTTPException(422, "Master sınıfı için seviye en az 60 olmalı.")
    skills = [req.skill_1, req.skill_2, req.skill_3]
    if any(v > req.level for v in skills):
        raise HTTPException(422, "Bir skill dalının puanı karakter seviyesini aşamaz.")
    if job["stage"] == 0 and any(skills + [req.skill_master]):
        raise HTTPException(422, "Başlangıç sınıfına dağıtılmış skill puanı verilemez.")
    if req.skill_master and (job["stage"] != 2 or req.skill_master > max(0, req.level - 60)):
        raise HTTPException(422, "Master skill puanı için Master sınıfı ve 60 üzeri seviye gerekir.")
    if old["class_id"] != req.class_id and any(skills + [req.skill_master]):
        raise HTTPException(422, "Sınıf değişiminde önce dağıtılmış skill dallarını sıfırlayın.")
    if exp_limit is None or req.exp >= exp_limit:
        raise HTTPException(422, "EXP, seçilen seviye için gereken EXP değerinden küçük olmalı.")
    if req.nation != old["nation"]:
        if old["clan"]:
            raise HTTPException(422, "Ülke değişimi için karakter önce klanından ayrılmalı.")
        if len(old["account_characters"]) != 1:
            raise HTTPException(422, "Hesapta başka karakterler var. Ülke değişimi tüm hesap için birlikte yapılmalı; bu ekrandan tek karakter değiştirilemez.")
        if old["zone"] != 21:
            raise HTTPException(422, "Ülke değişimi için karakteri önce Moradon'a götürün ve oyundan çıkın.")


def save_character(conn, req):
    c = conn.cursor()
    c.execute("SET XACT_ABORT ON; SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;")
    old = read_character(c, req.character, lock=True)
    if old["is_online"]:
        raise HTTPException(409, "Hesap çevrimiçi. Oyundan normal çıkış yapın, ardından mevcut değerleri yeniden yükleyin.")
    if old["revision"] != req.revision:
        raise HTTPException(409, "Karakter verileri değişmiş. Mevcut değerleri yeniden yükleyip tekrar düzenleyin.")
    c.execute("SELECT exp FROM LEVEL_UP WHERE [level]=? AND rebithlevel=?", (req.level, old["rebirth"]))
    limit_row = c.fetchone()
    validate_update(req, old, int(limit_row[0]) if limit_row else None)
    raw = bytearray.fromhex(old["skill_hex"])
    for index, value in [(0, req.skill_free), (5, req.skill_1), (6, req.skill_2), (7, req.skill_3), (8, req.skill_master)]:
        raw[index] = value
    # Keep reserved skill bytes (1..4,9). Use SQL's ANSI code page for native SQL_CHAR loading.
    c.execute("""UPDATE USERDATA SET [Level]=?, Exp=?, Nation=?, Race=?, Class=?,
        Strong=?, Sta=?, Dex=?, Intel=?, Cha=?, Points=?,
        strSkill=CONVERT(nvarchar(10), CONVERT(varchar(10), CAST(? AS varbinary(10))))
        WHERE strUserID=?""", (req.level, req.exp, req.nation, req.race, req.class_id,
        req.strong, req.sta, req.dex, req.intel, req.cha, req.points, bytes(raw), old["character"]))
    if req.race != old["race"]:
        c.execute("UPDATE USERDATA SET Face=0, HairRGB=0 WHERE strUserID=?", (old["character"],))
    if req.nation != old["nation"]:
        c.execute("UPDATE ACCOUNT_CHAR SET bNation=? WHERE strAccountID=?", (req.nation, old["account"]))
    shortcut_backup = None
    if req.class_id != old["class_id"]:
        c.execute("SELECT nCount, strSkillData FROM USERDATA_SKILLSHORTCUT WHERE strCharID=?", (old["character"],))
        shortcut_row = c.fetchone()
        if shortcut_row:
            shortcut_backup = {"count": shortcut_row[0], "data": bytes(shortcut_row[1] or b"").hex()}
        c.execute("UPDATE USERDATA_SKILLSHORTCUT SET nCount=0, strSkillData=0x00 WHERE strCharID=?", (old["character"],))
    new = read_character(c, old["character"])
    if new["skill_hex"] != bytes(raw).hex():
        raise HTTPException(409, "Skill baytları veritabanından aynı biçimde okunamadı; işlem geri alındı.")
    c.execute("""INSERT INTO KNIGHTLAB_CHARACTER_EDIT_AUDIT (CharacterName, BeforeJson, AfterJson)
        OUTPUT INSERTED.Id VALUES (?, ?, ?)""", (old["character"],
        json.dumps({**old, "shortcut_backup": shortcut_backup}, ensure_ascii=False), json.dumps(new, ensure_ascii=False)))
    audit_id = c.fetchone()[0]
    return {"success": True, "message": f"{old['character']} güncellendi. Yeni değerler sonraki oyun girişinde geçerli.", "character": new, "audit_id": audit_id}


def create_character_router(get_db):
    router = APIRouter()

    @router.get("/api/character-editor/options")
    def options():
        return {"classes": list(CLASSES.values()), "races": [
            {"id": race, "label": label, "nation": nation} for nation, races in RACES.items() for race, label in races],
            "max_level": 83}

    @router.get("/api/character-editor/{name}")
    def get_character(name: str):
        with closing(get_db()) as conn:
            return read_character(conn.cursor(), name)

    @router.post("/api/character-editor")
    def update_character(req: CharacterUpdate):
        with closing(get_db()) as conn:
            try:
                result = save_character(conn, req)
                conn.commit()
                return result
            except Exception:
                conn.rollback()
                raise

    return router


def install_audit_schema(get_db):
    with closing(get_db()) as conn:
        conn.cursor().execute("""IF OBJECT_ID(N'dbo.KNIGHTLAB_CHARACTER_EDIT_AUDIT', N'U') IS NULL
            CREATE TABLE dbo.KNIGHTLAB_CHARACTER_EDIT_AUDIT (
                Id bigint IDENTITY(1,1) PRIMARY KEY,
                EditedUtc datetime2 NOT NULL DEFAULT SYSUTCDATETIME(),
                CharacterName nvarchar(21) NOT NULL,
                BeforeJson nvarchar(max) NOT NULL,
                AfterJson nvarchar(max) NOT NULL);""")
        conn.commit()
