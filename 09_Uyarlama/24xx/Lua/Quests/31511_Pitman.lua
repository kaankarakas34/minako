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
if EVENT == 200 or EVENT == 300 then
  SelectMsg(UID, 2, -1, 10526, 31511, 10, -1)
  return
end
local UserClass;
local Ret = 0;
local NPC = 31511;
local RUN_EXCHANGE;

if (EVENT == 100) then
	SelectMsg(UID, 3, -1, 9170, NPC, 2017, 400, 7345, 160, 2020, 201);
end

if (EVENT == 400) then
Mattock = HowmuchItem(UID, 389132000);
Check = isRoomForItem(UID, 389132000);
if (Mattock == 0) then
	if (Check == -1) then
		SelectMsg(UID, 2, -1, 832, NPC, 27, 241);
	else
		GiveItem(UID, 389132000, 1)
	end
else	
	SelectMsg(UID, 2, -1, 9172, NPC, 22, 150, 23, 241);
end
end

if (EVENT == 150) then
	ITEMA = HowmuchItem(UID, 900000000);
	Check = isRoomForItem(UID, 389132000);
	if (ITEMA < 1000000) then
		SelectMsg(UID, 2, -1, 9181, NPC, 18, 1000);
	else
		if (Check == -1) then
			SelectMsg(UID, 2, -1, 832, NPC, 27, 241);
		else
			GoldLose(UID, 1000000)
			GiveItem(UID, 389132000, 1)
		end
	end
end

if (EVENT == 1000) then
	ShowMap(UID, 336);
end

if (EVENT == 160) then
	SelectMsg(UID, 2, -1, 9169, NPC, 10, 241);
end

if (EVENT == 201) then
	ORE = HowmuchItem(UID, 399210000);
	GOLDORE = HowmuchItem(UID, 399200000);
	if (ORE < 1 and GOLDORE < 1) then
		SelectMsg(UID, 2, -1, 9179, NPC, 10, 241);
	elseif (ORE > 0) then
		SelectMsg(UID, 2, -1, 9171, NPC, 7253, 202);
	elseif (GOLDORE > 0) then
		SelectMsg(UID, 2, -1, 9171, NPC, 7254, 203);
	elseif (ORE > 0 and GOLDORE > 0) then
		SelectMsg(UID, 2, -1, 9171, NPC, 7253, 202, 7254, 203);
	end
end

local Roll = 0;
local found;

if (EVENT == 202) then
	Check = CheckExchange(UID, 31511108)  -- Mysterious Ore Item Exchange
   if  Check == true then   
   Roll = RollDice(UID, 8) 
   found = Roll + 31511100
   RunExchange(UID, found);
   RobItem(UID, 399210000,2)   
   else
   Ret = 1; 
   end  
end
if (EVENT == 203) then
	Check = CheckExchange(UID, 31511117)  -- Mysterious Gold Ore Item Exchange
   if  Check == true then   
   Roll = RollDice(UID, 8) 
   found = Roll + 31511109
   RunExchange(UID, found);	 
   RobItem(UID, 399200000,2)  
   else
   Ret = 1; 
   end  
end

if (EVENT == 241) then
	Ret = 1;
end	
end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
