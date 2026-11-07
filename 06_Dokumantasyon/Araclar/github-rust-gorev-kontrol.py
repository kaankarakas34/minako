"""Audit the alternative v2603 scripts as text/compiled chunks only."""
from pathlib import Path
import csv, re, json, hashlib
from collections import Counter
from lupa import lua52

root = Path(__file__).resolve().parents[2]
report = root / '06_Dokumantasyon/Internet_Arastirmasi'
repo = 'derdems44/KORustGameServer'
commit = '5ee5b737a42f87ccb951ac54ff5eaa4007820902'
base = root / '08_Arastirma_Adaylari/KORust-Inceleme/Quests'
starting = json.loads((report / 'github-genis-tarama.json').read_text(encoding='utf-8'))
targets = {x.lower() for x in starting['startingMissingNames']}
with (root / '06_Dokumantasyon/Kurulum/eksik-lua-dosyalari.csv').open(encoding='utf-8-sig') as f:
    missing = {r['ScriptFile'].lower(): r['ScriptFile'] for r in csv.DictReader(f)}
with (report / 'alternatiflerde-kodlu-dosyasi-bulunamayan-lua.csv').open(encoding='utf-8-sig') as f:
    legacy_no_code = {r['ScriptFile'].lower() for r in csv.DictReader(f)}
helpers = {}
with (report / 'yerel-QUEST_HELPER.csv').open(encoding='utf-8-sig') as f:
    for r in csv.DictReader(f):
        helpers.setdefault(r['strLuaFilename'].strip().lower(), []).append(r)
lua = lua52.LuaRuntime(encoding=None, register_eval=False, register_builtins=False, max_memory=32*1024*1024)
rows = []
for path in sorted(base.glob('*.lua')):
    name = path.name.lower()
    if name not in missing:
        continue
    data = path.read_bytes()
    code = data.decode('utf-8-sig', errors='replace')
    code = re.sub(r'--\[(=*)\[.*?\]\1\]', '', code, flags=re.S)
    code = re.sub(r'--[^\n]*', '', code)
    calls = set(re.findall(r'(?<![\w.:])([A-Za-z_]\w*)\s*\(', code)) - {'if','elseif','while','for','function','until','and','or','not'}
    dispatcher = bool(code.strip()) and 'SearchQuest' in calls and calls <= {'SearchQuest','SelectMsg','NpcMsg'} and bool(re.search(r'\bEVENT\s*=\s*QuestNum', code))
    error = ''
    try:
        lua.compile(data[3:] if data.startswith(b'\xef\xbb\xbf') else data, name=path.name.encode(), mode=b't')
    except Exception as exc:
        error = str(exc)
    handlers = {int(x) for x in re.findall(r'\bEVENT\s*==\s*(\d+)', code)}
    expected = {int(r[k]) for r in helpers.get(name, []) for k in ('nEventTriggerIndex','nEventCompleteIndex') if int(r[k]) > 0}
    rows.append({'ScriptFile': missing[name], 'WasInPrevious183': name in targets,
        'NoNonemptyLegacyCandidate': name in legacy_no_code,
        'Bytes': len(data), 'SHA256': hashlib.sha256(data).hexdigest(),
        'LocalPath': str(path), 'SourceUrl': f'https://github.com/{repo}/blob/{commit}/Quests/{path.name}',
        'Lua52SyntaxOK': not error, 'SyntaxError': error,
        'DispatcherOnlyHeuristic': dispatcher, 'GlobalCallsHeuristic': ';'.join(sorted(calls)),
        'LiteralEventHandlers': ';'.join(map(str, sorted(handlers))),
        'ExpectedHelperEventsNotLiteralInScript': ';'.join(map(str, sorted(expected-handlers)))})
with (report / 'github-rust-gorev-kontrolu.csv').open('w',encoding='utf-8-sig',newline='') as f:
    w=csv.DictWriter(f, fieldnames=rows[0]);w.writeheader();w.writerows(rows)
found = {r['ScriptFile'].lower() for r in rows}
new_rows = [r for r in rows if r['WasInPrevious183']]
needs = [r for r in rows if r['NoNonemptyLegacyCandidate']]
summary = {'repository': repo, 'commit': commit, 'target_client_version_per_readme': 2603,
    'source_lua_count': len(list(base.glob('*.lua'))), 'matching_original468': len(rows),
    'matched_of_previous183': len(new_rows),
    'dispatcher_only_of_previous183': sum(r['DispatcherOnlyHeuristic'] for r in new_rows),
    'non_dispatcher_of_previous183': [r['ScriptFile'] for r in new_rows if not r['DispatcherOnlyHeuristic']],
    'syntax_fail_of_previous183': [r['ScriptFile'] for r in new_rows if not r['Lua52SyntaxOK']],
    'matched_of_legacy_no_code191': len(needs),
    'dispatcher_only_of_legacy_no_code191': sum(r['DispatcherOnlyHeuristic'] for r in needs),
    'no_exact_candidate_in_all_downloaded_sets': [missing[n] for n in sorted(missing.keys()-found) if n in legacy_no_code],
    'limits': ['No candidate code was executed and no runtime/SQL changes were made.',
        'Only-dispatch scripts do not supply downstream handlers for the assigned QuestNum.',
        'A dispatcher may suffice for a dialog-only NPC; it does not demonstrate a complete quest implementation.',
        'The source targets a different server implementation, database and client version.']}
(report / 'github-rust-gorev-ozeti.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps(summary,ensure_ascii=True,indent=2))
