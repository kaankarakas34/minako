"""Independent acceptance/turn-in regressions for adapted NPCs, using fake native calls."""
from pathlib import Path
import csv,json
from lupa import lua52
ROOT=Path(__file__).resolve().parents[2];REPORT=ROOT/'06_Dokumantasyon/Uyarlama';DATA=ROOT/'06_Dokumantasyon/Internet_Arastirmasi'
def rows(name):
    with (DATA/name).open(encoding='utf-8-sig') as f:return list(csv.DictReader(f))
helpers={int(r['nIndex']):r for r in rows('yerel-QUEST_HELPER.csv')}
exchanges={int(r['nIndex']):r for r in rows('yerel-ITEM_EXCHANGE.csv')}
api=json.loads((REPORT/'hazir-gameserver-lua-api.json').read_text())['Present']
specs=[('31567_Fellor.lua',772,[6201,6202],6207,3221,2),('13013_Patric.lua',60,[170,171,175,176,178],187,5,2),('25163_Rea',1312,[1112,1113],1118,6105,2),('29193_Dolkin.lua',946,[112],113,2537,4)]
results=[]
for filename,quest,accept_events,turn_in,exchange,completed_state in specs:
  for condition in ('success','no_items','full_bag'):
    lua=lua52.LuaRuntime(register_eval=False,register_builtins=False,attribute_filter=lambda *a:(_ for _ in ()).throw(AttributeError('disabled')),unpack_returned_tuples=True,max_memory=32*1024*1024)
    run=lua.eval('''function(code,env) local f,e=load(code,"regression","t",env); if not f then return false,e end; local n=0;debug.sethook(function() n=n+1;if n>100 then error("instruction limit") end end,"",1000);local ok,err=pcall(f);debug.sethook();return ok,err end''')
    env=lua.eval('function() return {ipairs=ipairs,pairs=pairs,pcall=pcall,error=error,tonumber=tonumber,type=type,math=math,table=table,string=string} end')()
    env['_G']=env;env['UID']=1;env['STEP']=0
    saved={};awards=[];dialogs=[];has_items=True;has_room=True
    def bind(name,*args):
      global has_items
      a=args[1:]
      def number(i=0,default=0):return int(a[i]) if len(a)>i and a[i] is not None else default
      if name=='CheckExistEvent':return saved.get(number(),0)==number(1,1)
      if name=='SaveEvent':
        r=helpers[number()];saved[int(r['sEventDataIndex'])]=int(r['bEventStatus']);return None
      if name=='HowmuchItem':return 100000000 if has_items else 0
      if name in ('RunExchange','RunSelectExchange','RunCountExchange'):
        assert number() in exchanges,'unknown exchange'
        if not(has_items and has_room):return False
        awards.append((name,number()));has_items=False;return True
      if name=='CheckExchange':return number() in exchanges and has_room
      if name=='CheckGiveSlot':return has_room
      if name=='isRoomForItem':return 0 if has_room else -1
      if name=='CountMonsterQuestSub':return 10000
      if name=='ExistMonsterQuestSub':return 0
      if name in ('CheckNation','GetNation','CheckClass'):return 1
      if name in ('CheckLevel','GetLevel'):return 83
      if name=='SelectMsg':dialogs.append(tuple(a));return None
      if name in ('ShowMap','NpcMsg','CountMonsterQuestMain'):return None
      if name=='SearchQuest':return 0
      if name.startswith(('is','has','Check')):return False
      if name.startswith('Get'):return 0
      raise AssertionError('Unexpected native call '+name)
    for name in api:env[name]=lambda *a,name=name:bind(name,*a)
    code=(ROOT/'09_Uyarlama/24xx/Quests'/filename).read_text(encoding='utf-8')
    def event(n):
      env['EVENT']=n
      ok,error=run(code,env)
      assert ok,(filename,n,str(error))
    try:
      for n in accept_events:event(n)
      assert saved.get(quest)==1,('acceptance state',saved)
      before=dict(saved)
      has_items=condition!='no_items';has_room=condition!='full_bag'
      event(turn_in)
      if condition=='success':
        assert saved.get(quest)==completed_state,('completion state',saved)
        assert sum(ex==exchange for _,ex in awards)==1,('reward count',awards)
        event(turn_in)
        assert sum(ex==exchange for _,ex in awards)==1,('repeated reward',awards)
      else:
        assert saved==before,('failed exchange changed quest state',before,saved)
        assert not awards,('failed exchange granted a reward',awards)
      results.append({'ScriptFile':filename,'Quest':quest,'Case':condition,'Passed':True,'Error':'','Rewards':len(awards)})
    except Exception as exc:
      results.append({'ScriptFile':filename,'Quest':quest,'Case':condition,'Passed':False,'Error':str(exc),'Rewards':len(awards)})
with (REPORT/'gorev-akis-regresyonu.csv').open('w',encoding='utf-8-sig',newline='') as f:
    w=csv.DictWriter(f,fieldnames=results[0]);w.writeheader();w.writerows(results)
summary={'Cases':len(results),'Passed':sum(r['Passed'] for r in results),'Failed':[r for r in results if not r['Passed']], 'Coverage':'Four NPCs: accept, successful turn-in, exactly one reward, replay rejection, insufficient items, full bag. Offline fake native API only.'}
(REPORT/'gorev-akis-regresyonu.json').write_text(json.dumps(summary,indent=2),encoding='utf-8')
print(json.dumps(summary,indent=2))
if summary['Failed']:raise SystemExit(1)
