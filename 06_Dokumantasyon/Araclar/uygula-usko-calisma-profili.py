"""Disable the supplied pack's custom gifts/events; retain canonical schedules.

Only the isolated runtime INI is modified, preserving its original byte encoding.
"""
from pathlib import Path
import json,re,shutil
ROOT=Path(__file__).resolve().parents[2]
path=ROOT/'10_Kaynak_Derleme/Yerel_Calistirma/.GameServer.ini'
backup=ROOT/'12_USKO_Denetimi/Yedek/GameServer-before-normal-events.ini'
if not backup.exists():shutil.copy2(path,backup)
raw=path.read_bytes()
settings={
 'PM_EVENT':{'ENABLED':'0','KC MIKTARI':'0'},
 'ONLINE_SYSTEM':{'Moradon KC':'0','Moradon NP':'0','PK KC':'0','PK NP':'0'},
 'WANTED_EVENT':{'STATUS':'0'},
 'GAME':{'AutoRoyalG1':'0'},
 'BONUS':{'EXP':'0','MONEY':'0','NP':'0'},
}
for section,values in settings.items():
    pattern=rb'(?ms)^\['+re.escape(section.encode())+rb'\]\r?\n(.*?)(?=^\[|\Z)'
    match=re.search(pattern,raw);assert match,section
    body=match.group(1)
    for key,value in values.items():
        line=re.compile(rb'(?m)^'+re.escape(key.encode())+rb'=[^\r\n]*')
        replacement=key.encode()+b'='+value.encode()
        if line.search(body):body=line.sub(replacement,body)
        else:body=replacement+b'\r\n'+body
    raw=raw[:match.start(1)]+body+raw[match.end(1):]
path.write_bytes(raw)
report={'Applied':True,'RuntimeOnly':True,'Settings':settings,'CanonicalEventSchedulesChanged':False,'UnknownUpgradeBaseRatesChanged':False,'MonsterDropsChanged':False}
(ROOT/'12_USKO_Denetimi/runtime-profile.json').write_text(json.dumps(report,indent=2),encoding='utf8')
print(json.dumps(report))
