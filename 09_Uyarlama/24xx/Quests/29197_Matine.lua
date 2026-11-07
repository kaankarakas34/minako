-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {

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
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 1000 then
  SelectMsg(UID, 2, -1, 10526, 29197, 10, -1)
  return
end
local Ret = 0;
local NPC = 29197;

if (EVENT == 100) then
	SelectMsg(UID, 3, -1, 10486, NPC, 7572, 200, 7582, 300);
end

if (EVENT == 200) then
	SelectMsg(UID, 2, -1, 10370, NPC, 20);
end

if (EVENT == 300) then
	SelectMsg(UID, 2, -1, 10499, NPC, 7585, 301, 27);
end

if EVENT == 301 then
	ItemA = HowmuchItem(UID, 508165000);
	  if  ItemA == 0 then
	   SelectMsg(UID, 2, savenum,8917, NPC, 10, 190);
	  else
		EVENT =  302
	  end
end

if EVENT == 302 then
SelectMsg(UID,2,-1,10501, NPC,10);
Check = CheckExchange(UID, 429)
 if  Check == true then   
   Roll = RollDice(UID, 19) 
   found = Roll + 410
   RunExchange(UID, found);	
      else
   Ret = 1; 
	   end  
end
-- SQL completed-state dialog exit; no reward or state mutation.
if EVENT == 101 then return end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
