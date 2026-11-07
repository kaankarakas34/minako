-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [469]={{910085000,1}},
  [3054]={{910232000,1}},
  [3063]={{910234000,1}},
  [3091]={},
}
local __KO_Completion = {
  [4174]={1382,0},
  [4179]={216,469},
  [11645]={564,3054},
  [11752]={573,3063},
  [12089]={602,3091},
}
local __KO_Quests = {
  [469]={216},
  [3054]={564},
  [3063]={573},
  [3091]={602},
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
if EVENT == 1301 or EVENT == 1305 or EVENT == 1306 or EVENT == 1401 or EVENT == 1405 or EVENT == 1406 or EVENT == 1501 or EVENT == 1503 or EVENT == 1601 or EVENT == 1605 or EVENT == 1606 or EVENT == 1701 or EVENT == 1705 or EVENT == 1706 or EVENT == 1801 or EVENT == 1803 or EVENT == 1901 or EVENT == 1905 or EVENT == 1906 or EVENT == 2001 or EVENT == 2005 or EVENT == 2006 or EVENT == 2101 or EVENT == 2105 or EVENT == 2106 or EVENT == 2201 or EVENT == 2205 or EVENT == 2206 or EVENT == 2301 or EVENT == 2305 or EVENT == 2306 or EVENT == 2401 or EVENT == 2403 or EVENT == 2501 or EVENT == 2505 or EVENT == 2506 or EVENT == 2601 or EVENT == 2603 then
  SelectMsg(UID, 2, -1, 10526, 14407, 10, -1)
  return
end
local Ret = 0;
local NPC = 14407;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then 
		SelectMsg(UID, 2, -1, 4273, NPC, 10, 101);
	elseif (QuestNum > 1 and QuestNum < 100) then 
		NpcMsg(UID, 4274, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 101) then
	Ret = 1;
end

local savenum = 63;

if (EVENT == 105) then -- 45 Level Secret Scroll of Dark Lunar
	Level = CheckLevel(UID)
	if (Level > 44 and Level < 50) then
		SelectMsg(UID, 2, savenum, 4277, NPC, 22, 106, 23, 107);
	elseif (Level > 50) then
		SelectMsg(UID, 2, savenum, 4278, NPC, 10, 101);
		SaveEvent(UID, 4174);
	else
		SelectMsg(UID, 2, savenum, 4278, NPC, 10, 101);
	end
end

if (EVENT == 106) then
	SaveEvent(UID, 4173);
end

if (EVENT == 107) then
	SaveEvent(UID, 4176);
end

if (EVENT == 110) then
	SelectMsg(UID, 2, savenum, 4280, NPC, 4171, 120, 4063, 101);
end

if (EVENT == 120) then 
	ITEMA = HowmuchItem(UID, 910084000);  
	if (ITEMA == 0) then 
		SelectMsg(UID, 2, savenum, 4279, NPC, 18, 121);
	else
		RobItem(UID, 910084000, 1)
		ExpChange(UID, 100000)
		GiveLoyalty(UID, 100)
		SaveEvent(UID, 4174);
	end
end

if (EVENT == 121) then
	ShowMap(UID, 425);
end

local savenum = 64;

if (EVENT == 125) then
	Level = CheckLevel(UID)
	if (Level > 49) then
		SelectMsg(UID, 2, savenum, 4283, NPC, 22, 126, 23, 127);
	else
		SelectMsg(UID, 2, savenum, 4284, NPC, 10, 101);
	end
end

if (EVENT == 126) then
	SaveEvent(UID, 4178);
end

if (EVENT == 127) then
	SaveEvent(UID, 4181);
end

if (EVENT == 130) then 
	SelectMsg(UID, 2, savenum, 4285, NPC, 4171, 131, 4063, 101);
end

if (EVENT == 131) then 
	ITEMB = HowmuchItem(UID, 910085000);  
	if (ITEMB == 0) then 
		SelectMsg(UID, 2, savenum, 4279, NPC, 18, 121);
	else
		RobItem(UID, 910085000, 1)
		ExpChange(UID, 300000)
		GiveLoyalty(UID, 500)
		SaveEvent(UID, 4179);
	end
end

-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=564 status=255 n_index=11642
if (EVENT == 1000) then
	SaveEvent(UID, 11643);
end

-- [AUTO-GEN] quest=564 status=0 n_index=11643
if (EVENT == 1002) then
	SelectMsg(UID, 4, 564, 20097, NPC, 3097, 1003, 23, -1);
end

-- [AUTO-GEN] quest=564 status=0 n_index=11643
if (EVENT == 1003) then
	SaveEvent(UID, 11644);
end

-- [AUTO-GEN] quest=564 status=1 n_index=11644
if (EVENT == 1005) then
	ItemA = HowmuchItem(UID, 910232000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 564, 20097, NPC, 18, 1006);
	else
		SelectMsg(UID, 4, 564, 20097, NPC, 41, 1008, 27, -1);
	end
end

-- [AUTO-GEN] quest=564 status=1 n_index=11644
if (EVENT == 1006) then
	ShowMap(UID, 11644);
end

-- [AUTO-GEN] quest=564 status=1 n_index=11644
if (EVENT == 1008) then
	QuestStatusCheck = GetQuestStatus(UID, 564)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3054);
		SaveEvent(UID, 11645);
	end
end

-- [AUTO-GEN] quest=602 status=2 n_index=12089
if (EVENT == 193) then
	QuestStatusCheck = GetQuestStatus(UID, 602)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3091);
		SaveEvent(UID, 12091);
	end
end

-- [AUTO-GEN] quest=602 status=255 n_index=12086
if (EVENT == 1200) then
	SaveEvent(UID, 12087);
end

-- [AUTO-GEN] quest=602 status=0 n_index=12087
if (EVENT == 1202) then
	SelectMsg(UID, 4, 602, 20773, NPC, 3171, 1203, 23, -1);
end

-- [AUTO-GEN] quest=602 status=1 n_index=12088
if (EVENT == 1203) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 602, 20773, NPC, 18, 1205);
	else
		SelectMsg(UID, 4, 602, 20773, NPC, 41, 1204, 27, -1);
	end
end

-- [AUTO-GEN] quest=602 status=1 n_index=12088
if (EVENT == 1204) then
	QuestStatusCheck = GetQuestStatus(UID, 602)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3091);
		SaveEvent(UID, 12089);
	end
end

-- [AUTO-GEN] quest=602 status=3 n_index=12090
if (EVENT == 1205) then
	SelectMsg(UID, 2, 602, 20773, NPC, 10, -1);
end

-- [AUTO-GEN] quest=573 status=255 n_index=11749
if (EVENT == 1100) then
	SaveEvent(UID, 11750);
end

-- [AUTO-GEN] quest=573 status=0 n_index=11750
if (EVENT == 1102) then
	SelectMsg(UID, 4, 573, 20115, NPC, 3115, 1103, 23, -1);
end

-- [AUTO-GEN] quest=573 status=0 n_index=11750
if (EVENT == 1103) then
	SaveEvent(UID, 11751);
end

-- [AUTO-GEN] quest=573 status=1 n_index=11751
if (EVENT == 1105) then
	ItemA = HowmuchItem(UID, 910234000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 573, 20115, NPC, 18, 1106);
	else
		SelectMsg(UID, 4, 573, 20115, NPC, 41, 1108, 27, -1);
	end
end

-- [AUTO-GEN] quest=573 status=1 n_index=11751
if (EVENT == 1106) then
	ShowMap(UID, 11751);
end

-- [AUTO-GEN] quest=573 status=1 n_index=11751
if (EVENT == 1108) then
	QuestStatusCheck = GetQuestStatus(UID, 573)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3063);
		SaveEvent(UID, 11752);
	end
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
