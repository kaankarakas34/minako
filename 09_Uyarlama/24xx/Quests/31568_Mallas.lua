-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [3155]={},
  [3220]={},
  [3221]={{900291000,1},{900292000,1},{900293000,1}},
  [3225]={{900296000,1}},
}
local __KO_Completion = {
  [12836]={675,3155},
  [13616]={771,3220},
  [13628]={772,3221},
  [13676]={777,3225},
}
local __KO_Quests = {
  [3155]={675},
  [3220]={771},
  [3221]={772},
  [3225]={777},
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
local NPC = 31568;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 23029, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 23029, NPC)
	else
		EVENT = QuestNum
	end
	end
	
if (EVENT == 6101)then
SelectMsg(UID, 2, 771, 22258, NPC, 10,6102);
end

if (EVENT == 6102)then
SaveEvent(UID, 13615);
end

if (EVENT == 6103)then
SelectMsg(UID, 4, 771, 22258, NPC, 3000,6104,3005,-1);
SaveEvent(UID, 13617);
end

if (EVENT == 6104)then
SaveEvent(UID, 13616);
SaveEvent(UID, 13627);
end

if (EVENT == 6201)then
	SelectMsg(UID, 4, 772, 22261, NPC, 3000,6202,4005,-1);
end

if (EVENT == 6202)then
	QuestStatus = GetQuestStatus(UID, 772)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 13627);
	end
end

if (EVENT == 6206)then
	QuestStatus = GetQuestStatus(UID, 772)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900291000);  
    ITEM2_COUNT = HowmuchItem(UID, 900292000); 
    ITEM3_COUNT = HowmuchItem(UID, 900293000); 	
		if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1 and ITEM3_COUNT < 1) then
			SelectMsg(UID, 2, -1, 22261, NPC, 10, -1);
		else
			SaveEvent(UID, 13629);
		end
	end
end

if (EVENT == 6205)then
	QuestStatus = GetQuestStatus(UID, 772)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900291000);  
    ITEM2_COUNT = HowmuchItem(UID, 900292000); 
    ITEM3_COUNT = HowmuchItem(UID, 900293000); 	
		if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1 and ITEM3_COUNT < 1) then
			SelectMsg(UID, 2, -1, 22261, NPC, 10, -1);
		else
			SelectMsg(UID, 4, 772, 22261, NPC,3000,6207,3005,-1);
		end
	end
end

if (EVENT == 6207) then
	QuestStatus = GetQuestStatus(UID, 772)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900291000);  
    ITEM2_COUNT = HowmuchItem(UID, 900292000); 
    ITEM3_COUNT = HowmuchItem(UID, 900293000); 	
		if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1 and ITEM3_COUNT < 1) then
			SelectMsg(UID, 2, -1, 22261, NPC, 10, -1);
		else
			RunExchange(UID,3221);
			SaveEvent(UID, 13628);
			SaveEvent(UID, 13639);
			SelectMsg(UID, 2, -1, 22157, NPC, 10, -1);
		end
	end
end

if (EVENT == 6601)then
	SelectMsg(UID, 4, 777, 22268, NPC, 3000,6602,4005,-1);
end

if (EVENT == 6602)then
	QuestStatus = GetQuestStatus(UID, 777)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 13675);
	end
end

if (EVENT == 6606)then
	QuestStatus = GetQuestStatus(UID, 777)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900296000);  
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, -1, 22268, NPC, 10, -1);
		else
			SaveEvent(UID, 13677);
		end
	end
end

if (EVENT == 6605)then
	QuestStatus = GetQuestStatus(UID, 777)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900296000);  
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, -1, 22268, NPC, 10, -1);
		else
			SelectMsg(UID, 4, 777, 22268, NPC,3000,6607,3005,-1);
		end
	end
end

if (EVENT == 6607) then
	QuestStatus = GetQuestStatus(UID, 777)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900296000);  
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, -1, 22268, NPC, 10, -1);
		else
			RunExchange(UID,3225);
			SaveEvent(UID, 13676);
		end
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=675 status=2 n_index=12836
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 675)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3155);
		SaveEvent(UID, 12838);
	end
end

-- [AUTO-GEN] quest=675 status=0 n_index=12834
if (EVENT == 1001) then
	SelectMsg(UID, 4, 675, 21319, NPC, 3295, 1002, 23, -1);
end

-- [AUTO-GEN] quest=675 status=0 n_index=12834
if (EVENT == 1002) then
	SaveEvent(UID, 12835);
end

-- [AUTO-GEN] quest=675 status=1 n_index=12835
if (EVENT == 1003) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 675, 21319, NPC, 18, 1005);
	else
		SelectMsg(UID, 4, 675, 21319, NPC, 41, 1004, 27, -1);
	end
end

-- [AUTO-GEN] quest=675 status=1 n_index=12835
if (EVENT == 1004) then
	QuestStatusCheck = GetQuestStatus(UID, 675)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3155);
		SaveEvent(UID, 12836);
	end
end

-- [AUTO-GEN] quest=675 status=1 n_index=12835
if (EVENT == 1005) then
	ShowMap(UID, 11);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
