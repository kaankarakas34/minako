"""Binary-preserving table reader for the isolated Knight client tools."""
from pathlib import Path
import struct,sys
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'08_Arastirma_Adaylari/KO_TBL_Tools'))
import tbl
WIDTH={1:1,2:1,3:2,4:2,5:4,6:4,8:4,9:8,10:8}
def parse(raw):
    count=struct.unpack_from('<I',raw,5)[0]
    assert 0<count<4096
    types=list(struct.unpack_from('<'+'I'*count,raw,9))
    at=9+4*count;rows_n=struct.unpack_from('<I',raw,at)[0];at+=4
    assert rows_n<1000000
    rows=[]
    for _ in range(rows_n):
        row=[]
        for typ in types:
            size=4+struct.unpack_from('<I',raw,at)[0] if typ==7 else WIDTH[typ]
            assert 0<size<=len(raw)-at
            row.append(raw[at:at+size]);at+=size
        rows.append(row)
    assert at==len(raw)
    return raw[:5],types,rows
def serialize(head,types,rows):
    return head+struct.pack('<I',len(types))+struct.pack('<'+'I'*len(types),*types)+struct.pack('<I',len(rows))+b''.join(cell for row in rows for cell in row)
def strings(types,row):
    return {i:cell[4:].decode('cp1254',errors='replace') for i,(typ,cell) in enumerate(zip(types,row)) if typ==7}
def load(path):
    return parse(tbl.decrypt_tbl(Path(path)))
