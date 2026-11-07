-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6103]={{900652000,20}},
  [6104]={{900659000,1}},
}
local __KO_Completion = {
  [3571]={1310,6103},
  [3577]={1311,6104},
}
local __KO_Quests = {
  [6103]={1310},
  [6104]={1311},
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
local NPC = 25166;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 43812, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 43812, NPC)
	else
		EVENT = QuestNum
	end
end

if(EVENT == 1112) then 
	SelectMsg(UID, 4, 1310, 43812, NPC, 22, 1113, 23, -1);
end

if(EVENT == 1113) then
	QuestStatus = GetQuestStatus(UID, 1310)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 3570);
	end
end

if(EVENT == 1117) then
	QuestStatus = GetQuestStatus(UID, 1310)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	WOLFDOG = HowmuchItem(UID, 900652000)
		if( WOLFDOG < 20) then
			SelectMsg(UID, 2, 1310, 43812, NPC, 18, 1116);
		else
			SaveEvent(UID, 3572);
		end
	end
end

if(EVENT == 1115) then
	QuestStatus = GetQuestStatus(UID, 1310)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	WOLFDOG = HowmuchItem(UID, 900652000)
		if( WOLFDOG < 20) then
			SelectMsg(UID, 2, 1310, 43812, NPC, 18, 1116);
		else
			SelectMsg(UID, 4, 1310, 43812, NPC, 10, 1118, 27, -1);
		end
	end
end

if(EVENT == 1116) then
	ShowMap(UID, 1323);
end

if(EVENT == 1118) then
	QuestStatus = GetQuestStatus(UID, 1310)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	WOLFDOG = HowmuchItem(UID, 900652000)
		if( WOLFDOG < 20) then
			SelectMsg(UID, 2, 1310, 43812, NPC, 18, 1116);
		else
			RunExchange(UID,6103);
			SaveEvent(UID, 3571);
		end
	end
end


if(EVENT == 1122) then 
	SelectMsg(UID, 4, 1311, 43815, NPC, 22, 1123, 23, -1);
end

if(EVENT == 1123) then
	QuestStatus = GetQuestStatus(UID, 1311)
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			if CheckGiveSlot(UID, 1) then
				GiveItem(UID, 900670000,1);
				SaveEvent(UID, 3576);
			end
	end
end

if(EVENT == 1127) then
	QuestStatus = GetQuestStatus(UID, 1311)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	SADI = HowmuchItem(UID, 900659000)
		if( SADI < 1) then
			SelectMsg(UID, 2, 1311, 43815, NPC, 18, 1126);
		else
			SaveEvent(UID, 3578);
		end
	end
end

if(EVENT == 1125) then
	QuestStatus = GetQuestStatus(UID, 1311)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	SADI = HowmuchItem(UID, 900659000)
		if( SADI < 1) then
			SelectMsg(UID, 2, 1311, 43815, NPC, 18, 1126);
		else
			SelectMsg(UID, 4, 1311, 43815, NPC, 10, 1128, 27, -1);
		end
	end
end

if(EVENT == 1126) then
	ShowMap(UID, 1291);
end

if(EVENT == 1128) then
	QuestStatus = GetQuestStatus(UID, 1311)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	SADI = HowmuchItem(UID, 900659000)
		if( SADI < 1) then
			SelectMsg(UID, 2, 1311, 43815, NPC, 18, 1126);
		else
			RunExchange(UID,6104);
			SaveEvent(UID, 3577);
		end
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=1310 status=255 n_index=3568
if (EVENT == 1110) then
	SaveEvent(UID, 3569);
end

-- [AUTO-GEN] quest=1311 status=255 n_index=3574
if (EVENT == 1120) then
	SaveEvent(UID, 3575);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
