"""Point the stock 2083 client to its compatible supplied option/help layout.

Only two UI resource paths change; table IDs, schema and all other cells remain
byte-identical. The unrelated newer font panel must not be loaded by this client.
"""
from pathlib import Path
import hashlib,json,shutil,struct,subprocess
from ko_tbl import load,parse,serialize,tbl
ROOT=Path(__file__).resolve().parents[2]
CLIENT=ROOT/'11_Istemci_Uyumluluk/Gamesoft_Yerel'
OUT=ROOT/'13_Istemci_Arayuz_Duzeltmesi'
BACKUP=OUT/'Yedek';BACKUP.mkdir(parents=True,exist_ok=True)
table=CLIENT/'Data/UIs_us.tbl'
layout=CLIENT/'UI/co_seed_helper_us.uif'
assert layout.is_file()
assert subprocess.check_output(['git','-C',str(ROOT/'08_Arastirma_Adaylari/KO_TBL_Tools'),'rev-parse','HEAD'],text=True).strip()=='d1c49328188dec4b2474e21a43b0bfb4d9ce4d7c'
if not (BACKUP/table.name).exists():shutil.copy2(table,BACKUP/table.name)
head,types,rows=load(table)
assert len(types)==312 and types[160]==7
before=[row.copy() for row in rows]
target=b'ui\\co_seed_helper_us.uif'
changed=[]
for row in rows:
    identity=int.from_bytes(row[0],'little')
    assert identity in(1,2)
    old=row[160][4:]
    assert old.lower() in(b'ui\\re_seed_helper.uif',target.lower()),old
    row[160]=struct.pack('<I',len(target))+target
    if old!=target:changed.append({'Nation':identity,'Old':old.decode('ascii'),'New':target.decode('ascii')})
assert all(a==b for x,y in zip(before,rows) for i,(a,b) in enumerate(zip(x,y)) if i!=160)
plain=serialize(head,types,rows)
assert parse(plain)==(head,types,rows)
candidate=OUT/'UIs_us.options-fixed.tbl';candidate.write_bytes(tbl.encrypt_tbl(plain))
assert tbl.decrypt_tbl(candidate)==plain
shutil.copy2(candidate,table)
report={'ClientWireVersion':2083,'Column':160,'Changed':changed,'OtherTableCellsUnchanged':True,'TableRoundTripPassed':True,'NewLayoutFile':'UI/co_seed_helper_us.uif','ClientExeChanged':False,'SHA256':hashlib.sha256(table.read_bytes()).hexdigest()}
(OUT/'options-resource-fix.json').write_text(json.dumps(report,indent=2),encoding='utf8')
print(json.dumps(report),flush=True)
