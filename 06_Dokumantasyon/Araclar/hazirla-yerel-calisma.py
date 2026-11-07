"""Create a loopback-only working directory; do not launch the servers."""
from pathlib import Path
import configparser,hashlib,json,shutil
ROOT=Path(__file__).resolve().parents[2]
RUN=ROOT/'10_Kaynak_Derleme/Yerel_Calistirma'
ASSETS=ROOT/'08_Arastirma_Adaylari/TemuKO_Posix_Assets/Server_Assets/Debug'
BIN=ROOT/'10_Kaynak_Derleme/TemuKO/ServerFiles/bin/x64/Release'
RUN.mkdir(exist_ok=True);(RUN/'Logs').mkdir(exist_ok=True)
for name in ['GameServer.exe','LogInServer.exe']:shutil.copy2(BIN/name,RUN/name)
shutil.copy2(ROOT/'10_Kaynak_Derleme/TemuKO/ServerFiles/SourceFiles/BugTrap/BugTrap-x64.dll',RUN/'BugTrap-x64.dll')
for filename in ['.GameServer.ini','.LogInServer.ini']:
    c=configparser.RawConfigParser(strict=False);c.optionxform=str
    c.read(ASSETS/filename,encoding='utf-8')
    def put(section,key,value):
        if not c.has_section(section):c.add_section(section)
        c.set(section,key,str(value))
    if filename=='.GameServer.ini':
        for prefix in ['ACCOUNT','GAME']:
            put('ODBC',prefix+'_DSN','KnightTemu2239_Lab')
            put('ODBC',prefix+'_UID','');put('ODBC',prefix+'_PWD','');put('ODBC',prefix+'_MARS','0')
        for key,value in {'MY_INFO':1,'SERVER_00':1,'SERVER_COUNT':1,'SERVER_IP_00':'127.0.0.1','SERVER_NUM':0}.items():put('ZONE_INFO',key,value)
        put('SETTINGS','PORT',15001)
    else:
        put('ODBC','DSN','KnightTemu2239_Lab');put('ODBC','UID','');put('ODBC','PWD','')
        put('SETTINGS','LISTEN_IP','127.0.0.1');put('SETTINGS','PORT',15100)
        put('DOWNLOAD','URL','127.0.0.1');put('DOWNLOAD','PATH','/')
        for i in range(3):put('NEWS',f'TITLE_{i:02d}','')
    with (RUN/filename).open('w',encoding='utf-8',newline='\n') as stream:c.write(stream,space_around_delimiters=False)
for filename in ['.EventAwards.ini','.Chat.ini']:shutil.copy2(ASSETS/filename,RUN/filename)
for filename in ['Notice.txt','Notice_up.txt']:(RUN/filename).write_text('Knight Online local test server.\n',encoding='ascii')
quests=RUN/'Quests';quests.mkdir(exist_ok=True);manifest=[]
for source in sorted((ASSETS/'Quests').glob('*.lua')):
    target=quests/source.name;shutil.copy2(source,target)
    manifest.append({'Name':source.name,'Source':'luisfelipe18/temuko-posix','Commit':'af34b1131c21b42d1949d2a63d689165b812103d','SHA256':hashlib.sha256(target.read_bytes()).hexdigest(),'Status':'REFERENCE_BASELINE_PENDING_QUEST_AUDIT'})
(ROOT/'06_Dokumantasyon/Derleme/yerel-quest-baseline.json').write_text(json.dumps(manifest,indent=2),encoding='utf8')
print(json.dumps({'Runtime':str(RUN),'BaselineLuaFiles':len(manifest),'ListenAddress':'127.0.0.1','GamePort':15001,'LoginPorts':'15100-15109','Database':'KNIGHT_TEMU_2239','DSNType':'Current user, 64-bit','Launched':False}))
