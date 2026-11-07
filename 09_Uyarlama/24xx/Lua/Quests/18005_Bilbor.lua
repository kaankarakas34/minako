-- Adapted for bundled GameServer SHA256 19e92a27...; source AKGame
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [2]={{989511000,1}},
  [6004]={{900605000,1}},
}
local __KO_Completion = {
  [434]={124,2},
  [7352]={1207,6004},
}
local __KO_Quests = {
  [2]={124},
  [6004]={1207},
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
if EVENT == 1000 then
  SelectMsg(UID, 2, -1, 10526, 0, 10, -1)
  return
end
-- =============================================
-- RİMA GUARD  //  www.RimaGUARD.com 
-- Knight Online Pvp v24xx Server Files & AntiCheat System
-- =============================================
--SelectMsg(UID,3,-1,101,NPC,40154,202,4262,-1,4554,-1,4475,712,8209,-1,7591,-1,7746,-1,7785,-1,7799,-1,3019,-1);

local NPC = 18005;

if (EVENT == 100) then
Quest1 = GetQuestStatus(UID,1203); --25000
Quest2 = GetQuestStatus(UID,1207); --18005
	if (Quest1 == 1 and Quest2 ~= 2) then
		SelectMsg(UID,3,-1,101,NPC,40154,202,4554,910,8209,920,7591,930,7746,940,7785,950,7799,960,3019,-1);  --,4262,900
	else
		SelectMsg(UID,3,-1,101,NPC,4554,910,8209,920,7591,930,7746,940,7785,950,7799,960,3019,-1); --,4262,900
	end
end

if (EVENT == 202) then
THRUST = GetQuestStatus(UID,1207);
BOOK = HowmuchItem(UID, 900605000);
	if (THRUST == 1 and BOOK == 0) then
		SelectMsg(UID, 2, -1, 43637, NPC,10,-1);
	elseif (THRUST == 3 and BOOK > 0) then
		EVENT = 205
	else
		SelectMsg(UID, 4, 1207, 43636, NPC, 22,203,23,-1);
	end
end

if (EVENT == 203) then
	SaveEvent(UID,7351);
end

if (EVENT == 205) then
THRUST = GetQuestStatus(UID,1207);
BOOK = HowmuchItem(UID, 900605000);
	if (BOOK == 0 and THRUST == 1) then
		SelectMsg(UID, 2, -1, 43637, NPC,10,-1);
	else
		SelectMsg(UID, 4, 1207, 43636, NPC, 40143,206,23,-1);
	end
end

if (EVENT == 206) then
THRUST = GetQuestStatus(UID,1207);
BOOK = HowmuchItem(UID, 900605000);
	if (BOOK == 0 and THRUST == 1) then
		SelectMsg(UID, 2, -1, 43637, NPC,10,-1);
	else 
		RunExchange(UID,6004);
		SaveEvent(UID,7352);
	end
end

if (EVENT == 207) then
	SaveEvent(UID,7353);
end

if (EVENT == 900) then
SelectMsg(UID, 10, -1, -1, NPC);
end
--if (EVENT == 910) then
--	KingsInspectorList(UID);
---end

if (EVENT == 920) then
YEARCA = HowmuchItem(UID, 900580000);
	if (YEARCA == 0) then
		SelectMsg(UID,2,-1,11638,NPC,10,-1)
	else
SlotCheck = CheckGiveSlot(UID, 1)
    if SlotCheck == false then
       
    else	
		RobItem(UID,900580000,1);
		GiveItem(UID,900758945,1,7);
		end
	end
end

if (EVENT == 930) then
WIPCARD = HowmuchItem(UID, 000000);
	if (WIPCARD == 0) then
		SelectMsg(UID,2,-1,10510,NPC,10,-1)
	else
SlotCheck = CheckGiveSlot(UID, 1)
    if SlotCheck == false then
       
    else	
		RobItem(UID,000000,1);
		GiveItem(UID,000000,1);
		end
	end
end

if (EVENT == 940) then
	SelectMsg(UID,2,-1,10650,NPC,10,941)
end

if (EVENT == 941) then
	SelectMsg(UID,2,-1,10651,NPC,3014,942)
end

if (EVENT == 942) then
	SelectMsg(UID,2,-1,10652,NPC,7732,943,13,-1)
end

if (EVENT == 943) then
NOAH = HowmuchItem(UID, 900000000);
	if (NOAH > 9999 or NOAH == 10000) then
		SelectMsg(UID,2,-1,10653,NPC,4170,944)
	else
		SelectMsg(UID,2,-1,10651,NPC,10,-1)
	end
end

if (EVENT == 944) then
	GoldLose(UID,10000);
	GiveItem(UID,810181843,1,1);
end

if (EVENT == 950) then
	SelectMsg(UID,2,-1,10841,NPC,10,-1)
end

if (EVENT == 960) then
	SelectMsg(UID,2,-1,10871,NPC,10,-1)
end

-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=1207 status=255 n_index=7349
if (EVENT == 200) then
	SaveEvent(UID, 7350);
end

-- [AUTO-GEN] quest=124 status=255 n_index=431
if (EVENT == 710) then
	SaveEvent(UID, 434);
end

-- [AUTO-GEN] quest=124 status=255 n_index=432
if (EVENT == 711) then
	SaveEvent(UID, 434);
end

-- [AUTO-GEN] quest=124 status=2 n_index=434
if (EVENT == 712) then
	QuestStatusCheck = GetQuestStatus(UID, 124)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 2);
		SaveEvent(UID, 433);
	end
end

-- SQL completed-state dialog exit; no reward or state mutation.
if EVENT == 101 then return end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
