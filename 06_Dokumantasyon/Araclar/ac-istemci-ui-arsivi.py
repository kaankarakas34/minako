"""Extract the supplied UI archive into the isolated client's loose UI files."""
from pathlib import Path, PureWindowsPath
import struct, json, hashlib
ROOT=Path(__file__).resolve().parents[2]
SRC=ROOT/'04_Istemci/Gamesoft_v24xx/UI'
DST=(ROOT/'11_Istemci_Uyumluluk/Gamesoft_Yerel/UI').resolve()
head=(SRC/'ui.hdr').read_bytes(); data=(SRC/'ui.src').read_bytes()
at=4;entries=[]
while at < len(head):
    n=struct.unpack_from('<I',head,at)[0];at+=4;assert 0<n<1024
    name=head[at:at+n].decode('cp1254');at+=n
    offset,size=struct.unpack_from('<II',head,at);at+=8
    assert offset+size<=len(data)
    relative=PureWindowsPath(name)
    assert not relative.is_absolute() and '..' not in relative.parts and not relative.drive
    path=DST.joinpath(*relative.parts).resolve();assert path.is_relative_to(DST)
    entries.append((path,offset,size))
assert at==len(head) and len(entries)==2815
for path,offset,size in entries:
    value=data[offset:offset+size]
    if path.exists():assert path.read_bytes()==value, str(path)
    else:
        path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(value)
assert all(path.read_bytes()==data[o:o+s] for path,o,s in entries)
(DST/'ui.hdr').write_bytes(struct.pack('<I',len(entries))+head[4:])
# The supplied patch client can use ordinary loose UI resources.
# Keep the other three resource archives in their original configuration.
(DST.parent/'Path.Ini').write_text('[Dir]\ncount=3\n0=object\n1=item\n2=fx\n\n[Version]\nCount=9\n',encoding='ascii')
result={'OriginalDeclaredCount':struct.unpack_from('<I',head)[0], 'ActualEntries':len(entries),'AllBoundsValidated':True,'ExtractedFilesVerified':True,'OriginalFilesModified':False,'UIArchiveLookupEnabled':False,'SourceSHA256':hashlib.sha256(data).hexdigest()}
(ROOT/'11_Istemci_Uyumluluk/ui-resource-extraction.json').write_text(json.dumps(result,indent=2),encoding='utf8')
print(json.dumps(result))
