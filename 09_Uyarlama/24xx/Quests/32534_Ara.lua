-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [169]={{900005000,250}},
  [171]={{900005000,252}},
  [173]={{900005000,254}},
  [175]={{900005000,256}},
  [177]={{900005000,258}},
  [179]={{900005000,260}},
  [181]={{900005000,262}},
}
local __KO_Completion = {
  [985]={250,169},
  [995]={252,171},
  [1005]={254,173},
  [1015]={256,175},
  [1025]={258,177},
  [1035]={260,179},
  [1045]={262,181},
}
local __KO_Quests = {
  [169]={250},
  [171]={252},
  [173]={254},
  [175]={256},
  [177]={258},
  [179]={260},
  [181]={262},
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
local NPC = 32534;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 8986, NPC, 10, -1);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 8986, NPC)
	else
		EVENT = QuestNum
	end
end

local savenum = 1041;

if (EVENT == 102) then
	SaveEvent(UID, 983);
end

if (EVENT == 104) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 1476, NPC, 22, 105, 23, 106);
	else
		SelectMsg(UID, 2, savenum, 1476, NPC, 10, -1);
	end
end

if (EVENT == 105) then
	SaveEvent(UID, 984);
end

if (EVENT == 106) then
	SaveEvent(UID, 987);
end

if (EVENT == 108) then
	SaveEvent(UID, 986);
end

if (EVENT == 109) then
	MonsterCount = CountMonsterQuestSub(UID, 1041, 1);
	if (MonsterCount < 5) then
		SelectMsg(UID, 2, savenum, 1476, NPC, 18, 110);
	else
		SelectMsg(UID, 4, savenum, 1476, NPC, 41, 111, 23, 110);
	end
end

if (EVENT == 110) then
	ShowMap(UID, 197);
end

if (EVENT == 111) then
	ExpChange(UID, 1400000);
	SaveEvent(UID, 985);
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=250 status=2 n_index=985
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 250)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 169);
		SaveEvent(UID, 987);
	end
end

-- [AUTO-GEN] quest=252 status=0 n_index=993
if (EVENT == 112) then
	SelectMsg(UID, 4, 252, 1476, NPC, 154, 113, 23, -1);
end

-- [AUTO-GEN] quest=252 status=0 n_index=993
if (EVENT == 113) then
	SaveEvent(UID, 994);
end

-- [AUTO-GEN] quest=252 status=1 n_index=994
if (EVENT == 116) then
	QuestStatusCheck = GetQuestStatus(UID, 252)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 171);
		SaveEvent(UID, 995);
	end
end

-- [AUTO-GEN] quest=252 status=1 n_index=994
if (EVENT == 117) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 252, 1476, NPC, 22, 116, 23, -1);
	else
		SelectMsg(UID, 2, 252, 1476, NPC, 18, 118);
	end
end

-- [AUTO-GEN] quest=252 status=1 n_index=994
if (EVENT == 118) then
	ShowMap(UID, 73);
end

-- [AUTO-GEN] quest=254 status=0 n_index=1003
if (EVENT == 120) then
	SelectMsg(UID, 4, 254, 1476, NPC, 154, 121, 23, -1);
end

-- [AUTO-GEN] quest=254 status=0 n_index=1003
if (EVENT == 121) then
	SaveEvent(UID, 1004);
end

-- [AUTO-GEN] quest=254 status=1 n_index=1004
if (EVENT == 124) then
	QuestStatusCheck = GetQuestStatus(UID, 254)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 173);
		SaveEvent(UID, 1005);
	end
end

-- [AUTO-GEN] quest=254 status=1 n_index=1004
if (EVENT == 125) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 254, 1476, NPC, 22, 124, 23, -1);
	else
		SelectMsg(UID, 2, 254, 1476, NPC, 18, 126);
	end
end

-- [AUTO-GEN] quest=254 status=1 n_index=1004
if (EVENT == 126) then
	ShowMap(UID, 73);
end

-- [AUTO-GEN] quest=256 status=0 n_index=1013
if (EVENT == 130) then
	SelectMsg(UID, 4, 256, 1476, NPC, 154, 131, 23, -1);
end

-- [AUTO-GEN] quest=256 status=0 n_index=1013
if (EVENT == 131) then
	SaveEvent(UID, 1014);
end

-- [AUTO-GEN] quest=256 status=1 n_index=1014
if (EVENT == 134) then
	QuestStatusCheck = GetQuestStatus(UID, 256)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 175);
		SaveEvent(UID, 1015);
	end
end

-- [AUTO-GEN] quest=256 status=1 n_index=1014
if (EVENT == 135) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 256, 1476, NPC, 22, 134, 23, -1);
	else
		SelectMsg(UID, 2, 256, 1476, NPC, 18, 136);
	end
end

-- [AUTO-GEN] quest=256 status=1 n_index=1014
if (EVENT == 136) then
	ShowMap(UID, 73);
end

-- [AUTO-GEN] quest=258 status=0 n_index=1023
if (EVENT == 140) then
	SelectMsg(UID, 4, 258, 1476, NPC, 154, 141, 23, -1);
end

-- [AUTO-GEN] quest=258 status=0 n_index=1023
if (EVENT == 141) then
	SaveEvent(UID, 1024);
end

-- [AUTO-GEN] quest=258 status=1 n_index=1024
if (EVENT == 144) then
	QuestStatusCheck = GetQuestStatus(UID, 258)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 177);
		SaveEvent(UID, 1025);
	end
end

-- [AUTO-GEN] quest=258 status=1 n_index=1024
if (EVENT == 145) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 258, 1476, NPC, 22, 144, 23, -1);
	else
		SelectMsg(UID, 2, 258, 1476, NPC, 18, 146);
	end
end

-- [AUTO-GEN] quest=258 status=1 n_index=1024
if (EVENT == 146) then
	ShowMap(UID, 73);
end

-- [AUTO-GEN] quest=260 status=0 n_index=1033
if (EVENT == 150) then
	SelectMsg(UID, 4, 260, 1476, NPC, 154, 151, 23, -1);
end

-- [AUTO-GEN] quest=260 status=0 n_index=1033
if (EVENT == 151) then
	SaveEvent(UID, 1034);
end

-- [AUTO-GEN] quest=260 status=1 n_index=1034
if (EVENT == 154) then
	QuestStatusCheck = GetQuestStatus(UID, 260)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 179);
		SaveEvent(UID, 1035);
	end
end

-- [AUTO-GEN] quest=260 status=1 n_index=1034
if (EVENT == 155) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 260, 1476, NPC, 22, 154, 23, -1);
	else
		SelectMsg(UID, 2, 260, 1476, NPC, 18, 156);
	end
end

-- [AUTO-GEN] quest=260 status=1 n_index=1034
if (EVENT == 156) then
	ShowMap(UID, 73);
end

-- [AUTO-GEN] quest=262 status=0 n_index=1043
if (EVENT == 160) then
	SelectMsg(UID, 4, 262, 1476, NPC, 154, 161, 23, -1);
end

-- [AUTO-GEN] quest=262 status=0 n_index=1043
if (EVENT == 161) then
	SaveEvent(UID, 1044);
end

-- [AUTO-GEN] quest=262 status=1 n_index=1044
if (EVENT == 164) then
	QuestStatusCheck = GetQuestStatus(UID, 262)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 181);
		SaveEvent(UID, 1045);
	end
end

-- [AUTO-GEN] quest=262 status=1 n_index=1044
if (EVENT == 165) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 262, 1476, NPC, 22, 164, 23, -1);
	else
		SelectMsg(UID, 2, 262, 1476, NPC, 18, 166);
	end
end

-- [AUTO-GEN] quest=262 status=1 n_index=1044
if (EVENT == 166) then
	ShowMap(UID, 73);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
