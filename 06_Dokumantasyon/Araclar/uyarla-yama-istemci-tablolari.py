"""Adapt six supplied data tables to the unmodified supplied patch client.

Only the isolated client copy is changed. Existing text bytes are preserved;
the seed-helper resource path explicitly selects the compatible supplied layout.
Expected native record sizes were read from this specific client's loaders.
DES data framing implementation: Bymuhh/ko-tbl-tools, MIT, pinned below.
"""
from pathlib import Path
import hashlib, json, struct, sys, subprocess

ROOT = Path(__file__).resolve().parents[2]
LIB = ROOT / '08_Arastirma_Adaylari/KO_TBL_Tools'
COMMIT = 'd1c49328188dec4b2474e21a43b0bfb4d9ce4d7c'
assert subprocess.check_output(['git', '-C', str(LIB), 'rev-parse', 'HEAD'], text=True).strip() == COMMIT
sys.path.insert(0, str(LIB))
import tbl

SRC = ROOT / '04_Istemci/Gamesoft_v24xx/Data'
DST = ROOT / '11_Istemci_Uyumluluk/Gamesoft_Yerel/Data'
STAGE = ROOT / '11_Istemci_Uyumluluk/Tablo_Incelemesi'
EXE = ROOT / '11_Istemci_Uyumluluk/Gamesoft_Yerel/KnightOnLine.exe'
assert hashlib.sha256(EXE.read_bytes()).hexdigest() == '683befabae1f217296befda2a824b26bd2fff77bff67aa72a66c219c040f12fe'
WIDTH = {1:1, 2:1, 3:2, 4:2, 5:4, 6:4, 8:4, 9:8, 10:8}

def parse(raw):
    count = struct.unpack_from('<I', raw, 5)[0]
    assert 0 < count < 4096
    types = list(struct.unpack_from('<' + 'I'*count, raw, 9))
    at = 9 + count*4
    rows_n = struct.unpack_from('<I', raw, at)[0]; at += 4
    assert rows_n < 1000000
    rows = []
    for _ in range(rows_n):
        row = []
        for typ in types:
            n = 4 + struct.unpack_from('<I', raw, at)[0] if typ == 7 else WIDTH[typ]
            assert 0 < n <= len(raw)-at
            row.append(raw[at:at+n]); at += n
        rows.append(row)
    assert at == len(raw)
    return raw[:5], types, rows

def serialize(head, types, rows):
    return head + struct.pack('<I', len(types)) + struct.pack('<'+'I'*len(types), *types) + struct.pack('<I', len(rows)) + b''.join(cell for row in rows for cell in row)

def record_size(types):
    at = 0
    for typ in types:
        n = 28 if typ == 7 else WIDTH[typ]
        a = min(n, 4); at = (at+a-1)//a*a+n
    return (at+3)//4*4

def load(name):
    cache = STAGE / (name+'.plain')
    data = cache.read_bytes() if cache.exists() else tbl.decrypt_tbl(SRC/name)
    return parse(data)

STAGE.mkdir(exist_ok=True)
_, item_types, item_rows = load('Item_Org_us.tbl')
assert len(item_types) == 41 and item_types[-1] == 2
names = {struct.unpack('<I', row[0])[0]: row[2] for row in item_rows}
spec = [('UIs_us.tbl',312,0x2208,0x95b4cc), ('Item_Org_us.tbl',40,0x94,0x95be58), ('Cloak.tbl',7,0x34,0x4b0e58)]
spec += [(n,None,0x2c,0x964a98) for n in ['item_user_buy_nomal_us.tbl','item_user_buy_wepon_us.tbl','item_user_buy_armor_us.tbl']]
report = {'ExeSHA256': hashlib.sha256(EXE.read_bytes()).hexdigest(), 'CryptoSource': f'https://github.com/Bymuhh/ko-tbl-tools/tree/{COMMIT}', 'Tables': []}
for name, keep, expected, evidence in spec:
    head, types, rows = load(name)
    before_types = types[:]
    original_ids = [row[0] for row in rows]
    unresolved = []
    if keep:
        types = types[:keep]; adapted = [row[:keep] for row in rows]
        if name == 'UIs_us.tbl':
            assert types[160] == 7 and types[282] == 7
            helper = b'ui\\co_seed_helper_us.uif'
            targetbar = b'ui\\co_target_framebar.uif'
            for row in adapted:
                row[160] = struct.pack('<I', len(helper)) + helper
                row[282] = struct.pack('<I', len(targetbar)) + targetbar
    else:
        assert types == [6,2,2,6,2]
        types = [6,7,2,2,6,2]; adapted = []
        for row in rows:
            item_id = struct.unpack('<I', row[0])[0]
            label = names.get(item_id) or names.get(item_id//1000*1000)
            if label is None:
                unresolved.append(item_id); label = struct.pack('<I', 0)
            adapted.append([row[0], label, *row[1:]])
    assert record_size(types) == expected, (name, record_size(types), expected)
    assert original_ids == [row[0] for row in adapted]
    plain = serialize(head, types, adapted)
    assert parse(plain) == (head, types, adapted)
    packed = tbl.encrypt_tbl(plain)
    staged = STAGE / (name+'.adapted'); staged.write_bytes(packed)
    decoded = tbl.decrypt_tbl(staged)
    assert decoded == plain
    report['Tables'].append({'File': name, 'Rows': len(rows), 'OriginalColumns': len(before_types), 'Columns':len(types), 'NativeSize':expected, 'NativeSizeCheckVA':hex(evidence), 'SHA256':hashlib.sha256(packed).hexdigest(), 'IDsPreserved':True, 'BinaryRoundTrip':True, 'UnresolvedNames':unresolved})
    print(json.dumps({'File':name, 'Rows':len(rows), 'Columns':len(types), 'UnresolvedNames':len(unresolved)}), flush=True)
for name, *_ in spec:
    assert DST.resolve().is_relative_to((ROOT/'11_Istemci_Uyumluluk').resolve())
    (DST/name).write_bytes((STAGE/(name+'.adapted')).read_bytes())
(ROOT/'11_Istemci_Uyumluluk/patch-table-adaptation.json').write_text(json.dumps(report,indent=2),encoding='utf-8')
print('Six isolated client tables installed; originals unchanged.', flush=True)
