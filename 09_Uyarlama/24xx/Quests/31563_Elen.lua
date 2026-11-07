-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [3136]={{900191000,1}},
  [3137]={},
  [3145]={},
  [3147]={{900168000,1}},
}
local __KO_Completion = {
  [12619]={651,3136},
  [12631]={652,3137},
  [12727]={660,3145},
  [12746]={662,3147},
}
local __KO_Quests = {
  [3136]={651},
  [3137]={652},
  [3145]={660},
  [3147]={662},
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
local NPC = 31563;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then 
		SelectMsg(UID, 2, -1, 4703, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then 
		NpcMsg(UID, 9124, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 1001) then
SelectMsg(UID, 4, 651, 21283, NPC, 22, 1002, 23, -1);
end

if (EVENT == 1002) then
	QuestStatus = GetQuestStatus(UID, 651)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12618);
	end
end

if (EVENT == 1006) then
	QuestStatus = GetQuestStatus(UID, 651)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900191000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 651, 21283, NPC, 18,-1);
		else
			SaveEvent(UID, 12620);
		end
	end
end

if (EVENT == 1005) then
	QuestStatus = GetQuestStatus(UID, 651)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900191000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 651, 21283, NPC, 18,-1);
		else
			SelectMsg(UID, 4, 651, 21283, NPC, 22, 1007, 27, -1);
		end
	end
end	

if (EVENT == 1007)then
	QuestStatus = GetQuestStatus(UID, 651)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900191000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 651, 21283, NPC, 18,-1);
		else
			RunExchange(UID,3136);
			SaveEvent(UID,12619);
			SaveEvent(UID,12630);
			SelectMsg(UID, 2, 651, 21736, NPC, 10,-1);
		end
	end
end

if (EVENT == 1101) then
SelectMsg(UID, 2, 652, 21301, NPC, 10,1103);
SaveEvent(UID,12630);
end

if (EVENT == 1103) then
SelectMsg(UID, 4, 652, 21301, NPC, 22, 1104, 23, -1);
SaveEvent(UID,12632);
end

if (EVENT == 1104) then
SelectMsg(UID, 2, 652, 21746, NPC, 10,-1);
SaveEvent(UID,12631);
SaveEvent(UID,12642);
end


if (EVENT == 1201) then
SelectMsg(UID, 2, 660, 21301, NPC, 10,1203);
SaveEvent(UID,12726);
end


if (EVENT == 1203) then
SelectMsg(UID, 4, 660, 21301, NPC, 22, 1204, 23, -1);
SaveEvent(UID,12728);
end

if (EVENT == 1204) then
	QuestStatus = GetQuestStatus(UID, 660)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SelectMsg(UID, 2, 660, 21844, NPC, 10,-1);
			RunExchange(UID,3145);
			SaveEvent(UID,12727);
			SaveEvent(UID,12733);
	end
end

if (EVENT == 1301) then
SelectMsg(UID, 4, 662, 21304, NPC, 22, 1302, 23, -1);
end

if (EVENT == 1302) then
	QuestStatus = GetQuestStatus(UID, 662)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12745);
	end
end

if (EVENT == 1306) then
	QuestStatus = GetQuestStatus(UID, 662)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900168000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 662, 662, NPC, 18,-1);
		else
			SaveEvent(UID, 12747);
		end
	end
end

if (EVENT == 1305) then
	QuestStatus = GetQuestStatus(UID, 662)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900168000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 662, 662, NPC, 18,-1);
		else
			SelectMsg(UID, 4, 662, 662, NPC, 22, 1307, 27, -1);
		end
	end
end	

if (EVENT == 1307) then
	QuestStatus = GetQuestStatus(UID, 662)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 900168000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 662, 662, NPC, 18,-1);
		else
			SelectMsg(UID, 2, 662, 21862, NPC, 10,-1);
			RunExchange(UID,3147);
			SaveEvent(UID,12746);
		end
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=651 status=2 n_index=12619
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 651)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3136);
		SaveEvent(UID, 12621);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
