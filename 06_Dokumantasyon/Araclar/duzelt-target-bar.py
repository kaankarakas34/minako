"""Point the stock 2083 client to its compatible supplied target frame bar layout.

Changes column 282 from ui\\re_target_framebar.uif (which contains the unsupported
and un-updated static "0 / 0 ( %0 )" text) to ui\\co_target_framebar.uif, the authentic
USKO target frame bar for client version 2083.
"""
from pathlib import Path
import hashlib, json, shutil, struct, sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / '06_Dokumantasyon/Araclar'))
from ko_tbl import load, parse, serialize, tbl

CLIENT = ROOT / '11_Istemci_Uyumluluk/Gamesoft_Yerel'
OUT = ROOT / '13_Istemci_Arayuz_Duzeltmesi'
BACKUP = OUT / 'Yedek'
BACKUP.mkdir(parents=True, exist_ok=True)

table = CLIENT / 'Data/UIs_us.tbl'
layout = CLIENT / 'UI/co_target_framebar.uif'
assert layout.is_file(), f'Target bar layout not found: {layout}'

# Backup current tbl before modification
backup_target = BACKUP / 'UIs_us.before-targetbar-fix.tbl'
if not backup_target.exists():
    shutil.copy2(table, backup_target)

head, types, rows = load(table)
assert len(types) == 312 and types[282] == 7, f'Unexpected schema: cols={len(types)}, col282_type={types[282]}'

before = [row.copy() for row in rows]
target = b'ui\\co_target_framebar.uif'
changed = []

for row in rows:
    identity = int.from_bytes(row[0], 'little')
    assert identity in (1, 2)
    old = row[282][4:]
    row[282] = struct.pack('<I', len(target)) + target
    if old != target:
        changed.append({
            'Nation': identity,
            'Old': old.decode('ascii', errors='replace'),
            'New': target.decode('ascii')
        })

# Verify only column 282 changed
assert all(a == b for x, y in zip(before, rows) for i, (a, b) in enumerate(zip(x, y)) if i != 282)

plain = serialize(head, types, rows)
assert parse(plain) == (head, types, rows)

candidate = OUT / 'UIs_us.targetbar-fixed.tbl'
candidate.write_bytes(tbl.encrypt_tbl(plain))
assert tbl.decrypt_tbl(candidate) == plain

shutil.copy2(candidate, table)

report = {
    'ClientWireVersion': 2083,
    'Column': 282,
    'Changed': changed,
    'OtherTableCellsUnchanged': True,
    'TableRoundTripPassed': True,
    'NewLayoutFile': 'UI/co_target_framebar.uif',
    'ClientExeChanged': False,
    'SHA256': hashlib.sha256(table.read_bytes()).hexdigest()
}

report_path = OUT / 'targetbar-resource-fix.json'
report_path.write_text(json.dumps(report, indent=2), encoding='utf8')
print(json.dumps(report, indent=2), flush=True)
