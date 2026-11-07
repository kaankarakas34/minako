"""Build a reviewable quest overlay for the bundled, statically identified 2083 API."""
from pathlib import Path
import csv, re, json, hashlib
from collections import defaultdict, Counter
from lupa import lua52

ROOT=Path(__file__).resolve().parents[2]
DATA=ROOT/'06_Dokumantasyon/Internet_Arastirmasi'
REPORT=ROOT/'06_Dokumantasyon/Uyarlama';REPORT.mkdir(exist_ok=True)
DEST=ROOT/'09_Uyarlama/24xx/Quests'
REVIEW=ROOT/'09_Uyarlama/Inceleme_Bekleyen';REVIEW.mkdir(exist_ok=True)
def csvread(path):
    with path.open(encoding='utf-8-sig',newline='') as f:return list(csv.DictReader(f))
def csvwrite(name,rows):
    if not rows:return
    with (REPORT/name).open('w',encoding='utf-8-sig',newline='') as f:
        w=csv.DictWriter(f,fieldnames=rows[0]);w.writeheader();w.writerows(rows)
api=set(json.loads((REPORT/'hazir-gameserver-lua-api.json').read_text())['Present'])
helpers=csvread(DATA/'yerel-QUEST_HELPER.csv')
byfile=defaultdict(list)
byid={int(r['nIndex']):r for r in helpers}
for r in helpers:byfile[r['strLuaFilename'].strip()].append(r)
exchanges={int(r['nIndex']):r for r in csvread(DATA/'yerel-ITEM_EXCHANGE.csv')}
bonus_exchanges={int(r['nIndex']):r for r in csvread(DATA/'yerel-ITEM_EXCHANGE_EXP.csv')}
talks={int(r['iNum']):r['strTalk'].strip() for r in csvread(DATA/'yerel-QUEST_TALK.csv')}
sources=[
    ('Original',ROOT/'02_Sunucu/24xx/Quests'),
    ('22xx-Old',ROOT/'08_Arastirma_Adaylari/22xx-FilesKoRelease/OldQuests'),
    ('22xx-New',ROOT/'08_Arastirma_Adaylari/22xx-FilesKoRelease/Quests'),
    ('AKGame',ROOT/'08_Arastirma_Adaylari/AKGame-2383/Server/Quests'),
    ('Orcun',ROOT/'08_Arastirma_Adaylari/Orcun-24xx/24xx/serverfile/23.05.2023Release/Quests'),
    ('Rust',ROOT/'08_Arastirma_Adaylari/KORust-Inceleme/Quests'),
]
files=defaultdict(list)
for rank,(label,folder) in enumerate(sources):
    for p in folder.glob('*.lua'):files[p.name.lower()].append((rank,label,p))
runtime=lua52.LuaRuntime(encoding=None,register_eval=False,register_builtins=False,max_memory=32*1024*1024)
protected=re.compile(r'--\[(=*)\[.*?\]\1\]|--[^\n]*|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'',re.S)
def clean(s):return protected.sub(lambda m:'\n'*m[0].count('\n') if m[0].startswith('--') else '""',s)
def replace_names(s,mapping):
    pattern=re.compile(protected.pattern+r'|\b[A-Za-z_]\w*\b',re.S)
    return pattern.sub(lambda m:mapping.get(m[0],m[0]),s)
def compile_error(code):
    try:runtime.compile(code.encode(),mode=b't');return ''
    except Exception as e:return str(e)
keywords=set('if elseif for while function until and or not return'.split())
builtins=set('assert error ipairs pairs next tonumber tostring type pcall select print'.split())
compat={'UpdateEvent','GetQuestStatus','RunQuestExchange'}
def calls(s):return set(re.findall(r'(?<![\w.:])([A-Za-z_]\w*)\s*\(',clean(s)))-keywords
def expected_events(rs):return {int(r[k]) for r in rs for k in ('nEventTriggerIndex','nEventCompleteIndex') if int(r[k])>0}
def selected_supported(args):
    # Native RunSelectExchange does not consume the same input groups as the
    # newer RunQuestExchange. Do not equate them just because STEP is present.
    if len(args)!=2 or not args[1].isdigit():return False
    exchange=int(args[1]);base=exchanges.get(exchange);bonus=bonus_exchanges.get(exchange)
    if base is None or int(base['bRandomFlag']) not in (0,10,11,12):return False
    if bonus and any(int(bonus[f'nExchangeItemNum{i}'])>0 and int(bonus[f'nExchangeItemCount{i}'])>0 for i in range(1,6)):return False
    return True
def native_event_blocks(text):
    """Find complete top-level Lua EVENT branches, retaining exact source spans."""
    masked=protected.sub(lambda m:''.join('\n' if c=='\n' else ' ' for c in m[0]),text)
    tokens=list(re.finditer(r'\b(if|elseif|then|else|end|for|while|do|function|repeat|until)\b',masked))
    stack=[];blocks=[]
    for token in tokens:
        word=token[0]
        if word in ('if','for','while','function','repeat'):
            events=[]
            if word=='if' and not stack:
                tail=masked[token.end():];then=re.search(r'\bthen\b',tail)
                if then:events=[int(x) for x in re.findall(r'\bEVENT\s*==\s*(-?\d+)',tail[:then.start()])]
            stack.append([word,token.start(),events,word in ('for','while')])
        elif word=='do':
            if stack and stack[-1][0] in ('for','while') and stack[-1][3]:stack[-1][3]=False
            else:stack.append(['do',token.start(),[],False])
        elif word in ('end','until'):
            if not stack:continue
            kind,start,events,_=stack.pop()
            if kind=='if' and not stack and events:blocks.append((start,token.end(),events,text[start:token.end()]))
    return blocks
def isolate_unsupported_events(text,unknown):
    blocked=set();reasons=set();ranges=[]
    for start,end,events,block in native_event_blocks(text):
        bc=clean(block)
        bad_calls=calls(block)&unknown
        bad_ids={int(x) for x in re.findall(r'\b(?:SaveEvent|UpdateEvent)\s*\(\s*UID\s*,\s*(\d+)',bc)}-byid.keys()
        bad_select=any(not selected_supported([x.strip() for x in s.split(',')]) for s in re.findall(r'\bRunQuestExchange\s*\(([^)]*)\)',bc))
        if bad_calls or bad_ids or bad_select:
            ranges.append((start,end));blocked.update(events)
            reasons.update('native:'+x for x in bad_calls)
            reasons.update('helper:'+str(x) for x in bad_ids)
            if bad_select:reasons.add('selected reward semantics')
    for start,end in reversed(ranges):
        text=text[:start]+'-- Unsupported EVENT branch is retained in the review copy.\n'+text[end:]
    return text,blocked,reasons
def add_verified_blocks(name,rs,text):
    """Append only missing metadata-derived groups that exactly match the local SQL.

    Never copy zero-text placeholder dialogs, unknown native features, foreign
    helper IDs, or conflicting handlers into the current implementation.
    """
    current={int(x) for x in re.findall(r'\bEVENT\s*==\s*(\d+)',clean(text))}
    missing=expected_events(rs)-current
    if not missing:return text,[]
    rust=[entry for entry in files.get(name.lower(),[]) if entry[1]=='Rust']
    if not rust:return text,[]
    raw=rust[0][2].read_text(encoding='utf-8-sig')
    blocks=list(re.finditer(r'^-- \[AUTO-GEN\] quest=(\d+) status=(\d+) n_index=(\d+)[^\n]*\n',raw,re.M))
    groups=defaultdict(list)
    for i,m in enumerate(blocks):
        end=blocks[i+1].start() if i+1<len(blocks) else len(raw)
        block=raw[m.start():end].strip()
        # Divider comments are irrelevant to the code; each marker is one handler.
        match=re.search(r'\bEVENT\s*==\s*(\d+)',clean(block))
        if not match:continue
        groups[int(m[1])].append((int(m[2]),int(m[3]),int(match[1]),block))
    appended=[];changes=[]
    for quest,items in groups.items():
        if not any(event in missing for _,_,event,_ in items):continue
        valid=True;prepared=[]
        for status,helper,event,block in items:
            row=byid.get(helper)
            if row is None or int(row['sEventDataIndex'])!=quest or int(row['bEventStatus'])!=status or row['strLuaFilename'].strip().lower()!=name.lower():
                valid=False;break
            bc=clean(block)
            if calls(block)-api-compat-builtins:
                valid=False;break
            state_refs=[int(x) for x in re.findall(r'\bSaveEvent\s*\(\s*UID\s*,\s*(\d+)',bc)]
            if any(i not in byid or int(byid[i]['sEventDataIndex'])!=quest for i in state_refs):
                valid=False;break
            # Header text must have an actual local definition. Zero is not a
            # replacement for missing authored quest content.
            headers=[int(x) for x in re.findall(r'\bSelectMsg\s*\(\s*UID\s*,\s*\d+\s*,\s*-?\d+\s*,\s*(\d+)',bc)]
            if any(i<=0 or i not in talks for i in headers):
                valid=False;break
            exs=[int(x) for x in re.findall(r'\bRunQuestExchange\s*\(\s*UID\s*,\s*(\d+)',bc)]
            allowed_ex={int(r['nExchangeIndex']) for r in rs if int(r['sEventDataIndex'])==quest}
            if any(i not in exchanges or i not in allowed_ex for i in exs):
                valid=False;break
            block=re.sub(r'\bShowMap\s*\(\s*UID\s*,\s*\d+\s*\)',f'ShowMap(UID, {helper})',block)
            if event not in current:prepared.append((event,block))
        if not valid:continue
        for event,block in prepared:
            if event in current:continue
            appended.append(block);current.add(event)
        if prepared:changes.append(f'local-SQL-verified event group quest {quest}')
    if appended:text+='\n\n-- Missing handlers verified against this database snapshot.\n'+'\n\n'.join(appended)+'\n'
    return text,changes
def reward_guard(text):
    """Stop the chunk before committing completion with missing inputs/capacity.

    Keep native exchange semantics. Do not turn an unknown server feature into a
    fake success or grant any reward inferred from a filename.
    """
    code=clean(text)
    refs={int(x) for x in re.findall(r'\bSaveEvent\s*\(\s*UID\s*,\s*(\d+)',code)}
    completion={i:byid[i] for i in refs if i in byid and int(byid[i]['bEventStatus'])==2 and int(byid[i]['sEventDataIndex'])>0}
    if not completion and not (calls(text)&{'RunExchange','RunSelectExchange'}):return text,False
    ids={int(r['nExchangeIndex']) for r in completion.values() if int(r['nExchangeIndex'])>0}
    ids.update(int(x) for x in re.findall(r'\b(?:RunExchange|RunSelectExchange)\s*\(\s*UID\s*,\s*(\d+)',code))
    req=[]
    for ex in sorted(ids):
        if ex not in exchanges:continue
        pairs=[]
        for j in range(1,6):
            item=int(exchanges[ex][f'nOriginItemNum{j}']);count=int(exchanges[ex][f'nOriginItemCount{j}'])
            if item>0 and count>0:pairs.append('{'+str(item)+','+str(count)+'}')
        req.append(f'  [{ex}]={{'+','.join(pairs)+'},')
    hrows=[f'  [{i}]={{{int(r["sEventDataIndex"])},{int(r["nExchangeIndex"])}}},' for i,r in sorted(completion.items())]
    qbyex=defaultdict(set)
    for r in completion.values():qbyex[int(r['nExchangeIndex'])].add(int(r['sEventDataIndex']))
    qrows=[f'  [{ex}]={{'+','.join(map(str,sorted(qs)))+'},' for ex,qs in sorted(qbyex.items()) if ex>0]
    pre='''-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
'''+ '\n'.join(req)+'''
}
local __KO_Completion = {
'''+ '\n'.join(hrows)+'''
}
local __KO_Quests = {
'''+ '\n'.join(qrows)+'''
}
local function __KO_Ready(uid, exchange)
  if not CheckExchange(uid, exchange) then return false end
  local required = __KO_Requirements[exchange]
  if required == nil then return false end
  for _, pair in ipairs(required) do
    if HowmuchItem(uid, pair[1]) < pair[2] then return false end
  end
  return true
end
local function __KO_AlreadyComplete(uid, exchange)
  local quests = __KO_Quests[exchange]
  if quests == nil then return false end
  local completed = false
  for _, quest in ipairs(quests) do
    if CheckExistEvent(uid, quest, 1) or CheckExistEvent(uid, quest, 3) or CheckExistEvent(uid, quest, 4) then return false end
    if CheckExistEvent(uid, quest, 2) and not __KO_Committed[quest] then completed = true end
  end
  return completed
end
local function RunExchange(uid, exchange)
  if __KO_AlreadyComplete(uid, exchange) and not __KO_Done[exchange] then error(__KO_Stop) end
  if __KO_Done[exchange] and __KO_Quests[exchange] ~= nil then return true end
  if not __KO_Ready(uid, exchange) then error(__KO_Stop) end
  local ok = __KO_Run(uid, exchange)
  if not ok then error(__KO_Stop) end
  __KO_Done[exchange] = true
  return true
end
local function RunSelectExchange(uid, exchange)
  if __KO_AlreadyComplete(uid, exchange) and not __KO_Done[exchange] then error(__KO_Stop) end
  if __KO_Done[exchange] and __KO_Quests[exchange] ~= nil then return true end
  if not __KO_Ready(uid, exchange) then error(__KO_Stop) end
  local ok = __KO_Select(uid, exchange)
  if not ok then error(__KO_Stop) end
  __KO_Done[exchange] = true
  return true
end
local function SaveEvent(uid, helper)
  local completing = __KO_Completion[helper]
  if completing ~= nil then
    if CheckExistEvent(uid, completing[1], 2) then error(__KO_Stop) end
    if completing[2] > 0 and not __KO_Done[completing[2]] and not __KO_Ready(uid, completing[2]) then error(__KO_Stop) end
  end
  __KO_Save(uid, helper)
  if completing ~= nil then __KO_Committed[completing[1]] = true end
end
local __KO_OK, __KO_Error = pcall(function()
'''
    return pre+text+'\nend)\nif not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end\n',True
def stage(name,label,path,text,changes,rs,status):
    text,guarded=reward_guard(text)
    if guarded:changes.append('native exchange preflight + completed-quest repeat guard')
    header=f'-- Adapted for bundled GameServer SHA256 19e92a27...; source {label}\n'
    body=header+text
    (DEST/name).write_text(body,encoding='utf-8',newline='\n')
    # The binary uses ./Quests; mirror the historical duplicate folder consistently.
    other=ROOT/'09_Uyarlama/24xx/Lua/Quests'/name;other.parent.mkdir(exist_ok=True,parents=True);other.write_text(body,encoding='utf-8',newline='\n')
    return {'ScriptFile':name,'Status':status,'Source':label,'SourcePath':str(path) if path else '',
        'Changes':';'.join(changes),'SHA256':hashlib.sha256(body.encode()).hexdigest(),
        'SyntaxError':compile_error(body),'UnsupportedCalls':';'.join(sorted(calls(body)-api-builtins-{'__KO_Save','__KO_Run','__KO_Select'}-set(re.findall(r'(?:local\s+)?function\s+(\w+)\s*\(',body))))}

rows=[];rejected=[];detail=[]
for name,rs in sorted(byfile.items()):
    target_npcs={int(r['sNpcId']) for r in rs}
    candidates=files.get(name.lower(),[])
    if not name.lower().endswith('.lua'):
        prefix=name.lower()+'_'
        candidates=[entry for key,entries in files.items() if key.startswith(prefix) for entry in entries]
    scored=[]
    for rank,label,path in candidates:
        raw=path.read_bytes()
        if not raw:continue
        try:text=raw.decode('utf-8-sig')
        except UnicodeDecodeError:text=raw.decode('cp1254')
        text=text.replace('\r\n','\n')
        if not clean(text).strip():continue
        err=compile_error(text)
        if err:continue
        c=clean(text);unknown=calls(text)-api-compat-builtins-set(re.findall(r'function\s+(\w+)\s*\(',c))
        literal_events={int(x) for x in re.findall(r'\bEVENT\s*==\s*(\d+)',c)}
        gaps=expected_events(rs)-literal_events
        state_refs={int(x) for x in re.findall(r'\b(?:SaveEvent|UpdateEvent)\s*\(\s*UID\s*,\s*(\d+)',c)}
        bad_ids=state_refs-byid.keys()
        # Prefer available native functions and locally valid helper IDs over folder labels.
        score=10000*len(unknown)+500*len(bad_ids)+50*len(gaps)+rank
        if label=='Original':score-=2
        mismatch=sum(not selected_supported([x.strip() for x in s.split(',')]) for s in re.findall(r'\bRunQuestExchange\s*\(([^)]*)\)',c))
        score+=10000*mismatch
        scored.append((score,rank,label,path,text,unknown,gaps,state_refs))
    scored.sort(key=lambda x:x[0])
    if not scored:
        npc=next(iter(target_npcs)) if len(target_npcs)==1 else 0
        body=f'-- Original quest behavior is unavailable. No reward or state is fabricated.\nSelectMsg(UID, 2, -1, 10526, {npc}, 10, -1)\nreturn\n'
        row=stage(name,'Protected unavailable content',None,body,['missing authored content; interaction protected'],rs,'BLOCKED_MISSING_QUEST_CONTENT')
        rows.append(row)
        continue
    _,rank,label,path,text,unknown,gaps,state_refs=scored[0]
    changes=[]
    original_candidate=text
    text,blocked,reasons=isolate_unsupported_events(text,unknown)
    if blocked:
        (REVIEW/name).write_text(original_candidate,encoding='utf-8')
        changes.append('isolated unsupported EVENTs '+','.join(map(str,sorted(blocked))))
        unknown=calls(text)-api-compat-builtins-set(re.findall(r'function\s+(\w+)\s*\(',clean(text)))
    if unknown:
        (REVIEW/name).write_text(text,encoding='utf-8')
        rows.append({'ScriptFile':name,'Status':'REVIEW_UNSUPPORTED_API','Source':label,'SourcePath':str(path),'Changes':'','SHA256':'','SyntaxError':'','UnsupportedCalls':';'.join(sorted(unknown))})
        continue
    c=clean(text)
    declared_npcs={int(x) for x in re.findall(r'\blocal\s+NPC\s*=\s*(\d+)',c)}
    if not declared_npcs and len(target_npcs)==1:
        text=f'local NPC = {next(iter(target_npcs))};\n'+text
        changes.append('NPC injected from local SQL')
    if len(target_npcs)==1 and len(declared_npcs)==1 and declared_npcs!=target_npcs:
        old=next(iter(declared_npcs));new=next(iter(target_npcs))
        if old!=0:
            text=re.sub(r'\blocal\s+NPC\s*=\s*'+str(old)+r'\b',f'local NPC = {new}',text)
            changes.append(f'NPC {old}->{new}')
    # Global helper IDs come from this restored SQL, not from NPC filename prefixes.
    refs={int(x) for x in re.findall(r'\b(?:SaveEvent|UpdateEvent)\s*\(\s*UID\s*,\s*(\d+)',clean(text))}
    missing_ids=refs-byid.keys()
    if missing_ids:
        (REVIEW/name).write_text(text,encoding='utf-8')
        rows.append({'ScriptFile':name,'Status':'REVIEW_HELPER_IDS','Source':label,'SourcePath':str(path),'Changes':';'.join(changes),'SHA256':'','SyntaxError':'','UnsupportedCalls':';'.join(map(str,sorted(missing_ids)))})
        continue
    text,merged=add_verified_blocks(name,rs,text)
    changes.extend(merged)
    prefix=[]
    if 'UpdateEvent' in calls(text):
        text=replace_names(text,{'UpdateEvent':'SaveEvent'});changes.append('UpdateEvent->SaveEvent')
    if 'GetQuestStatus' in calls(text):
        prefix.append('local function GetQuestStatus(uid, quest)\n  for state=0,4 do\n    if CheckExistEvent(uid, quest, state) then return state end\n  end\n  if CheckExistEvent(uid, quest, 255) then return 255 end\n  return 0\nend\n')
        changes.append('GetQuestStatus via native CheckExistEvent')
    if 'RunQuestExchange' in calls(text):
        # A two-argument standard exchange maps to the old native interface. Explicit
        # selected rewards need a separate implementation and are not silently dropped.
        call_text=re.findall(r'\bRunQuestExchange\s*\(([^)]*)\)',clean(text))
        if any(not selected_supported([x.strip() for x in s.split(',')]) for s in call_text):
            (REVIEW/name).write_text(text,encoding='utf-8')
            rows.append({'ScriptFile':name,'Status':'REVIEW_SELECTED_REWARD','Source':label,'SourcePath':str(path),'Changes':';'.join(changes),'SHA256':'','SyntaxError':'','UnsupportedCalls':'RunQuestExchange selected reward'})
            continue
        if any(len(s.split(','))==4 for s in call_text):
            prefix.append('local function RunQuestExchange(uid, exchange, selected, allExp)\n  if selected == nil then return RunExchange(uid, exchange) end\n  if selected ~= STEP or selected < 0 or selected > 4 or allExp ~= 1 then return false end\n  return RunSelectExchange(uid, exchange)\nend\n')
            changes.append('explicit STEP+allExp selection->native RunSelectExchange')
        else:
            text=replace_names(text,{'RunQuestExchange':'RunExchange'});changes.append('RunQuestExchange->native RunExchange (2 arguments)')
    # Missing state-2/exit events can safely close an NPC dialog; missing active quest
    # events cannot be invented from labels or replaced with a success stub.
    c=clean(text);handled={int(x) for x in re.findall(r'\bEVENT\s*==\s*(\d+)',c)}
    gap=expected_events(rs)-handled
    gap_rows=[r for r in rs if any(int(r[k]) in gap for k in ('nEventTriggerIndex','nEventCompleteIndex'))]
    passive={int(r['nEventTriggerIndex']) for r in rs if int(r['bEventStatus'])==2 and int(r['nEventTriggerIndex'])>0}
    for event in sorted(gap&passive):
        text+=f'\n-- SQL completed-state dialog exit; no reward or state mutation.\nif EVENT == {event} then return end\n'
        changes.append(f'completed-state exit {event}')
    unresolved=gap-passive
    # Preserve all implemented handlers, while accurately reporting absent active ones.
    status='ADAPTED' if not unresolved else 'ADAPTED_PARTIAL_EVENTS'
    if all(int(r['sEventDataIndex'])==0 for r in rs):status='DIALOG_ONLY'
    protected_events=blocked|unresolved
    if protected_events:
        status='ADAPTED_WITH_DISABLED_EVENTS'
        if unresolved and not blocked:status='ADAPTED_PARTIAL_EVENTS'
        npc=next(iter(target_npcs)) if len(target_npcs)==1 else 0
        condition=' or '.join(f'EVENT == {event}' for event in sorted(protected_events))
        text=f'-- These events require missing native/server data; no costs or quest state changes are allowed.\nif {condition} then\n  SelectMsg(UID, 2, -1, 10526, {npc}, 10, -1)\n  return\nend\n'+text
    if unresolved:changes.append('unimplemented SQL events '+','.join(map(str,sorted(unresolved))))
    row=stage(name,label,path,'\n'.join(prefix)+text,changes,rs,status)
    row['BlockedEvents']=';'.join(map(str,sorted(protected_events)))
    row['BlockedReasons']=';'.join(sorted(reasons))
    rows.append(row)
    detail.append({'ScriptFile':name,'UnimplementedActiveEvents':';'.join(map(str,sorted(unresolved))),
        'HelperRows':len(rs),'QuestIds':';'.join(map(str,sorted({int(r['sEventDataIndex']) for r in rs if int(r['sEventDataIndex'])>0}))),
        'StateHelpersReferenced':len(refs),'Source':label})

for row in rows:
    row.setdefault('BlockedEvents','');row.setdefault('BlockedReasons','')
csvwrite('gorev-uyarlama-manifestosu.csv',rows)
csvwrite('gorev-olay-kapsami.csv',detail)
summary={'References':len(rows),'Statuses':dict(Counter(r['Status'] for r in rows)),
    'ChangedFiles':sum(bool(r['Changes']) for r in rows),'SyntaxErrors':sum(bool(r['SyntaxError']) for r in rows),
    'UnexpectedGlobalCalls':sum(bool(r['UnsupportedCalls']) for r in rows if r['SHA256']),
    'Limits':['Prepared files are a reviewable working copy, not a verified live game.',
        'Runtime quest acceptance/completion/reward tests remain necessary.',
        'No NPC, item, quest progression or reward IDs were invented.']}
(REPORT/'gorev-uyarlama-ozeti.json').write_text(json.dumps(summary,indent=2),encoding='utf-8')
print(json.dumps(summary,indent=2))
