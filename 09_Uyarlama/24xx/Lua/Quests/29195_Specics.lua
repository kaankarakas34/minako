-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [2530]={{508137000,3}},
  [2531]={{508138000,3}},
  [2532]={{508147000,1},{508149000,1},{508151000,1},{508152000,1}},
}
local __KO_Completion = {

}
local __KO_Quests = {

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
local NPC = 29195;

if (EVENT == 100) then
	SelectMsg(UID, 3, -1, 10392, NPC,7570,110,7571,120,7581,130);
end

if (EVENT == 110) then
QuestStatus = GetQuestStatus(UID, 939);
	if(QuestStatus == 1 or QuestStatus == 3) then
		EVENT = 111
	else
		SelectMsg(UID, 2, -1, 10380, NPC, 56,112);
	end
end

if (EVENT == 111) then
QuestStatus = GetQuestStatus(UID, 939);
		if(QuestStatus == 1) then
			SelectMsg(UID, 2, -1, 10382, NPC, 10,-1);
		elseif (QuestStatus == 3) then
			SelectMsg(UID, 2, -1, 10392, NPC, 10,113);
		else
			SaveEvent(UID, 6781);
	end
end

if (EVENT == 112) then
	SaveEvent(UID, 6781);
end

if (EVENT == 1005) then
	SaveEvent(UID, 6783);
end

if (EVENT == 113) then
COUNTA = HowmuchItem(UID, 508137000);
	if (COUNTA < 3) then
		SelectMsg(UID, 2, -1, 10382, NPC, 10,-1);
	else
		RunExchange(UID, 2530);
		SaveEvent(UID, 6784);
	end
end

if (EVENT == 120) then
QuestStatus = GetQuestStatus(UID, 940);
	if(QuestStatus == 1 or QuestStatus == 3) then
		EVENT = 121
	else
		SelectMsg(UID, 2, -1, 10388, NPC, 56,122);
	end
end

if (EVENT == 121) then
QuestStatus = GetQuestStatus(UID, 940);
		if(QuestStatus == 1) then
			SelectMsg(UID, 2, -1, 10386, NPC, 10,-1);
		elseif (QuestStatus == 3) then
			SelectMsg(UID, 2, -1, 10393, NPC, 10,123);
		else
			SaveEvent(UID, 6786);
	end
end

if (EVENT == 122) then
	SaveEvent(UID, 6786);
end

if (EVENT == 2005) then
	SaveEvent(UID, 6788);
end

if (EVENT == 123) then
COUNTA = HowmuchItem(UID, 508138000);
	if (COUNTA < 3) then
		SelectMsg(UID, 2, -1, 10386, NPC, 10,-1);
	else
		RunExchange(UID, 2531);
		SaveEvent(UID, 6789);
	end
end

if (EVENT == 130) then
QuestStatus = GetQuestStatus(UID, 941);
	if(QuestStatus == 1 or QuestStatus == 3) then
		EVENT = 131
	else
		SelectMsg(UID, 2, -1, 10406, NPC, 56,132);
	end
end

if (EVENT == 131) then
QuestStatus = GetQuestStatus(UID, 941);
		if(QuestStatus == 1) then
			SelectMsg(UID, 2, -1, 10406, NPC, 10,-1);
		elseif (QuestStatus == 3) then
			SelectMsg(UID, 2, -1, 10482, NPC, 10,133);
		else
			SaveEvent(UID, 6791);
	end
end

if (EVENT == 132) then
	SaveEvent(UID, 6791);
end

if (EVENT == 4005) then
	SaveEvent(UID, 6793);
end

if (EVENT == 133) then
COUNTA = HowmuchItem(UID, 508142000);
COUNTB = HowmuchItem(UID, 508142000);
COUNTC = HowmuchItem(UID, 508142000);
COUNTD = HowmuchItem(UID, 508142000);
	if (COUNTA < 1 or COUNTB < 1 or COUNTC < 1 or COUNTD < 1) then
		SelectMsg(UID, 2, -1, 10482, NPC, 10,-1);
	else
		RunExchange(UID, 2532);
		SaveEvent(UID, 6794);
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=939 status=2 n_index=6782
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 939)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 2530);
		SaveEvent(UID, 6784);
	end
end

-- [AUTO-GEN] quest=939 status=0 n_index=6780
if (EVENT == 1000) then
	SelectMsg(UID, 4, 939, 10392, NPC, 470, 1001, 23, -1);
end

-- [AUTO-GEN] quest=939 status=1 n_index=6781
if (EVENT == 1001) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 939, 10392, NPC, 22, 1005, 23, -1);
	else
		SelectMsg(UID, 2, 939, 10392, NPC, 18, 1002);
	end
end

-- [AUTO-GEN] quest=939 status=1 n_index=6781
if (EVENT == 1002) then
	ShowMap(UID, 86);
end

-- [AUTO-GEN] quest=939 status=3 n_index=6783
if (EVENT == 1101) then
	SelectMsg(UID, 2, 939, 10392, NPC, 10, -1);
end

-- [AUTO-GEN] quest=940 status=1 n_index=6786
if (EVENT == 2001) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 940, 10393, NPC, 22, 2005, 23, -1);
	else
		SelectMsg(UID, 2, 940, 10393, NPC, 18, 2002);
	end
end

-- [AUTO-GEN] quest=940 status=1 n_index=6786
if (EVENT == 2002) then
	ShowMap(UID, 86);
end

-- [AUTO-GEN] quest=940 status=3 n_index=6788
if (EVENT == 2101) then
	SelectMsg(UID, 2, 940, 10393, NPC, 10, -1);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
