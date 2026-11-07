-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [55]={{910182000,1}},
  [190]={{900036000,1}},
  [490]={{900008000,248}},
  [1094]={{900005000,271}},
}
local __KO_Completion = {
  [1277]={189,190},
  [4315]={248,490},
  [7134]={440,55},
  [9395]={271,1094},
}
local __KO_Quests = {
  [55]={440},
  [190]={189},
  [490]={248},
  [1094]={271},
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
local NPC = 14425;

if (EVENT == 190) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 4589, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 4590, NPC)
	else
		EVENT = QuestNum
	end
end

local savenum = 248;

if (EVENT == 530) then
	SaveEvent(UID, 4313);
	SelectMsg(UID, 2, savenum, 4591, NPC, 4080, -1);
end

if (EVENT == 532) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, savenum, 4592, NPC, 4228, 535, 4063, -1);
	else
		SelectMsg(UID, 2, savenum, 4593, NPC, 10, -1);
	end
end

if (EVENT == 535) then
	SelectMsg(UID, 4, savenum, 4647, NPC, 22, 533, 23, 534);
end

if (EVENT == 533) then
	SaveEvent(UID, 4314);
end

if (EVENT == 534) then
	SaveEvent(UID, 4317);
end

if (EVENT == 180) then
	SaveEvent(UID, 4316);
	SelectMsg(UID, 2, savenum, 4594, NPC, 14, -1);
end

if (EVENT == 536) then
	MonsterCount = CountMonsterQuestSub(UID, 248, 1);
	if (MonsterCount < 10) then
		SelectMsg(UID, 2, savenum, 4595, NPC, 18, 538);
	else
		SelectMsg(UID, 2, savenum, 4596, NPC, 4272, 537, 4273, -1);
	end
end

if (EVENT == 538) then
	ShowMap(UID, 488);
end

if (EVENT == 537) then
	MonsterCount = CountMonsterQuestSub(UID, 248, 1);
	if (MonsterCount < 10) then
		SelectMsg(UID, 2, savenum, 4595, NPC, 18, 538);
	else
	RunExchange(UID,490)
	SaveEvent(UID, 4315); 
end
end

local savenum = 271;

if (EVENT == 9360) then -- 59 Level Ardream Kill 10
	SaveEvent(UID, 9393);
	SelectMsg(UID, 2, savenum, 4591, NPC, 4080, -1);
end

if (EVENT == 9362) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, savenum, 8685, NPC, 4228, 9363, 4063, -1);
	else
		SelectMsg(UID, 2, savenum, 8685, NPC, 10, -1);
	end
end

if (EVENT == 9363) then
	SelectMsg(UID, 4, savenum, 8685, NPC, 22, 9364, 23, 9368);
end

if (EVENT == 9364) then
	SaveEvent(UID, 9394);
end

if (EVENT == 9368) then
	SaveEvent(UID, 9397);
end

if (EVENT == 9365) then
	SaveEvent(UID, 9396);
	SelectMsg(UID, 2, savenum, 8685, NPC, 14, -1);
end

if (EVENT == 9367) then
	MonsterCount1 = CountMonsterQuestSub(UID, 271, 1);
	MonsterCount2 = CountMonsterQuestSub(UID, 271, 2);
	if (MonsterCount1 < 1 and MonsterCount2 < 1) then
		SelectMsg(UID, 2, savenum, 8685, NPC, 18, 9370);
	else
		SelectMsg(UID, 4, savenum, 8685, NPC, 4272, 9369, 4273, -1);
	end
end

if (EVENT == 9370) then
	ShowMap(UID, 488);
end

if (EVENT == 9369) then
	MonsterCount1 = CountMonsterQuestSub(UID, 271, 1);
	MonsterCount2 = CountMonsterQuestSub(UID, 271, 2);
	if (MonsterCount1 < 1 and MonsterCount2 < 1) then
		SelectMsg(UID, 2, savenum, 8685, NPC, 18, 9370);
	else
	RunExchange(UID,1094)
	SaveEvent(UID, 9395);   
end
end

if (EVENT == 400) then
	SelectMsg(UID, 4, 440, 6121, NPC, 10, 401, 4005, -1);
end

if (EVENT == 401) then
    SelectMsg(UID, 15, -1, -1, NPC);
    RunExchange(UID,55)
	SaveEvent(UID, 7134);
end

if (EVENT == 100) then
	SelectMsg(UID, 4, 189, 8878, NPC, 10, -1, 4005, -1);
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=189 status=1 n_index=1276
if (EVENT == 120) then
	QuestStatusCheck = GetQuestStatus(UID, 189)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 190);
		SaveEvent(UID, 1277);
	end
end

-- [AUTO-GEN] quest=189 status=2 n_index=1277
if (EVENT == 193) then
	QuestStatusCheck = GetQuestStatus(UID, 189)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 190);
		SaveEvent(UID, 1279);
	end
end

-- [AUTO-GEN] quest=440 status=2 n_index=7134
if (EVENT == 240) then
	QuestStatusCheck = GetQuestStatus(UID, 440)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 55);
		SaveEvent(UID, 7136);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
