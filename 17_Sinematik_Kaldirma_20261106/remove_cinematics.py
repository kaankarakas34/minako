"""Remove cinematic-only resources from the isolated client; preserve recovery copies."""
from pathlib import Path
import argparse
import hashlib
import json
import shutil
import struct
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
OUT = Path(__file__).resolve().parent
CLIENT = ROOT / '11_Istemci_Uyumluluk/Gamesoft_Yerel'
BACKUP = OUT / 'Yedek'
sys.path.insert(0, str(ROOT/'06_Dokumantasyon/Araclar'))
from ko_tbl import load, parse, serialize, tbl

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()

def main(apply=False):
    table = CLIENT/'Data/movie_scene.tbl'
    head, types, rows = load(table)
    assert types == [6,7,7,6,2,2,2,2,3,2,3,3,3,2]
    assert sha(CLIENT/'KnightOnLine.exe') == '683befabae1f217296befda2a824b26bd2fff77bff67aa72a66c219c040f12fe'
    paths = set()
    for folder in ['Intro','KnightMovie']:
        paths.update(p.relative_to(CLIENT) for p in (CLIENT/folder).rglob('*') if p.is_file())
    for row in rows:
        for index in [1,2]:
            value = row[index][4:].decode('ascii')
            if value:
                path = Path(value.replace('\\','/'))
                assert path.parts[0].lower() == 'scene' and path.suffix.lower() in ['.n3scene','.n3scenex']
                if (CLIENT/path).is_file(): paths.add(path)
    plain = serialize(head, types, [])
    assert parse(plain) == (head, types, [])
    candidate = OUT/'movie_scene.empty.tbl'
    candidate.write_bytes(tbl.encrypt_tbl(plain))
    assert load(candidate) == (head, types, [])
    plan = {'Applied':False, 'OriginalSceneRows':len(rows), 'NewSceneRows':0,
        'FilesToRemove': [{'Path':str(p).replace('\\','/'),'SHA256':sha(CLIENT/p)} for p in sorted(paths)],
        'ClientExeModified':False,'GraphicalStartupVerified':False,'CharacterEntryVerified':False}
    if apply:
        # Require normal client exit. Never kill an online character to change assets.
        active = subprocess.check_output(['powershell.exe','-NoLogo','-NoProfile','-NonInteractive','-Command',
            "@(Get-Process -Name KnightOnLine -ErrorAction SilentlyContinue).Count"], text=True).strip()
        assert active == '0', 'Close the game normally before applying cinematic removal.'
        BACKUP.mkdir(exist_ok=True)
        assert not (BACKUP/'Data/movie_scene.tbl').exists(), 'Already applied; refusing to replace recovery copies.'
        (BACKUP/'Data').mkdir(exist_ok=True)
        shutil.copy2(table,BACKUP/'Data/movie_scene.tbl')
        for relative in sorted(paths):
            source = (CLIENT/relative).resolve()
            target = (BACKUP/relative).resolve()
            assert source.is_relative_to(CLIENT.resolve()) and target.is_relative_to(BACKUP.resolve())
            target.parent.mkdir(parents=True,exist_ok=True)
            assert not target.exists()
            shutil.move(str(source),str(target))
        shutil.copy2(candidate,table)
        assert load(table)==(head,types,[])
        assert all(not (CLIENT/p).exists() for p in paths)
        plan['Applied']=True
        plan['RecoveryCopies']=str(BACKUP)
        plan['ActiveMovieTableSHA256']=sha(table)
    (OUT/('removal-result.json' if apply else 'removal-plan.json')).write_text(json.dumps(plan,indent=2),encoding='utf8')
    print(json.dumps({'Applied':apply,'Files':len(paths),'SceneRowsBefore':len(rows),'SceneRowsAfter':0}))

if __name__=='__main__':
    args=argparse.ArgumentParser();args.add_argument('--apply',action='store_true');main(args.parse_args().apply)
