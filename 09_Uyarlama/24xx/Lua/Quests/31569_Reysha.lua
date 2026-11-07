-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [13156]={{900005000,677}},
  [13157]={{900005000,679}},
  [13158]={{900005000,681}},
  [13159]={{900005000,683}},
  [13160]={{900005000,685}},
  [13167]={{900005000,693}},
  [13168]={{900005000,695}},
}
local __KO_Completion = {
  [12854]={677,13156},
  [12866]={679,13157},
  [12878]={681,13158},
  [12890]={683,13159},
  [12902]={685,13160},
  [12986]={693,13167},
  [12998]={695,13168},
}
local __KO_Quests = {
  [13156]={677},
  [13157]={679},
  [13158]={681},
  [13159]={683},
  [13160]={685},
  [13167]={693},
  [13168]={695},
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
local NPC = 31569;

if (EVENT == 0) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 9124, NPC, 10, -1);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 9124, NPC)
	else
		EVENT = QuestNum
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=0 status=0 n_index=5025
if (EVENT == 100) then
	SearchQuest(UID, 31569);
end

-- [AUTO-GEN] quest=677 status=2 n_index=12854
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 677)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 13156);
		SaveEvent(UID, 12856);
	end
end

-- [AUTO-GEN] quest=677 status=0 n_index=12852
if (EVENT == 1001) then
	SelectMsg(UID, 4, 677, 21322, NPC, 3298, 1002, 23, -1);
end

-- [AUTO-GEN] quest=677 status=0 n_index=12852
if (EVENT == 1002) then
	SaveEvent(UID, 12853);
end

-- [AUTO-GEN] quest=677 status=1 n_index=12853
if (EVENT == 1005) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 677, 21322, NPC, 22, 1006, 23, -1);
	else
		SelectMsg(UID, 2, 677, 21322, NPC, 18, 1006);
	end
end

-- [AUTO-GEN] quest=677 status=1 n_index=12853
if (EVENT == 1006) then
	QuestStatusCheck = GetQuestStatus(UID, 677)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 13156);
		SaveEvent(UID, 12854);
	end
end

-- [AUTO-GEN] quest=679 status=0 n_index=12864
if (EVENT == 1101) then
	SelectMsg(UID, 4, 679, 21324, NPC, 3300, 1102, 23, -1);
end

-- [AUTO-GEN] quest=679 status=0 n_index=12864
if (EVENT == 1102) then
	SaveEvent(UID, 12865);
end

-- [AUTO-GEN] quest=679 status=1 n_index=12865
if (EVENT == 1105) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 679, 21324, NPC, 22, 1106, 23, -1);
	else
		SelectMsg(UID, 2, 679, 21324, NPC, 18, 1106);
	end
end

-- [AUTO-GEN] quest=679 status=1 n_index=12865
if (EVENT == 1106) then
	QuestStatusCheck = GetQuestStatus(UID, 679)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 13157);
		SaveEvent(UID, 12866);
	end
end

-- [AUTO-GEN] quest=681 status=0 n_index=12876
if (EVENT == 1201) then
	SelectMsg(UID, 4, 681, 21326, NPC, 3302, 1202, 23, -1);
end

-- [AUTO-GEN] quest=681 status=0 n_index=12876
if (EVENT == 1202) then
	SaveEvent(UID, 12877);
end

-- [AUTO-GEN] quest=681 status=1 n_index=12877
if (EVENT == 1205) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 681, 21326, NPC, 22, 1206, 23, -1);
	else
		SelectMsg(UID, 2, 681, 21326, NPC, 18, 1206);
	end
end

-- [AUTO-GEN] quest=681 status=1 n_index=12877
if (EVENT == 1206) then
	QuestStatusCheck = GetQuestStatus(UID, 681)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 13158);
		SaveEvent(UID, 12878);
	end
end

-- [AUTO-GEN] quest=683 status=0 n_index=12888
if (EVENT == 1301) then
	SelectMsg(UID, 4, 683, 21328, NPC, 3304, 1302, 23, -1);
end

-- [AUTO-GEN] quest=683 status=0 n_index=12888
if (EVENT == 1302) then
	SaveEvent(UID, 12889);
end

-- [AUTO-GEN] quest=683 status=1 n_index=12889
if (EVENT == 1305) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 683, 21328, NPC, 22, 1306, 23, -1);
	else
		SelectMsg(UID, 2, 683, 21328, NPC, 18, 1306);
	end
end

-- [AUTO-GEN] quest=683 status=1 n_index=12889
if (EVENT == 1306) then
	QuestStatusCheck = GetQuestStatus(UID, 683)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 13159);
		SaveEvent(UID, 12890);
	end
end

-- [AUTO-GEN] quest=685 status=0 n_index=12900
if (EVENT == 1401) then
	SelectMsg(UID, 4, 685, 21330, NPC, 3306, 1402, 23, -1);
end

-- [AUTO-GEN] quest=685 status=0 n_index=12900
if (EVENT == 1402) then
	SaveEvent(UID, 12901);
end

-- [AUTO-GEN] quest=685 status=1 n_index=12901
if (EVENT == 1405) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 685, 21330, NPC, 22, 1406, 23, -1);
	else
		SelectMsg(UID, 2, 685, 21330, NPC, 18, 1406);
	end
end

-- [AUTO-GEN] quest=685 status=1 n_index=12901
if (EVENT == 1406) then
	QuestStatusCheck = GetQuestStatus(UID, 685)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 13160);
		SaveEvent(UID, 12902);
	end
end

-- [AUTO-GEN] quest=693 status=0 n_index=12984
if (EVENT == 1501) then
	SelectMsg(UID, 4, 693, 21344, NPC, 3320, 1502, 23, -1);
end

-- [AUTO-GEN] quest=693 status=0 n_index=12984
if (EVENT == 1502) then
	SaveEvent(UID, 12985);
end

-- [AUTO-GEN] quest=693 status=1 n_index=12985
if (EVENT == 1505) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 693, 21344, NPC, 22, 1506, 23, -1);
	else
		SelectMsg(UID, 2, 693, 21344, NPC, 18, 1506);
	end
end

-- [AUTO-GEN] quest=693 status=1 n_index=12985
if (EVENT == 1506) then
	QuestStatusCheck = GetQuestStatus(UID, 693)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 13167);
		SaveEvent(UID, 12986);
	end
end

-- [AUTO-GEN] quest=695 status=0 n_index=12996
if (EVENT == 1601) then
	SelectMsg(UID, 4, 695, 21346, NPC, 3322, 1602, 23, -1);
end

-- [AUTO-GEN] quest=695 status=0 n_index=12996
if (EVENT == 1602) then
	SaveEvent(UID, 12997);
end

-- [AUTO-GEN] quest=695 status=1 n_index=12997
if (EVENT == 1605) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 695, 21346, NPC, 22, 1606, 23, -1);
	else
		SelectMsg(UID, 2, 695, 21346, NPC, 18, 1606);
	end
end

-- [AUTO-GEN] quest=695 status=1 n_index=12997
if (EVENT == 1606) then
	QuestStatusCheck = GetQuestStatus(UID, 695)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 13168);
		SaveEvent(UID, 12998);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
