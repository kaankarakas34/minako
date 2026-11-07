-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [86]={{910117000,1}},
  [304]={{910038000,5}},
  [501]={{900005000,358}},
  [502]={{900005000,358}},
  [503]={{900005000,358}},
  [504]={{900005000,358}},
  [600]={{910039000,10}},
}
local __KO_Completion = {
  [3035]={84,304},
  [4379]={358,501},
  [4384]={358,502},
  [4389]={358,503},
  [4394]={358,504},
  [6004]={64,86},
  [6025]={88,600},
}
local __KO_Quests = {
  [86]={64},
  [304]={84},
  [501]={358},
  [502]={358},
  [503]={358},
  [504]={358},
  [600]={88},
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
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 205 or EVENT == 6014 then
  SelectMsg(UID, 2, -1, 10526, 13009, 10, -1)
  return
end
local Ret = 0;
local NPC = 13009;

if (EVENT == 3000) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 1186, NPC, 10, 3001);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 1187, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 3001) then
	Ret = 1;
end

if (EVENT == 3002) then -- 12 Level Orc Duel
	SelectMsg(UID, 2, 88, 1188, NPC, 28, 3003);
end

if (EVENT == 3003) then
	ShowMap(UID, 6);
	SaveEvent(UID, 3033);
end

if (EVENT == 3004) then
	SelectMsg(UID, 2, 88, 1189, NPC, 10, 3003);
end

if (EVENT == 3005) then
	SelectMsg(UID, 2, 88, 1190, NPC, 10, 3006);
end

if (EVENT == 3006) then
	SelectMsg(UID, 4, 88, 1191, NPC, 22, 3007, 23, 3001);
end

if (EVENT == 3007) then
	ZoneChange(UID, 51, 150, 150)
	SaveEvent(UID, 3034);
end

if (EVENT == 3008) then
	SaveEvent(UID, 3036);
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, 88, 1192, NPC, 32, 3009);
	else
		SelectMsg(UID, 2, 88, 1193, NPC, 21, 3009);
	end
end

if (EVENT == 3009) then
	ShowMap(UID, 6);
end

if (EVENT == 3010) then
	ITEM_COUNT = HowmuchItem(UID, 910038000);
	if (ITEM_COUNT < 5) then
		SelectMsg(UID, 2, 88, 1194, NPC, 18, 3011);
	else
		SelectMsg(UID, 4, 88, 1195, NPC, 4006, 3012, 4005, 3001);
	end
end

if (EVENT == 3011) then
	ZoneChange(UID, 51, 150, 150)
end

if (EVENT == 3012) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then   
		RobItem(UID, 910038000, 5)
		GoldGain(UID, 30000)
		ExpChange(UID, 4000)
		GiveItem(UID, 202001005, 1)
		SaveEvent(UID, 3035);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		RobItem(UID, 910038000, 5)
		GoldGain(UID, 30000)
		ExpChange(UID, 4000)
		GiveItem(UID, 242001005, 1)
		SaveEvent(UID, 3035);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		RobItem(UID, 910038000, 5)
		GoldGain(UID, 30000)
		ExpChange(UID, 4000)
		GiveItem(UID, 262001005, 1)
		SaveEvent(UID, 3035);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		RobItem(UID, 910038000, 5)
		GoldGain(UID, 30000)
		ExpChange(UID, 4000)
		GiveItem(UID, 282001005, 1)
		SaveEvent(UID, 3035);
	end
end

if (EVENT == 6060) then -- 21 Level Gem of Bravery
	SelectMsg(UID, 2, 84, 6014, NPC, 28, 6061);
end

if (EVENT == 6061) then
	ShowMap(UID, 6);
	SaveEvent(UID, 6023);
end

if (EVENT == 6062) then
	SelectMsg(UID, 2, 84, 6015, NPC, 10, 6061);
end

if (EVENT == 6063) then
	SelectMsg(UID, 2, 84, 6016, NPC, 10, 6064);
end

if (EVENT == 6064) then
	SelectMsg(UID, 4, 84, 6017, NPC, 22, 6065, 23, 3001);
end

if (EVENT == 6065) then
	ZoneChange(UID, 52, 150, 150)
	SaveEvent(UID, 6024);
end

if (EVENT == 6066) then
	SaveEvent(UID, 6026);
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, 84, 6019, NPC, 32, 6067);
	else
		SelectMsg(UID, 2, 84, 6020, NPC, 21, 6067);
	end
end

if (EVENT == 6067) then
	ShowMap(UID, 6);
end

if (EVENT == 6068) then
	ITEM_COUNT = HowmuchItem(UID, 910039000);
	if (ITEM_COUNT < 10) then
		SelectMsg(UID, 2, 84, 6021, NPC, 18, 6069);
	else
		SelectMsg(UID, 4, 84, 6022, NPC, 4006, 6070, 4005, 3001);
	end
end

if (EVENT == 6069) then
	ZoneChange(UID, 52, 150, 150)
end

if (EVENT == 6070) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then   
		RobItem(UID, 910039000, 10)
		ExpChange(UID, 60000)
		GiveItem(UID, 202001006, 1)
		SaveEvent(UID, 6025);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		RobItem(UID, 910039000, 10)
		ExpChange(UID, 60000)
		GiveItem(UID, 242001006, 1)
		SaveEvent(UID, 6025);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		RobItem(UID, 910039000, 10)
		ExpChange(UID, 60000)
		GiveItem(UID, 262001006, 1)
		SaveEvent(UID, 6025);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		RobItem(UID, 910039000, 10)
		ExpChange(UID, 60000)
		GiveItem(UID, 282001006, 1)
		SaveEvent(UID, 6025);
	end	 
end

if (EVENT == 6080) then -- 40 Level Goblin
	SelectMsg(UID, 2, 358, 6030, NPC, 28, 6061);
end

if (EVENT == 6081) then
	ShowMap(UID, 6);
	SaveEvent(UID, 6033);
end

if (EVENT == 6082) then
	SelectMsg(UID, 2, 358, 6031, NPC, 10, 6081);
end

if (EVENT == 6083) then
	SelectMsg(UID, 2, 358, 6032, NPC, 10, 6084);
end

if (EVENT == 6084) then
	Level = CheckLevel(UID)
	if (Level > 1 and Level < 39) then  
		SelectMsg(UID, 2, 358, 6033, NPC, 10, 3001);
	elseif (Level == 40) then
		SelectMsg(UID, 2, 358, 6034, NPC, 59, 6085, 60, 3001);
	else
		SelectMsg(UID, 2, 358, 6035, NPC, 10, 3001);
	end
end

if (EVENT == 6085) then
	ZoneChange(UID, 53, 150, 150)
	SaveEvent(UID, 6034);
end

if (EVENT == 6086) then
	Level = CheckLevel(UID)
	if (Level == 41) then
		SaveEvent(UID, 6035);
		NATION = CheckNation(UID);
		if (NATION == 1) then
			SelectMsg(UID, 2, 358, 6036, NPC, 61, 3001);
		else
			SelectMsg(UID, 2, 358, 6037, NPC, 62, 3001);
		end
	end
end

local savenum = 64;

if (EVENT == 630) then -- 75 Level Dragon Cave Hunt
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 4377);
		EVENT = 631
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 4382);
		EVENT = 631
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 4387);
		EVENT = 631
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 4392);
		EVENT = 631
	end
end

if (EVENT == 631) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, savenum, 4635, NPC, 4080, 193);
	else
		SelectMsg(UID, 2, savenum, 4636, NPC, 4080, 193);
	end
end

if (EVENT == 632) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 4637, NPC, 22, 633, 23, 3001);
	else
		SelectMsg(UID, 2, savenum, 4638, NPC, 10, 3001);
	end
end

if (EVENT == 633) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 4378);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 4383);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 4388);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 4393);
	end
end

if (EVENT == 280) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 4380);
		EVENT = 281
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 4385);
		EVENT = 281
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 4390);
		EVENT = 281
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 4395);
		EVENT = 281
	end
end

if (EVENT == 281) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, savenum, 4639, NPC, 4080, 193);
	else
		SelectMsg(UID, 2, savenum, 4640, NPC, 4080, 193);
	end
end

if (EVENT == 636) then
	MonsterCount = CountMonsterQuestSub(UID, 444, 1);
	if (MonsterCount < 1) then
		SelectMsg(UID, 2, savenum, 4641, NPC, 10, 193);
	else
		SelectMsg(UID, 4, savenum, 4642, NPC, 4161, 637, 4162, 193);
	end
end

if (EVENT == 637) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		GiveItem(UID, 156210005, 1)
		SaveEvent(UID, 4379);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		GiveItem(UID, 111210005, 1)
		GiveItem(UID, 168410005, 1)
		SaveEvent(UID, 4384); 
	elseif (Class == 3 or Class == 9 or Class == 10) then
		GiveItem(UID, 181110005, 1)
		SaveEvent(UID, 4389); 
	elseif (Class == 4 or Class == 11 or Class == 12) then
		GiveItem(UID, 170210275, 1)
		SaveEvent(UID, 4394); 
	end	 
end

-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=358 status=2 n_index=4379
if (EVENT == 190) then
	SearchQuest(UID, 13009);
end

-- [AUTO-GEN] quest=437 status=2 n_index=7102
if (EVENT == 240) then
	QuestStatusCheck = GetQuestStatus(UID, 437)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		SaveEvent(UID, 7104);
	end
end

-- [AUTO-GEN] quest=437 status=255 n_index=7099
if (EVENT == 400) then
	SaveEvent(UID, 7100);
end

-- [AUTO-GEN] quest=437 status=0 n_index=7100
if (EVENT == 401) then
	SelectMsg(UID, 4, 437, 4985, NPC, 963, 402, 23, -1);
end

-- [AUTO-GEN] quest=437 status=0 n_index=7100
if (EVENT == 402) then
	SaveEvent(UID, 7101);
end

-- [AUTO-GEN] quest=437 status=1 n_index=7101
if (EVENT == 403) then
	ShowMap(UID, 7101);
end

-- [AUTO-GEN] quest=59 status=255 n_index=11
if (EVENT == 420) then
	SaveEvent(UID, 12);
end

-- [AUTO-GEN] quest=59 status=0 n_index=12
if (EVENT == 422) then
	SelectMsg(UID, 4, 59, 8138, NPC, 6, 423, 23, -1);
end

-- [AUTO-GEN] quest=59 status=0 n_index=12
if (EVENT == 423) then
	SaveEvent(UID, 12);
end

-- [AUTO-GEN] quest=64 status=255 n_index=6000
if (EVENT == 6000) then
	SaveEvent(UID, 6002);
end

-- [AUTO-GEN] quest=64 status=1 n_index=6003
if (EVENT == 6003) then
	ItemA = HowmuchItem(UID, 910117000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 64, 6013, NPC, 18, 6004);
	else
		SelectMsg(UID, 4, 64, 6013, NPC, 41, 6009, 27, -1);
	end
end

-- [AUTO-GEN] quest=64 status=1 n_index=6003
if (EVENT == 6004) then
	ShowMap(UID, 6003);
end

-- [AUTO-GEN] quest=64 status=1 n_index=6003
if (EVENT == 6009) then
	QuestStatusCheck = GetQuestStatus(UID, 64)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 86);
		SaveEvent(UID, 6004);
	end
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
