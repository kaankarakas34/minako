"""Offline Lua execution against a bounded fake game API; no game/SQL writes."""
from pathlib import Path
import csv,json,re,gc
from collections import defaultdict,Counter
from lupa import lua52
ROOT=Path(__file__).resolve().parents[2]
REPORT=ROOT/'06_Dokumantasyon/Uyarlama'
DATA=ROOT/'06_Dokumantasyon/Internet_Arastirmasi'
def read(name,base=DATA):
    with (base/name).open(encoding='utf-8-sig',newline='') as f:return list(csv.DictReader(f))
manifest=read('gorev-uyarlama-manifestosu.csv',REPORT)
helpers=read('yerel-QUEST_HELPER.csv');byfile=defaultdict(list)
for r in helpers:byfile[r['strLuaFilename'].strip()].append(r)
byid={int(r['nIndex']):r for r in helpers}
exchanges={int(r['nIndex']):r for r in read('yerel-ITEM_EXCHANGE.csv')}
api=json.loads((REPORT/'hazir-gameserver-lua-api.json').read_text())['Present']
def no_attributes(obj,attr,setting):raise AttributeError('Python attributes disabled')
lua=lua52.LuaRuntime(encoding='utf-8',register_eval=False,register_builtins=False,attribute_filter=no_attributes,max_memory=256*1024*1024,unpack_returned_tuples=True)
runner=lua.eval('''function(code, env, chunkname)
  local f, e = load(code, chunkname, "t", env)
  if not f then return false, e end
  local ticks = 0
  debug.sethook(function() ticks=ticks+1; if ticks>100 then error("instruction limit") end end,"",1000)
  local ok, err = pcall(f)
  debug.sethook()
  return ok, err
end''')
safe=lua.eval('function() return {math=math,string=string,table=table,ipairs=ipairs,pairs=pairs,next=next,type=type,tonumber=tonumber,tostring=tostring,assert=assert,error=error,pcall=pcall,select=select} end')
cases=[];errors=[];risks=[]
state={}
def integer(v,default=0):return int(v) if v is not None else default
def call(name,*a):
    trace=state['trace'];uid=integer(a[0]) if a else 0
    args=a[1:]
    def num(i=0,default=0):return integer(args[i],default) if len(args)>i else default
    if name=='CheckExistEvent':return state['quests'].get(num(),0)==num(1,1)
    if name=='SaveEvent':
        target=byid.get(num())
        if target is None:raise ValueError(f'Unknown helper {num()}')
        q=int(target['sEventDataIndex']);s=int(target['bEventStatus']);state['quests'][q]=s
        trace.append(('SaveEvent',num(),q,s));return None
    if name in ('CheckNation','GetNation'):return state['nation']
    if name in ('CheckClass','GetClass'):return state['klass']
    if name in ('CheckLevel','GetLevel'):return state['level']
    if name=='SearchQuest':
        npc=num()
        return 2 if any(int(r['sNpcId'])==npc and int(r['sEventDataIndex'])>0 and state['quests'].get(int(r['sEventDataIndex']),0)==int(r['bEventStatus']) for r in state['rows']) else 0
    if name in ('RunExchange','RunSelectExchange','RunCountExchange'):
        if num() not in exchanges:raise ValueError(f'Unknown exchange {num()}')
        ok=state['has_items'] and state['has_room']
        trace.append((name,num(),ok));return ok
    if name=='CheckExchange':return num() in exchanges and state['has_room']
    if name in ('HowmuchItem','GetCoins','GetInnCoins','GetLoyalty','GetMonthlyLoyalty','GetManner'):
        return 100000000 if state['has_items'] else 0
    if name in ('CheckGiveSlot','CheckWeight'):return state['has_room']
    if name=='isRoomForItem':return 0 if state['has_room'] else -1
    if name=='CheckExistItem':return state['has_items']
    if name=='ExistMonsterQuestSub':return 0
    if name=='CountMonsterQuestSub':return 10000 if state['has_items'] else 0
    if name in ('NpcMsg','SelectMsg','ShowMap','CountMonsterQuestMain','NpcSay'):
        if name=='SelectMsg' and len(a)<5:raise ValueError('SelectMsg missing required arguments')
        trace.append((name,)+tuple(a[1:6]));return None
    if name in ('GiveItem','RobItem','GoldGain','GoldLose','ExpChange','GiveLoyalty','RobLoyalty','GiveCash','GiveKnightCash'):
        trace.append((name,)+tuple(args));return state['has_room'] if name=='GiveItem' else state['has_items']
    if name in ('GetName','GetAccountName'):return 'AdaptTest'
    if name=='GetPremium':return 0
    if name=='GetRace':return 1
    if name=='CheckSkillPoint':return 60
    if name=='GetMaxExchange':return 1 if state['has_items'] else 0
    if name=='GetEventTrigger':return state['event']
    if name in ('GetX','GetY','GetZ'):return 100
    if name=='GetZoneID':return state['zone']
    if name in ('isWarrior','isRogue','isMage','isPriest'):return state['klass']=={'isWarrior':1,'isRogue':2,'isMage':3,'isPriest':4}[name]
    if name.startswith(('is','has','Check')):return False
    if name.startswith('Get'):return 0
    trace.append((name,)+tuple(args));return True

api_functions={fn:(lambda *a,fn=fn:call(fn,*a)) for fn in api}
for item in manifest:
    if not item['SHA256']:continue
    name=item['ScriptFile'];code=(ROOT/'09_Uyarlama/24xx/Quests'/name).read_text(encoding='utf-8')
    (REPORT/'lua-benzetim-ilerleme.txt').write_text(f'{name}; completed cases={len(cases)}',encoding='utf-8')
    rows=byfile[name]
    # Exercise every distinct SQL-dispatched event under that row's expected quest state.
    scenarios={}
    for r in rows:
        for k in ('nEventTriggerIndex','nEventCompleteIndex'):
            evt=int(r[k]);q=int(r['sEventDataIndex']);s=int(r['bEventStatus'])
            if evt>0:scenarios.setdefault((evt,q,s,int(r['bNation']),int(r['bClass'])),r)
    for (event,quest,qstate,nation,klass),r in scenarios.items():
        for has_items,has_room in ((False,True),(True,True),(True,False)):
            state={'quests':{quest:qstate},'event':event,'nation':nation if nation in (1,2) else 1,
                'klass':klass if klass in (1,2,3,4) else 1,'level':max(int(r['bLevel']),83),
                'zone':int(r['bZone']),'has_items':has_items,'has_room':has_room,'trace':[],'rows':rows}
            env=safe();env['_G']=env;env['UID']=1;env['STEP']=0;env['EVENT']=event
            for fn,callback in api_functions.items():env[fn]=callback
            ok,err=runner(code,env,name)
            case={'ScriptFile':name,'Event':event,'Quest':quest,'QuestState':qstate,'HasItems':has_items,'HasRoom':has_room,'OK':bool(ok),'Error':str(err) if err else ''}
            cases.append(case)
            if not ok:errors.append(case)
            completed=[x for x in state['trace'] if x[0]=='SaveEvent' and x[3]==2 and x[2]>0]
            failed_ex=[x for x in state['trace'] if x[0] in ('RunExchange','RunSelectExchange','RunCountExchange') and x[-1] is False]
            if completed and failed_ex:
                risks.append({**case,'Issue':'Quest completed despite failed exchange','Trace':json.dumps(state['trace'],ensure_ascii=False)})
            env=None
            if len(cases)%50==0:
                lua.gccollect();gc.collect()
    lua.gccollect()
for filename,rows in [('lua-benzetim-sonuclari.csv',cases),('lua-benzetim-hatalari.csv',errors),('lua-odul-kontrol-riskleri.csv',risks)]:
    if rows:
        with (REPORT/filename).open('w',encoding='utf-8-sig',newline='') as f:
            w=csv.DictWriter(f,fieldnames=rows[0]);w.writeheader();w.writerows(rows)
    else:
        (REPORT/filename).write_text('',encoding='utf-8')
summary={'Scripts':len({r['ScriptFile'] for r in cases}),'Cases':len(cases),'RuntimeErrorCases':len(errors),'RuntimeErrorFiles':len({r['ScriptFile'] for r in errors}),'CompletionAfterFailedExchangeCases':len(risks),'CompletionAfterFailedExchangeFiles':len({r['ScriptFile'] for r in risks}),
    'Limits':'Bounded offline fake API, not native EXE/client validation; inventories and quest state never reach SQL or game services.'}
(REPORT/'lua-benzetim-ozeti.json').write_text(json.dumps(summary,indent=2),encoding='utf-8')
print(json.dumps(summary,indent=2))
