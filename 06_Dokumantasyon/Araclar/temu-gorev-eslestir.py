"""Adapt only database-backed helper/exchange IDs; keep incomplete quests visible."""
from pathlib import Path
from collections import defaultdict,Counter
import csv,json,re,hashlib
from lupa import lua52
ROOT=Path(__file__).resolve().parents[2]
REPORT=ROOT/'06_Dokumantasyon/Derleme'
PREP=ROOT/'10_Kaynak_Derleme/Veritabani_Hazirlik'
RUN=ROOT/'10_Kaynak_Derleme/Yerel_Calistirma/Quests'
manifest=json.loads((PREP/'manifest.json').read_text())
api=set(json.loads((REPORT/'kaynak-gameserver-lua-api.json').read_text())['Present'])

def table(name):
    t=next(t for t in manifest['Tables'] if t['Name']==name)
    cols=[c['Name'] for c in t['Columns']]
    return [dict(zip(cols,json.loads(line))) for line in (PREP/'StaticData'/(name+'.jsonl')).read_text(encoding='utf8').splitlines()]

def readcsv(path):
    return [{k.lower():v for k,v in r.items()} for r in csv.DictReader(path.open(encoding='utf-8-sig'))]
def source_encoding(path):
    raw=path.read_bytes()
    try:raw.decode('utf-8-sig');return 'utf-8-sig' if raw.startswith(b'\xef\xbb\xbf') else 'utf-8'
    except UnicodeDecodeError:return 'latin1'
def source_text(path):return path.read_text(encoding=source_encoding(path))
helpers=table('quest_helper');byid={int(r['nindex']):r for r in helpers};byfile=defaultdict(list)
for r in helpers:
    if r['strluafilename'].strip():byfile[r['strluafilename'].strip()].append(r)
current_ex={int(r['nindex']):r for r in table('item_exchange')}
current_bonus={int(r['nindex']):r for r in table('item_exchange_exp')}
old=ROOT/'06_Dokumantasyon/Internet_Arastirmasi'
domains={
 'Original':(readcsv(old/'yerel-QUEST_HELPER.csv'),readcsv(old/'yerel-ITEM_EXCHANGE.csv'),readcsv(old/'yerel-ITEM_EXCHANGE_EXP.csv')),
 'AKGame':(readcsv(REPORT/'akgame-QUEST_HELPER.csv'),readcsv(REPORT/'akgame-ITEM_EXCHANGE2369.csv'),readcsv(REPORT/'akgame-ITEM_EXCHANGE_EXP.csv')),
}
helper_fields=[k for k in helpers[0] if k not in ('nindex','strluafilename','squestmenu','snpcmain','squestsolo')]
ex_fields=[k for k in next(iter(current_ex.values())) if k!='nindex']
bonus_fields=[k for k in next(iter(current_bonus.values())) if k!='nindex']
widths={(r['Table'],r['Column']):r['Bits'] for r in json.loads((REPORT/'temu-unsigned-columns.json').read_text())}
def sig(row,fields,tab):
    values=[]
    for key in fields:
        value=row.get(key,'0')
        try:
            number=int(value);bits=widths.get((tab,key))
            if bits and number<0:number+=2**bits
            values.append(str(number))
        except (ValueError,TypeError):values.append(str(value).strip().lower())
    return tuple(values)

helper_sigs=defaultdict(list);recipe_sigs=defaultdict(list)
for r in helpers:helper_sigs[sig(r,helper_fields,'quest_helper')].append(int(r['nindex']))
for i,r in current_ex.items():recipe_sigs[sig(r,ex_fields,'item_exchange')].append(i)
maps={}
for label,(hs,es,bs) in domains.items():
    hm={};em={};bs={int(r['nindex']):r for r in bs}
    for r in hs:
        i=int(r['nindex']);matches=helper_sigs[sig(r,helper_fields,'quest_helper')]
        if i in matches:hm[i]=i
        elif len(matches)==1:hm[i]=matches[0]
    for r in es:
        i=int(r['nindex']);matches=recipe_sigs[sig(r,ex_fields,'item_exchange')]
        matches=[j for j in matches if sig(bs.get(i,{}),bonus_fields,'item_exchange_exp')==sig(current_bonus.get(j,{}),bonus_fields,'item_exchange_exp')]
        if i in matches:em[i]=i
        elif len(matches)==1:em[i]=matches[0]
    maps[label]=(hm,em)

protected=re.compile(r'--\[(=*)\[.*?\]\1\]|--[^\n]*|"(?:\\.|[^"\\])*"|\'(?:\\.|[^\'\\])*\'',re.S)
def mask(s):return protected.sub(lambda m:' '*(len(m[0])-m[0].count('\n'))+'\n'*m[0].count('\n'),s)
keywords=set('if elseif for while function until and or not return'.split())
builtins=set('assert error ipairs pairs next tonumber tostring type pcall select print'.split())
lua=lua52.LuaRuntime(encoding=None,register_eval=False,register_builtins=False,max_memory=64*1024*1024)
def analyse(text,expected):
    code=mask(text);defined=set(re.findall(r'\bfunction\s+(\w+)\s*\(',code))
    calls=set(re.findall(r'(?<![\w.:])([A-Za-z_]\w*)\s*\(',code))-keywords-defined-builtins
    events={int(v) for v in re.findall(r'\bEVENT\s*==\s*(\d+)',code)}
    unknown=sorted(calls-api)
    try:lua.compile(text.encode('utf8'),mode=b't');syntax=''
    except Exception as e:syntax=str(e)
    return {'UnknownAPI':unknown,'SyntaxError':syntax,'CoveredEvents':len(events&expected),'ExpectedEvents':len(expected)}

base=ROOT/'08_Arastirma_Adaylari/TemuKO_Posix_Assets/Server_Assets/Debug/Quests'
donors=[('Original',ROOT/'02_Sunucu/24xx/Quests'),('AKGame',ROOT/'08_Arastirma_Adaylari/AKGame-2383/Server/Quests')]
index=defaultdict(list)
for label,folder in donors:
    for path in folder.glob('*.lua'):index[path.name.lower()].append((label,path))
canonical={p.name.lower():p for p in base.glob('*.lua')};records=[];rewrites=[]
for name,rs in sorted(byfile.items()):
    expected={int(r[k]) for r in rs for k in ['neventtriggerindex','neventcompleteindex'] if int(r[k])>0}
    if name.lower() in canonical:
        p=canonical[name.lower()];text=source_text(p);a=analyse(text,expected)
        status='BASELINE_API_AND_SYNTAX_OK' if not a['UnknownAPI'] and not a['SyntaxError'] else 'REVIEW_BASELINE'
        if a['CoveredEvents']<a['ExpectedEvents']:status='PARTIAL_BASELINE'
        records.append({'File':name,'Status':status,'Source':str(p.relative_to(ROOT)),**a});continue
    choices=[];reasons=[]
    names=[name.lower()]
    # Extensionless aliases are accepted only for the exact basename, not for
    # similarly named NPCs or different prison wings.
    if not Path(name).suffix:names.append(name.lower()+'.lua')
    for donor_name in names:
        for label,path in index.get(donor_name,[]):
            text=source_text(path);changes=[];blocked=[];hm,em=maps[label]
            pattern=re.compile(protected.pattern+r'|\b(SaveEvent|UpdateEvent|ShowMap|RunQuestExchange|RunExchange|CheckExchange|GetMaxExchange|RunCountExchange)\s*\(\s*UID\s*,\s*(\d+)',re.S)
            def rewrite(m):
                if not m.group(2):return m[0]
                fn=m[2];oldid=int(m[3]);mapping=hm if fn in ('SaveEvent','UpdateEvent','ShowMap') else em
                if oldid not in mapping:blocked.append(fn+':'+str(oldid));return m[0]
                new=mapping[oldid]
                if oldid!=new:changes.append({'Call':fn,'Old':oldid,'New':new})
                return m[0][:m.start(3)-m.start()]+str(new)
            text=pattern.sub(rewrite,text);a=analyse(text,expected)
            if blocked or a['SyntaxError'] or a['UnknownAPI'] or (expected and not a['CoveredEvents']):
                reasons.extend(blocked+a['UnknownAPI']+(['syntax'] if a['SyntaxError'] else []));continue
            # Native RunQuestExchange consumes origin items. A donor which also
            # removes those same items needs event-by-event review.
            code=mask(text);exids={int(x) for x in re.findall(r'RunQuestExchange\s*\(\s*UID\s*,\s*(\d+)',code)}
            removed={int(x) for x in re.findall(r'RobItem\s*\(\s*UID\s*,\s*(\d+)',code)}
            origins={int(row.get(f'noriginitemnum{i}',0)) for ex in exids if (row:=current_ex.get(ex)) for i in range(1,6)}
            if removed&origins:reasons.append('possible duplicate item consumption');continue
            choices.append((a['CoveredEvents'],len(text),label,path,text,changes,a))
    if choices:
        _,_,label,path,text,changes,a=max(choices,key=lambda x:(x[0],x[1]))
        (RUN/name).write_text('-- Adapted helper/recipe IDs verified against KNIGHT_TEMU_2239.\n'+text,encoding=source_encoding(path))
        status='ADAPTED_PENDING_GAMEPLAY' if a['CoveredEvents']==a['ExpectedEvents'] else 'PARTIAL_ADAPTED_PENDING_GAMEPLAY'
        records.append({'File':name,'Status':status,'Source':str(path.relative_to(ROOT)),**a})
        rewrites.append({'File':name,'Domain':label,'Changes':changes,'SHA256':hashlib.sha256((RUN/name).read_bytes()).hexdigest()})
    else:records.append({'File':name,'Status':'MISSING_VERIFIED_CONTENT','Source':'','UnknownAPI':sorted(set(reasons)),'SyntaxError':'','CoveredEvents':0,'ExpectedEvents':len(expected)})
(REPORT/'temu-quest-file-map.json').write_text(json.dumps(records,indent=2,ensure_ascii=False),encoding='utf8')
(REPORT/'temu-quest-id-rewrites.json').write_text(json.dumps(rewrites,indent=2),encoding='utf8')
summary={'DistinctDatabaseReferences':len(records),'Statuses':dict(Counter(r['Status'] for r in records)),
         'AddedFiles':len(rewrites),'RewrittenLiteralIDs':sum(len(r['Changes']) for r in rewrites),
         'SourceDomains':{label:{'MappedHelpers':len(hm),'MappedRecipes':len(em)} for label,(hm,em) in maps.items()},
         'Limits':'Compile/API/SQL metadata checks only. Dialog coverage and real reward/inventory behavior require further gameplay tests. Missing quest content is not replaced with dispatcher-only placeholders.'}
(REPORT/'temu-quest-summary.json').write_text(json.dumps(summary,indent=2),encoding='utf8');print(json.dumps(summary))
