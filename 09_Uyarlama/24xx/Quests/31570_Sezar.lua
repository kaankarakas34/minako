-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [3156]={{900005000,676}},
  [3157]={{900005000,678}},
  [3158]={{900005000,680}},
  [3159]={{900005000,682}},
  [3160]={{900005000,684}},
  [3167]={{900005000,692}},
  [3168]={{900005000,694}},
}
local __KO_Completion = {
  [12848]={676,3156},
  [12860]={678,3157},
  [12872]={680,3158},
  [12884]={682,3159},
  [12896]={684,3160},
  [12980]={692,3167},
  [12992]={694,3168},
}
local __KO_Quests = {
  [3156]={676},
  [3157]={678},
  [3158]={680},
  [3159]={682},
  [3160]={684},
  [3167]={692},
  [3168]={694},
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
local NPC = 31570;

if (EVENT == 0) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 9137, NPC, 10, -1);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 9137, NPC)
	else
		EVENT = QuestNum
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=0 status=0 n_index=5026
if (EVENT == 100) then
	SearchQuest(UID, 31570);
end

-- [AUTO-GEN] quest=676 status=2 n_index=12848
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 676)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3156);
		SaveEvent(UID, 12850);
	end
end

-- [AUTO-GEN] quest=676 status=0 n_index=12846
if (EVENT == 1001) then
	SelectMsg(UID, 4, 676, 21321, NPC, 3297, 1002, 23, -1);
end

-- [AUTO-GEN] quest=676 status=0 n_index=12846
if (EVENT == 1002) then
	SaveEvent(UID, 12847);
end

-- [AUTO-GEN] quest=676 status=1 n_index=12847
if (EVENT == 1005) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 676, 21321, NPC, 22, 1006, 23, -1);
	else
		SelectMsg(UID, 2, 676, 21321, NPC, 18, 1006);
	end
end

-- [AUTO-GEN] quest=676 status=1 n_index=12847
if (EVENT == 1006) then
	QuestStatusCheck = GetQuestStatus(UID, 676)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3156);
		SaveEvent(UID, 12848);
	end
end

-- [AUTO-GEN] quest=678 status=0 n_index=12858
if (EVENT == 1101) then
	SelectMsg(UID, 4, 678, 21323, NPC, 3299, 1102, 23, -1);
end

-- [AUTO-GEN] quest=678 status=0 n_index=12858
if (EVENT == 1102) then
	SaveEvent(UID, 12859);
end

-- [AUTO-GEN] quest=678 status=1 n_index=12859
if (EVENT == 1105) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 678, 21323, NPC, 22, 1106, 23, -1);
	else
		SelectMsg(UID, 2, 678, 21323, NPC, 18, 1106);
	end
end

-- [AUTO-GEN] quest=678 status=1 n_index=12859
if (EVENT == 1106) then
	QuestStatusCheck = GetQuestStatus(UID, 678)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3157);
		SaveEvent(UID, 12860);
	end
end

-- [AUTO-GEN] quest=680 status=0 n_index=12870
if (EVENT == 1201) then
	SelectMsg(UID, 4, 680, 21325, NPC, 3301, 1202, 23, -1);
end

-- [AUTO-GEN] quest=680 status=0 n_index=12870
if (EVENT == 1202) then
	SaveEvent(UID, 12871);
end

-- [AUTO-GEN] quest=680 status=1 n_index=12871
if (EVENT == 1205) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 680, 21325, NPC, 22, 1206, 23, -1);
	else
		SelectMsg(UID, 2, 680, 21325, NPC, 18, 1206);
	end
end

-- [AUTO-GEN] quest=680 status=1 n_index=12871
if (EVENT == 1206) then
	QuestStatusCheck = GetQuestStatus(UID, 680)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3158);
		SaveEvent(UID, 12872);
	end
end

-- [AUTO-GEN] quest=682 status=0 n_index=12882
if (EVENT == 1301) then
	SelectMsg(UID, 4, 682, 21327, NPC, 3303, 1302, 23, -1);
end

-- [AUTO-GEN] quest=682 status=0 n_index=12882
if (EVENT == 1302) then
	SaveEvent(UID, 12883);
end

-- [AUTO-GEN] quest=682 status=1 n_index=12883
if (EVENT == 1305) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 682, 21327, NPC, 22, 1306, 23, -1);
	else
		SelectMsg(UID, 2, 682, 21327, NPC, 18, 1306);
	end
end

-- [AUTO-GEN] quest=682 status=1 n_index=12883
if (EVENT == 1306) then
	QuestStatusCheck = GetQuestStatus(UID, 682)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3159);
		SaveEvent(UID, 12884);
	end
end

-- [AUTO-GEN] quest=684 status=0 n_index=12894
if (EVENT == 1401) then
	SelectMsg(UID, 4, 684, 21329, NPC, 3305, 1402, 23, -1);
end

-- [AUTO-GEN] quest=684 status=0 n_index=12894
if (EVENT == 1402) then
	SaveEvent(UID, 12895);
end

-- [AUTO-GEN] quest=684 status=1 n_index=12895
if (EVENT == 1405) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 684, 21329, NPC, 22, 1406, 23, -1);
	else
		SelectMsg(UID, 2, 684, 21329, NPC, 18, 1406);
	end
end

-- [AUTO-GEN] quest=684 status=1 n_index=12895
if (EVENT == 1406) then
	QuestStatusCheck = GetQuestStatus(UID, 684)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3160);
		SaveEvent(UID, 12896);
	end
end

-- [AUTO-GEN] quest=692 status=0 n_index=12978
if (EVENT == 1501) then
	SelectMsg(UID, 4, 692, 21343, NPC, 3319, 1502, 23, -1);
end

-- [AUTO-GEN] quest=692 status=0 n_index=12978
if (EVENT == 1502) then
	SaveEvent(UID, 12979);
end

-- [AUTO-GEN] quest=692 status=1 n_index=12979
if (EVENT == 1505) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 692, 21343, NPC, 22, 1506, 23, -1);
	else
		SelectMsg(UID, 2, 692, 21343, NPC, 18, 1506);
	end
end

-- [AUTO-GEN] quest=692 status=1 n_index=12979
if (EVENT == 1506) then
	QuestStatusCheck = GetQuestStatus(UID, 692)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3167);
		SaveEvent(UID, 12980);
	end
end

-- [AUTO-GEN] quest=694 status=0 n_index=12990
if (EVENT == 1601) then
	SelectMsg(UID, 4, 694, 21345, NPC, 3321, 1602, 23, -1);
end

-- [AUTO-GEN] quest=694 status=0 n_index=12990
if (EVENT == 1602) then
	SaveEvent(UID, 12991);
end

-- [AUTO-GEN] quest=694 status=1 n_index=12991
if (EVENT == 1605) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 694, 21345, NPC, 22, 1606, 23, -1);
	else
		SelectMsg(UID, 2, 694, 21345, NPC, 18, 1606);
	end
end

-- [AUTO-GEN] quest=694 status=1 n_index=12991
if (EVENT == 1606) then
	QuestStatusCheck = GetQuestStatus(UID, 694)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3168);
		SaveEvent(UID, 12992);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
