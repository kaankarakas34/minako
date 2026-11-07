-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [3026]={},
  [3027]={{508106000,5}},
}
local __KO_Completion = {
  [11309]={539,3026},
  [11321]={540,3027},
}
local __KO_Quests = {
  [3026]={539},
  [3027]={540},
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
local NPC = 31515;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then 
		SelectMsg(UID, 2, -1, 4703, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then 
		NpcMsg(UID, 21715, NPC)
	else
		EVENT = QuestNum
	end
end

if(EVENT == 1002)then 
	SelectMsg(UID, 2, 539, 20314, NPC, 10, 1004);
end

if(EVENT == 1003)then 
	SelectMsg(UID, 2, 539, 20314, NPC, 10, 1004);
end

if(EVENT == 1004)then 
	SelectMsg(UID, 4, 539, 20315, NPC,22, 1005, 27, -1); 
	SaveEvent(UID, 11310);
end

if(EVENT == 1005)then 
	SaveEvent(UID, 11309);
	SaveEvent(UID, 11320);
end

if (EVENT == 1101)then
	SelectMsg(UID, 4, 540, 20048, NPC, 22, 1102,23,-1);
end

if(EVENT == 1102)then 
	QuestStatusCheck = GetQuestStatus(UID, 540)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 11320);
	end
end

if(EVENT == 1106)then 
	QuestStatusCheck = GetQuestStatus(UID, 540)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 508106000);   
		if (ITEM1_COUNT < 5) then
			SelectMsg(UID, 2, 540, 20048, NPC, 18,1104);
		else
			SaveEvent(UID, 11322);
		end
	end
end

if (EVENT == 1103) then
	QuestStatusCheck = GetQuestStatus(UID, 540)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 508106000);   
		if (ITEM1_COUNT < 5) then
			SelectMsg(UID, 2, 540, 20048, NPC, 18,1104);
		else
			SelectMsg(UID, 4, 540, 20048, NPC, 22, 1107, 27, -1); 
		end
	end
end

if (EVENT == 1104 ) then
	ShowMap(UID, 371)
end

if (EVENT == 1107)then
	QuestStatusCheck = GetQuestStatus(UID, 540)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 508106000);   
		if (ITEM1_COUNT < 5) then
			SelectMsg(UID, 2, 540, 20048, NPC, 18,1104);
		else
			RunExchange(UID,3027);
			SaveEvent(UID,11321);
			SaveEvent(UID,11332);
		end
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=539 status=2 n_index=11309
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 539)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3026);
		SaveEvent(UID, 11311);
	end
end

-- [AUTO-GEN] quest=539 status=255 n_index=11306
if (EVENT == 1000) then
	SaveEvent(UID, 11307);
end

-- [AUTO-GEN] quest=540 status=255 n_index=11318
if (EVENT == 1100) then
	SaveEvent(UID, 11319);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
