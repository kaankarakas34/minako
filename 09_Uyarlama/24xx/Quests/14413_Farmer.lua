-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [31]={{379204000,1}},
  [1150]={{900005000,215}},
  [1151]={{900005000,215}},
  [1152]={{900005000,215}},
  [1153]={{900005000,215}},
}
local __KO_Completion = {
  [116]={201,31},
  [9704]={215,1150},
  [9709]={215,1151},
  [9714]={215,1152},
  [9719]={215,1153},
}
local __KO_Quests = {
  [31]={201},
  [1150]={215},
  [1151]={215},
  [1152]={215},
  [1153]={215},
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
local Ret = 0;
local NPC = 14413;

if (EVENT == 190) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 331, NPC, 10, 193);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 331, NPC)
	else 
		EVENT = QuestNum
	end
end

if (EVENT == 193) then
	Ret = 1;
end

if (EVENT == 195) then -- 47 Level Tyon Meat
	SaveEvent(UID, 114);
end

if (EVENT == 200) then
	SelectMsg(UID, 4, 108, 1247, NPC, 22, 201, 23, 202);
end

if (EVENT == 201) then
	SaveEvent(UID, 115);
	ShowMap(UID, 14);
end

if (EVENT == 202) then
	SaveEvent(UID, 118);
end

if (EVENT == 205) then
	SelectMsg(UID, 2, 108, 1247, NPC, 10, 193);
	SaveEvent(UID, 117);
end

if (EVENT == 210) then
	ItemA = HowmuchItem(UID, 379204000);
	if (ItemA < 1) then
		SelectMsg(UID, 2, 108, 1248, NPC, 18, 212);
	else
		SelectMsg(UID, 4, 108, 1247, NPC, 41, 211, 27, 193);
	end
end

if (EVENT == 212) then
	ShowMap(UID, 14);
end

if (EVENT == 211) then
	RobItem(UID, 379204000, 1)
	GoldGain(UID, 10000)
	SaveEvent(UID, 116);
end

if (EVENT == 9530) then -- 49 Level Tyon
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9702);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9707);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9712);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9717);
	end
end

if (EVENT == 9532) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 922, 8770, NPC, 22, 9533, 23, 9534);
	else
		SelectMsg(UID, 2, 922, 8770, NPC, 10, 193);
	end
end

if (EVENT == 9533) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9703);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9708);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9713);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9718);
	end
end

if (EVENT == 9534) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9706);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9711);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9716);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9721);
	end
end

if (EVENT == 9540) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9705);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9710);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9715);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9720);
	end
end

if (EVENT == 9536) then
	MonsterCount = CountMonsterQuestSub(UID, 922, 1);
	if (MonsterCount < 40) then
		SelectMsg(UID, 2, 922, 8770, NPC, 18, 9537);
	else
		SelectMsg(UID, 4, 922, 8770, NPC, 41, 9538, 27, 193);
	end
end

if (EVENT == 9537) then
	ShowMap(UID, 14);
end

if (EVENT == 9538) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		ExpChange(UID, 2100000)
		GoldGain(UID, 300000)
		SaveEvent(UID, 9704);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		ExpChange(UID, 2100000)
		GoldGain(UID, 300000)
		SaveEvent(UID, 9709);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		ExpChange(UID, 2100000)
		GoldGain(UID, 300000)
		SaveEvent(UID, 9714);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		ExpChange(UID, 2100000)
		GoldGain(UID, 300000)
		SaveEvent(UID, 9719);
	end
end
end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
