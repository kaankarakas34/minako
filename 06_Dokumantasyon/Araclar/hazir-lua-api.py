"""Extract the actual PE32 Lua registration table without executing the EXE."""
from pathlib import Path
import struct, re, json, csv, hashlib
root=Path(__file__).resolve().parents[2]
out=root/'06_Dokumantasyon/Uyarlama';out.mkdir(exist_ok=True)
d=(root/'02_Sunucu/24xx/GameServer.exe').read_bytes()
u16=lambda p:struct.unpack_from('<H',d,p)[0]
u32=lambda p:struct.unpack_from('<I',d,p)[0]
pe=u32(0x3c);assert d[pe:pe+4]==b'PE\0\0'
n=u16(pe+6);opt=pe+24;assert u16(opt)==0x10b
base=u32(opt+28);secs=[]
for i in range(n):
    p=opt+u16(pe+20)+i*40
    secs.append({'name':d[p:p+8].split(b'\0')[0].decode(), 'vsize':u32(p+8),'rva':u32(p+12),'size':u32(p+16),'offset':u32(p+20),'flags':u32(p+36)})
def vaoff(va):
    for s in secs:
        if s['rva']<=va-base<s['rva']+s['size']:
            return va-base-s['rva']+s['offset']
def offva(off):
    for s in secs:
        if s['offset']<=off<s['offset']+s['size']:
            return base+s['rva']+off-s['offset']
def name_at(va):
    p=vaoff(va)
    if p is None:return ''
    q=d.find(b'\0',p,p+100)
    if q<0:return ''
    b=d[p:q]
    return b.decode() if re.fullmatch(rb'[A-Za-z_]\w*',b) else ''
target=offva(d.index(b'CheckPercent\0'))
tables=[]
for match in re.finditer(re.escape(struct.pack('<I',target)),d):
    p=match.start();rows=[]
    for k in range(300):
        at=p+k*8;nameva,fn=struct.unpack_from('<II',d,at)
        if nameva==0 and fn==0:break
        name=name_at(nameva)
        executable=any(s['rva']<=fn-base<s['rva']+s['vsize'] and s['flags']&0x20000000 for s in secs)
        if not name or not executable:break
        rows.append({'Name':name,'FunctionVA':hex(fn),'TableOffset':hex(at)})
    if len(rows)>20:tables.append(rows)
assert len(tables)==1,[(len(t)) for t in tables]
rows=tables[0]
with (out/'hazir-gameserver-lua-api.csv').open('w',encoding='utf-8-sig',newline='') as f:
    w=csv.DictWriter(f,fieldnames=rows[0]);w.writeheader();w.writerows(rows)
ref=(root/'08_Arastirma_Adaylari/2083_Kaynak_Referans/LuaEngine.cpp').read_text(encoding='utf-8')
ref=re.sub(r'//[^\n]*','',ref.split('CLuaEngine::CLuaEngine',1)[0])
expected=re.findall(r'MAKE_LUA_FUNCTION\((\w+)\)',ref)
summary={'ExeSHA256':hashlib.sha256(d).hexdigest(),'FunctionCount':len(rows),'AllNamesAndOrderMatch2083Reference':expected==[r['Name'] for r in rows],'Present':[r['Name'] for r in rows],'ReferenceCommit':'95e7942926653dd306947cb147a10ea75c383064','Method':'PE32 name/function pointer table; executable-section pointer validation; no EXE execution'}
(out/'hazir-gameserver-lua-api.json').write_text(json.dumps(summary,indent=2),encoding='utf-8')
print(json.dumps({k:v for k,v in summary.items() if k!='Present'}))
