"""Read-only Lua 5.2 syntax and reference audit; never executes candidate code."""
from pathlib import Path
import csv
import hashlib
import json
import re
from collections import defaultdict, Counter
from lupa import lua52

ROOT = Path(__file__).resolve().parents[2]
REPORT = ROOT / '06_Dokumantasyon/Internet_Arastirmasi'
SOURCES = [
    ('AKGame-2383', 'halilcanakcay/knight-online-server-files-2383',
     'cfec765ff19d58a1b9a8ae07bcedcd7bf72f0ece', 'Server/Quests'),
    ('22xx-FilesKoRelease', 'omeraraz22/22xx-FilesKoRelease',
     'ad45c5d707a1506e8f48532124573bdf2bc2d92d', 'Quests'),
    ('22xx-FilesKoRelease', 'omeraraz22/22xx-FilesKoRelease',
     'ad45c5d707a1506e8f48532124573bdf2bc2d92d', 'OldQuests'),
    ('Orcun-24xx', 'OrcunEryurekliler/KO-24xx-Server',
     '52d6e67f3f07751a5f917899dc0a632debc3d903', '24xx/serverfile/23.05.2023Release/Quests'),
]

def read_csv(path):
    with path.open(encoding='utf-8-sig', newline='') as stream:
        return list(csv.DictReader(stream))

def write_csv(name, rows):
    if not rows:
        return
    with (REPORT / name).open('w', encoding='utf-8-sig', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)

missing = read_csv(ROOT / '06_Dokumantasyon/Kurulum/eksik-lua-dosyalari.csv')
missing_names = {r['ScriptFile'].lower(): r['ScriptFile'] for r in missing}
helpers = defaultdict(list)
for row in read_csv(REPORT / 'yerel-QUEST_HELPER.csv'):
    helpers[row['strLuaFilename'].strip().lower()].append(row)
exchanges = {int(r['nIndex']) for r in read_csv(REPORT / 'yerel-ITEM_EXCHANGE.csv')}
npcs = {int(r['sSid']) for r in read_csv(REPORT / 'yerel-K_NPC.csv')}
source_text = (ROOT / '01_Kaynak_Kod/TemuKO-main/ServerFiles/SourceFiles/GameServer/LuaEngine.cpp').read_text(encoding='utf-8-sig')
# Only the active global registration table, with line comments removed.
table_text = source_text.split('CLuaEngine::CLuaEngine', 1)[0]
table_text = re.sub(r'//[^\n]*', '', table_text)
registered = set(re.findall(r'MAKE_LUA_FUNCTION\((\w+)\)', table_text))
builtins = set('assert collectgarbage dofile error getmetatable ipairs load loadfile next pairs pcall print rawequal rawget rawlen rawset require select setmetatable tonumber tostring type xpcall'.split())
keywords = set('if elseif for while function and or not until return'.split())
runtime = lua52.LuaRuntime(encoding=None, register_eval=False, register_builtins=False, max_memory=32*1024*1024)
results = []
counts = []
for local_name, repo, commit, folder in SOURCES:
    base = ROOT / '08_Arastirma_Adaylari' / local_name / folder
    files = sorted(base.rglob('*.lua'))
    counts.append({'repo': repo, 'folder': folder, 'lua_files': len(files), 'commit': commit})
    for path in files:
        name = path.name.lower()
        if name not in missing_names:
            continue
        raw = path.read_bytes()
        text = raw.decode('utf-8-sig', errors='replace')
        # Compilation checks syntax only. The returned function is never called.
        syntax_error = ''
        try:
            # luaL_loadfile(), used by TemuKO, skips a UTF-8 BOM before parsing.
            parser_bytes = raw[3:] if raw.startswith(b'\xef\xbb\xbf') else raw
            runtime.compile(parser_bytes, name=path.name.encode('utf-8'), mode=b't')
        except Exception as exc:
            syntax_error = str(exc)
        code = re.sub(r'--\[(=*)\[.*?\]\1\]', '', text, flags=re.S)
        code = re.sub(r'--[^\n]*', '', code)
        code = re.sub(r'"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'', '""', code)
        calls = set(re.findall(r'(?<![\w.:])([A-Za-z_]\w*)\s*\(', code)) - keywords
        declared = set(re.findall(r'function\s+(\w+)\s*\(', code))
        has_code = bool(code.strip())
        unknown = sorted(calls - registered - builtins - declared)
        script_npcs = {int(x) for x in re.findall(r'\bNPC\s*=\s*(\d+)', code)}
        expected_npcs = {int(r['sNpcId']) for r in helpers[name] if int(r['sNpcId']) > 0}
        literal_exchanges = {int(x) for x in re.findall(r'\bRunQuestExchange\s*\(\s*UID\s*,\s*(\d+)', code)}
        event_literals = {int(x) for x in re.findall(r'\bEVENT\s*==\s*(\d+)', code)}
        expected_events = {int(r[col]) for r in helpers[name] for col in ('nEventTriggerIndex', 'nEventCompleteIndex') if int(r[col]) > 0}
        results.append({
            'ScriptFile': missing_names[name], 'Repository': repo, 'Commit': commit,
            'SourceFolder': folder, 'LocalPath': str(path),
            'SourceUrl': f'https://github.com/{repo}/blob/{commit}/{folder}/{path.name}',
            'SHA256': hashlib.sha256(raw).hexdigest(), 'Bytes': len(raw),
            'Utf8BOM': raw.startswith(b'\xef\xbb\xbf'),
            'HasNonCommentCode': has_code,
            'Lua52SyntaxOK': not syntax_error, 'SyntaxError': syntax_error,
            'UnregisteredGlobalCallsHeuristic': ';'.join(unknown),
            'ExpectedNpcIds': ';'.join(map(str, sorted(expected_npcs))),
            'ScriptNpcIds': ';'.join(map(str, sorted(script_npcs))),
            'ExpectedNpcIdsMissingInLocalTable': ';'.join(map(str, sorted(expected_npcs-npcs))),
            'ExpectedNpcIdsNotLiteralInScript': ';'.join(map(str, sorted(expected_npcs-script_npcs))),
            'QuestExchangeIdsMissingInLocalTable': ';'.join(map(str, sorted(literal_exchanges-exchanges))),
            'ExpectedHelperEventsNotLiteralInScript': ';'.join(map(str, sorted(expected_events-event_literals))),
        })
write_csv('alternatif-lua-dosya-kontrolu.csv', results)
found = {r['ScriptFile'].lower() for r in results}
nonempty_found = {r['ScriptFile'].lower() for r in results if r['HasNonCommentCode']}
write_csv('alternatiflerde-bulunamayan-lua.csv', [r for r in missing if r['ScriptFile'].lower() not in found])
write_csv('alternatiflerde-kodlu-dosyasi-bulunamayan-lua.csv', [r for r in missing if r['ScriptFile'].lower() not in nonempty_found])
summary = {
    'date': '2026-11-04', 'lua_parser': runtime.lua_implementation.decode(),
    'original_missing_lua_names': len(missing_names), 'source_counts': counts,
    'matching_variant_paths': len(results), 'matching_unique_names': len(found),
    'still_unmatched_names': len(missing_names.keys()-found),
    'unique_names_with_nonempty_code': len(nonempty_found),
    'unique_names_found_only_as_empty_files': sorted(found-nonempty_found),
    'names_without_nonempty_code_in_legacy_candidates': len(missing_names.keys()-nonempty_found),
    'syntax_pass_variant_paths': sum(r['Lua52SyntaxOK'] for r in results),
    'syntax_fail_variant_paths': sum(not r['Lua52SyntaxOK'] for r in results),
    'unique_names_with_syntax_pass_variant': len({r['ScriptFile'].lower() for r in results if r['Lua52SyntaxOK']}),
    'unique_names_with_syntax_pass_and_no_unregistered_call_detected': len({r['ScriptFile'].lower() for r in results if r['Lua52SyntaxOK'] and not r['UnregisteredGlobalCallsHeuristic']}),
    'global_calls_absent_from_temu_source_table': dict(Counter(c for r in results for c in r['UnregisteredGlobalCallsHeuristic'].split(';') if c)),
    'limits': [
        'Candidate code was compiled for syntax only and was never executed.',
        'Main runtime, original INI files and SQL schema/data were not modified.',
        'Global API comparison uses TemuKO source 2239; compiled server API is not proven identical.',
        'Regex reference checks are preliminary; missing literal events are warnings, not proof of incompatibility.',
        'Matching filenames and syntax do not verify quest rewards, exploit resistance or runtime compatibility.',
        'Original 12 extensionless missing references are outside the 468-name Lua comparison.'
    ]
}
(REPORT / 'alternatif-lua-ozeti.json').write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding='utf-8')
print(json.dumps(summary, ensure_ascii=True, indent=2))
