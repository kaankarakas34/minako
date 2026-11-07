-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [3228]={},
  [3229]={{900318000,4},{900319000,1}},
  [3231]={{900338000,1}},
  [3232]={{900321000,4},{900322000,1}},
  [3239]={},
  [3243]={{370005000,20},{900000000,100000}},
}
local __KO_Completion = {
  [13712]={780,3228},
  [13724]={781,3229},
  [13748]={783,3231},
  [13760]={784,3232},
  [13834]={791,3239},
  [13882]={797,3243},
}
local __KO_Quests = {
  [3228]={780},
  [3229]={781},
  [3231]={783},
  [3232]={784},
  [3239]={791},
  [3243]={797},
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
local NPC= 29070;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then 
		EVENT = 101
	elseif (QuestNum > 1 and QuestNum < 100) then 
		NpcMsg(UID, 4174, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 101) then
	Ret = 1;
end

if (EVENT == 1001)then
	SelectMsg(UID, 2, 780, 23057, NPC, 10, 1002);
end

if (EVENT == 1002)then
	SelectMsg(UID, 2, 780, 23058, NPC, 3000, 1003,3005,-1);
	SaveEvent(UID, 13711);
end

if (EVENT == 1003)then
	SelectMsg(UID, 4, 780, 22986, NPC, 3000, 1004,3005,-1);
	SaveEvent(UID, 13713);
end

if (EVENT == 1004)then
	SelectMsg(UID, 2, 780, 23075, NPC, 3000,1005,4005,-1);
	SaveEvent(UID, 13712);
	SaveEvent(UID, 13723);
end

if (EVENT == 1005)then
	SelectMsg(UID, 2, 780, 23075, NPC, 3000,1006,4005,-1);
	SaveEvent(UID, 13712);
	SaveEvent(UID, 13723);
end

if (EVENT == 1007)then
	SelectMsg(UID, 2, 780, 23075, NPC, 3000,1006,4005,-1);
end

if (EVENT == 1006)then
ZoneChange(UID, 81, 203, 197)
end

if (EVENT == 1101)then
	SelectMsg(UID, 4, 781, 22988, NPC, 3000,1102,4005,-1);
end

if (EVENT == 1102)then
	SaveEvent(UID, 13723);
end

if (EVENT == 1106)then
	SaveEvent(UID, 13725);
end

if (EVENT == 1105)then
	QuestStatus = SearchQuest(UID, 781)	
	if(QuestStatus == 1) then
	SelectMsg(UID, 2, 780, 23075, NPC, 3000,1006,4005,-1);
	else
	ITEM1_COUNT = HowmuchItem(UID, 900318000);  
    ITEM2_COUNT = HowmuchItem(UID, 900319000); 	
	if (ITEM1_COUNT < 4 and ITEM2_COUNT < 1) then
	SelectMsg(UID, 2, 780, 23075, NPC, 3000,1006,4005,-1);
	else
	SelectMsg(UID, 4, 781, 22988, NPC, 22, 1107, 27, -1);
end
end
end

if (EVENT == 1107)then
RunExchange(UID,3229)
	SaveEvent(UID,13724)
	SaveEvent(UID,13735)
	end
	
if (EVENT == 1201)then
	SelectMsg(UID, 4, 783, 22992, NPC, 3000,1202,4005,-1);
end

if (EVENT == 1202)then
	SaveEvent(UID, 13747);
end

if (EVENT == 1206)then
	SaveEvent(UID, 13749);
end

if(EVENT == 1205) then
	ITEMA = HowmuchItem(UID, 900338000)	
	if(ITEMA < 1) then
		SelectMsg(UID, 2, 783, 22990, NPC, 18, -1);
	else
		SelectMsg(UID, 4, 783, 22990, NPC, 22, 1207,23,-1);
	end
end

if (EVENT == 1207)then
SelectMsg(UID, 2, 784, 23113, NPC, 10,1307,4005,-1);
RunExchange(UID,3231)
	SaveEvent(UID,13748)
	SaveEvent(UID,13759)
	end
	
if (EVENT == 1301)then
	SelectMsg(UID, 4, 784, 22994, NPC, 3000,1302,4005,-1);
end

if (EVENT == 1302)then
	SaveEvent(UID, 13759);
end

if (EVENT == 1306)then
	SaveEvent(UID, 13761);
end

if (EVENT == 1305)then
	QuestStatus = SearchQuest(UID, 784)	
	if(QuestStatus == 1) then
	SelectMsg(UID, 2, 784, 23113, NPC, 10,1307,4005,-1);
	else
	ITEM1_COUNT = HowmuchItem(UID, 900321000);  
    ITEM2_COUNT = HowmuchItem(UID, 900322000); 	
	if (ITEM1_COUNT < 4 and ITEM2_COUNT < 1) then
	SelectMsg(UID, 2, 784, 23113, NPC, 10,1307,4005,-1);
	else
	SelectMsg(UID, 4, 784, 22988, NPC, 22, 1308, 27, -1);
end
end
end

if (EVENT == 1307)then
ZoneChange(UID, 81, 203, 197)
end

if (EVENT == 1308)then
RunExchange(UID,3232)
	SaveEvent(UID,13760)
	SaveEvent(UID,13771)
	end
	
	
	
if (EVENT == 1401)then
	SelectMsg(UID, 2, 791, 23057, NPC, 22, 1402);
end

if (EVENT == 1402)then
	SelectMsg(UID, 2, 791, 23058, NPC, 3000, 1403,3005,-1);
	SaveEvent(UID, 13833);
end

if (EVENT == 1403)then
	SelectMsg(UID, 4, 791, 22986, NPC, 3000, 1404,3005,-1);
	SaveEvent(UID, 13835);
end

if (EVENT == 1404)then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SelectMsg(UID, 2, 791, 23185, NPC, 10,-1);
	SaveEvent(UID, 13834);
	SaveEvent(UID, 13845);
	RunExchange(UID,3239)
end
end

if (EVENT == 1501) then
	SelectMsg(UID, 4, 797, 23014, NPC, 22, 1502, 27, -1);
end

if (EVENT == 1502) then
	SaveEvent(UID, 13881);
end

if (EVENT == 1506) then
	SaveEvent(UID, 13883);
end

	if(EVENT == 1505) then
	ITEMA = HowmuchItem(UID, 370005000)	
	ITEMB = HowmuchItem(UID, 900000000)	
	if(ITEMA < 20 and ITEMA < 100000) then
		SelectMsg(UID, 2, 797, 23014, NPC, 18,1507);
	else
		SelectMsg(UID, 4, 797, 23014, NPC, 22, 1508,23,-1);
	end
end

if (EVENT == 1507 ) then
	ShowMap(UID, 414)
end

if (EVENT == 1508)then
	SelectMsg(UID, 2, 797, 23243, NPC, 10,-1);
	SaveEvent(UID, 13882);
	SaveEvent(UID, 13893);
	RunExchange(UID,3243)
	GiveItem(UID, 900337525)
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
