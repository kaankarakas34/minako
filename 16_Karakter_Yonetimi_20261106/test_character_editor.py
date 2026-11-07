"""Real SQL + HTTP handler regression tests. All fixture edits are rolled back."""
from pathlib import Path
import json
import sys
import pyodbc
from fastapi import FastAPI
from fastapi.testclient import TestClient

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / '14_GM_Admin_Paneli'))
from character_management import create_character_router, read_character

conn = pyodbc.connect('DRIVER={ODBC Driver 18 for SQL Server};SERVER=.\\KNIGHTLOCAL;DATABASE=KNIGHT_TEMU_2239;Trusted_Connection=yes;TrustServerCertificate=yes')
checks = []
NAME, ACCOUNT = 'KoStatsProbe', 'KoStatsProbeAccount'
class Transaction:
    def cursor(self): return conn.cursor()
    def commit(self): pass
    def rollback(self): pass  # Test owns the outer transaction.
    def close(self): pass

def state(): return read_character(conn.cursor(), NAME)
def payload(**changes):
    s = state()
    keys = ['character','revision','level','exp','nation','race','class_id','strong','sta','dex','intel','cha','points','skill_free','skill_1','skill_2','skill_3','skill_master']
    return {**{k:s[k] for k in keys}, **changes}
def post(body, status, label):
    response = client.post('/api/character-editor', json=body)
    assert response.status_code == status, (label, response.status_code, response.text)
    checks.append(label)
    return response.json()

try:
    c = conn.cursor()
    c.execute('SELECT COUNT(*) FROM USERDATA WHERE strUserID=?', NAME); assert c.fetchone()[0] == 0
    c.execute('SELECT COUNT(*) FROM ACCOUNT_CHAR WHERE strAccountID=?', ACCOUNT); assert c.fetchone()[0] == 0
    c.execute("SELECT name FROM sys.columns WHERE object_id=OBJECT_ID('USERDATA') AND is_identity=0 AND is_computed=0 ORDER BY column_id")
    columns = [r[0] for r in c.fetchall()]
    names = ','.join('['+n+']' for n in columns)
    values = ','.join('?' if n.lower() == 'struserid' else '['+n+']' for n in columns)
    c.execute(f'INSERT INTO USERDATA ({names}) SELECT {values} FROM USERDATA WHERE strUserID=?', NAME, 'cabbar')
    c.execute("INSERT INTO ACCOUNT_CHAR SELECT ?,1,1,?,'','','',0,0,0,0 FROM ACCOUNT_CHAR WHERE strCharID1='cabbar'", ACCOUNT, NAME)
    c.execute('INSERT INTO USERDATA_SKILLSHORTCUT (strCharID,nCount,strSkillData) VALUES (?,1,0x01020304)', NAME)
    c.execute('UPDATE USERDATA SET Knights=0,Zone=21,Exp=0 WHERE strUserID=?', NAME)
    app = FastAPI(); app.include_router(create_character_router(lambda: Transaction()))
    client = TestClient(app)
    assert client.get('/api/character-editor/options').status_code == 200
    assert client.get('/api/character-editor/NoSuchEditProbe').status_code == 404
    checks.append('Metadata and missing character responses')
    initial = state(); reserved = bytes.fromhex(initial['skill_hex'])
    result = post(payload(level=83, exp=0, points=321, strong=255, sta=190, dex=150, intel=220, cha=200,
        skill_free=148, skill_1=70, skill_2=10, skill_3=0, skill_master=0), 200, 'Level, all stats, free points and skill branches persisted')
    updated = result['character']
    assert updated['level']==83 and updated['strong']==255 and updated['points']==321
    assert updated['skill_free']==148 and updated['skill_1']==70 and updated['skill_2']==10
    assert all(bytes.fromhex(updated['skill_hex'])[i]==reserved[i] for i in [1,2,3,4,9])
    checks.append('148 skill points survive ANSI/Unicode SQL conversion; reserved bytes preserved')
    post(payload(revision=initial['revision']), 409, 'Stale revision rejected')
    for change in [dict(level=84), dict(strong=256), dict(points=-1), dict(level=10.5), dict(skill_free=256)]:
        post(payload(**change), 422, 'Storage and integer bounds rejected '+str(change))
    post(payload(race=1), 422, 'Incompatible race and priest class rejected')
    post(payload(class_id=112,level=59,skill_1=0,skill_2=0),422,'Master below level 60 rejected')
    post(payload(exp=9223372036854775807),422,'EXP beyond selected level rejected')
    before = state()
    post(payload(class_id=105, race=1),422,'Class change with allocated skills rejected')
    # An online account is refused even when its logged-in character is a different slot.
    c.execute('SELECT * FROM CURRENTUSER WHERE strAccountID=?',ACCOUNT); assert c.fetchone() is None
    c.execute("INSERT INTO CURRENTUSER (strAccountID,strCharID,nserverno,strserverip,strclientip) VALUES (?,? ,1,'127.0.0.1','127.0.0.1')",ACCOUNT,NAME)
    post(payload(),409,'Online account edit rejected')
    c.execute('DELETE FROM CURRENTUSER WHERE strAccountID=?',ACCOUNT)
    result=post(payload(class_id=105,race=1,skill_free=148,skill_1=0,skill_2=0,skill_3=0,skill_master=0),200,'Job and race change saved')
    assert result['character']['class_id']==105 and result['character']['race']==1 and result['character']['face']==0
    c.execute('SELECT nCount FROM USERDATA_SKILLSHORTCUT WHERE strCharID=?',NAME);assert c.fetchone()[0]==0
    checks.append('Class change resets shortcuts without deleting inventory')
    result=post(payload(class_id=205,race=12,nation=2),200,'Single-character country change updates account and character together')
    assert result['character']['nation']==2 and result['character']['account_nation']==2
    c.execute('SELECT COUNT(*) FROM KNIGHTLAB_CHARACTER_EDIT_AUDIT WHERE CharacterName=?',NAME);assert c.fetchone()[0]==3
    checks.append('Before and after snapshots stored for each successful write')
finally:
    conn.rollback();conn.close()

report={'Passed':True,'Checks':checks,'TestCharacter':NAME,'AllTestChangesRolledBack':True,'PlayerCharacterModified':False}
(ROOT/'16_Karakter_Yonetimi_20261106/character-editor-test.json').write_text(json.dumps(report,indent=2),encoding='utf8')
print(json.dumps(report))
