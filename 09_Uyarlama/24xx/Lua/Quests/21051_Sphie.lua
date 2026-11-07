-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [89]={{910044000,1}},
}
local __KO_Completion = {
  [474]={178,89},
}
local __KO_Quests = {
  [89]={178},
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
local NPC = 21051;

if (EVENT == 215) then
	ITEM_COUNT1 = HowmuchItem(UID, 910044000); 
	if (ITEM_COUNT1 < 1) then
		SelectMsg(UID, 2, 178, 1183, NPC, 18, 191);
	else
		SelectMsg(UID, 4, 178, 1184, NPC, 22, 218, 23, -1);
	end
end

if (EVENT == 191) then
	ShowMap(UID, 45);
end

if (EVENT == 218) then
	QuestStatusCheck = GetQuestStatus(UID, 178) 
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 8012, NPC, 10, -1);
		else
	ITEM_COUNT1 = HowmuchItem(UID, 910044000); 
		if (ITEM_COUNT1 < 1) then
			SelectMsg(UID, 2, 178, 1183, NPC, 18, 191);
		else
	Check = isRoomForItem(UID, 910041000);
		if (Check == -1) then
			SelectMsg(UID, 2, -1, 1627, NPC, 27, -1);
		else
			RunExchange(UID,89);
			SaveEvent(UID, 474);
			SelectMsg(UID, 2, 178, 1185, NPC, 10, -1);
			end
		end
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=178 status=1 n_index=473
if (EVENT == 216) then
	ItemA = HowmuchItem(UID, 910044000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 178, 0, NPC, 18, 218);
	else
		SelectMsg(UID, 4, 178, 0, NPC, 41, 217, 27, -1);
	end
end

-- [AUTO-GEN] quest=178 status=1 n_index=473
if (EVENT == 217) then
	QuestStatusCheck = GetQuestStatus(UID, 178)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 89);
		SaveEvent(UID, 474);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
