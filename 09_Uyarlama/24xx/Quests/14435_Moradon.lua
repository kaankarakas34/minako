-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [541]={{379273000,3}},
  [542]={{379274000,3}},
  [543]={{379272000,3}},
  [544]={{810418000,3}},
  [545]={{379275000,3}},
  [546]={{810418000,10}},
  [547]={{379277000,7}},
  [548]={{379276000,3}},
  [549]={{379272000,7}},
  [3000]={},
  [3007]={{910210000,1}},
  [3008]={{910211000,1},{910212000,1},{910213000,1}},
  [6161]={{810494000,5}},
  [6162]={{810495000,20}},
  [6163]={{810496000,15}},
  [6164]={{810497000,3}},
}
local __KO_Completion = {
  [3965]={1373,6161},
  [3975]={1374,6162},
  [3985]={1375,6163},
  [3995]={1376,6164},
  [9868]={133,543},
  [9880]={136,544},
  [9892]={139,545},
  [9904]={142,546},
  [9916]={145,547},
  [9928]={148,548},
  [9940]={151,549},
  [10014]={127,541},
  [10026]={130,542},
  [11009]={516,3000},
  [11087]={520,3007},
  [11099]={521,3008},
}
local __KO_Quests = {
  [541]={127},
  [542]={130},
  [543]={133},
  [544]={136},
  [545]={139},
  [546]={142},
  [547]={145},
  [548]={148},
  [549]={151},
  [3000]={516},
  [3007]={520},
  [3008]={521},
  [6161]={1373},
  [6162]={1374},
  [6163]={1375},
  [6164]={1376},
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
local function GetQuestStatus(uid, quest)
  for state=0,4 do
    if CheckExistEvent(uid, quest, state) then return state end
  end
  if CheckExistEvent(uid, quest, 255) then return 255 end
  return 0
end
local Ret = 0;
local NPC = 14435;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 4937, NPC, 10, 158);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 4937, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 158) then
	Ret = 1;
end

local savenum = 127;

if (EVENT == 232) then -- 35 Level
	SelectMsg(UID, 4, savenum, 4931, NPC, 22, 233, 23, 158);
end

if (EVENT == 233) then
	SaveEvent(UID, 10013);
end

if (EVENT == 235) then
	SaveEvent(UID, 10015);
end

if (EVENT == 236) then
	ANIMAL = HowmuchItem(UID, 379273000);
	if (ANIMAL < 3) then
		SelectMsg(UID, 2, savenum, 4991, NPC, 19, 238);
	else
		SelectMsg(UID, 4, savenum, 4998, NPC, 22, 237, 23, 158);
	end
end

if (EVENT == 238) then
	ShowMap(UID, 96);
end

if (EVENT == 237) then
RunExchange(UID,541)
	SaveEvent(UID, 10014);
end

local savenum1 = 130;

if (EVENT == 242) then -- 36 Level
	SelectMsg(UID, 4, savenum1, 575, NPC, 22, 243, 23, 158);
end

if (EVENT == 243) then
	SaveEvent(UID, 10025);
end

if (EVENT == 245) then
	SaveEvent(UID, 10027);
end

if (EVENT == 246) then
	ROTTEN = HowmuchItem(UID, 379274000);
	if (ROTTEN < 3) then
		SelectMsg(UID, 2, savenum1, 788, NPC, 19, 248);
	else
		SelectMsg(UID, 4, savenum1, 6106, NPC, 22, 247, 23, 158);
	end
end

if (EVENT == 248) then
	ShowMap(UID, 98);
end

if (EVENT == 247) then
RunExchange(UID,542)
	SaveEvent(UID, 10026);
end

local savenum2 = 133;

if (EVENT == 252) then -- 37 Level
	SelectMsg(UID, 4, savenum2, 576, NPC, 22, 253, 23, 158);
end

if (EVENT == 253) then
	SaveEvent(UID, 9867);
end

if (EVENT == 255) then
	SaveEvent(UID, 9869);
end

if (EVENT == 256) then
	FEATHER = HowmuchItem(UID, 379272000);
	if (FEATHER < 3) then
		SelectMsg(UID, 2, savenum2, 6187, NPC, 19, 258);
	else
		SelectMsg(UID, 4, savenum2, 6196, NPC, 22, 257, 23, 158);
	end
end

if (EVENT == 258) then
	ShowMap(UID, 100);
end

if (EVENT == 257) then
RunExchange(UID,543)
	SaveEvent(UID, 9868);
end

local savenum3 = 136;

if (EVENT == 262) then -- 38 Level
	SelectMsg(UID, 4, savenum3, 586, NPC, 22, 263, 23, 158);
end

if (EVENT == 263) then
	SaveEvent(UID, 9879);
end

if (EVENT == 265) then
	SaveEvent(UID, 9881);
end

if (EVENT == 266) then
	SKULL = HowmuchItem(UID, 810418000);
	if (SKULL < 3) then
		SelectMsg(UID, 2, savenum3, 6127, NPC, 19, 268);
	else
		SelectMsg(UID, 4, savenum3, 6128, NPC, 22, 267, 23, 158);
	end
end

if (EVENT == 268) then
	ShowMap(UID, 102);
end

if (EVENT == 267) then
RunExchange(UID,544)
	SaveEvent(UID, 9880);
end

local savenum4 = 139;

if (EVENT == 272) then -- 39 Level
	SelectMsg(UID, 4, savenum4, 6139, NPC, 22, 273, 23, 158);
end

if (EVENT == 273) then
	SaveEvent(UID, 9891);
end

if (EVENT == 275) then
	SaveEvent(UID, 9893);
end

if (EVENT == 276) then
	COARSE = HowmuchItem(UID, 379275000);
	if (COARSE < 3) then
		SelectMsg(UID, 2, savenum4, 6141, NPC, 19, 278);
	else
		SelectMsg(UID, 4, savenum4, 6142, NPC, 22, 277, 23, 158);
	end
end

if (EVENT == 278) then
	ShowMap(UID, 104);
end

if (EVENT == 277) then
RunExchange(UID,545)
	SaveEvent(UID, 9892);
end

local savenum5 = 142;

if (EVENT == 282) then -- 40 Level
	SelectMsg(UID, 4, savenum5, 590, NPC, 22, 283, 23, 158);
end

if (EVENT == 283) then
	SaveEvent(UID, 9903);
end

if (EVENT == 285) then
	SaveEvent(UID, 9905);
end

if (EVENT == 286) then
	APPLE = HowmuchItem(UID, 810418000);
	if (APPLE < 10 ) then
		SelectMsg(UID, 2, savenum5, 6141, NPC, 19, 288);
	elseif (APPLE > 10) then
		SelectMsg(UID, 4, savenum5, 6142, NPC, 22, 287, 23, 158);
	end
end

if (EVENT == 288) then
	ShowMap(UID, 106);
end

if (EVENT == 287) then
RunExchange(UID,546)
	SaveEvent(UID, 9904);
end

local savenum6 = 145;

if (EVENT == 292) then -- 41 Level
	SelectMsg(UID, 4, savenum6, 6163, NPC, 22, 293, 23, 158);
end

if (EVENT == 293) then
	SaveEvent(UID, 9915);
end

if (EVENT == 295) then
	SaveEvent(UID, 9917);
end

if (EVENT == 296) then
	ORK = HowmuchItem(UID, 379277000);
	if (ORK < 7) then
		SelectMsg(UID, 2, savenum6, 6163, NPC, 19, 298);
	else
		SelectMsg(UID, 4, savenum6, 6142, NPC, 22, 297, 23, 158);
	end
end

if (EVENT == 298) then
	ShowMap(UID, 108);
end

if (EVENT == 297) then
RunExchange(UID,547)
	SaveEvent(UID, 9916);
end

local savenum7 = 148;

if (EVENT == 302) then -- 42 Level
	SelectMsg(UID, 4, savenum7, 4932, NPC, 22, 303, 23, 158);
end

if (EVENT == 303) then
	SaveEvent(UID, 9927);
end

if (EVENT == 305) then
	SaveEvent(UID, 9929);
end

if (EVENT == 306) then
	OATH = HowmuchItem(UID, 379276000);
	if (OATH < 3) then
		SelectMsg(UID, 2, savenum7, 4932, NPC, 19, 308);
	else
		SelectMsg(UID, 4, savenum7, 4934, NPC, 22, 307, 23, 158);
	end
end

if (EVENT == 308) then
	ShowMap(UID, 110);
end

if (EVENT == 307) then
RunExchange(UID,548)
	SaveEvent(UID, 9928);
end

local savenum8 = 151;

if (EVENT == 312) then -- 43 Level
	SelectMsg(UID, 4, savenum8, 576, NPC, 22, 313, 23, 158);
end

if (EVENT == 313) then
	SaveEvent(UID, 9939);
end

if (EVENT == 315) then
	SaveEvent(UID, 9941);
end

if (EVENT == 316) then
	FEATHER = HowmuchItem(UID, 379272000);
	if (FEATHER < 7) then
		SelectMsg(UID, 2, savenum8, 6187, NPC, 19, 318);
	else
		SelectMsg(UID, 4, savenum8, 6196, NPC, 22, 317, 23, 158);
	end
end

if (EVENT == 318) then
	ShowMap(UID, 112);
end

if (EVENT == 317) then
RunExchange(UID,549)
	SaveEvent(UID, 9940);
end


local savenum=1373
local talknum=44200
local exchangeid=6161

if (EVENT == 500) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 501, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 501) then
	SaveEvent(UID, 3964);
end

if (EVENT == 506) then
	ITEMA  = HowmuchItem(UID, 810494000);
	if(ITEMA > 4) then
		SaveEvent(UID, 3966)
	end	
end

if (EVENT == 503) then
	ITEMA  = HowmuchItem(UID, 810494000);
	if(ITEMA > 4) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 504, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 505);
	end
end

if (EVENT == 504)then
	RunExchange(UID, exchangeid)
	SaveEvent(UID,3965)
end

if (EVENT == 505) then
ShowMap(UID, 586);
end

local savenum=1374
local talknum=44204
local exchangeid=6162

if (EVENT == 510) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 511, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 511) then
	SaveEvent(UID, 3974);
end

if (EVENT == 516) then
	ITEMA  = HowmuchItem(UID, 810495000);
	if(ITEMA > 19) then
		SaveEvent(UID, 3976)
	end	
end

if (EVENT == 513) then
	ITEMA  = HowmuchItem(UID, 810495000);
	if(ITEMA > 19) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 514, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 515);
	end
end

if (EVENT == 515) then
ShowMap(UID, 550);
end


if (EVENT == 514)then
	RunExchange(UID, exchangeid)
	SaveEvent(UID,3975)
end

local savenum=1375
local talknum=44208
local exchangeid=6163

if (EVENT == 520) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 521, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 521) then
	SaveEvent(UID, 3984);
end

if (EVENT == 526) then
	ITEMA  = HowmuchItem(UID, 810496000);
	if(ITEMA > 14) then
		SaveEvent(UID, 3986)
	end	
end

if (EVENT == 523) then
	ITEMA  = HowmuchItem(UID, 810496000);
	if(ITEMA > 14) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 524, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 525);
	end
end

if (EVENT == 524)then
	RunExchange(UID, exchangeid)
	SaveEvent(UID,3985)
end

if (EVENT == 525) then
	ShowMap(UID, 36);
end

local savenum=1376
local talknum=44212
local exchangeid=6164

if (EVENT == 530) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 531, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 531) then
	SaveEvent(UID, 3994);
end

if (EVENT == 536) then
	SaveEvent(UID, 3996)
end

if (EVENT == 533) then
	ITEMA = HowmuchItem(UID, 810497000);
	if (ITEMA > 2) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 41, 534, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 534)then
	RunExchange(UID, exchangeid)
	SaveEvent(UID,3995)
end
if (EVENT == 1002)then
	SelectMsg(UID, 2, 516, 20122, NPC, 4161, 1003);
end

if (EVENT == 1003)then
	SelectMsg(UID, 2, 516, 20123, NPC, 4552, 1004,6004,-1);
	SaveEvent(UID,11008)
end

if (EVENT == 1004)then
	SelectMsg(UID, 4, 516, 20124, NPC, 4161, 1005,3005,-1);
	SaveEvent(UID,11010)
end

if (EVENT == 1005) then 
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
	    SaveEvent(UID,11009);
		SaveEvent(UID, 11014);
		SelectMsg(UID, 2, 516, 20207, NPC,6002, -1);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID,11009);
		SaveEvent(UID, 11019);
		SelectMsg(UID, 2, 516, 20207, NPC,6002, -1);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID,11009);
		SaveEvent(UID, 11024);
		SelectMsg(UID, 2, 516, 20207, NPC,6002, -1);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID,11009);
		SaveEvent(UID, 11029);
		SelectMsg(UID, 2, 516, 20207, NPC,6002, -1);
	end
end

if (EVENT == 1101)then
	SelectMsg(UID, 4, 520, 20009, NPC, 22, 1102,23,-1);
end

if (EVENT == 1102)then
	SaveEvent(UID,11086)
end

if (EVENT == 1106)then
	SaveEvent(UID,11088)
end

if (EVENT == 1103) then
	ITEM_COUNT = HowmuchItem(UID, 910210000);   
	if (ITEM_COUNT < 1) then
		SelectMsg(UID, 2, 520, 20009, NPC, 18, -1);
	else
		SelectMsg(UID, 4, 520, 20009, NPC, 22, 1105, 27, -1); 
	end
end

if (EVENT == 1105)then
RunExchange(UID,3007)
	SaveEvent(UID,11087)
	SaveEvent(UID,11098)
end

if (EVENT == 1201)then
	SelectMsg(UID, 4, 521, 20011, NPC, 22, 1202,23,-1);
end

if (EVENT == 1202)then
	SaveEvent(UID,11098)
end

if (EVENT == 1206)then
	SaveEvent(UID,11100)
end

if (EVENT == 1203) then
		SelectMsg(UID, 4, 521, 20011, NPC, 22, 1205, 27, -1); 
end

if (EVENT == 1205)then
RunExchange(UID,3008)
	SaveEvent(UID,11099)
	SaveEvent(UID,11110)
end


-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=516 status=2 n_index=11009
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 516)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3000);
		SaveEvent(UID, 11011);
	end
end

-- [AUTO-GEN] quest=516 status=255 n_index=11006
if (EVENT == 1000) then
	SaveEvent(UID, 11007);
end

-- [AUTO-GEN] quest=127 status=2 n_index=10014
if (EVENT == 165) then
	QuestStatusCheck = GetQuestStatus(UID, 127)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 541);
		SaveEvent(UID, 10016);
	end
end

-- [AUTO-GEN] quest=127 status=255 n_index=10011
if (EVENT == 230) then
	SaveEvent(UID, 10012);
end

-- [AUTO-GEN] quest=520 status=2 n_index=11087
if (EVENT == 196) then
	QuestStatusCheck = GetQuestStatus(UID, 520)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3007);
		SaveEvent(UID, 11089);
	end
end

-- [AUTO-GEN] quest=520 status=255 n_index=11084
if (EVENT == 1100) then
	SaveEvent(UID, 11085);
end

-- [AUTO-GEN] quest=130 status=255 n_index=10023
if (EVENT == 240) then
	SaveEvent(UID, 10024);
end

-- [AUTO-GEN] quest=133 status=255 n_index=9865
if (EVENT == 250) then
	SaveEvent(UID, 9866);
end

-- [AUTO-GEN] quest=136 status=255 n_index=9877
if (EVENT == 260) then
	SaveEvent(UID, 9878);
end

-- [AUTO-GEN] quest=139 status=255 n_index=9889
if (EVENT == 270) then
	SaveEvent(UID, 9890);
end

-- [AUTO-GEN] quest=142 status=255 n_index=9901
if (EVENT == 280) then
	SaveEvent(UID, 9902);
end

-- [AUTO-GEN] quest=145 status=255 n_index=9913
if (EVENT == 290) then
	SaveEvent(UID, 9914);
end

-- [AUTO-GEN] quest=148 status=255 n_index=9925
if (EVENT == 300) then
	SaveEvent(UID, 9926);
end

-- [AUTO-GEN] quest=151 status=255 n_index=9937
if (EVENT == 310) then
	SaveEvent(UID, 9938);
end

-- [AUTO-GEN] quest=521 status=255 n_index=11096
if (EVENT == 1200) then
	SaveEvent(UID, 11097);
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
