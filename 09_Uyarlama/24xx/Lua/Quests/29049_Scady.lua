-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [1221]={{508213000,30},{508211000,1},{508212000,1}},
  [1223]={{900005000,810}},
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
if EVENT == 1005 or EVENT == 1006 then
  SelectMsg(UID, 2, -1, 10526, 29049, 10, -1)
  return
end
local Ret = -1;
local NPC = 29049;

if (EVENT == 100) then
		SelectMsg(UID, 3, -1, 9464, 29049, 7176,1001,7177,1101,7178,1201);
end




if(EVENT == 1001) then 
SelectMsg(UID, 2, -1, 9465, NPC, 10,1002);
end

if(EVENT == 1002) then 
SelectMsg(UID, 2, -1, 9469, NPC, 7179,1003,7180,1004);
end

if(EVENT == 1003) then 
STAMP = HowmuchItem(UID, 508213000)
CUBE = HowmuchItem(UID, 508211000)
GOLDP = HowmuchItem(UID, 508212000)
if(STAMP > 29 and CUBE > 0 and GOLDP > 0) then
SelectMsg(UID, 5, 808, 9492, NPC,3000,1005,3005,1005,3005,1005)
else
SelectMsg(UID, 2, -1, 9492, NPC, 10,-1);
end
end


if(EVENT == 1004) then 
STAMP = HowmuchItem(UID, 508213000)
CUBE = HowmuchItem(UID, 508211000)
GOLDP = HowmuchItem(UID, 508212000)
if(STAMP > 29 and CUBE > 0 and GOLDP > 0) then
SelectMsg(UID, 5, 809, 9492, NPC,3000,1006,3005,1006,3005,1006,3005,1006,3005,1006,3005,1006)
else
SelectMsg(UID, 2, -1, 9492, NPC, 10,-1);
end
end

-- Unsupported EVENT branch is retained in the review copy.


-- Unsupported EVENT branch is retained in the review copy.


if(EVENT == 1101) then 
	QuestStatus = SearchQuest(UID, 810)	
	if(QuestStatus == 1) then
		EVENT = 1106
		else
	QuestStatus = SearchQuest(UID, 810)	
	if(QuestStatus == 3) then
		EVENT = 1108
		else
SelectMsg(UID, 2, 810, 9471, NPC, 10,1102);
end
end
end

if(EVENT == 1102) then 
SelectMsg(UID, 4, 810, 9493, NPC,3000,1107,3005,-1);
end

if(EVENT == 1103) then 
SaveEvent(UID, 2713);
end

if(EVENT == 1107) then 
SaveEvent(UID, 2711);
end

if(EVENT == 1106) then 
SelectMsg(UID, 2, 810, 9471, NPC, 18,1109);
end

if (EVENT == 1109) then
	ShowMap(UID, 1011);
end

if(EVENT == 1108) then 
SelectMsg(UID, 4, 810, 9493, NPC,3000,1110,3005,-1);
end

if (EVENT == 1110) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	RunExchange(UID,1223)
	SaveEvent(UID, 2714);
end
end

if(EVENT == 1201) then 
ZoneChange(UID, 35, 464, 116);
end


-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=808 status=2 n_index=2702
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 808)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 1221);
		SaveEvent(UID, 2704);
	end
end

-- [AUTO-GEN] quest=810 status=1 n_index=2711
if (EVENT == 1104) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 810, 9493, NPC, 22, 1103, 23, -1);
	else
		SelectMsg(UID, 2, 810, 9493, NPC, 18, 1105);
	end
end

-- [AUTO-GEN] quest=810 status=1 n_index=2711
if (EVENT == 1105) then
	ShowMap(UID, 2711);
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
