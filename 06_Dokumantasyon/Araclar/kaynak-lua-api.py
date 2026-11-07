"""Read the compiled x64 Lua registry without loading or running the server."""
from pathlib import Path
import csv, hashlib, json, re, struct

root = Path(__file__).resolve().parents[2]
source = root / '10_Kaynak_Derleme/TemuKO/ServerFiles/SourceFiles'
exe = source.parent / 'bin/x64/Release/GameServer.exe'
out = root / '06_Dokumantasyon/Derleme'
data = exe.read_bytes()
u16 = lambda offset: struct.unpack_from('<H', data, offset)[0]
u32 = lambda offset: struct.unpack_from('<I', data, offset)[0]
u64 = lambda offset: struct.unpack_from('<Q', data, offset)[0]
pe = u32(0x3c)
assert data[pe:pe+4] == b'PE\0\0' and u16(pe+4) == 0x8664
opt = pe + 24
assert u16(opt) == 0x20b
base = u64(opt+24)
sections = []
for index in range(u16(pe+6)):
    p = opt + u16(pe+20) + 40*index
    sections.append((u32(p+12), u32(p+8), u32(p+20), u32(p+16), u32(p+36)))

def offset_of(address):
    for rva, size, offset, raw_size, flags in sections:
        if rva <= address-base < rva+raw_size:
            return offset+address-base-rva

def address_of(offset):
    for rva, size, raw, raw_size, flags in sections:
        if raw <= offset < raw+raw_size:
            return base+rva+offset-raw

def name_of(address):
    offset = offset_of(address)
    if offset is None:
        return None
    end = data.find(b'\0', offset, offset+100)
    value = data[offset:end] if end >= 0 else b''
    return value.decode('ascii') if re.fullmatch(rb'[A-Za-z_]\w*', value) else None

tables = []
for string_match in re.finditer(b'CheckPercent\0', data):
    address = address_of(string_match.start())
    if address is None:
        continue
    for pointer_match in re.finditer(re.escape(struct.pack('<Q', address)), data):
        rows = []
        for index in range(500):
            offset = pointer_match.start() + index*16
            if offset+16 > len(data):
                break
            name_ptr, function_ptr = struct.unpack_from('<QQ', data, offset)
            if name_ptr == function_ptr == 0:
                break
            name = name_of(name_ptr)
            executable = any(rva <= function_ptr-base < rva+size and flags & 0x20000000
                             for rva,size,raw,raw_size,flags in sections)
            if not name or not executable:
                break
            rows.append({'Name':name, 'FunctionVA':hex(function_ptr), 'TableOffset':hex(offset)})
        if len(rows) > 30:
            tables.append(rows)
assert len(tables) == 1, [len(rows) for rows in tables]
rows = tables[0]
text = (source/'GameServer/LuaEngine.cpp').read_text(encoding='utf-8-sig')
text = re.sub(r'//[^\n]*', '', text.split('CLuaEngine::CLuaEngine',1)[0])
expected = re.findall(r'MAKE_LUA_FUNCTION\((\w+)\)', text)
assert expected == [row['Name'] for row in rows], 'Compiled registry differs from edited source'
for required in ('RebirthSystemActivity','JuraidTempleEventJoin','RunQuestExchange',
                 'SpawnEventSystem','MonsterStoneQuestJoin','EventSoccerMember'):
    assert required in expected, required
with (out/'kaynak-gameserver-lua-api.csv').open('w',encoding='utf-8-sig',newline='') as stream:
    writer = csv.DictWriter(stream, fieldnames=rows[0]); writer.writeheader(); writer.writerows(rows)
result = {'Architecture':'AMD64', 'ExeSHA256':hashlib.sha256(data).hexdigest(),
          'FunctionCount':len(rows),'NamesAndOrderMatchEditedSource':True,
          'Present':[row['Name'] for row in rows],
          'Method':'PE32+ registry extraction; executable-section pointer validation; no server execution'}
(out/'kaynak-gameserver-lua-api.json').write_text(json.dumps(result,indent=2),encoding='utf-8')
print(json.dumps({k:v for k,v in result.items() if k != 'Present'}))
