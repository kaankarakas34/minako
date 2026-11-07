-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6000]={{810418000,2}},
  [6001]={{810418000,2}},
  [6002]={{900005000,1202}},
}
local __KO_Completion = {
  [7311]={1200,6000},
  [7318]={1201,6001},
  [7325]={1202,6002},
}
local __KO_Quests = {
  [6000]={1200},
  [6001]={1201},
  [6002]={1202},
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
local Ret = 0;
local NPC = 25073;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 8256, NPC, 10, 158);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 8258, NPC)
	else
		EVENT = QuestNum
	end
end

local savenum = 1200
if(EVENT == 102) then -- 
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 8244, NPC, 22, 106, 23, 158);
	else
		SelectMsg(UID, 2, savenum, 8265, NPC, 10, 158);
	end
end

if(EVENT == 106) then
	SaveEvent(UID, 7310)
end

if(EVENT == 107) then
	SaveEvent(UID, 7312)
end

if(EVENT == 105) then
	CountA = HowmuchItem(UID, 810418000)
	
	if( CountA < 2) then
		SelectMsg(UID, 2, savenum, 8267, NPC, 18, 108);
	else
		SelectMsg(UID, 5, savenum, 8268, NPC, 41, 110, 27, 158);
	end
end

if(EVENT == 108) then
	ShowMap(UID, 1)
end

if(EVENT == 110) then
	RunSelectExchange(UID, 6000);
	SaveEvent(UID, 7311)
end

local savenum = 1201

if(EVENT == 112) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 8244, NPC, 22, 114, 23, 158);
	else
		SelectMsg(UID, 2, savenum, 8265, NPC, 10, 158);
	end
end

if(EVENT == 114) then
	SaveEvent(UID, 7317)
end

if(EVENT == 117) then
	SaveEvent(UID, 7319)
end

if(EVENT == 115) then
	CountA = HowmuchItem(UID, 810418000)
	
	if( CountA < 2) then
		SelectMsg(UID, 2, savenum, 8267, NPC, 18, 118);
	else
		SelectMsg(UID, 5, savenum, 8268, NPC, 41, 120, 27, 158);
	end
end

if (EVENT == 118 ) then
	ShowMap(UID, 2)
end

if(EVENT == 120) then
	RunSelectExchange(UID, 6001);
	SaveEvent(UID, 7318)
end


local savenum = 1202


if(EVENT == 122) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 8244, NPC, 22, 124, 23, 158);
	else
		SelectMsg(UID, 2, savenum, 8265, NPC, 10, 158);
	end
end

if(EVENT == 124) then
	SaveEvent(UID, 7324)
end

if(EVENT == 128) then
	SaveEvent(UID, 7326)
end

if(EVENT == 125) then
	MonsterCount  = CountMonsterQuestSub(UID, savenum, 1);
	if (MonsterCount < 5) then
		SelectMsg(UID, 2, savenum, 8267, NPC, 18, 129);
	else
		SelectMsg(UID, 5, savenum, 8268, NPC, 41, 130, 27, 158);
	end
end

if(EVENT == 129) then
	ShowMap(UID, 2)
end

if(EVENT == 130) then
	RunSelectExchange(UID, 6002);
	SaveEvent(UID, 7325)
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
