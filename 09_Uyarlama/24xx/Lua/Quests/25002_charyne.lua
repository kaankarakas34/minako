-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6026]={{900614000,1}},
  [6027]={},
  [6028]={{900649000,1}},
  [6029]={{900005000,1235}},
  [6032]={},
}
local __KO_Completion = {
  [7501]={1232,6026},
  [7507]={1233,6027},
  [7513]={1234,6028},
  [7519]={1235,6029},
  [7525]={1236,6032},
}
local __KO_Quests = {
  [6026]={1232},
  [6027]={1233},
  [6028]={1234},
  [6029]={1235},
  [6032]={1236},
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
local NPC = 25002;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 43742, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 43742, NPC)
	else
		EVENT = QuestNum
	end
end

if(EVENT == 115) then
	SelectMsg(UID, 2, 1232, 43742, NPC, 40220, 116);
end

if(EVENT == 116) then
	SelectMsg(UID, 2, 1232, 43743, NPC, 40221, 118);
end

if(EVENT == 117) then
	SaveEvent(UID, 7502);
end

if(EVENT == 118) then
SelectMsg(UID, 2, 1232, 43744, NPC, 40222, 119);
end

if(EVENT == 119) then
	SelectMsg(UID, 2, 1232, 43745, NPC, 40223, 120);
end

if(EVENT == 120) then
RunExchange(UID, 6026);
SaveEvent(UID, 7501);
end

if(EVENT == 122) then
	SelectMsg(UID, 2, 1233, 43746, NPC, 40224, 123);
end

if(EVENT == 123) then
	SelectMsg(UID, 2, 1233, 43747, NPC, 40225, 124);
end

if(EVENT == 124) then
	SelectMsg(UID, 2, 1233, 43748, NPC, 65, 125);
end

if(EVENT == 125) then
	RunExchange(UID, 6027);
	SaveEvent(UID, 7507);
end

if(EVENT == 132) then
	SelectMsg(UID, 4, 1234, 43750, NPC, 22, 133,23,-1);
end

if(EVENT == 133) then
	QuestStatus = GetQuestStatus(UID, 1234)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7512);
	end
end

if(EVENT == 137) then
	QuestStatus = GetQuestStatus(UID, 1234)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	CountA = HowmuchItem(UID, 900649000)
		if( CountA < 1) then
			SelectMsg(UID, 2, 1234, 43750, NPC, 18, 136);
		else
			SaveEvent(UID, 7514);
		end
	end
end

if(EVENT == 135) then
	QuestStatus = GetQuestStatus(UID, 1234)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	CountA = HowmuchItem(UID, 900649000)
		if(CountA < 1) then
			SelectMsg(UID, 2, 1234, 43750, NPC, 18, 136);
		else
			SelectMsg(UID, 4, 1234, 43750, NPC, 41, 138, 27, -1);
		end
	end
end

if(EVENT == 136) then
ShowMap(UID, 1257);
end

if(EVENT == 138) then
	QuestStatus = GetQuestStatus(UID, 1234)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	CountA = HowmuchItem(UID, 900649000)
		if(CountA < 1) then
			SelectMsg(UID, 2, 1234, 43750, NPC, 18, 136);
		else
			RunExchange(UID, 6028);
			SaveEvent(UID, 7513);
		end
	end
end

if(EVENT == 142) then
	SelectMsg(UID, 4, 1235, 43753, NPC, 22, 143,23,-1);
end

if(EVENT == 143) then
	QuestStatus = GetQuestStatus(UID, 1235)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7518);
	end
end

if(EVENT == 147) then
	QuestStatus = GetQuestStatus(UID, 1235)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount  = CountMonsterQuestSub(UID, 1235, 1);
		if (MonsterCount < 1) then
			SelectMsg(UID, 2, 1235, 43753, NPC, 18, -1);
		else
			SaveEvent(UID, 7520);
		end
	end
end

if(EVENT == 145) then
	QuestStatus = GetQuestStatus(UID, 1235)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount  = CountMonsterQuestSub(UID, 1235, 1);
		if (MonsterCount < 1) then
			SelectMsg(UID, 2, 1235, 43753, NPC, 18, -1);
		else
			SelectMsg(UID, 4, 1235, 43753, NPC, 41, 146, 27, -1);
		end
	end
end

if(EVENT == 146) then
	QuestStatus = GetQuestStatus(UID, 1235)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount  = CountMonsterQuestSub(UID, 1235, 1);
		if (MonsterCount < 1) then
			SelectMsg(UID, 2, 1235, 43753, NPC, 18, -1);
		else
			RunExchange(UID, 6029);
			SaveEvent(UID, 7519);
		end
	end
end

if(EVENT == 152) then
	SelectMsg(UID, 4, 1236, 43758, NPC, 22, 153,23,-1);
end

if(EVENT == 153) then
	SaveEvent(UID, 7524)
end

if(EVENT == 157) then
	SaveEvent(UID, 7526)
end

if(EVENT == 155) then
	SelectMsg(UID, 4, 1236, 43758, NPC, 22, 156,23,-1);
end

if(EVENT == 156) then
	SelectMsg(UID, 2, 1236, 43758, NPC, 10, 158);
	RunExchange(UID, 6032);
	SaveEvent(UID, 7525);
end

if (EVENT == 158 ) then
	ShowMap(UID, 1189);
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=1232 status=255 n_index=7498
if (EVENT == 110) then
	SaveEvent(UID, 7499);
end

-- [AUTO-GEN] quest=1232 status=0 n_index=7499
if (EVENT == 112) then
	SelectMsg(UID, 4, 1232, 43742, NPC, 703, 113, 23, -1);
end

-- [AUTO-GEN] quest=1232 status=0 n_index=7499
if (EVENT == 113) then
	SaveEvent(UID, 7500);
end

-- [AUTO-GEN] quest=1233 status=1 n_index=7506
if (EVENT == 127) then
	QuestStatusCheck = GetQuestStatus(UID, 1233)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6027);
		SaveEvent(UID, 7507);
	end
end

-- [AUTO-GEN] quest=1234 status=255 n_index=7510
if (EVENT == 130) then
	SaveEvent(UID, 7511);
end

-- [AUTO-GEN] quest=1235 status=255 n_index=7516
if (EVENT == 140) then
	SaveEvent(UID, 7517);
end

-- [AUTO-GEN] quest=1236 status=255 n_index=7522
if (EVENT == 150) then
	SaveEvent(UID, 7523);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
