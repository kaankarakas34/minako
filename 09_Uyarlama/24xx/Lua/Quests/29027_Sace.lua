-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [3169]={},
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
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 1001 or EVENT == 1003 or EVENT == 1101 or EVENT == 1105 or EVENT == 1106 or EVENT == 1201 or EVENT == 1205 or EVENT == 1206 or EVENT == 1301 or EVENT == 1305 or EVENT == 1306 or EVENT == 1401 or EVENT == 1405 or EVENT == 1406 or EVENT == 1501 or EVENT == 1505 or EVENT == 1506 or EVENT == 1601 or EVENT == 1605 or EVENT == 1606 or EVENT == 1701 or EVENT == 1705 or EVENT == 1706 or EVENT == 1801 or EVENT == 1805 or EVENT == 1806 or EVENT == 1901 or EVENT == 1905 or EVENT == 1906 or EVENT == 2001 or EVENT == 2005 or EVENT == 2006 or EVENT == 2101 or EVENT == 2105 or EVENT == 2106 or EVENT == 2201 or EVENT == 2205 or EVENT == 2206 or EVENT == 2301 or EVENT == 2305 or EVENT == 2306 or EVENT == 2401 or EVENT == 2405 or EVENT == 2406 or EVENT == 2501 or EVENT == 2505 or EVENT == 2506 or EVENT == 2601 or EVENT == 2605 or EVENT == 2606 or EVENT == 2701 or EVENT == 2705 or EVENT == 2706 or EVENT == 2801 or EVENT == 2805 or EVENT == 2806 or EVENT == 2901 or EVENT == 2905 or EVENT == 2906 or EVENT == 3001 or EVENT == 3005 or EVENT == 3006 or EVENT == 3101 or EVENT == 3105 or EVENT == 3106 or EVENT == 3201 or EVENT == 3205 or EVENT == 3206 or EVENT == 3301 or EVENT == 3305 or EVENT == 3306 or EVENT == 3401 or EVENT == 3405 or EVENT == 3406 or EVENT == 3501 or EVENT == 3505 or EVENT == 3506 or EVENT == 3601 or EVENT == 3605 or EVENT == 3606 or EVENT == 3701 or EVENT == 3705 or EVENT == 3706 or EVENT == 3801 or EVENT == 3805 or EVENT == 3806 or EVENT == 3901 or EVENT == 3905 or EVENT == 3906 or EVENT == 4001 or EVENT == 4005 or EVENT == 4006 or EVENT == 4101 or EVENT == 4105 or EVENT == 4106 or EVENT == 4201 or EVENT == 4205 or EVENT == 4206 or EVENT == 4301 or EVENT == 4305 or EVENT == 4306 or EVENT == 4401 or EVENT == 4405 or EVENT == 4406 or EVENT == 4501 or EVENT == 4505 or EVENT == 4506 or EVENT == 4601 or EVENT == 4605 or EVENT == 4606 or EVENT == 4701 or EVENT == 4705 or EVENT == 4706 or EVENT == 4801 or EVENT == 4805 or EVENT == 4806 or EVENT == 4901 or EVENT == 4905 or EVENT == 4906 or EVENT == 5001 or EVENT == 5005 or EVENT == 5006 or EVENT == 5101 or EVENT == 5105 or EVENT == 5106 or EVENT == 5201 or EVENT == 5205 or EVENT == 5206 or EVENT == 5301 or EVENT == 5305 or EVENT == 5306 or EVENT == 5401 or EVENT == 5405 or EVENT == 5406 or EVENT == 5501 or EVENT == 5505 or EVENT == 5506 or EVENT == 5601 or EVENT == 5605 or EVENT == 5606 or EVENT == 5701 or EVENT == 5705 or EVENT == 5706 or EVENT == 5801 or EVENT == 5805 or EVENT == 5806 or EVENT == 5901 or EVENT == 5905 or EVENT == 5906 or EVENT == 6001 or EVENT == 6005 or EVENT == 6006 or EVENT == 6301 or EVENT == 6305 or EVENT == 6306 or EVENT == 6401 or EVENT == 6403 or EVENT == 6501 or EVENT == 6505 or EVENT == 6506 then
  SelectMsg(UID, 2, -1, 10526, 29027, 10, -1)
  return
end
local Ret = 0;
local NPC = 29027;

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



-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=696 status=2 n_index=13010
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 696)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3169);
		SaveEvent(UID, 13012);
	end
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
