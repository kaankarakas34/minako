-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [3237]={{900327000,1}},
  [3238]={{900328000,5},{900329000,1}},
}
local __KO_Completion = {
  [13821]={789,3237},
  [13828]={790,3238},
}
local __KO_Quests = {
  [3237]={789},
  [3238]={790},
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
local NPC = 9260;

if (EVENT == 100) then
	NpcMsg(UID, 23004,NPC)
end

if(EVENT == 1001) then
	SelectMsg(UID, 4, 789, 23004, NPC, 3000, 1002,3005,-1);
end

if(EVENT == 1002) then
	SaveEvent(UID, 13820);
end

if(EVENT == 1006) then
	SaveEvent(UID, 13822);
end

if(EVENT == 1005 ) then
	COUNTA = HowmuchItem(UID, 900327000)	
	if(COUNTA > 0) then
		SelectMsg(UID, 4, 789, 23004, NPC, 41, 1007, 27, -1);
	else
		SelectMsg(UID, 2, 789, 23004, NPC, 18, -1);
	end
end

if(EVENT == 1007 ) then
	QuestStatusCheck = GetQuestStatus(UID, 789) 
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 1179, NPC, 10, -1);
	else
		SelectMsg(UID, 2, -1, 23176, NPC, 10, -1);
		RunExchange(UID, 3237);
		SaveEvent(UID, 13821);
		SaveEvent(UID, 13827);
	end
end

if(EVENT == 1101) then
	SelectMsg(UID, 4, 790, 23005, NPC, 3000, 1102,3005,-1);
end

if(EVENT == 1102) then
	SaveEvent(UID, 13827);
end

if(EVENT == 1106) then
	SaveEvent(UID, 13829);
end

if(EVENT == 1105 ) then
	COUNTA = HowmuchItem(UID, 900328000)	
	COUNTB = HowmuchItem(UID, 900329000)	
	if(COUNTA > 4 and COUNTA > 0) then
		SelectMsg(UID, 4, 790, 23005, NPC, 41, 1107, 27, -1);
	else
		SelectMsg(UID, 2, 790, 23005, NPC, 18, -1);
	end
end

if(EVENT == 1107 ) then
	QuestStatusCheck = GetQuestStatus(UID, 790) 
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 1179, NPC, 10, -1);
	else
		SelectMsg(UID, 2, -1, 23180, NPC, 10, -1);
		RunExchange(UID, 3238);
		SaveEvent(UID, 13828);
		SaveEvent(UID, 13833);
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=789 status=2 n_index=13821
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 789)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3237);
		SaveEvent(UID, 13823);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
