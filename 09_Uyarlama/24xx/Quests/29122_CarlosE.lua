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
  [6316]={840,243},
  [6326]={842,245},
  [6384]={848,1587},
  [6394]={850,1634},
}
local __KO_Quests = {
  [243]={840},
  [245]={842},
  [1587]={848},
  [1634]={850},
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
local NPC = 29122;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 8779, NPC)
	else
		EVENT = QuestNum
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=840 status=2 n_index=6316
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 840)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 243);
		SaveEvent(UID, 6318);
	end
end

-- [AUTO-GEN] quest=848 status=2 n_index=6384
if (EVENT == 201) then
	QuestStatusCheck = GetQuestStatus(UID, 848)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 1587);
		SaveEvent(UID, 6386);
	end
end

-- [AUTO-GEN] quest=840 status=0 n_index=6314
if (EVENT == 1602) then
	SelectMsg(UID, 4, 840, 9819, NPC, 1963, 1603, 23, -1);
end

-- [AUTO-GEN] quest=840 status=0 n_index=6314
if (EVENT == 1603) then
	SaveEvent(UID, 6315);
end

-- [AUTO-GEN] quest=840 status=1 n_index=6315
if (EVENT == 1605) then
	QuestStatusCheck = GetQuestStatus(UID, 840)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 243);
		SaveEvent(UID, 6316);
	end
end

-- [AUTO-GEN] quest=840 status=1 n_index=6315
if (EVENT == 1606) then
	ItemA = HowmuchItem(UID, 900371000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 840, 9819, NPC, 18, 1607);
	else
		SelectMsg(UID, 4, 840, 9819, NPC, 41, 1605, 27, -1);
	end
end

-- [AUTO-GEN] quest=840 status=1 n_index=6315
if (EVENT == 1607) then
	ShowMap(UID, 2);
end

-- [AUTO-GEN] quest=842 status=0 n_index=6324
if (EVENT == 1702) then
	SelectMsg(UID, 4, 842, 9820, NPC, 1964, 1703, 23, -1);
end

-- [AUTO-GEN] quest=842 status=0 n_index=6324
if (EVENT == 1703) then
	SaveEvent(UID, 6325);
end

-- [AUTO-GEN] quest=842 status=1 n_index=6325
if (EVENT == 1705) then
	QuestStatusCheck = GetQuestStatus(UID, 842)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 245);
		SaveEvent(UID, 6326);
	end
end

-- [AUTO-GEN] quest=842 status=1 n_index=6325
if (EVENT == 1706) then
	ItemA = HowmuchItem(UID, 900375000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 842, 9820, NPC, 18, 1707);
	else
		SelectMsg(UID, 4, 842, 9820, NPC, 41, 1705, 27, -1);
	end
end

-- [AUTO-GEN] quest=842 status=1 n_index=6325
if (EVENT == 1707) then
	ShowMap(UID, 2);
end

-- [AUTO-GEN] quest=848 status=0 n_index=6382
if (EVENT == 2102) then
	SelectMsg(UID, 4, 848, 9822, NPC, 1967, 2103, 23, -1);
end

-- [AUTO-GEN] quest=848 status=0 n_index=6382
if (EVENT == 2103) then
	SaveEvent(UID, 6383);
end

-- [AUTO-GEN] quest=848 status=1 n_index=6383
if (EVENT == 2105) then
	QuestStatusCheck = GetQuestStatus(UID, 848)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 1587);
		SaveEvent(UID, 6384);
	end
end

-- [AUTO-GEN] quest=848 status=1 n_index=6383
if (EVENT == 2106) then
	ItemA = HowmuchItem(UID, 900369000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 848, 9822, NPC, 18, 2107);
	else
		SelectMsg(UID, 4, 848, 9822, NPC, 41, 2105, 27, -1);
	end
end

-- [AUTO-GEN] quest=848 status=1 n_index=6383
if (EVENT == 2107) then
	ShowMap(UID, 2);
end

-- [AUTO-GEN] quest=850 status=0 n_index=6392
if (EVENT == 2202) then
	SelectMsg(UID, 4, 850, 9822, NPC, 1968, 2203, 23, -1);
end

-- [AUTO-GEN] quest=850 status=0 n_index=6392
if (EVENT == 2203) then
	SaveEvent(UID, 6393);
end

-- [AUTO-GEN] quest=850 status=1 n_index=6393
if (EVENT == 2205) then
	QuestStatusCheck = GetQuestStatus(UID, 850)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 1634);
		SaveEvent(UID, 6394);
	end
end

-- [AUTO-GEN] quest=850 status=1 n_index=6393
if (EVENT == 2206) then
	ItemA = HowmuchItem(UID, 900370000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 850, 9822, NPC, 18, 2207);
	else
		SelectMsg(UID, 4, 850, 9822, NPC, 41, 2205, 27, -1);
	end
end

-- [AUTO-GEN] quest=850 status=1 n_index=6393
if (EVENT == 2207) then
	ShowMap(UID, 2);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
