-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [243]={{900371000,1}},
  [245]={{900375000,1}},
  [1587]={{900369000,1}},
  [1634]={{900370000,1}},
}
local __KO_Completion = {
  [6311]={839,243},
  [6321]={841,245},
  [6379]={847,1587},
  [6389]={849,1634},
}
local __KO_Quests = {
  [243]={839},
  [245]={841},
  [1587]={847},
  [1634]={849},
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
local NPC = 29123;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 8778, NPC, 10, -1);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 8778, NPC)
	else
		EVENT = QuestNum
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=839 status=2 n_index=6311
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 839)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 243);
		SaveEvent(UID, 6313);
	end
end

-- [AUTO-GEN] quest=847 status=2 n_index=6379
if (EVENT == 201) then
	QuestStatusCheck = GetQuestStatus(UID, 847)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 1587);
		SaveEvent(UID, 6381);
	end
end

-- [AUTO-GEN] quest=839 status=0 n_index=6309
if (EVENT == 1602) then
	SelectMsg(UID, 4, 839, 9814, NPC, 1963, 1603, 23, -1);
end

-- [AUTO-GEN] quest=839 status=0 n_index=6309
if (EVENT == 1603) then
	SaveEvent(UID, 6310);
end

-- [AUTO-GEN] quest=839 status=1 n_index=6310
if (EVENT == 1605) then
	QuestStatusCheck = GetQuestStatus(UID, 839)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 243);
		SaveEvent(UID, 6311);
	end
end

-- [AUTO-GEN] quest=839 status=1 n_index=6310
if (EVENT == 1606) then
	ItemA = HowmuchItem(UID, 900371000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 839, 9814, NPC, 18, 1607);
	else
		SelectMsg(UID, 4, 839, 9814, NPC, 41, 1605, 27, -1);
	end
end

-- [AUTO-GEN] quest=839 status=1 n_index=6310
if (EVENT == 1607) then
	ShowMap(UID, 1);
end

-- [AUTO-GEN] quest=841 status=0 n_index=6319
if (EVENT == 1702) then
	SelectMsg(UID, 4, 841, 9815, NPC, 1964, 1703, 23, -1);
end

-- [AUTO-GEN] quest=841 status=0 n_index=6319
if (EVENT == 1703) then
	SaveEvent(UID, 6320);
end

-- [AUTO-GEN] quest=841 status=1 n_index=6320
if (EVENT == 1705) then
	QuestStatusCheck = GetQuestStatus(UID, 841)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 245);
		SaveEvent(UID, 6321);
	end
end

-- [AUTO-GEN] quest=841 status=1 n_index=6320
if (EVENT == 1706) then
	ItemA = HowmuchItem(UID, 900375000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 841, 9815, NPC, 18, 1707);
	else
		SelectMsg(UID, 4, 841, 9815, NPC, 41, 1705, 27, -1);
	end
end

-- [AUTO-GEN] quest=841 status=1 n_index=6320
if (EVENT == 1707) then
	ShowMap(UID, 1);
end

-- [AUTO-GEN] quest=847 status=0 n_index=6377
if (EVENT == 2102) then
	SelectMsg(UID, 4, 847, 9817, NPC, 1967, 2103, 23, -1);
end

-- [AUTO-GEN] quest=847 status=0 n_index=6377
if (EVENT == 2103) then
	SaveEvent(UID, 6378);
end

-- [AUTO-GEN] quest=847 status=1 n_index=6378
if (EVENT == 2105) then
	QuestStatusCheck = GetQuestStatus(UID, 847)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 1587);
		SaveEvent(UID, 6379);
	end
end

-- [AUTO-GEN] quest=847 status=1 n_index=6378
if (EVENT == 2106) then
	ItemA = HowmuchItem(UID, 900369000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 847, 9817, NPC, 18, 2107);
	else
		SelectMsg(UID, 4, 847, 9817, NPC, 41, 2105, 27, -1);
	end
end

-- [AUTO-GEN] quest=847 status=1 n_index=6378
if (EVENT == 2107) then
	ShowMap(UID, 1);
end

-- [AUTO-GEN] quest=849 status=0 n_index=6387
if (EVENT == 2202) then
	SelectMsg(UID, 4, 849, 9817, NPC, 1968, 2203, 23, -1);
end

-- [AUTO-GEN] quest=849 status=0 n_index=6387
if (EVENT == 2203) then
	SaveEvent(UID, 6388);
end

-- [AUTO-GEN] quest=849 status=1 n_index=6388
if (EVENT == 2205) then
	QuestStatusCheck = GetQuestStatus(UID, 849)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 1634);
		SaveEvent(UID, 6389);
	end
end

-- [AUTO-GEN] quest=849 status=1 n_index=6388
if (EVENT == 2206) then
	ItemA = HowmuchItem(UID, 900370000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 849, 9817, NPC, 18, 2207);
	else
		SelectMsg(UID, 4, 849, 9817, NPC, 41, 2205, 27, -1);
	end
end

-- [AUTO-GEN] quest=849 status=1 n_index=6388
if (EVENT == 2207) then
	ShowMap(UID, 1);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
