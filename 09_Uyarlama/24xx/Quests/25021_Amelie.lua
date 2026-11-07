-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6018]={},
  [6019]={{900609000,1}},
}
local __KO_Completion = {
  [7453]={1224,6018},
  [7459]={1225,6019},
}
local __KO_Quests = {
  [6018]={1224},
  [6019]={1225},
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
local NPC = 25021;

if (EVENT == 100) then
	QuestStatus = GetQuestStatus(UID, 1223)	--1228
		if(QuestStatus == 1) then
			EVENT = 112
		else
	QuestStatus = GetQuestStatus(UID, 1226)	--1228
		if(QuestStatus == 1) then
			EVENT = 122
		else
	QuestStatus = GetQuestStatus(UID, 1228)	--1228
		if(QuestStatus == 1) then
			EVENT = 132
		else
	QuestNum = SearchQuest(UID, NPC);
		if (QuestNum == 0) then
			SelectMsg(UID, 2, -1, 43664, NPC, 10, -1);
		elseif (QuestNum > 1 and  QuestNum < 100) then
			NpcMsg(UID, 43664, NPC)
		else
			EVENT = QuestNum
		end
	end
end
end
end

if(EVENT == 112) then
	SelectMsg(UID, 2, 1224, 43664, NPC, 40201, 113);
end

if(EVENT == 113) then
	SelectMsg(UID, 2, 1224, 43770, NPC, 40204, 114);
end

if(EVENT == 114) then
	SelectMsg(UID, 2, 1224, 43771, NPC, 40205, 115);
end

if(EVENT == 115) then
	SelectMsg(UID, 2, 1224, 43772, NPC, 4160, 116);
end

if(EVENT == 116) then
	SelectMsg(UID, 2, 1224, 43773, NPC, 4160, 117);
end

if(EVENT == 117) then
	SelectMsg(UID, 2, 1224, 43773, NPC, 4160, 118);
end

if(EVENT == 118) then
	SelectMsg(UID, 2, 1224, 43774, NPC, 4160, 119);
end

if(EVENT == 119) then
	SelectMsg(UID, 2, 1224, 43774, NPC, 4160, 120);
end

if(EVENT == 120) then
	SelectMsg(UID, 2, 1224, 43775, NPC, 4160, 121);
end

if(EVENT == 121) then
	SaveEvent(UID, 7453);
	SaveEvent(UID, 7448);
end


if(EVENT == 122) then
	SelectMsg(UID, 2, 1225, 43664, NPC, 40202, 123);
end

if(EVENT == 123) then
	SelectMsg(UID, 2, 1225, 43780, NPC, 40209, 124,40210,-1);
end

if(EVENT == 124) then
	if CheckGiveSlot(UID, 1) then
		GiveItem(UID, 900609000, 1);
		SaveEvent(UID, 7459);
	end
end

if(EVENT == 132) then
	SelectMsg(UID, 2, -1, 43664, NPC, 40211, 133);
end

if(EVENT == 133) then
	SelectMsg(UID, 2, -1, 43783, NPC, 40212, 134);
end

if(EVENT == 134) then
	SelectMsg(UID, 2, -1, 43784, NPC, 40212, 135);
end

if(EVENT == 135) then
	SelectMsg(UID, 2, -1, 43785, NPC, 40214, 136);
end

if(EVENT == 136) then
	SelectMsg(UID, 2, -1, 43786, NPC, 40215, 137);
end

if(EVENT == 137) then
	SelectMsg(UID, 2, -1, 43787, NPC, 10, 138);
end

if(EVENT == 138) then
	SaveEvent(UID, 7478);
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=1224 status=255 n_index=7450
if (EVENT == 110) then
	SaveEvent(UID, 7451);
end

-- [AUTO-GEN] quest=1225 status=1 n_index=7458
if (EVENT == 125) then
	ItemA = HowmuchItem(UID, 900609000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1225, 0, NPC, 18, 126);
	else
		SelectMsg(UID, 4, 1225, 0, NPC, 41, 127, 27, -1);
	end
end

-- [AUTO-GEN] quest=1225 status=1 n_index=7458
if (EVENT == 126) then
	ShowMap(UID, 21);
end

-- [AUTO-GEN] quest=1225 status=1 n_index=7458
if (EVENT == 127) then
	QuestStatusCheck = GetQuestStatus(UID, 1225)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6019);
		SaveEvent(UID, 7459);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
