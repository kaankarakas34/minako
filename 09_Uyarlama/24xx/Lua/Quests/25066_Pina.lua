-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6058]={{900654000,1}},
  [6085]={},
  [6088]={{900008000,1292}},
  [6089]={{900638000,1}},
}
local __KO_Completion = {
  [7681]={1262,6058},
  [7881]={1289,6085},
  [7899]={1292,6088},
  [7905]={1293,6089},
}
local __KO_Quests = {
  [6058]={1262},
  [6085]={1289},
  [6088]={1292},
  [6089]={1293},
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
local NPC = 25066;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 43928, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 43928, NPC)
	else
		EVENT = QuestNum
	end
end

if(EVENT == 112) then 
	SelectMsg(UID, 4, 1262, 43928, NPC, 22, 113, 23, -1);
end

if(EVENT == 113) then
	QuestStatus = GetQuestStatus(UID, 1262)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7680);
	end
end

if(EVENT == 117) then
	QuestStatus = GetQuestStatus(UID, 1262)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	BRACE = HowmuchItem(UID, 900654000)
		if( BRACE < 1) then
			SelectMsg(UID, 2, 1262, 43928, NPC, 18, 116);
		else
			SaveEvent(UID, 7682);
		end
	end
end

if(EVENT == 115) then
	QuestStatus = GetQuestStatus(UID, 1262)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	BRACE = HowmuchItem(UID, 900654000)
		if( BRACE < 1) then
			SelectMsg(UID, 2, 1262, 43928, NPC, 18, 116);
		else
			SelectMsg(UID, 4, 1262, 43928, NPC, 10, 118, 27, -1);
		end
	end
end

if(EVENT == 116) then
	ShowMap(UID, 1337);
end

if(EVENT == 118) then
	QuestStatus = GetQuestStatus(UID, 1262)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	BRACE = HowmuchItem(UID, 900654000)
		if( BRACE < 1) then
			SelectMsg(UID, 2, 1262, 43928, NPC, 18, 116);
		else
			RunExchange(UID,6058);
			SaveEvent(UID, 7681);
		end
	end
end

if (EVENT == 152) then
	SelectMsg(UID, 4, 1289, 44139, NPC, 10, 153, 23, -1);
end

if(EVENT == 153) then
    RunExchange(UID,6085);
    SaveEvent(UID, 7880);
	SaveEvent(UID, 7882);
	SaveEvent(UID, 7881);
end

if (EVENT == 182) then
	SelectMsg(UID, 4, 1292, 44140, NPC, 10, 183, 23, -1);
end

if(EVENT == 183) then
	QuestStatus = GetQuestStatus(UID, 1292)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7898);
	end
end

if(EVENT == 187) then
	QuestStatus = GetQuestStatus(UID, 1292)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1292, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 1292, 44140, NPC, 10, 186);
		else
			SaveEvent(UID, 7900);
		end
	end
end

if (EVENT == 185) then
	QuestStatus = GetQuestStatus(UID, 1292)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1292, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 1292, 44140, NPC, 10, 186);
		else
			SelectMsg(UID, 4, 1292, 44140, NPC, 10, 188, 27, -1);
		end
	end
end

if(EVENT == 186) then
ShowMap(UID, 488);
end

if(EVENT == 188) then
	QuestStatus = GetQuestStatus(UID, 1292)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1292, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 1292, 44140, NPC, 10, 186);
		else
			RunExchange(UID,6088);
			SaveEvent(UID, 7899);
		end
	end
end

if (EVENT == 192) then
	SelectMsg(UID, 4, 1293, 44141, NPC, 10, 193, 23, -1);
end

if(EVENT == 193) then
	QuestStatus = GetQuestStatus(UID, 1293)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7904);
	end
end

if(EVENT == 197) then
	QuestStatus = GetQuestStatus(UID, 1293)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	GHOST = HowmuchItem(UID, 900638000)
		if( GHOST < 1) then
			SelectMsg(UID, 2, 1293, 44141, NPC, 18, 196);
		else
			SaveEvent(UID, 7906);
		end
	end
end

if(EVENT == 195) then
	QuestStatus = GetQuestStatus(UID, 1293)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	GHOST = HowmuchItem(UID, 900638000)
		if( GHOST < 1) then
			SelectMsg(UID, 2, 1293, 44141, NPC, 18, 196);
		else
			SelectMsg(UID, 4, 1293, 44141, NPC, 10, 198, 27, -1);
		end
	end
end

if(EVENT == 196) then
ShowMap(UID, 1284);
end

if(EVENT == 198) then
	QuestStatus = GetQuestStatus(UID, 1293)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	GHOST = HowmuchItem(UID, 900638000)
		if( GHOST < 1) then
			SelectMsg(UID, 2, 1293, 44141, NPC, 18, 196);
		else
			RunExchange(UID,6089);
			SaveEvent(UID, 7905);
		end
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=1262 status=255 n_index=7678
if (EVENT == 110) then
	SaveEvent(UID, 7679);
end

-- [AUTO-GEN] quest=1289 status=255 n_index=7878
if (EVENT == 150) then
	SaveEvent(UID, 7879);
end

-- [AUTO-GEN] quest=1289 status=1 n_index=7880
if (EVENT == 157) then
	QuestStatusCheck = GetQuestStatus(UID, 1289)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6085);
		SaveEvent(UID, 7881);
	end
end

-- [AUTO-GEN] quest=1292 status=255 n_index=7896
if (EVENT == 180) then
	SaveEvent(UID, 7897);
end

-- [AUTO-GEN] quest=1293 status=255 n_index=7902
if (EVENT == 190) then
	SearchQuest(UID, 25066);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
