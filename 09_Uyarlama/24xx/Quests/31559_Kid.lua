-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [3129]={{900169000,1}},
  [3131]={{900195000,1}},
  [3133]={{900193000,1}},
  [3135]={{900199000,1}},
}
local __KO_Completion = {
  [12535]={644,3129},
  [12559]={646,3131},
  [12583]={648,3133},
  [12607]={650,3135},
}
local __KO_Quests = {
  [3129]={644},
  [3131]={646},
  [3133]={648},
  [3135]={650},
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
local NPC = 31559;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then 
		SelectMsg(UID, 2, -1, 4703, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then 
		NpcMsg(UID, 20543, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 1001) then
SelectMsg(UID, 4, 644, 21269, NPC, 22, 1002, 23, -1);
end

if (EVENT == 1002) then
	QuestStatus = GetQuestStatus(UID, 644)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12534);
	end
end

if (EVENT == 1006) then
	QuestStatus = GetQuestStatus(UID, 644)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900169000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 644, 21269, NPC, 18,-1);
		else
			SaveEvent(UID, 12536);
		end
	end
end

if (EVENT == 1005) then
	QuestStatus = GetQuestStatus(UID, 644)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900169000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 644, 21269, NPC, 18,-1);
		else
			SelectMsg(UID, 4, 644, 21269, NPC, 22, 1007, 27, -1);
		end
	end
end	

if (EVENT == 1007)then
	QuestStatus = GetQuestStatus(UID, 644)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900169000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 644, 21269, NPC, 18,-1);
		else
			RunExchange(UID,3129);
			SaveEvent(UID,12535);
			SaveEvent(UID,12546);
		end
	end
end


if (EVENT == 1101) then
SelectMsg(UID, 4, 646, 21273, NPC, 22, 1102, 23, -1);
end

if (EVENT == 1102) then
	QuestStatus = GetQuestStatus(UID, 646)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12558);
	end
end

if (EVENT == 1106) then
	QuestStatus = GetQuestStatus(UID, 646)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900195000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 646, 21273, NPC, 18,-1);
		else
			SaveEvent(UID, 12560);
		end
	end
end

if (EVENT == 1105) then
	QuestStatus = GetQuestStatus(UID, 646)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900195000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 646, 21273, NPC, 18,-1);
		else
			SelectMsg(UID, 4, 646, 21273, NPC, 22, 1107, 27, -1);
		end
	end
end	

if (EVENT == 1107)then
	QuestStatus = GetQuestStatus(UID, 646)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900195000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 646, 21273, NPC, 18,-1);
		else
			RunExchange(UID,3131);
			SaveEvent(UID,12559);
			SaveEvent(UID,12570);
		end
	end
end

if (EVENT == 1201) then
SelectMsg(UID, 4, 648, 21277, NPC, 22, 1202, 23, -1);
end

if (EVENT == 1202) then
	QuestStatus = GetQuestStatus(UID, 648)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12582);
	end
end

if (EVENT == 1206) then
	QuestStatus = GetQuestStatus(UID, 648)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900193000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 648, 21277, NPC, 18,1204);
		else
			SaveEvent(UID, 12584);
		end
	end
end

if (EVENT == 1205) then
	QuestStatus = GetQuestStatus(UID, 648)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900193000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 648, 21277, NPC, 18,1204);
		else
			SelectMsg(UID, 4, 648, 21277, NPC, 22, 1207, 27, -1);
		end
	end
end	

if (EVENT == 1204) then
	ShowMap(UID, 828);
end

if (EVENT == 1207)then
	QuestStatus = GetQuestStatus(UID, 648)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900193000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 648, 21277, NPC, 18,1204);
		else
			RunExchange(UID,3133);
			SaveEvent(UID,12583);
			SaveEvent(UID,12594);
			SelectMsg(UID, 2, 648, 21696, NPC, 10,-1);
		end
	end
end

if (EVENT == 1301) then
SelectMsg(UID, 4, 650, 21281, NPC, 22, 1302, 23, -1);
end

if (EVENT == 1302) then
	QuestStatus = GetQuestStatus(UID, 650)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
		SaveEvent(UID, 12606);
	end
end

if (EVENT == 1306) then
	QuestStatus = GetQuestStatus(UID, 650)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900199000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 650, 21277, NPC, 18,-1);
		else
			SaveEvent(UID, 12608);
		end
	end
end

if (EVENT == 1305) then
	QuestStatus = GetQuestStatus(UID, 650)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900199000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 650, 21277, NPC, 18,-1);
		else
			SelectMsg(UID, 4, 650, 21277, NPC, 22, 1307, 27, -1);
		end
	end
end	

if (EVENT == 1307)then
	QuestStatus = GetQuestStatus(UID, 650)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900199000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 650, 21277, NPC, 18,-1);
		else
			RunExchange(UID,3135);
			SaveEvent(UID,12607);
			SaveEvent(UID,12618);
		end
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=644 status=2 n_index=12535
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 644)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3129);
		SaveEvent(UID, 12537);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
