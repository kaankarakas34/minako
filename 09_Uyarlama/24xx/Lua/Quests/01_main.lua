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
  [5002]={500,0},
  [5005]={500,0},
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
local NATION = 0;
local NPC = 0;

if (EVENT == 500) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 6, 500, 5000, NPC, 5000, 501);
	else
		SelectMsg(UID, 6, 500, 5001, NPC, 5000, 501);
	end
end

if (EVENT == 501) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SaveEvent(UID, 5001);
	else
		SaveEvent(UID, 5004);
	end
end

if (EVENT == 502) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 6, 500, 5002, NPC, 5001, 503);
	else
		SelectMsg(UID, 6, 500, 5003, NPC, 5004, 503);
	end
end

if (EVENT == 503) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SaveEvent(UID, 5002);
	else
		SaveEvent(UID, 5005);
	end
		NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 1, 500, 5004, NPC, 5002, 504);
	else
		SelectMsg(UID, 1, 500, 5005, NPC, 5005, 504);
	end
end

if (EVENT == 504) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 1, 500, 5006, NPC, 5003, 505);
	else
		SelectMsg(UID, 1, 500, 5007, NPC, 5003, 505);
	end
end

if (EVENT == 505) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 1, 500, 5008, NPC, 5004, 506);
	else
		SelectMsg(UID, 1, 500, 5009, NPC, 5004, 506);
	end
end

if (EVENT == 506) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 1, 500, 5010, NPC, 5005, 507);
	else
		SelectMsg(UID, 1, 500, 5011, NPC, 5005, 507);
	end
end

if (EVENT == 507) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 1, 500, 5012, NPC, 5006, 508);
	else
		SelectMsg(UID, 1, 500, 5013, NPC, 5006, 508);
	end
end

if (EVENT == 508) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 6, 500, 5014, NPC, 6002, 509);
	else
		SelectMsg(UID, 6, 500, 5015, NPC, 6002, 509);
	end
end

if (EVENT == 509) then
	Ret = 1;
end
end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
