-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [1224]={{900060000,5}},
}
local __KO_Completion = {

}
local __KO_Quests = {

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
local NPC = 29052;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 9488, NPC, 10, -1);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 9488, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 1001) then
SelectMsg(UID, 2, -1, 9477, NPC, 7181, 1002,7182,1010);
end

if (EVENT == 1010) then
ZONEKONTROL = GetZoneID(UID);
--ZONEKONTROL2 = GetZoneID(UID);
if (ZONEKONTROL == 35) then
ZoneChange(UID, 30, 510, 252);
--else
--if (ZONEKONTROL2 == 91) then
--ZoneChange(UID, 21, 510, 252);
--end
end
end

if (EVENT == 1002) then
	SelectMsg(UID, 2, 811, 9478, NPC, 10, 1005);
end

if (EVENT == 1005) then
	SelectMsg(UID, 4, 811, 9494, NPC, 3000, 1006, 3005, -1);
end

if (EVENT == 1006) then
	SaveEvent(UID, 2716);
end

if (EVENT == 1004) then
	ITEMA = HowmuchItem(UID, 900060000);
	if (ITEMA < 5) then 
		SelectMsg(UID, 2, 811, 9494, NPC, 18, 1008);
	else
		SelectMsg(UID, 4, 811, 9494, NPC, 3000, 1007, 3005, -1);
	end
end

if (EVENT == 1008) then
	ShowMap(UID, 1008);
end

if (EVENT == 1003) then
	SaveEvent(UID, 2718);
end

if (EVENT == 1007) then
	ITEMA = HowmuchItem(UID, 900060000);
		if (ITEMA < 5) then 
			SelectMsg(UID, 2, 811, 9494, NPC, 18, 1008);
		else
			RunExchange(UID,1224);
			SaveEvent(UID, 2719);
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=811 status=2 n_index=2717
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 811)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 1224);
		SaveEvent(UID, 2719);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
