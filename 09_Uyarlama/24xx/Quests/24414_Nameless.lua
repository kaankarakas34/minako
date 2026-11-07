-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [305]={{810418000,3}},
  [328]={{900005000,106}},
}
local __KO_Completion = {
  [3055]={107,305},
  [7014]={106,328},
}
local __KO_Quests = {
  [305]={107},
  [328]={106},
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

local function RunQuestExchange(uid, exchange, selected, allExp)
  if selected == nil then return RunExchange(uid, exchange) end
  if selected ~= STEP or selected < 0 or selected > 4 or allExp ~= 1 then return false end
  return RunSelectExchange(uid, exchange)
end
local NPC = 24414;

if (EVENT == 190) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 3003, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 3200, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 195) then
	SelectMsg(UID, 2, 107, 3201, NPC, 28, 196);
end

if (EVENT == 196) then
	ShowMap(UID, 334);
	SaveEvent(UID, 3053);
end

if (EVENT == 197) then
	SelectMsg(UID, 2, 107, 3201, NPC, 28, 196);
end

if (EVENT == 200) then 
	SelectMsg(UID, 2, 107, 3201, NPC, 10, 201);
end

if (EVENT == 201) then
	SelectMsg(UID, 4, 107, 3202, NPC, 22, 202, 23, -1);
end

if (EVENT == 202) then
	QuestStatus = GetQuestStatus(UID, 107)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 3054);
	end
end

if (EVENT == 205) then
	QuestStatus = GetQuestStatus(UID, 107)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 3056);
			NATION = CheckNation(UID);
		if (NATION == 1) then
			SelectMsg(UID, 2, 107, 3005, NPC, 3009, -1);
		else
			SelectMsg(UID, 2, 107, 3006, NPC, 3009, -1);
		end
	end
end

if (EVENT == 210) then
	QuestStatus = GetQuestStatus(UID, 107)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 810418000);
		if (ITEM_COUNT < 3) then
			SelectMsg(UID, 2, 107, 3203, NPC, 18, 213);
		else
			SelectMsg(UID, 5, 107, 3204, NPC, 41, 214, 27, -1);
		end
	end
end

if (EVENT == 213) then
	ShowMap(UID, 22);
end

if (EVENT == 214) then
	QuestStatus = GetQuestStatus(UID, 107)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 810418000);
		if (ITEM_COUNT < 3) then
			SelectMsg(UID, 2, 107, 3203, NPC, 18, 213);
		else
			RunQuestExchange(UID,328,STEP,1);
			SaveEvent(UID, 3055); 
		end
	end
end

if (EVENT == 250) then
	SelectMsg(UID, 2, 106, 476, NPC, 24, 251);
end

if (EVENT == 251) then
	ShowMap(UID, 334);
	SaveEvent(UID, 7012);
end

if (EVENT == 252) then
	SelectMsg(UID, 2, 106, 476, NPC, 24, 251);
end

if (EVENT == 300) then
	SelectMsg(UID, 2, 106, 3205, NPC, 3006, 308, 13, -1);
end

if (EVENT == 308) then
	SelectMsg(UID, 2, 106, 3206, NPC, 3000, 301);
end

if (EVENT == 301) then
	SelectMsg(UID, 4, 106, 3207, NPC, 22, 302, 23, -1);
end

if (EVENT == 302) then
	QuestStatus = GetQuestStatus(UID, 106)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7013);
	end
end

if (EVENT == 303) then
	QuestStatus = GetQuestStatus(UID, 106)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7015);
			NATION = CheckNation(UID);
		if (NATION == 1) then
			SelectMsg(UID, 2, 106, 3851, NPC, 3003, -1);
		elseif (NATION == 2) then
			SelectMsg(UID, 2, 106, 3852, NPC, 3003, -1);
		end
	end
end

if (EVENT == 305) then
	QuestStatus = GetQuestStatus(UID, 106)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 106, 1);
		if (MonsterCount < 5) then
			SelectMsg(UID, 2, 106, 3210, NPC, 18, 306);
		else
			SelectMsg(UID, 5, 106, 3211, NPC, 41, 307, 27, -1);
		end
	end
end

if (EVENT == 306) then
	ShowMap(UID, 576);
end

if (EVENT == 307) then
	QuestStatus = GetQuestStatus(UID, 106)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 106, 1);
		if (MonsterCount < 5) then
			SelectMsg(UID, 2, 106, 3210, NPC, 18, 306);
		else
			RunQuestExchange(UID,305,STEP,1);
			SaveEvent(UID, 7014); 
		end
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=106 status=2 n_index=7014
if (EVENT == 165) then
	QuestStatusCheck = GetQuestStatus(UID, 106)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 328);
		SaveEvent(UID, 7016);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
