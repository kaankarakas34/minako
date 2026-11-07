import os
import re
import socket
import pyodbc
from typing import Optional, List
from fastapi import FastAPI, HTTPException
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

app = FastAPI(title="Knight Online Local GM Admin Panel")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8080", "http://127.0.0.1:8080"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

DB_CONN_STR = (
    "DRIVER={ODBC Driver 18 for SQL Server};"
    "SERVER=.\\KNIGHTLOCAL;"
    "DATABASE=KNIGHT_TEMU_2239;"
    "Trusted_Connection=yes;"
    "TrustServerCertificate=yes;"
)

ICONS_DIR = r"C:\Users\murat\KnightOnlineLab\ClientGamesoft\GameSoft\ui\itemicons"

def get_db():
    return pyodbc.connect(DB_CONN_STR, timeout=5)

from character_management import create_character_router, install_audit_schema
install_audit_schema(get_db)
app.include_router(create_character_router(get_db))

def check_port(host: str, port: int) -> bool:
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(0.5)
            return s.connect_ex((host, port)) == 0
    except Exception:
        return False

# Global in-memory cache for ultra-fast Knight Online item icon resolution
ITEM_ICON_MAP = {}
AVAILABLE_ICONS = set()

def init_icon_cache():
    global AVAILABLE_ICONS, ITEM_ICON_MAP
    if os.path.isdir(ICONS_DIR):
        AVAILABLE_ICONS = set(os.listdir(ICONS_DIR))
    try:
        with get_db() as conn:
            c = conn.cursor()
            c.execute("SELECT Num, itemiconid1 FROM ITEM WHERE itemiconid1 IS NOT NULL AND itemiconid1 > 0")
            ITEM_ICON_MAP = {r[0]: r[1] for r in c.fetchall()}
        print(f" [Icon Engine] {len(ITEM_ICON_MAP):,} itemiconid1 eşleştirmesi ve {len(AVAILABLE_ICONS):,} PNG ikonu hafızaya yüklendi.")
    except Exception as e:
        print(f" [Icon Engine] Uyarı: İkon tablosu yüklenemedi: {e}")

def get_icon_url(item_num_or_icon_id: Optional[int] = None, fallback_item_num: Optional[int] = None) -> Optional[str]:
    if not item_num_or_icon_id and not fallback_item_num:
        return None

    targets = []
    if item_num_or_icon_id:
        targets.append(item_num_or_icon_id)
        if item_num_or_icon_id in ITEM_ICON_MAP:
            targets.append(ITEM_ICON_MAP[item_num_or_icon_id])
    if fallback_item_num:
        targets.append(fallback_item_num)
        if fallback_item_num in ITEM_ICON_MAP:
            targets.append(ITEM_ICON_MAP[fallback_item_num])

    for val in targets:
        s = str(val)
        cands = []
        if len(s) == 8:
            cands.append(f"itemicon_{s[0]}_{s[1:5]}_{s[5:7]}_{s[7]}.png")
            cands.append(f"itemicon_{s[:2]}_{s[2:6]}_{s[6:8]}.png")
        elif len(s) == 9:
            s8 = s[:8]
            cands.append(f"itemicon_{s8[0]}_{s8[1:5]}_{s8[5:7]}_{s8[7]}.png")
            cands.append(f"itemicon_{s[:2]}_{s[2:6]}_{s[6:8]}_{s[8]}.png")

        for fn in cands:
            if fn in AVAILABLE_ICONS:
                return f"/item-icons/{fn}"

    return None
init_icon_cache()


def extract_base_name(name: str) -> str:
    return re.sub(r'\s*\(\+[0-9]+\)', '', name).strip()

# Pydantic Request Models
class GiveGoldReq(BaseModel):
    character: str
    amount: int
    mode: str = "add"

class GiveKcReq(BaseModel):
    character: str
    amount: int

class GiveItemReq(BaseModel):
    character: str
    item_id: int
    count: int = 1

class ForgeItemReq(BaseModel):
    character: str
    base_item_id: int
    name: str
    damage: int = 0
    ac: int = 0
    strb: int = 0
    stab: int = 0
    dexb: int = 0
    intelb: int = 0
    chab: int = 0
    maxhpb: int = 0
    maxmpb: int = 0
    firedamage: int = 0
    icedamage: int = 0
    lightningdamage: int = 0
    poisondamage: int = 0
    hpdrain: int = 0
    mpdrain: int = 0
    count: int = 1

class SetLevelReq(BaseModel):
    character: str
    level: int

class SetAuthorityReq(BaseModel):
    character: str
    authority: int  # 0 = GM, 1 = Player

class SpawnBossReq(BaseModel):
    ssid: int
    zone: int
    x: float = 0.0
    y: float = 0.0
    z: float = 0.0
    count: int = 1
    target_player: Optional[str] = None

class KillMobsReq(BaseModel):
    zone: int

class NoticeReq(BaseModel):
    message: str
    notice_type: str = "notice"

class TeleportReq(BaseModel):
    character: str
    zone: int
    x: float
    z: float

class KickReq(BaseModel):
    character: str

class PunishReq(BaseModel):
    character: str
    duration_minutes: int = 60

class UnpunishReq(BaseModel):
    character: str

class BanReq(BaseModel):
    character: str

class UnbanReq(BaseModel):
    character: str

class MuteReq(BaseModel):
    character: str

class UnmuteReq(BaseModel):
    character: str

class AttackControlReq(BaseModel):
    character: str
    disable: bool = True

class WarControlReq(BaseModel):
    war_type: int = 1
    action: str = "open"  # 'open' or 'close'

class EventBonusReq(BaseModel):
    bonus_type: str = "EXP"
    percent: int = 50

# Status endpoint
@app.get("/api/status")
def get_status():
    game_server = check_port("127.0.0.2", 15001) or check_port("127.0.0.1", 15001)
    login_server = check_port("127.0.0.1", 15100)
    relay = check_port("127.0.0.2", 15100)
    
    char_count = 0
    account_count = 0
    online_count = 0
    try:
        with get_db() as conn:
            c = conn.cursor()
            c.execute("SELECT COUNT(*) FROM USERDATA")
            char_count = c.fetchone()[0]
            c.execute("SELECT COUNT(*) FROM TB_USER")
            account_count = c.fetchone()[0]
            c.execute("SELECT COUNT(*) FROM CURRENTUSER")
            online_count = c.fetchone()[0]
    except Exception:
        pass
        
    return {
        "game_server": game_server,
        "login_server": login_server,
        "relay": relay,
        "char_count": char_count,
        "account_count": account_count,
        "online_count": online_count
    }

def get_job_info(class_id: int):
    if class_id in (101, 105, 106, 201, 205, 206):
        category = "warrior"
        title = "Warrior"
    elif class_id in (102, 107, 108, 202, 207, 208):
        category = "rogue"
        title = "Rogue"
    elif class_id in (103, 109, 110, 203, 209, 210):
        category = "mage"
        title = "Mage"
    elif class_id in (104, 111, 112, 204, 211, 212):
        category = "priest"
        title = "Priest"
    elif class_id in (113, 114, 115, 213, 214, 215):
        category = "kurian"
        title = "Kurian"
    else:
        category = "warrior"
        title = "Warrior"
    
    specific_titles = {
        101: "Beginner Warrior", 105: "Berserker", 106: "Guardian",
        102: "Beginner Rogue", 107: "Hunter", 108: "Penetrator",
        103: "Beginner Mage", 109: "Sorcerer", 110: "Necromancer",
        104: "Beginner Priest", 111: "Shaman", 112: "Dark Priest",
        113: "Kurian", 114: "Novice Kurian", 115: "Master Kurian",
        201: "Beginner Warrior", 205: "Blade", 206: "Protector",
        202: "Beginner Rogue", 207: "Ranger", 208: "Assassin",
        203: "Beginner Mage", 209: "Mage", 210: "Enchanter",
        204: "Beginner Priest", 211: "Cleric", 212: "Druid",
        213: "Porutu", 214: "Novice Porutu", 215: "Master Porutu"
    }
    return category, specific_titles.get(class_id, title)

@app.get("/api/characters")
def get_characters():
    return search_characters(q="", status="all", nation="all", job="all", limit=200)

@app.get("/api/characters/search")
def search_characters(q: str = "", status: str = "all", nation: str = "all", job: str = "all", limit: int = 200):
    all_chars = []
    total_online = 0
    total_offline = 0

    with get_db() as conn:
        c = conn.cursor()
        sql = """
            SELECT u.struserid, u.level, u.gold, u.points, u.zone, u.authority, 
                   u.race, u.class, ISNULL(u.nation, CASE WHEN u.race <= 4 THEN 1 ELSE 2 END) AS nation,
                   u.exp, u.strong, u.sta, u.dex, u.intel, u.cha,
                   ac.straccountid, ISNULL(tb.cashpoint, 0) as cash,
                   CASE WHEN cu.strcharid IS NOT NULL THEN 1 ELSE 0 END AS is_online,
                   ISNULL(u.timepunishment, 0) AS timepunishment
            FROM USERDATA u
            LEFT JOIN CURRENTUSER cu ON cu.strcharid = u.struserid
            LEFT JOIN ACCOUNT_CHAR ac ON (ac.strcharid1 = u.struserid OR ac.strcharid2 = u.struserid OR ac.strcharid3 = u.struserid OR ac.strcharid4 = u.struserid)
            LEFT JOIN TB_USER tb ON tb.straccountid = ac.straccountid
            ORDER BY is_online DESC, u.level DESC, u.struserid ASC
        """
        c.execute(sql)
        for row in c.fetchall():
            name = row[0].strip() if row[0] else ""
            level = row[1]
            gold = row[2]
            points = row[3]
            zone = row[4]
            authority = row[5]
            race = row[6]
            cls = row[7]
            nat = row[8]
            acc = row[15].strip() if row[15] else "Bilinmiyor"
            cash = row[16]
            is_online = bool(row[17])
            time_punishment = int(row[18])

            if is_online:
                total_online += 1
            else:
                total_offline += 1

            cat, title = get_job_info(cls)
            nat_name = "Karus" if (nat == 1 or race <= 4) else "El Morad"

            punish_text = ""
            if time_punishment > 0:
                hours = time_punishment // 3600
                mins = (time_punishment % 3600) // 60
                punish_text = f"{hours} sa {mins} dk" if hours > 0 else f"{mins} dk"

            all_chars.append({
                "name": name,
                "level": level,
                "gold": gold,
                "points": points,
                "zone": zone,
                "authority": authority,
                "is_gm": authority == 0,
                "is_banned": authority == 255,
                "is_muted": authority == 11,
                "is_punished": time_punishment > 0,
                "punish_seconds": time_punishment,
                "punish_text": punish_text,
                "race": race,
                "class": cls,
                "job": cat.capitalize(),
                "job_category": cat,
                "job_title": title,
                "nation": nat,
                "nation_name": nat_name,
                "account": acc,
                "cash": cash,
                "is_online": is_online
            })

    query = q.strip().lower()
    filtered = all_chars

    if query:
        filtered = [c for c in filtered if query in c["name"].lower() or query in c["account"].lower()]

    if status == "online":
        filtered = [c for c in filtered if c["is_online"]]
    elif status == "offline":
        filtered = [c for c in filtered if not c["is_online"]]

    if nation == "karus":
        filtered = [c for c in filtered if c["nation"] == 1 or c["race"] <= 4]
    elif nation == "elmorad":
        filtered = [c for c in filtered if c["nation"] == 2 or c["race"] > 4]

    if job in ("warrior", "rogue", "mage", "priest", "kurian"):
        filtered = [c for c in filtered if c["job_category"] == job]

    return {
        "total": len(filtered),
        "online_count": total_online,
        "offline_count": total_offline,
        "characters": filtered[:limit]
    }

@app.get("/api/bosses/presets")
def get_boss_presets():
    return [
        {"name": "Felankor", "ssid": 5702, "level": 230, "icon": "dragon"},
        {"name": "Ultima", "ssid": 6551, "level": 250, "icon": "skull"},
        {"name": "Isiloon", "ssid": 5701, "level": 170, "icon": "eye"},
        {"name": "Talos", "ssid": 2405, "level": 140, "icon": "shield-virus"},
        {"name": "Snake Queen", "ssid": 2005, "level": 100, "icon": "staff-snake"},
        {"name": "Harpy Queen", "ssid": 2205, "level": 110, "icon": "crow"},
        {"name": "Deruvish Founder", "ssid": 2105, "level": 100, "icon": "hat-wizard"},
        {"name": "Troll King", "ssid": 2305, "level": 120, "icon": "hammer"},
        {"name": "Attila", "ssid": 1405, "level": 80, "icon": "horse-head"},
        {"name": "Samma", "ssid": 1306, "level": 90, "icon": "axe"},
        {"name": "Shaula", "ssid": 914, "level": 75, "icon": "spider"},
        {"name": "Lesath", "ssid": 917, "level": 75, "icon": "bug"},
        {"name": "Bach", "ssid": 1206, "level": 60, "icon": "ring"},
        {"name": "Duke", "ssid": 1205, "level": 55, "icon": "ring"},
        {"name": "Bishop", "ssid": 1207, "level": 65, "icon": "ring"},
        {"name": "Lobo", "ssid": 802, "level": 60, "icon": "dog"},
        {"name": "Lycaon", "ssid": 801, "level": 60, "icon": "dog"},
        {"name": "Lupus", "ssid": 803, "level": 60, "icon": "dog"},
        {"name": "Orc Bandit Leader", "ssid": 505, "level": 70, "icon": "mask"},
        {"name": "Bone Collector", "ssid": 1105, "level": 65, "icon": "bone"}
    ]

@app.get("/api/bosses/search")
def search_mobs(q: str):
    results = []
    if not q or len(q.strip()) < 2:
        return results
    query = q.strip()
    with get_db() as conn:
        c = conn.cursor()
        if query.isdigit():
            c.execute("""
                SELECT TOP 30 sSid, strName, sLevel, iExp, iMaxHp 
                FROM K_NPC WHERE sSid = ? OR sSid LIKE ?
                ORDER BY sLevel DESC
            """, (int(query), f"%{query}%"))
        else:
            c.execute("""
                SELECT TOP 30 sSid, strName, sLevel, iExp, iMaxHp 
                FROM K_NPC WHERE strName LIKE ? 
                ORDER BY sLevel DESC
            """, (f"%{query}%",))
        for row in c.fetchall():
            results.append({
                "ssid": row[0],
                "name": row[1].strip() if row[1] else "Bilinmiyor",
                "level": row[2],
                "exp": row[3],
                "hp": row[4]
            })
    return results

@app.get("/api/items/search")
def search_items(
    q: str = "",
    category: str = "all",
    sub_category: str = "all",
    base_only: bool = False,
    sort: str = "default",
    page: int = 1,
    limit: int = 30
):
    results = []
    page = max(1, page)
    limit = max(1, min(100, limit))
    offset = (page - 1) * limit

    category_kind_map = {
        "weapon": [11, 21, 22, 31, 32, 41, 42, 51, 52, 60, 70, 71, 110, 140, 181],
        "armor": [200, 210, 220, 230, 240, 252],
        "accessory": [91, 92, 93, 94, 95, 97],
        "scroll": [98, 250, 253, 254],
        "box": [255]
    }

    sub_kind_map = {
        "dagger": [11],
        "sword": [21, 22],
        "axe": [31, 32],
        "mace": [41, 42],
        "spear": [51, 52],
        "shield": [60],
        "bow": [70, 71],
        "staff": [110],
        "jamadar": [140],
        "kurian_weapon": [181],
        "earring": [91],
        "necklace": [92],
        "ring": [93],
        "belt": [94],
        "warrior_armor": [210],
        "rogue_armor": [220],
        "mage_armor": [230],
        "priest_armor": [240],
        "kurian_armor": [200, 252],
        "scroll": [98, 250],
        "box": [255]
    }

    where_clauses = ["strName IS NOT NULL", "strName != ''"]
    params = []

    # Category / Subcategory
    if sub_category != "all" and sub_category in sub_kind_map:
        kinds = sub_kind_map[sub_category]
        placeholders = ','.join(['?'] * len(kinds))
        where_clauses.append(f"Kind IN ({placeholders})")
        params.extend(kinds)
    elif category != "all" and category in category_kind_map:
        kinds = category_kind_map[category]
        placeholders = ','.join(['?'] * len(kinds))
        where_clauses.append(f"Kind IN ({placeholders})")
        params.extend(kinds)

    # Box keyword special case
    if category == "box" or sub_category == "box":
        where_clauses.append("(strName LIKE '%Chest%' OR strName LIKE '%Gem%' OR strName LIKE '%Fragment%' OR strName LIKE '%Kutu%')")

    # Keyword search
    sort_params = []
    if q and q.strip():
        query_str = q.strip()
        if query_str.isdigit():
            where_clauses.append("(Num = ? OR Num LIKE ?)")
            params.extend([int(query_str), f"%{query_str}%"])
        else:
            where_clauses.append("strName LIKE ?")
            params.append(f"%{query_str}%")
            if sort == "default":
                sort_params = [query_str, f"{query_str}%"]

    # Base items only
    if base_only:
        where_clauses.append("strName NOT LIKE '%(+%'")

    where_sql = " AND ".join(where_clauses)

    # Sorting
    if sort == "damage_desc":
        order_sql = "ORDER BY Damage DESC, Num ASC"
    elif sort == "ac_desc":
        order_sql = "ORDER BY Ac DESC, Num ASC"
    elif sort == "name_asc":
        order_sql = "ORDER BY strName ASC"
    elif sort == "num_desc":
        order_sql = "ORDER BY Num DESC"
    else:
        if q and not q.isdigit():
            order_sql = "ORDER BY CASE WHEN strName = ? THEN 1 WHEN strName LIKE ? THEN 2 ELSE 3 END, Damage DESC, Num ASC"
        else:
            order_sql = "ORDER BY CASE WHEN Damage > 0 THEN 0 ELSE 1 END, Damage DESC, Ac DESC, Num ASC"

    with get_db() as conn:
        c = conn.cursor()
        
        # Total count
        count_sql = f"SELECT COUNT(*) FROM ITEM WHERE {where_sql}"
        c.execute(count_sql, params)
        total_count = c.fetchone()[0]

        # Items
        select_sql = f"""
            SELECT Num, strName, Damage, Ac, StrB, StaB, DexB, IntelB, ChaB, 
                   MaxHpB, MaxMpB, FireDamage, IceDamage, LightningDamage, PoisonDamage, 
                   HpDrain, MpDrain, ReqLevel, ItemClass, ItemType, ItemIconID1
            FROM ITEM 
            WHERE {where_sql}
            {order_sql}
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """
        all_params = params + sort_params + [offset, limit]
        c.execute(select_sql, all_params)
        
        rows = c.fetchall()
        for row in rows:
            item_num = row[0]
            name = row[1].strip() if row[1] else "Bilinmiyor"
            icon_url = get_icon_url(icon_id=row[20] if len(row) > 20 else None, fallback_item_num=item_num)
            grade_match = re.search(r'\(\+([0-9]+)\)', name)
            grade = int(grade_match.group(1)) if grade_match else 0
            base_name = extract_base_name(name)
            
            results.append({
                "num": item_num,
                "name": name,
                "base_name": base_name,
                "grade": grade,
                "damage": row[2],
                "ac": row[3],
                "strb": row[4],
                "stab": row[5],
                "dexb": row[6],
                "intelb": row[7],
                "chab": row[8],
                "maxhpb": row[9],
                "maxmpb": row[10],
                "firedamage": row[11],
                "icedamage": row[12],
                "lightningdamage": row[13],
                "poisondamage": row[14],
                "hpdrain": row[15],
                "mpdrain": row[16],
                "req_level": row[17],
                "item_class": row[18],
                "item_type": row[19],
                "icon_url": icon_url
            })

    total_pages = max(1, (total_count + limit - 1) // limit)
    return {
        "items": results,
        "total": total_count,
        "page": page,
        "limit": limit,
        "total_pages": total_pages
    }

@app.get("/api/items/variants")
def get_item_variants(base_name: str):
    variants = []
    with get_db() as conn:
        c = conn.cursor()
        c.execute("""
            SELECT Num, strName, Damage, Ac, StrB, StaB, DexB, IntelB, ChaB, 
                   MaxHpB, MaxMpB, FireDamage, IceDamage, LightningDamage, PoisonDamage, 
                   ReqLevel, ItemIconID1
            FROM ITEM 
            WHERE strName LIKE ? OR strName = ?
            ORDER BY Num ASC
        """, (f"{base_name} (+%", base_name))
        for row in c.fetchall():
            name = row[1].strip() if row[1] else ""
            grade_match = re.search(r'\(\+([0-9]+)\)', name)
            grade = int(grade_match.group(1)) if grade_match else 0
            variants.append({
                "num": row[0],
                "name": name,
                "grade": grade,
                "damage": row[2],
                "ac": row[3],
                "req_level": row[15],
                "icon_url": get_icon_url(icon_id=row[16] if len(row) > 16 else None, fallback_item_num=row[0])
            })
    variants.sort(key=lambda v: v["grade"])
    return variants

@app.post("/api/give-item")
def give_item(req: GiveItemReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("""
            INSERT INTO SERVER_COMMAND_QUEUE (command, param1, param2, param3, status)
            VALUES ('GIVE_ITEM', ?, ?, ?, 0)
        """, (req.character, str(req.item_id), str(req.count)))
        conn.commit()
    return {"success": True, "message": f"{req.character} karakterine eşya (ID: {req.item_id}) kuyruğa eklendi."}

@app.post("/api/forge-item")
def forge_item(req: ForgeItemReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("SELECT MAX(Num) FROM ITEM WHERE Num >= 999900000 AND Num < 999999999")
        last_custom = c.fetchone()[0]
        new_num = (last_custom + 1) if last_custom else 999900001
        
        c.execute("SELECT * FROM ITEM WHERE Num = ?", (req.base_item_id,))
        base_cols = [column[0] for column in c.description]
        base_row = c.fetchone()
        
        if not base_row:
            raise HTTPException(status_code=404, detail="Base item not found in database")
            
        item_dict = dict(zip(base_cols, base_row))
        item_dict['Num'] = new_num
        item_dict['strName'] = req.name
        if req.damage: item_dict['Damage'] = req.damage
        if req.ac: item_dict['Ac'] = req.ac
        if req.strb: item_dict['StrB'] = req.strb
        if req.stab: item_dict['StaB'] = req.stab
        if req.dexb: item_dict['DexB'] = req.dexb
        if req.intelb: item_dict['IntelB'] = req.intelb
        if req.chab: item_dict['ChaB'] = req.chab
        if req.maxhpb: item_dict['MaxHpB'] = req.maxhpb
        if req.maxmpb: item_dict['MaxMpB'] = req.maxmpb
        if req.firedamage: item_dict['FireDamage'] = req.firedamage
        if req.icedamage: item_dict['IceDamage'] = req.icedamage
        if req.lightningdamage: item_dict['LightningDamage'] = req.lightningdamage
        if req.poisondamage: item_dict['PoisonDamage'] = req.poisondamage
        if req.hpdrain: item_dict['HpDrain'] = req.hpdrain
        if req.mpdrain: item_dict['MpDrain'] = req.mpdrain
        
        cols = list(item_dict.keys())
        placeholders = ', '.join(['?'] * len(cols))
        col_names = ', '.join(cols)
        values = [item_dict[k] for k in cols]
        
        sql = f"INSERT INTO ITEM ({col_names}) VALUES ({placeholders})"
        c.execute(sql, values)
        
        c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, status) VALUES ('RELOAD_ITEMS', 0)")
        c.execute("""
            INSERT INTO SERVER_COMMAND_QUEUE (command, param1, param2, param3, status)
            VALUES ('GIVE_ITEM', ?, ?, ?, 0)
        """, (req.character, str(new_num), str(req.count)))
        
        conn.commit()
        
    return {
        "success": True, 
        "item_num": new_num,
        "message": f"Edit eşya '{req.name}' (ID: {new_num}) üretildi ve {req.character} çantasına gönderildi!"
    }

@app.post("/api/give-gold")
def give_gold(req: GiveGoldReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("SELECT Gold FROM USERDATA WHERE strUserID = ?", (req.character,))
        row = c.fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Character not found")
        current_gold = row[0]
        
        if req.mode == "add":
            new_gold = min(2100000000, current_gold + req.amount)
            c.execute("""
                INSERT INTO SERVER_COMMAND_QUEUE (command, param1, param2, status)
                VALUES ('GIVE_GOLD', ?, ?, 0)
            """, (req.character, str(req.amount)))
        else:
            new_gold = max(0, min(2100000000, req.amount))
            
        c.execute("UPDATE USERDATA SET Gold = ? WHERE strUserID = ?", (new_gold, req.character))
        conn.commit()
    return {"success": True, "new_gold": new_gold, "message": f"{req.character} hesabına {req.amount:,} Noah verildi."}

@app.post("/api/give-kc")
def give_kc(req: GiveKcReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("""
            SELECT tb.strAccountID, ISNULL(tb.CashPoint, 0)
            FROM USERDATA u
            JOIN ACCOUNT_CHAR ac ON (ac.strCharID1 = u.strUserID OR ac.strCharID2 = u.strUserID OR ac.strCharID3 = u.strUserID OR ac.strCharID4 = u.strUserID)
            JOIN TB_USER tb ON tb.strAccountID = ac.strAccountID
            WHERE u.strUserID = ?
        """, (req.character,))
        row = c.fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Account not found for character")
        acc_id, current_cash = row
        new_cash = current_cash + req.amount
        c.execute("UPDATE TB_USER SET CashPoint = ? WHERE strAccountID = ?", (new_cash, acc_id))
        conn.commit()
    return {"success": True, "new_cash": new_cash, "account": acc_id, "message": f"{acc_id} hesabına {req.amount:,} KC yüklendi."}

@app.post("/api/set-level")
def set_level(req: SetLevelReq):
    raise HTTPException(410, "Seviye değişikliklerini Karakter Stat Yönetimi sekmesinden kaydedin.")

@app.post("/api/set-authority")
def set_authority(req: SetAuthorityReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("UPDATE USERDATA SET Authority = ? WHERE strUserID = ?", (req.authority, req.character))
        
        c.execute("""
            SELECT ac.strAccountID FROM ACCOUNT_CHAR ac 
            WHERE ac.strCharID1 = ? OR ac.strCharID2 = ? OR ac.strCharID3 = ? OR ac.strCharID4 = ?
        """, (req.character, req.character, req.character, req.character))
        row = c.fetchone()
        if row:
            acc_id = row[0]
            tb_auth = 0 if req.authority == 0 else 1
            c.execute("UPDATE TB_USER SET bAuthority = ? WHERE strAccountID = ?", (tb_auth, acc_id))
            
            c.execute("SELECT strcharid FROM GAME_MASTER_SETTINGS WHERE strcharid = ?", (req.character,))
            if not c.fetchone():
                c.execute("""
                    INSERT INTO GAME_MASTER_SETTINGS 
                    (straccountid, strcharid, sserverno,
                     smute, sunmute, sunban, sbanpermit, sallowattack, sdisabledattack,
                     snpadd, sexpadd, smoneyadd, sloyaltychange, sexpchange, smoneychange,
                     sgiveitem, sgiveitemself, ssummonuser, stponuser, szonechange, slocationchange,
                     smonstersummon, snpcsummon, smonkilled, steleportalluser, sclansummon,
                     sresetplayerranking, schangeeventroom, swaropen1, swaropen2, swaropen3,
                     swaropen4, swaropen5, swaropen6, swaropen9, swarsiegeopen, swarclose,
                     scaptainelection, swarsiegeclose, ssendprsion)
                    VALUES 
                    (?, ?, 1,
                     1, 1, 1, 1, 1, 1,
                     1, 1, 1, 1, 1, 1,
                     1, 1, 1, 1, 1, 1,
                     1, 1, 1, 1, 1,
                     1, 1, 1, 1, 1,
                     1, 1, 1, 1, 1, 1,
                     1, 1, 1)
                """, (acc_id, req.character))
            else:
                c.execute("""
                    UPDATE GAME_MASTER_SETTINGS SET
                     smute=1, sunmute=1, sunban=1, sbanpermit=1, sallowattack=1, sdisabledattack=1,
                     snpadd=1, sexpadd=1, smoneyadd=1, sloyaltychange=1, sexpchange=1, smoneychange=1,
                     sgiveitem=1, sgiveitemself=1, ssummonuser=1, stponuser=1, szonechange=1, slocationchange=1,
                     smonstersummon=1, snpcsummon=1, smonkilled=1, steleportalluser=1, sclansummon=1,
                     sresetplayerranking=1, schangeeventroom=1, swaropen1=1, swaropen2=1, swaropen3=1,
                     swaropen4=1, swaropen5=1, swaropen6=1, swaropen9=1, swarsiegeopen=1, swarclose=1,
                     scaptainelection=1, swarsiegeclose=1, ssendprsion=1
                    WHERE strcharid = ?
                """, (req.character,))
        conn.commit()
    role_name = "Game Master [GM] (Tüm Komut Yetkileri Açık)" if req.authority == 0 else "Normal Oyuncu"
    return {"success": True, "message": f"{req.character} yetkisi güncellendi: {role_name}"}

# Discipline & Moderation Endpoints
@app.post("/api/character/punish")
def punish_character(req: PunishReq):
    seconds = max(60, req.duration_minutes * 60)
    with get_db() as conn:
        c = conn.cursor()
        c.execute("""
            INSERT INTO SERVER_COMMAND_QUEUE (command, param1, param2, status)
            VALUES ('PUNISH', ?, ?, 0)
        """, (req.character, str(seconds)))
        c.execute("""
            UPDATE USERDATA SET TimePunishment = ?, Zone = 21, PX = 81500, PZ = 54500
            WHERE strUserID = ?
        """, (seconds, req.character))
        conn.commit()
    return {"success": True, "message": f"{req.character} oyuncusuna {req.duration_minutes} dakika Moradon Town cezası verildi!"}

@app.post("/api/character/unpunish")
def unpunish_character(req: UnpunishReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("""
            INSERT INTO SERVER_COMMAND_QUEUE (command, param1, status)
            VALUES ('UNPUNISH', ?, 0)
        """, (req.character,))
        c.execute("""
            UPDATE USERDATA SET TimePunishment = 0 WHERE strUserID = ?
        """, (req.character,))
        conn.commit()
    return {"success": True, "message": f"{req.character} cezası kaldırıldı, serbest bırakıldı."}

@app.post("/api/character/ban")
def ban_character(req: BanReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, param1, status) VALUES ('BAN', ?, 0)", (req.character,))
        c.execute("UPDATE USERDATA SET Authority = 255 WHERE strUserID = ?", (req.character,))
        c.execute("""
            UPDATE TB_USER SET bAuthority = 255 
            WHERE strAccountID = (SELECT strAccountID FROM USERDATA WHERE strUserID = ?)
        """, (req.character,))
        conn.commit()
    return {"success": True, "message": f"{req.character} hesabı banlandı (Authority 255)."}

@app.post("/api/character/unban")
def unban_character(req: UnbanReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, param1, status) VALUES ('UNBAN', ?, 0)", (req.character,))
        c.execute("UPDATE USERDATA SET Authority = 1 WHERE strUserID = ?", (req.character,))
        c.execute("""
            UPDATE TB_USER SET bAuthority = 1 
            WHERE strAccountID = (SELECT strAccountID FROM USERDATA WHERE strUserID = ?)
        """, (req.character,))
        conn.commit()
    return {"success": True, "message": f"{req.character} banı kaldırıldı (Authority 1)."}

@app.post("/api/character/mute")
def mute_character(req: MuteReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, param1, status) VALUES ('MUTE', ?, 0)", (req.character,))
        c.execute("UPDATE USERDATA SET Authority = 11 WHERE strUserID = ?", (req.character,))
        conn.commit()
    return {"success": True, "message": f"{req.character} susturuldu (Muted)."}

@app.post("/api/character/unmute")
def unmute_character(req: UnmuteReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, param1, status) VALUES ('UNMUTE', ?, 0)", (req.character,))
        c.execute("UPDATE USERDATA SET Authority = 1 WHERE strUserID = ?", (req.character,))
        conn.commit()
    return {"success": True, "message": f"{req.character} susturması kaldırıldı."}

@app.post("/api/character/attack-control")
def attack_control(req: AttackControlReq):
    cmd = "DISABLE_ATTACK" if req.disable else "ALLOW_ATTACK"
    with get_db() as conn:
        c = conn.cursor()
        c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, param1, status) VALUES (?, ?, 0)", (cmd, req.character))
        conn.commit()
    action = "kapatıldı" if req.disable else "açıldı"
    return {"success": True, "message": f"{req.character} saldırı izni {action}."}

@app.post("/api/teleport")
def teleport(req: TeleportReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("""
            INSERT INTO SERVER_COMMAND_QUEUE (command, param1, param2, param3, param4, status)
            VALUES ('TELEPORT', ?, ?, ?, ?, 0)
        """, (req.character, str(req.zone), str(req.x), str(req.z)))
        conn.commit()
    return {"success": True, "message": f"{req.character} ışınlama komutu iletildi"}

@app.post("/api/kick")
def kick(req: KickReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("""
            INSERT INTO SERVER_COMMAND_QUEUE (command, param1, status)
            VALUES ('KICK', ?, 0)
        """, (req.character,))
        conn.commit()
    return {"success": True, "message": f"{req.character} oyundan atma komutu iletildi"}

# Server & Event Management Endpoints
@app.post("/api/bosses/spawn")
def spawn_boss(req: SpawnBossReq):
    with get_db() as conn:
        c = conn.cursor()
        p3 = req.target_player if req.target_player else str(req.x)
        c.execute("""
            INSERT INTO SERVER_COMMAND_QUEUE (command, param1, param2, param3, param4, param5, param6, status)
            VALUES ('SPAWN', ?, ?, ?, ?, ?, ?, 0)
        """, (str(req.ssid), str(req.zone), p3, str(req.y), str(req.z), str(req.count)))
        conn.commit()
    return {"success": True, "message": f"Boss spawn komutu kuyruğa eklendi (SSID: {req.ssid}, Adet: {req.count})"}

@app.post("/api/bosses/kill-all")
def kill_all_mobs(req: KillMobsReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("""
            INSERT INTO SERVER_COMMAND_QUEUE (command, param1, status)
            VALUES ('KILL_MOBS', ?, 0)
        """, (str(req.zone),))
        conn.commit()
    return {"success": True, "message": f"Bölge {req.zone} için tüm canavarları silme komutu kuyruğa eklendi"}

@app.post("/api/server/war")
def server_war(req: WarControlReq):
    with get_db() as conn:
        c = conn.cursor()
        if req.action == "open":
            c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, param1, status) VALUES ('WAR_OPEN', ?, 0)", (str(req.war_type),))
            msg = f"Savaş başlatıldı (Tip: {req.war_type})"
        else:
            c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, status) VALUES ('WAR_CLOSE', 0)")
            msg = "Savaş sonlandırıldı ve oyuncular güvenli bölgelere çekildi."
        conn.commit()
    return {"success": True, "message": msg}

@app.post("/api/server/bonus")
def server_bonus(req: EventBonusReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, param1, param2, status) VALUES ('EVENT_BONUS', ?, ?, 0)",
                  (req.bonus_type.upper(), str(req.percent)))
        conn.commit()
    return {"success": True, "message": f"Sunucu {req.bonus_type.upper()} bonusu %{req.percent} olarak ayarlandı."}

@app.post("/api/send-notice")
def send_notice(req: NoticeReq):
    cmd = "ANNOUNCEMENT" if req.notice_type == "announcement" else "NOTICE"
    with get_db() as conn:
        c = conn.cursor()
        c.execute("""
            INSERT INTO SERVER_COMMAND_QUEUE (command, param1, status)
            VALUES (?, ?, 0)
        """, (cmd, req.message))
        conn.commit()
    return {"success": True, "message": "Duyuru sunucuya iletildi"}

@app.get("/api/queue-history")
def get_queue_history():
    history = []
    with get_db() as conn:
        c = conn.cursor()
        c.execute("""
            SELECT TOP 30 id, command, param1, param2, param3, status, result_msg, created_at, processed_at
            FROM SERVER_COMMAND_QUEUE
            ORDER BY id DESC
        """)
        for r in c.fetchall():
            history.append({
                "id": r[0],
                "command": r[1],
                "param1": r[2],
                "param2": r[3],
                "param3": r[4],
                "status": r[5],
                "result_msg": r[6],
                "created_at": str(r[7]) if r[7] else "-",
                "processed_at": str(r[8]) if r[8] else "-"
            })
    return history

ZONE_NAMES = {
    1: "Luferson Castle",
    2: "El Morad Castle",
    5: "Karus Military Camp",
    6: "El Morad Military Camp",
    11: "Karus Eslant",
    12: "El Morad Eslant",
    21: "Moradon",
    30: "Delos",
    31: "Bifrost",
    32: "Despair Abyss",
    33: "Hell Abyss",
    66: "Juraid Mountain",
    71: "Colony Zone (Ronark Land)",
    72: "Ardream",
    73: "Ronark Land Base",
    84: "Krowaz Dominion",
    87: "Monster Stone",
    94: "Felankor Lair"
}

class DropSlotUpdate(BaseModel):
    slot: int
    item_id: int
    percent: float

class UpdateMobDropsReq(BaseModel):
    drops: List[DropSlotUpdate]

class UpdateSpawnReq(BaseModel):
    zone_id: int
    left_x: int
    top_z: int
    num_npc: int
    reg_time: int

class AddSpawnReq(BaseModel):
    zone_id: int
    num_npc: int = 1
    reg_time: int = 60
    x: int
    z: int

class DeleteSpawnReq(BaseModel):
    zone_id: int
    left_x: int
    top_z: int

@app.get("/api/mobs")
def get_mobs(q: str = "", zone: int = 0, has_drops: str = "all", is_boss: str = "all", limit: int = 50, offset: int = 0):
    query = q.strip()
    where_clauses = ["1=1"]
    params = []
    
    if query:
        if query.isdigit():
            where_clauses.append("(m.sSid = ? OR m.strName LIKE ?)")
            params.extend([int(query), f"%{query}%"])
        else:
            where_clauses.append("m.strName LIKE ?")
            params.append(f"%{query}%")
            
    if zone > 0:
        where_clauses.append("EXISTS (SELECT 1 FROM k_npcpos p WHERE p.NpcID = m.sSid AND p.ZoneID = ?)")
        params.append(zone)
        
    if has_drops == "yes":
        where_clauses.append("EXISTS (SELECT 1 FROM k_monster_item d WHERE d.sIndex = m.sSid AND (d.iItem01 > 0 OR d.iItem02 > 0 OR d.iItem03 > 0 OR d.iItem04 > 0 OR d.iItem05 > 0 OR d.iItem06 > 0 OR d.iItem07 > 0))")
    elif has_drops == "no":
        where_clauses.append("NOT EXISTS (SELECT 1 FROM k_monster_item d WHERE d.sIndex = m.sSid AND (d.iItem01 > 0 OR d.iItem02 > 0 OR d.iItem03 > 0 OR d.iItem04 > 0 OR d.iItem05 > 0 OR d.iItem06 > 0 OR d.iItem07 > 0))")
        
    if is_boss == "boss":
        where_clauses.append("(m.sLevel >= 70 OR m.byGroup = 3 OR m.sSid IN (5702, 6551, 5701, 2405, 2005, 2205, 2105, 2305, 1405, 1306, 914, 917, 1206, 1205, 1207, 801, 802, 803, 505, 1105))")
    elif is_boss == "normal":
        where_clauses.append("(m.sLevel < 70 AND m.byGroup <> 3 AND m.sSid NOT IN (5702, 6551, 5701, 2405, 2005, 2205, 2105, 2305, 1405, 1306, 914, 917, 1206, 1205, 1207, 801, 802, 803, 505, 1105))")

    where_sql = " AND ".join(where_clauses)
    
    with get_db() as conn:
        c = conn.cursor()
        c.execute(f"SELECT COUNT(*) FROM k_monster m WHERE {where_sql}", params)
        total = c.fetchone()[0]
        
        sql = f"""
            SELECT m.sSid, m.strName, m.sLevel, m.iHpPoint, m.sAtk, m.sAc, m.iExp, m.iLoyalty,
                   (SELECT COUNT(*) FROM k_npcpos p WHERE p.NpcID = m.sSid) as spawn_count,
                   (SELECT CASE WHEN d.iItem01 > 0 THEN 1 ELSE 0 END +
                           CASE WHEN d.iItem02 > 0 THEN 1 ELSE 0 END +
                           CASE WHEN d.iItem03 > 0 THEN 1 ELSE 0 END +
                           CASE WHEN d.iItem04 > 0 THEN 1 ELSE 0 END +
                           CASE WHEN d.iItem05 > 0 THEN 1 ELSE 0 END +
                           CASE WHEN d.iItem06 > 0 THEN 1 ELSE 0 END +
                           CASE WHEN d.iItem07 > 0 THEN 1 ELSE 0 END
                    FROM k_monster_item d WHERE d.sIndex = m.sSid) as drop_count
            FROM k_monster m
            WHERE {where_sql}
            ORDER BY m.sLevel DESC, m.sSid ASC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """
        c.execute(sql, params + [offset, limit])
        mobs = []
        for r in c.fetchall():
            ssid = r[0]
            name = r[1].strip() if r[1] else "Bilinmiyor"
            lvl = r[2]
            hp = r[3]
            atk = r[4]
            ac = r[5]
            exp = r[6]
            loyalty = r[7]
            spawns = r[8] or 0
            drops = r[9] or 0
            is_boss_flag = (lvl >= 70 or ssid in (5702, 6551, 5701, 2405, 2005, 2205, 2105, 2305, 1405, 1306, 914, 917, 1206, 1205, 1207, 801, 802, 803, 505, 1105))
            mobs.append({
                "ssid": ssid,
                "name": name,
                "level": lvl,
                "hp": hp,
                "atk": atk,
                "ac": ac,
                "exp": exp,
                "loyalty": loyalty,
                "spawn_count": spawns,
                "drop_count": drops,
                "is_boss": is_boss_flag
            })
            
    return {"total": total, "mobs": mobs, "offset": offset, "limit": limit}

@app.get("/api/mobs/{ssid}")
def get_mob_detail(ssid: int):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("SELECT sSid, strName, sLevel, iHpPoint, smpPoint, sAtk, sAc, iExp, iLoyalty FROM k_monster WHERE sSid = ?", (ssid,))
        row = c.fetchone()
        if not row:
            raise HTTPException(status_code=404, detail="Monster not found")
            
        mob = {
            "ssid": row[0],
            "name": row[1].strip() if row[1] else "Bilinmiyor",
            "level": row[2],
            "hp": row[3],
            "mp": row[4],
            "atk": row[5],
            "ac": row[6],
            "exp": row[7],
            "loyalty": row[8]
        }
        
        c.execute("""
            SELECT iItem01, sPersent01, iItem02, sPersent02, iItem03, sPersent03, 
                   iItem04, sPersent04, iItem05, sPersent05, iItem06, sPersent06, 
                   iItem07, sPersent07
            FROM k_monster_item WHERE sIndex = ?
        """, (ssid,))
        drop_row = c.fetchone()
        
        drops = []
        item_ids = []
        if drop_row:
            for i in range(7):
                item_id = drop_row[i * 2]
                percent_raw = drop_row[i * 2 + 1]
                if item_id > 0:
                    item_ids.append(item_id)
                drops.append({
                    "slot": i + 1,
                    "item_id": item_id,
                    "percent_raw": percent_raw,
                    "percent_float": round(percent_raw / 100.0, 2),
                    "item_name": "Boş Slot",
                    "icon_url": None
                })
        else:
            for i in range(7):
                drops.append({
                    "slot": i + 1,
                    "item_id": 0,
                    "percent_raw": 0,
                    "percent_float": 0.0,
                    "item_name": "Boş Slot",
                    "icon_url": None
                })
                
        if item_ids:
            placeholders = ','.join(['?'] * len(item_ids))
            c.execute(f"SELECT Num, strName FROM ITEM WHERE Num IN ({placeholders})", item_ids)
            item_map = {r[0]: r[1].strip() for r in c.fetchall()}
            for d in drops:
                if d["item_id"] in item_map:
                    d["item_name"] = item_map[d["item_id"]]
                if d["item_id"] > 0:
                    d["icon_url"] = get_icon_url(d["item_id"])
                    
        c.execute("""
            SELECT ZoneID, NumNPC, RegTime, LeftX, TopZ, RightX, BottomZ, ActType
            FROM k_npcpos WHERE NpcID = ?
            ORDER BY ZoneID ASC
        """, (ssid,))
        spawns = []
        for r in c.fetchall():
            zid = r[0]
            zname = ZONE_NAMES.get(zid, f"Zone {zid}")
            spawns.append({
                "zone_id": zid,
                "zone_name": zname,
                "num_npc": r[1],
                "reg_time": r[2],
                "left_x": r[3],
                "top_z": r[4],
                "right_x": r[5],
                "bottom_z": r[6],
                "act_type": r[7]
            })
            
    return {"mob": mob, "drops": drops, "spawns": spawns}

@app.post("/api/mobs/{ssid}/drops")
def update_mob_drops(ssid: int, req: UpdateMobDropsReq):
    drop_dict = {d.slot: (d.item_id, max(0, min(10000, int(round(d.percent * 100))))) for d in req.drops}
    
    i1, p1 = drop_dict.get(1, (0, 0))
    i2, p2 = drop_dict.get(2, (0, 0))
    i3, p3 = drop_dict.get(3, (0, 0))
    i4, p4 = drop_dict.get(4, (0, 0))
    i5, p5 = drop_dict.get(5, (0, 0))
    i6, p6 = drop_dict.get(6, (0, 0))
    i7, p7 = drop_dict.get(7, (0, 0))
    
    with get_db() as conn:
        c = conn.cursor()
        c.execute("SELECT sIndex FROM k_monster_item WHERE sIndex = ?", (ssid,))
        if c.fetchone():
            c.execute("""
                UPDATE k_monster_item SET
                    iItem01 = ?, sPersent01 = ?,
                    iItem02 = ?, sPersent02 = ?,
                    iItem03 = ?, sPersent03 = ?,
                    iItem04 = ?, sPersent04 = ?,
                    iItem05 = ?, sPersent05 = ?,
                    iItem06 = ?, sPersent06 = ?,
                    iItem07 = ?, sPersent07 = ?
                WHERE sIndex = ?
            """, (i1, p1, i2, p2, i3, p3, i4, p4, i5, p5, i6, p6, i7, p7, ssid))
        else:
            c.execute("""
                INSERT INTO k_monster_item 
                (sIndex, iItem01, sPersent01, iItem02, sPersent02, iItem03, sPersent03,
                 iItem04, sPersent04, iItem05, sPersent05, iItem06, sPersent06, iItem07, sPersent07)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (ssid, i1, p1, i2, p2, i3, p3, i4, p4, i5, p5, i6, p6, i7, p7))
            
        c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, status) VALUES ('RELOAD_DROPS', 0)")
        conn.commit()
        
    return {"success": True, "message": f"SSID {ssid} drop oranları güncellendi ve oyun sunucusunda anında yenilendi!"}

@app.post("/api/mobs/{ssid}/spawn/update")
def update_mob_spawn(ssid: int, req: UpdateSpawnReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("""
            UPDATE k_npcpos SET 
                NumNPC = ?, RegTime = ?
            WHERE NpcID = ? AND ZoneID = ? AND LeftX = ? AND TopZ = ?
        """, (req.num_npc, req.reg_time, ssid, req.zone_id, req.left_x, req.top_z))
        c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, status) VALUES ('RELOAD_SPAWNS', 0)")
        conn.commit()
    return {"success": True, "message": f"Spawn ayarları güncellendi (Adet: {req.num_npc}, Süre: {req.reg_time}s)!"}

@app.post("/api/mobs/{ssid}/spawn/add")
def add_mob_spawn(ssid: int, req: AddSpawnReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("""
            INSERT INTO k_npcpos 
            (ZoneID, NpcID, ActType, RegenType, DungeonFamily, SpecialType, TrapNumber, 
             LeftX, TopZ, RightX, BottomZ, LimitMinX, LimitMinZ, LimitMaxX, LimitMaxZ, 
             NumNPC, RegTime, byDirection, DotCnt, path)
            VALUES (?, ?, 1, 0, 0, 0, 0, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 0, 'NULL')
        """, (req.zone_id, ssid, req.x, req.z, req.x + 5, req.z + 5, req.x - 20, req.z - 20, req.x + 20, req.z + 20, req.num_npc, req.reg_time))
        c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, status) VALUES ('RELOAD_SPAWNS', 0)")
        conn.commit()
    return {"success": True, "message": f"Zone {req.zone_id} için yeni spawn noktası eklendi!"}

@app.post("/api/mobs/{ssid}/spawn/delete")
def delete_mob_spawn(ssid: int, req: DeleteSpawnReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("DELETE FROM k_npcpos WHERE NpcID = ? AND ZoneID = ? AND LeftX = ? AND TopZ = ?",
                  (ssid, req.zone_id, req.left_x, req.top_z))
        c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, status) VALUES ('RELOAD_SPAWNS', 0)")
        conn.commit()
    return {"success": True, "message": "Spawn noktası silindi!"}


# ========================================================
# --- 📦 KUTU, GEM & FRAGMENT DROP SİSTEMİ APILERI ---
# ========================================================

class UpdateChestDropItem(BaseModel):
    exchange_id: int
    weight: int

class UpdateChestDropsReq(BaseModel):
    drops: List[UpdateChestDropItem]

class AddChestDropReq(BaseModel):
    item_id: int
    weight: int = 100

class DeleteChestDropReq(BaseModel):
    exchange_id: int

class UpdateUpgradeRateReq(BaseModel):
    scroll: str
    note: str
    rate_type: int
    percent: float

@app.get("/api/chests")
def get_chests_list(q: str = "", filter_type: str = "all"):
    query = q.strip().lower()
    
    with get_db() as conn:
        c = conn.cursor()
        c.execute("""
            SELECT e.nOriginItemNum1, i.strName, COUNT(*) as drop_count, 
                   SUM(CAST(e.nExchangeItemCount1 AS BIGINT)) as total_weight
            FROM ITEM_EXCHANGE e
            INNER JOIN ITEM i ON i.Num = e.nOriginItemNum1
            WHERE e.nOriginItemNum1 > 0
            GROUP BY e.nOriginItemNum1, i.strName
            HAVING COUNT(*) >= 2
            ORDER BY COUNT(*) DESC
        """)
        rows = c.fetchall()
        
        chests = []
        for r in rows:
            cid = r[0]
            name = (r[1] or "Bilinmeyen Kutu").strip()
            drop_cnt = r[2]
            tot_weight = r[3] or 0
            
            # Determine type
            lname = name.lower()
            if any(k in lname for k in ["gem", "taY", "stone"]) and not "fragment" in lname:
                ctype = "gem"
            elif "fragment" in lname:
                ctype = "fragment"
            elif any(k in lname for k in ["chest", "box", "kutu", "trophy", "bag"]):
                ctype = "chest"
            else:
                ctype = "other"
                
            if filter_type != "all" and ctype != filter_type:
                continue
                
            if query and (query not in lname and query not in str(cid)):
                continue
                
            chests.append({
                "id": cid,
                "name": name,
                "type": ctype,
                "drop_count": drop_cnt,
                "total_weight": tot_weight,
                "icon_url": get_icon_url(cid)
            })
            
    return chests

@app.get("/api/chests/{chest_id}")
def get_chest_detail(chest_id: int):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("SELECT Num, strName FROM ITEM WHERE Num = ?", (chest_id,))
        chest_row = c.fetchone()
        if not chest_row:
            raise HTTPException(status_code=404, detail="Kutu/Gem bulunamadı")
            
        chest_info = {
            "id": chest_row[0],
            "name": (chest_row[1] or "Kutu").strip(),
            "icon_url": get_icon_url(chest_row[0])
        }
        
        c.execute("""
            SELECT e.nIndex, e.nExchangeItemNum1, i.strName, e.nExchangeItemCount1, e.bRandomFlag
            FROM ITEM_EXCHANGE e
            LEFT JOIN ITEM i ON i.Num = e.nExchangeItemNum1
            WHERE e.nOriginItemNum1 = ?
            ORDER BY e.nExchangeItemCount1 DESC, e.nIndex ASC
        """, (chest_id,))
        rows = c.fetchall()
        
        total_weight = sum(r[3] for r in rows if r[3] > 0)
        drops = []
        for r in rows:
            eid = r[0]
            iid = r[1]
            iname = (r[2] or f"Eşya #{iid}").strip()
            weight = r[3]
            pct = round((weight / total_weight * 100.0), 3) if total_weight > 0 else 0.0
            drops.append({
                "exchange_id": eid,
                "item_id": iid,
                "name": iname,
                "icon_url": get_icon_url(iid),
                "weight": weight,
                "percent": pct
            })
            
        chest_info["total_weight"] = total_weight
        chest_info["total_drops"] = len(drops)
        
    return {"chest": chest_info, "drops": drops}

@app.post("/api/chests/{chest_id}/drops/update")
def update_chest_drops(chest_id: int, req: UpdateChestDropsReq):
    with get_db() as conn:
        c = conn.cursor()
        for d in req.drops:
            c.execute("""
                UPDATE ITEM_EXCHANGE 
                SET nExchangeItemCount1 = ? 
                WHERE nIndex = ? AND nOriginItemNum1 = ?
            """, (max(1, d.weight), d.exchange_id, chest_id))
            
        c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, status) VALUES ('RELOAD_EXCHANGE', 0)")
        conn.commit()
    return {"success": True, "message": "Kutu/Gem drop ağırlıkları güncellendi ve GameServer'da anında yenilendi!"}

@app.post("/api/chests/{chest_id}/drops/add")
def add_chest_drop(chest_id: int, req: AddChestDropReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("SELECT ISNULL(MAX(nIndex), 0) + 1 FROM ITEM_EXCHANGE")
        next_index = c.fetchone()[0]
        
        c.execute("""
            INSERT INTO ITEM_EXCHANGE (
                nIndex, bRandomFlag, 
                nOriginItemNum1, nOriginItemCount1, 
                nOriginItemNum2, nOriginItemCount2,
                nOriginItemNum3, nOriginItemCount3,
                nOriginItemNum4, nOriginItemCount4,
                nOriginItemNum5, nOriginItemCount5,
                nExchangeItemNum1, nExchangeItemCount1,
                nExchangeItemNum2, nExchangeItemCount2,
                nExchangeItemNum3, nExchangeItemCount3,
                nExchangeItemNum4, nExchangeItemCount4,
                nExchangeItemNum5, nExchangeItemCount5
            ) VALUES (
                ?, 101, 
                ?, 1, 0, 0, 0, 0, 0, 0, 0, 0,
                ?, ?, 0, 0, 0, 0, 0, 0, 0, 0
            )
        """, (next_index, chest_id, req.item_id, max(1, req.weight)))
        
        c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, status) VALUES ('RELOAD_EXCHANGE', 0)")
        conn.commit()
    return {"success": True, "message": "Yeni eşya kutu drop tablosuna eklendi!", "exchange_id": next_index}

@app.post("/api/chests/{chest_id}/drops/delete")
def delete_chest_drop(chest_id: int, req: DeleteChestDropReq):
    with get_db() as conn:
        c = conn.cursor()
        c.execute("DELETE FROM ITEM_EXCHANGE WHERE nIndex = ? AND nOriginItemNum1 = ?", (req.exchange_id, chest_id))
        c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, status) VALUES ('RELOAD_EXCHANGE', 0)")
        conn.commit()
    return {"success": True, "message": "Eşya kutu drop tablosundan kaldırıldı!"}


# ========================================================
# --- ⚡ EŞYA UPGRADE (BASMA) ORANLARI APILERI ---
# ========================================================

@app.get("/api/upgrades")
def get_upgrade_rates():
    with get_db() as conn:
        c = conn.cursor()
        c.execute("""
            SELECT scrollname, upgradenote, bratetype, AVG(ngenrate) as avg_rate, COUNT(*) as cnt
            FROM ITEM_UPGRADE
            WHERE scrollname IN (
                'Blessed Upgrade Scroll',
                'Upgrade Scroll',
                'Upgrade Scroll (Middle Class item)',
                'Upgrade Scroll (Low Class item)',
                'Reverse Item Strengthen Scroll',
                'Accessory Compound Scroll'
            )
            AND (upgradenote LIKE '(+%' OR upgradenote LIKE '(+-%')
            GROUP BY scrollname, upgradenote, bratetype
            ORDER BY scrollname, bratetype, upgradenote
        """)
        rows = c.fetchall()
        
        # Categorize into organized groups
        categories = {
            "bus": {"name": "Blessed Upgrade Scroll (High Class / BUS)", "scroll": "Blessed Upgrade Scroll", "steps": []},
            "middle": {"name": "Middle Class Upgrade Scroll", "scroll": "Upgrade Scroll (Middle Class item)", "steps": []},
            "low": {"name": "Low Class Upgrade Scroll", "scroll": "Upgrade Scroll (Low Class item)", "steps": []},
            "rebirth": {"name": "Reverse / Rebirth Item Strengthen Scroll", "scroll": "Reverse Item Strengthen Scroll", "steps": []},
            "accessory": {"name": "Accessory Compound Scroll (Takı Upgrade)", "scroll": "Accessory Compound Scroll", "steps": []}
        }
        
        for r in rows:
            scroll = (r[0] or "").strip()
            note = (r[1] or "").strip()
            rtype = r[2]
            basis = int(r[3] or 0)
            pct = round(basis / 100.0, 2)
            cnt = r[4]
            
            step_item = {
                "scroll": scroll,
                "note": note,
                "rate_type": rtype,
                "basis": basis,
                "percent": pct,
                "count": cnt
            }
            
            if scroll == "Blessed Upgrade Scroll" and rtype == 0:
                categories["bus"]["steps"].append(step_item)
            elif scroll == "Upgrade Scroll (Middle Class item)" and rtype == 0:
                categories["middle"]["steps"].append(step_item)
            elif scroll == "Upgrade Scroll (Low Class item)" and rtype == 0:
                categories["low"]["steps"].append(step_item)
            elif scroll == "Reverse Item Strengthen Scroll" and rtype == 4:
                # Keep main rebirth steps e.g. (+1)->(+2)
                if not note.startswith("(+1)+") and not note.startswith("(+2)+"):
                    categories["rebirth"]["steps"].append(step_item)
            elif scroll == "Accessory Compound Scroll" and rtype == 4:
                categories["accessory"]["steps"].append(step_item)

    return categories

@app.post("/api/upgrades/update")
def update_upgrade_rate(req: UpdateUpgradeRateReq):
    new_basis = max(0, min(10000, int(round(req.percent * 100))))
    with get_db() as conn:
        c = conn.cursor()
        c.execute("""
            UPDATE ITEM_UPGRADE 
            SET ngenrate = ? 
            WHERE scrollname = ? AND upgradenote = ? AND bratetype = ?
        """, (new_basis, req.scroll, req.note, req.rate_type))
        rows_affected = c.rowcount
        
        c.execute("INSERT INTO SERVER_COMMAND_QUEUE (command, status) VALUES ('RELOAD_UPGRADE', 0)")
        conn.commit()
        
    return {
        "success": True, 
        "message": f"{req.note} upgrade oranı %{req.percent} olarak güncellendi ({rows_affected} eşya kuralı) ve GameServer'da anında yenilendi!",
        "rows_affected": rows_affected,
        "new_basis": new_basis
    }


STATIC_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "static")

if os.path.isdir(ICONS_DIR):
    app.mount("/item-icons", StaticFiles(directory=ICONS_DIR), name="item-icons")

app.mount("/static", StaticFiles(directory=STATIC_DIR), name="static")

@app.get("/")
def read_root():
    return FileResponse(
        os.path.join(STATIC_DIR, "index.html"),
        headers={
            "Cache-Control": "no-cache, no-store, must-revalidate",
            "Pragma": "no-cache",
            "Expires": "0"
        }
    )

if __name__ == "__main__":
    import uvicorn
    print("="*60)
    print(" Knight Online Local GM Admin Panel")
    print(" Web Arayuzu: http://localhost:8080")
    print(f" Item Icons: {ICONS_DIR}")
    print("="*60)
    uvicorn.run(app, host="127.0.0.1", port=8080)
