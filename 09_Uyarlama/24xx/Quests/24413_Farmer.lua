-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [32]={{379204000,1}},
  [1146]={{900005000,214}},
  [1147]={{900005000,214}},
  [1148]={{900005000,214}},
  [1149]={{900005000,214}},
}
local __KO_Completion = {
  [123]={200,32},
  [9683]={214,1146},
  [9688]={214,1147},
  [9693]={214,1148},
  [9698]={214,1149},
}
local __KO_Quests = {
  [32]={200},
  [1146]={214},
  [1147]={214},
  [1148]={214},
  [1149]={214},
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
local NPC = 24413;

if (EVENT == 190) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 330, NPC, 10, 193);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 330, NPC)
	else 
		EVENT = QuestNum
	end
end

if (EVENT == 193) then
	Ret = 1;
end

if (EVENT == 195) then -- 47 Level Tyon Meat
	SaveEvent(UID, 121);
end

if (EVENT == 200) then
	SelectMsg(UID, 4, 109, 1247, NPC, 22, 201, 23, 202);
end

if (EVENT == 201) then
	SaveEvent(UID, 122);
	ShowMap(UID, 344);
end

if (EVENT == 202) then
	SaveEvent(UID, 125);
end

if (EVENT == 205) then
	SelectMsg(UID, 2, 109, 1247, NPC, 10, 193);
	SaveEvent(UID, 124);
end

if (EVENT == 210) then
	ItemA = HowmuchItem(UID, 379204000);
	if (ItemA < 1) then
		SelectMsg(UID, 2, 109, 1248, NPC, 18, 212);
	else
		SelectMsg(UID, 4, 109, 1247, NPC, 41, 211, 27, 193);
	end
end

if (EVENT == 212) then
	ShowMap(UID, 344);
end

if (EVENT == 211) then
	RobItem(UID, 379204000, 1)
	GoldGain(UID, 10000)
	SaveEvent(UID, 123);
end

if (EVENT == 9530) then -- 49 Level Tyon
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9681);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9686);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9691);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9696);
	end
end

if (EVENT == 9532) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 921, 8770, NPC, 22, 9533, 23, 9534);
	else
		SelectMsg(UID, 2, 921, 8770, NPC, 10, 193);
	end
end

if (EVENT == 9533) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9682);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9687);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9692);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9697);
	end
end

if (EVENT == 9534) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9685);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9690);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9695);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9700);
	end
end

if (EVENT == 9540) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9684);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9689);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9694);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9699);
	end
end

if (EVENT == 9536) then
	MonsterCount = CountMonsterQuestSub(UID, 921, 1);
	if (MonsterCount < 40) then
		SelectMsg(UID, 2, 921, 8770, NPC, 18, 9537);
	else
		SelectMsg(UID, 4, 921, 8770, NPC, 41, 9538, 27, 193);
	end
end

if (EVENT == 9537) then
	ShowMap(UID, 344);
end

if (EVENT == 9538) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		ExpChange(UID, 2100000)
		GoldGain(UID, 300000)
		SaveEvent(UID, 9683);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		ExpChange(UID, 2100000)
		GoldGain(UID, 300000)
		SaveEvent(UID, 9688);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		ExpChange(UID, 2100000)
		GoldGain(UID, 300000)
		SaveEvent(UID, 9693);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		ExpChange(UID, 2100000)
		GoldGain(UID, 300000)
		SaveEvent(UID, 9698);
	end
end
end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
