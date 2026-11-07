"""Configure only the local client's display, preserving all other INI bytes."""
from pathlib import Path
import json,re,shutil
ROOT=Path(__file__).resolve().parents[2]
path=ROOT/'11_Istemci_Uyumluluk/Gamesoft_Yerel/Option.ini'
out=ROOT/'13_Istemci_Arayuz_Duzeltmesi';backup=out/'Yedek/Option-before-fullscreen.ini'
backup.parent.mkdir(parents=True,exist_ok=True)
if not backup.exists():shutil.copy2(path,backup)
raw=path.read_bytes()
changes={'ViewPort':{'Width':'1920','Height':'1080','ColorDepth':'32'},'Screen':{'WindowMode':'0'}}
for section,settings in changes.items():
    match=re.search(rb'(?ms)^\['+section.encode()+rb'\]\r?\n(.*?)(?=^\[|\Z)',raw);assert match,section
    body=match.group(1)
    for key,value in settings.items():
        pattern=rb'(?m)^'+key.encode()+rb'=[^\r\n]*'
        assert re.search(pattern,body),key
        body=re.sub(pattern,key.encode()+b'='+value.encode(),body)
    raw=raw[:match.start(1)]+body+raw[match.end(1):]
path.write_bytes(raw)
report={'Applied':True,'Width':1920,'Height':1080,'Fullscreen':True,'MonitorResolutionReadFromHardware':True,'WindowsDisplaySettingsChanged':False,'OtherIniSettingsPreserved':True}
(out/'display-settings.json').write_text(json.dumps(report,indent=2),encoding='utf8')
print(json.dumps(report))
