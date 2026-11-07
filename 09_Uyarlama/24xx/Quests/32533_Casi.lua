-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [168]={{900005000,249}},
  [170]={{900005000,251}},
  [172]={{900005000,253}},
  [174]={{900005000,255}},
  [176]={{900005000,257}},
  [178]={{900005000,259}},
  [180]={{900005000,261}},
}
local __KO_Completion = {
  [979]={249,168},
  [990]={251,170},
  [1000]={253,172},
  [1010]={255,174},
  [1020]={257,176},
  [1030]={259,178},
  [1040]={261,180},
}
local __KO_Quests = {
  [168]={249},
  [170]={251},
  [172]={253},
  [174]={255},
  [176]={257},
  [178]={259},
  [180]={261},
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
local NPC = 32533;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 1466, NPC, 10, -1);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 1466, NPC)
	else
		EVENT = QuestNum
	end
end

local savenum = 1040;

if (EVENT == 102) then
	SaveEvent(UID, 977);
end

if (EVENT == 104) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 1466, NPC, 22, 105, 23, 106);
	else
		SelectMsg(UID, 2, savenum, 1466, NPC, 10, -1);
	end
end

if (EVENT == 105) then
	SaveEvent(UID, 978);
end

if (EVENT == 106) then
	SaveEvent(UID, 981);
end

if (EVENT == 108) then
	SaveEvent(UID, 980);
end

if (EVENT == 109) then
	MonsterCount = CountMonsterQuestSub(UID, 1040, 1);
	if (MonsterCount < 5) then
		SelectMsg(UID, 2, savenum, 1466, NPC, 18, 110);
	else
		SelectMsg(UID, 4, savenum, 1466, NPC, 41, 111, 23, 110);
	end
end

if (EVENT == 110) then
	ShowMap(UID, 196);
end

if (EVENT == 111) then
	ExpChange(UID, 1400000);
	SaveEvent(UID, 979);
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=249 status=2 n_index=979
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 249)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 168);
		SaveEvent(UID, 981);
	end
end

-- [AUTO-GEN] quest=251 status=0 n_index=988
if (EVENT == 112) then
	SelectMsg(UID, 4, 251, 1466, NPC, 155, 113, 23, -1);
end

-- [AUTO-GEN] quest=251 status=0 n_index=988
if (EVENT == 113) then
	SaveEvent(UID, 989);
end

-- [AUTO-GEN] quest=251 status=1 n_index=989
if (EVENT == 116) then
	QuestStatusCheck = GetQuestStatus(UID, 251)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 170);
		SaveEvent(UID, 990);
	end
end

-- [AUTO-GEN] quest=251 status=1 n_index=989
if (EVENT == 117) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 251, 1466, NPC, 22, 116, 23, -1);
	else
		SelectMsg(UID, 2, 251, 1466, NPC, 18, 118);
	end
end

-- [AUTO-GEN] quest=251 status=1 n_index=989
if (EVENT == 118) then
	ShowMap(UID, 73);
end

-- [AUTO-GEN] quest=253 status=0 n_index=998
if (EVENT == 120) then
	SelectMsg(UID, 4, 253, 1466, NPC, 155, 121, 23, -1);
end

-- [AUTO-GEN] quest=253 status=0 n_index=998
if (EVENT == 121) then
	SaveEvent(UID, 999);
end

-- [AUTO-GEN] quest=253 status=1 n_index=999
if (EVENT == 124) then
	QuestStatusCheck = GetQuestStatus(UID, 253)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 172);
		SaveEvent(UID, 1000);
	end
end

-- [AUTO-GEN] quest=253 status=1 n_index=999
if (EVENT == 125) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 253, 1466, NPC, 22, 124, 23, -1);
	else
		SelectMsg(UID, 2, 253, 1466, NPC, 18, 126);
	end
end

-- [AUTO-GEN] quest=253 status=1 n_index=999
if (EVENT == 126) then
	ShowMap(UID, 73);
end

-- [AUTO-GEN] quest=255 status=0 n_index=1008
if (EVENT == 130) then
	SelectMsg(UID, 4, 255, 1466, NPC, 155, 131, 23, -1);
end

-- [AUTO-GEN] quest=255 status=0 n_index=1008
if (EVENT == 131) then
	SaveEvent(UID, 1009);
end

-- [AUTO-GEN] quest=255 status=1 n_index=1009
if (EVENT == 134) then
	QuestStatusCheck = GetQuestStatus(UID, 255)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 174);
		SaveEvent(UID, 1010);
	end
end

-- [AUTO-GEN] quest=255 status=1 n_index=1009
if (EVENT == 135) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 255, 1466, NPC, 22, 134, 23, -1);
	else
		SelectMsg(UID, 2, 255, 1466, NPC, 18, 136);
	end
end

-- [AUTO-GEN] quest=255 status=1 n_index=1009
if (EVENT == 136) then
	ShowMap(UID, 73);
end

-- [AUTO-GEN] quest=257 status=0 n_index=1018
if (EVENT == 140) then
	SelectMsg(UID, 4, 257, 1466, NPC, 155, 141, 23, -1);
end

-- [AUTO-GEN] quest=257 status=0 n_index=1018
if (EVENT == 141) then
	SaveEvent(UID, 1019);
end

-- [AUTO-GEN] quest=257 status=1 n_index=1019
if (EVENT == 144) then
	QuestStatusCheck = GetQuestStatus(UID, 257)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 176);
		SaveEvent(UID, 1020);
	end
end

-- [AUTO-GEN] quest=257 status=1 n_index=1019
if (EVENT == 145) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 257, 1466, NPC, 22, 144, 23, -1);
	else
		SelectMsg(UID, 2, 257, 1466, NPC, 18, 146);
	end
end

-- [AUTO-GEN] quest=257 status=1 n_index=1019
if (EVENT == 146) then
	ShowMap(UID, 73);
end

-- [AUTO-GEN] quest=259 status=0 n_index=1028
if (EVENT == 150) then
	SelectMsg(UID, 4, 259, 1466, NPC, 155, 151, 23, -1);
end

-- [AUTO-GEN] quest=259 status=0 n_index=1028
if (EVENT == 151) then
	SaveEvent(UID, 1029);
end

-- [AUTO-GEN] quest=259 status=1 n_index=1029
if (EVENT == 154) then
	QuestStatusCheck = GetQuestStatus(UID, 259)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 178);
		SaveEvent(UID, 1030);
	end
end

-- [AUTO-GEN] quest=259 status=1 n_index=1029
if (EVENT == 155) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 259, 1466, NPC, 22, 154, 23, -1);
	else
		SelectMsg(UID, 2, 259, 1466, NPC, 18, 156);
	end
end

-- [AUTO-GEN] quest=259 status=1 n_index=1029
if (EVENT == 156) then
	ShowMap(UID, 73);
end

-- [AUTO-GEN] quest=261 status=0 n_index=1038
if (EVENT == 160) then
	SelectMsg(UID, 4, 261, 1466, NPC, 155, 161, 23, -1);
end

-- [AUTO-GEN] quest=261 status=0 n_index=1038
if (EVENT == 161) then
	SaveEvent(UID, 1039);
end

-- [AUTO-GEN] quest=261 status=1 n_index=1039
if (EVENT == 164) then
	QuestStatusCheck = GetQuestStatus(UID, 261)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 180);
		SaveEvent(UID, 1040);
	end
end

-- [AUTO-GEN] quest=261 status=1 n_index=1039
if (EVENT == 165) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 261, 1466, NPC, 22, 164, 23, -1);
	else
		SelectMsg(UID, 2, 261, 1466, NPC, 18, 166);
	end
end

-- [AUTO-GEN] quest=261 status=1 n_index=1039
if (EVENT == 166) then
	ShowMap(UID, 73);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
