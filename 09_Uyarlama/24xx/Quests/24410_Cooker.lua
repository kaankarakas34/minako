-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [90]={{379204000,2}},
  [3006]={{910209000,1}},
}
local __KO_Completion = {
  [606]={202,90},
  [11075]={519,3006},
}
local __KO_Quests = {
  [90]={202},
  [3006]={519},
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
local NPC = 24410;

if (EVENT == 190) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 1258, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 1259, NPC)
	else 
		EVENT = QuestNum
	end
end

if (EVENT == 200) then
	SelectMsg(UID, 4, 202, 1280, NPC, 22, 202, 23, -1);
end

if (EVENT == 202) then
	QuestStatus = GetQuestStatus(UID, 202)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 605);
	end
end

if (EVENT == 205) then
	QuestStatus = GetQuestStatus(UID, 202)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 379204000);   
		if (ITEM_COUNT < 2) then
			SelectMsg(UID, 2, 202, 1280, NPC, 18, 213);
		else
			SaveEvent(UID, 607);
	NATION = CheckNation(UID);
		if (NATION == 1) then
			SelectMsg(UID, 2, 202, 1280, NPC, 32, -1);
		else
			SelectMsg(UID, 2, 202, 1280, NPC, 21, -1);
			end
		end
	end
end

if (EVENT == 210) then
	QuestStatus = GetQuestStatus(UID, 202)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 379204000);   
		if (ITEM_COUNT < 2) then
			SelectMsg(UID, 2, 202, 1280, NPC, 18, 213);
		else
			SelectMsg(UID, 4, 202, 1280, NPC, 41, 214, 27, -1); 
		end
	end
end

if (EVENT == 213) then
	ShowMap(UID, 344);
end

if (EVENT == 214) then
	QuestStatus = GetQuestStatus(UID, 202)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	Check = isRoomForItem(UID, 389620000);
		if (Check == -1) then
			SelectMsg(UID, 2, -1, 832, NPC, 27, -1);
		else
			RunExchange(UID,90);
			SaveEvent(UID, 606);
		end
	end
end

if (EVENT == 1001) then
SelectMsg(UID, 4, 519, 20148, NPC, 22, 1002, 23, -1); 
end

if (EVENT == 1002) then
	QuestStatus = GetQuestStatus(UID, 519)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 11074);
	end
end

if (EVENT == 1006) then
	QuestStatus = GetQuestStatus(UID, 519)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 910209000);   
		if (ITEM_COUNT < 1) then
			SelectMsg(UID, 2, 519, 20148, NPC, 18, -1);
		else
			SaveEvent(UID, 11076);
		end
	end
end

if (EVENT == 1003) then
	QuestStatus = GetQuestStatus(UID, 519)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 910209000);   
		if (ITEM_COUNT < 1) then
			SelectMsg(UID, 2, 519, 20148, NPC, 18, -1);
		else
			SelectMsg(UID, 4, 519, 20148, NPC, 22, 1005, 27, -1); 
		end
	end
end

if (EVENT == 1005) then
	QuestStatus = GetQuestStatus(UID, 519)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 910209000);   
		if (ITEM_COUNT < 1) then
			SelectMsg(UID, 2, 519, 20148, NPC, 18, -1);
		else
			RunExchange(UID,3006);
			SaveEvent(UID, 11075);
			SaveEvent(UID, 11080);
		end
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=202 status=255 n_index=603
if (EVENT == 195) then
	SaveEvent(UID, 604);
end

-- [AUTO-GEN] quest=519 status=2 n_index=11075
if (EVENT == 196) then
	QuestStatusCheck = GetQuestStatus(UID, 519)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3006);
		SaveEvent(UID, 11077);
	end
end

-- [AUTO-GEN] quest=519 status=255 n_index=11072
if (EVENT == 1000) then
	SaveEvent(UID, 11073);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
