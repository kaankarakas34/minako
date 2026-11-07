-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [53]={{910181000,1}},
  [88]={{910041000,1},{910040000,3}},
  [94]={{910138000,3},{910135000,1}},
  [95]={{910138000,3},{910135000,1}},
  [96]={{910138000,3},{910135000,1}},
  [97]={{910138000,3},{910135000,1}},
  [222]={{900143000,1}},
  [470]={{910057000,1}},
  [3046]={{910198000,1}},
  [3053]={{910231000,1}},
  [3055]={{910233000,1}},
  [3056]={{910199000,1}},
  [3064]={{910235000,1}},
  [3065]={{910200000,1}},
  [3070]={},
  [3076]={},
  [3077]={{910205000,1}},
  [3083]={{910237000,1}},
  [3086]={},
  [3087]={{910206000,1}},
  [3096]={{910241000,1}},
  [3097]={{910207000,1}},
  [3103]={},
  [3106]={{910244000,1}},
  [3107]={{910208000,1}},
}
local __KO_Completion = {
  [469]={177,88},
  [2454]={494,222},
  [4207]={220,470},
  [6041]={199,94},
  [6047]={199,95},
  [6053]={199,96},
  [6059]={199,97},
  [11543]={556,3046},
  [11627]={563,3053},
  [11651]={565,3055},
  [11663]={566,3056},
  [11758]={574,3064},
  [11770]={575,3065},
  [11831]={580,3070},
  [11903]={586,3076},
  [11915]={587,3077},
  [11987]={594,3083},
  [12023]={597,3086},
  [12035]={598,3087},
  [12143]={607,3096},
  [12155]={608,3097},
  [12227]={614,3103},
  [12263]={617,3106},
  [12275]={618,3107},
}
local __KO_Quests = {
  [88]={177},
  [94]={199},
  [95]={199},
  [96]={199},
  [97]={199},
  [222]={494},
  [470]={220},
  [3046]={556},
  [3053]={563},
  [3055]={565},
  [3056]={566},
  [3064]={574},
  [3065]={575},
  [3070]={580},
  [3076]={586},
  [3077]={587},
  [3083]={594},
  [3086]={597},
  [3087]={598},
  [3096]={607},
  [3097]={608},
  [3103]={614},
  [3106]={617},
  [3107]={618},
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
if EVENT == 400 or EVENT == 410 or EVENT == 411 or EVENT == 412 or EVENT == 1102 or EVENT == 1104 or EVENT == 1105 or EVENT == 1202 or EVENT == 1205 or EVENT == 1208 or EVENT == 1302 or EVENT == 1305 or EVENT == 1308 or EVENT == 1402 or EVENT == 1403 or EVENT == 1405 or EVENT == 1502 or EVENT == 1503 or EVENT == 1505 or EVENT == 1602 or EVENT == 1605 or EVENT == 1608 or EVENT == 1702 or EVENT == 1705 or EVENT == 1708 or EVENT == 1802 or EVENT == 1805 or EVENT == 1808 or EVENT == 1902 or EVENT == 1905 or EVENT == 1908 or EVENT == 2002 or EVENT == 2005 or EVENT == 2008 or EVENT == 2102 or EVENT == 2105 or EVENT == 2108 then
  SelectMsg(UID, 2, -1, 10526, 21510, 10, -1)
  return
end
local Ret = 0;
local NPC = 21510;

if (EVENT == 190) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 664, NPC, 10, 193);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 664, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 193) then
	Ret = 1;
end

if (EVENT == 195) then -- 44 Level Recons
	SaveEvent(UID, 467);
end

if (EVENT == 200) then
	SelectMsg(UID, 2, 8, 1173, NPC, 10, 201);
end

if (EVENT == 201) then
	SelectMsg(UID, 4, 8, 1174, NPC, 22, 202, 23, 193);
end

if (EVENT == 202) then
	Check = isRoomForItem(UID, 910044000);
	if (Check == -1) then
		SelectMsg(UID, 2, -1, 832, NPC, 27, 193);
	else
		GiveItem(UID, 910044000, 1)
		SaveEvent(UID, 468);
	end
end

if (EVENT == 205) then
	SelectMsg(UID, 2, 8, 1175, NPC, 10, 193);
	SaveEvent(UID, 470);
end

if (EVENT == 210) then
	ITEMA = HowmuchItem(UID, 910040000);
	ITEMB = HowmuchItem(UID, 910041000);
	if (ITEMA < 3) then 
		SelectMsg(UID, 2, 8, 1177, NPC, 18, 213);
	elseif (ITEMB < 1) then
		SelectMsg(UID, 2, 8, 1178, NPC, 18, 213);
	elseif (ITEMA > 2 and ITEMB > 0) then
		SelectMsg(UID, 4, 8, 1179, NPC, 41, 214, 27, 193);
	end
end

if (EVENT == 213) then
	ShowMap(UID, 46);
end

if (EVENT == 214) then
	RobItem(UID, 910040000, 3)
	RobItem(UID, 910041000, 1)
	ExpChange(UID, 1000000)
	GoldGain(UID, 100000)
	SaveEvent(UID, 469);
end

local savenum = 603;

if (EVENT == 6092) then -- 46 Level Quest Area
	SelectMsg(UID, 2, savenum, 6065, NPC, 6007, 6093, 4005, 193);
end

if (EVENT == 6093) then
	ITEM_COUNT = HowmuchItem(UID, 910135000);   
	ITEM_COUNT1 = HowmuchItem(UID, 910138000);
	if (ITEM_COUNT < 1 or ITEM_COUNT1 < 3) then
		SelectMsg(UID, 4, savenum, 6067, NPC, 4543, 6095, 4191, 193);
	elseif (ITEM_COUNT > 0 and ITEM_COUNT1 > 2) then
		SelectMsg(UID, 4, savenum, 6070, NPC, 4006, 7004, 4005, 193);
	end
end

if (EVENT == 6095) then
	PartyCheck = isInParty(UID);
	if (PartyCheck) then
		ZoneChangeParty(UID, 81, 202, 199);
		EVENT = 6096
	else
		SelectMsg(UID, 2, savenum, 6068, NPC, 10, 193);
	end
end

if (EVENT == 6096) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 6040);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 6046);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 6052);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 6058);
	end
end

if (EVENT == 6094) then
	ITEM_COUNT = HowmuchItem(UID, 910135000);   
	ITEM_COUNT1 = HowmuchItem(UID, 910138000);
	if (ITEM_COUNT < 1 or ITEM_COUNT1 < 3) then
		SelectMsg(UID, 4, savenum, 6043, NPC, 4543, 6095, 4191, 193);
	elseif (ITEM_COUNT > 0 and ITEM_COUNT1 > 2) then
		SelectMsg(UID, 4, savenum, 6043, NPC, 4006, 7004, 4005, 193);
	end
end

if (EVENT == 7000) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 6042);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 6048);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 6054);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 6060);
	end
end

if (EVENT == 7004) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		EVENT = 7005
	elseif (Class == 2 or Class == 7 or Class == 8) then
		EVENT = 7006
	elseif (Class == 3 or Class == 9 or Class == 10) then
		EVENT = 7007
	elseif (Class == 4 or Class == 11 or Class == 12) then
		EVENT = 7008
	end
end

if (EVENT == 7005) then
	GoldGain(UID, 100000)
	ExpChange(UID, 1000000)
	RobItem(UID, 910135000, 1)
	RobItem(UID , 910138000, 3)
	GiveItem(UID, 972190733, 1)
	GiveItem(UID, 972230788, 1)
	GiveItem(UID, 972260823, 1)
	GiveItem(UID, 972270431, 1)
	SaveEvent(UID, 6041);
end 

if (EVENT == 7006) then
	GoldGain(UID, 100000)
	ExpChange(UID, 1000000)
	RobItem(UID, 910135000, 1)
	RobItem(UID , 910138000, 3)
	GiveItem(UID, 972200491, 1)
	GiveItem(UID, 972200491, 1)
	GiveItem(UID, 972240919, 1)
	SaveEvent(UID, 6047); 
end

if (EVENT == 7007) then
	GoldGain(UID, 100000)
	ExpChange(UID, 1000000)
	RobItem(UID, 910135000, 1)
	RobItem(UID , 910138000, 3)
	GiveItem(UID, 972210359, 1)
	GiveItem(UID, 972210367, 1)
	GiveItem(UID, 972210375, 1)
	SaveEvent(UID, 6053);
end

if (EVENT == 7008) then
	GoldGain(UID, 100000)
	ExpChange(UID, 1000000)
	RobItem(UID, 910135000, 1)
	RobItem(UID, 910138000, 3)
	GiveItem(UID, 972220761, 1)
	GiveItem(UID, 972250765, 1)
	SaveEvent(UID, 6059); 
end

if (EVENT == 532) then -- 50 Level 7 Keys Quest
	SelectMsg(UID, 4, 9, 4196, NPC, 22, 533, 23, 534);
end

if (EVENT == 533) then
	Check = isRoomForItem(UID, 910050000);
	if (Check == -1) then
		SelectMsg(UID, 2, -1, 832, NPC, 27, 193);
	else
		GiveItem(UID, 910050000, 1)
		SaveEvent(UID, 4206);
	end
end

if (EVENT == 534) then
	SaveEvent(UID, 4209);
end

if (EVENT == 538) then
	SaveEvent(UID, 4208);
end

if (EVENT == 536) then
	ITEM7 = HowmuchItem(UID, 910057000);
	if (ITEM7 > 0) then
		SelectMsg(UID, 4, 9, 4197, NPC, 4172, 537, 4173, 193);
	else
		SelectMsg(UID, 2, 9, 4198, NPC, 18, 192);
	end
end

if (EVENT == 192) then
	ShowMap(UID, 432);
end

if (EVENT == 537) then
	RobItem(UID, 910057000, 1)
	ExpChange(UID, 15218948)
	SaveEvent(UID, 4207);
end

if (EVENT == 1000) then -- 47 Level Border Security Scroll
	SaveEvent(UID, 2452);
end

if (EVENT == 1001) then
	SelectMsg(UID, 4, 202, 9238, NPC, 22, 1002, 23, 1003);
end

if (EVENT == 1002) then
	SaveEvent(UID, 2453);
end   

if (EVENT == 1003) then
	SaveEvent(UID, 2456);
end

if (EVENT == 1006) then
	SaveEvent(UID, 2455);
end

if (EVENT == 1007) then
	ITEMBDW = HowmuchItem(UID, 900143000);
	if (ITEMBDW < 1) then
		SelectMsg(UID, 2, 202, 9238, NPC, 18, 191);
	else
		SelectMsg(UID, 4, 202, 9238, NPC, 4006, 1008, 4005, 193);
	end
end

if (EVENT == 191) then
	ShowMap(UID, 726);
end

if (EVENT == 1008) then
	RobItem(UID, 900143000, 1)
	ExpChange(UID, 1000000)
	SaveEvent(UID, 2454);
end

-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=199 status=255 n_index=6038
if (EVENT == 6090) then
	SaveEvent(UID, 6039);
end

-- [AUTO-GEN] quest=438 status=2 n_index=7107
if (EVENT == 240) then
	QuestStatusCheck = GetQuestStatus(UID, 438)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 53);
		SaveEvent(UID, 7109);
	end
end

-- [AUTO-GEN] quest=439 status=255 n_index=7115
if (EVENT == 405) then
	SaveEvent(UID, 7116);
end

-- [AUTO-GEN] quest=220 status=255 n_index=4204
if (EVENT == 530) then
	SaveEvent(UID, 4205);
end

-- [AUTO-GEN] quest=522 status=255 n_index=11102
if (EVENT == 1100) then
	SaveEvent(UID, 11103);
end

-- [AUTO-GEN] quest=525 status=255 n_index=11138
if (EVENT == 1200) then
	SaveEvent(UID, 11139);
end

-- [AUTO-GEN] quest=526 status=255 n_index=11150
if (EVENT == 1300) then
	SaveEvent(UID, 11151);
end

-- [AUTO-GEN] quest=527 status=255 n_index=11162
if (EVENT == 1400) then
	SaveEvent(UID, 11163);
end

-- [AUTO-GEN] quest=535 status=255 n_index=11258
if (EVENT == 1500) then
	SaveEvent(UID, 11259);
end

-- [AUTO-GEN] quest=536 status=255 n_index=11270
if (EVENT == 1600) then
	SaveEvent(UID, 11271);
end

-- [AUTO-GEN] quest=542 status=255 n_index=11342
if (EVENT == 1700) then
	SaveEvent(UID, 11343);
end

-- [AUTO-GEN] quest=543 status=255 n_index=11354
if (EVENT == 1800) then
	SaveEvent(UID, 11355);
end

-- [AUTO-GEN] quest=544 status=255 n_index=11366
if (EVENT == 1900) then
	SaveEvent(UID, 11367);
end

-- [AUTO-GEN] quest=545 status=255 n_index=11378
if (EVENT == 2000) then
	SaveEvent(UID, 11379);
end

-- [AUTO-GEN] quest=555 status=255 n_index=11528
if (EVENT == 2100) then
	SaveEvent(UID, 11529);
end

-- [AUTO-GEN] quest=556 status=255 n_index=11540
if (EVENT == 2200) then
	SaveEvent(UID, 11541);
end

-- [AUTO-GEN] quest=556 status=0 n_index=11541
if (EVENT == 2202) then
	SelectMsg(UID, 4, 556, 20080, NPC, 3080, 2203, 23, -1);
end

-- [AUTO-GEN] quest=556 status=0 n_index=11541
if (EVENT == 2203) then
	SaveEvent(UID, 11542);
end

-- [AUTO-GEN] quest=556 status=1 n_index=11542
if (EVENT == 2205) then
	ItemA = HowmuchItem(UID, 910198000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 556, 20080, NPC, 18, 2206);
	else
		SelectMsg(UID, 4, 556, 20080, NPC, 41, 2208, 27, -1);
	end
end

-- [AUTO-GEN] quest=556 status=1 n_index=11542
if (EVENT == 2206) then
	ShowMap(UID, 11542);
end

-- [AUTO-GEN] quest=556 status=1 n_index=11542
if (EVENT == 2208) then
	QuestStatusCheck = GetQuestStatus(UID, 556)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3046);
		SaveEvent(UID, 11543);
	end
end

-- [AUTO-GEN] quest=563 status=255 n_index=11624
if (EVENT == 2300) then
	SaveEvent(UID, 11625);
end

-- [AUTO-GEN] quest=563 status=0 n_index=11625
if (EVENT == 2302) then
	SelectMsg(UID, 4, 563, 20094, NPC, 3094, 2303, 23, -1);
end

-- [AUTO-GEN] quest=563 status=0 n_index=11625
if (EVENT == 2303) then
	SaveEvent(UID, 11626);
end

-- [AUTO-GEN] quest=563 status=1 n_index=11626
if (EVENT == 2305) then
	ItemA = HowmuchItem(UID, 910231000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 563, 20094, NPC, 18, 2306);
	else
		SelectMsg(UID, 4, 563, 20094, NPC, 41, 2308, 27, -1);
	end
end

-- [AUTO-GEN] quest=563 status=1 n_index=11626
if (EVENT == 2306) then
	ShowMap(UID, 11626);
end

-- [AUTO-GEN] quest=563 status=1 n_index=11626
if (EVENT == 2308) then
	QuestStatusCheck = GetQuestStatus(UID, 563)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3053);
		SaveEvent(UID, 11627);
	end
end

-- [AUTO-GEN] quest=565 status=255 n_index=11648
if (EVENT == 2400) then
	SaveEvent(UID, 11649);
end

-- [AUTO-GEN] quest=565 status=0 n_index=11649
if (EVENT == 2402) then
	SelectMsg(UID, 4, 565, 20098, NPC, 3098, 2403, 23, -1);
end

-- [AUTO-GEN] quest=565 status=0 n_index=11649
if (EVENT == 2403) then
	SaveEvent(UID, 11650);
end

-- [AUTO-GEN] quest=565 status=1 n_index=11650
if (EVENT == 2405) then
	ItemA = HowmuchItem(UID, 910233000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 565, 20098, NPC, 18, 2406);
	else
		SelectMsg(UID, 4, 565, 20098, NPC, 41, 2408, 27, -1);
	end
end

-- [AUTO-GEN] quest=565 status=1 n_index=11650
if (EVENT == 2406) then
	ShowMap(UID, 11650);
end

-- [AUTO-GEN] quest=565 status=1 n_index=11650
if (EVENT == 2408) then
	QuestStatusCheck = GetQuestStatus(UID, 565)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3055);
		SaveEvent(UID, 11651);
	end
end

-- [AUTO-GEN] quest=566 status=255 n_index=11660
if (EVENT == 2500) then
	SaveEvent(UID, 11661);
end

-- [AUTO-GEN] quest=566 status=0 n_index=11661
if (EVENT == 2502) then
	SelectMsg(UID, 4, 566, 20100, NPC, 3100, 2503, 23, -1);
end

-- [AUTO-GEN] quest=566 status=0 n_index=11661
if (EVENT == 2503) then
	SaveEvent(UID, 11662);
end

-- [AUTO-GEN] quest=566 status=1 n_index=11662
if (EVENT == 2505) then
	ItemA = HowmuchItem(UID, 910199000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 566, 20100, NPC, 18, 2506);
	else
		SelectMsg(UID, 4, 566, 20100, NPC, 41, 2508, 27, -1);
	end
end

-- [AUTO-GEN] quest=566 status=1 n_index=11662
if (EVENT == 2506) then
	ShowMap(UID, 11662);
end

-- [AUTO-GEN] quest=566 status=1 n_index=11662
if (EVENT == 2508) then
	QuestStatusCheck = GetQuestStatus(UID, 566)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3056);
		SaveEvent(UID, 11663);
	end
end

-- [AUTO-GEN] quest=574 status=255 n_index=11755
if (EVENT == 2600) then
	SaveEvent(UID, 11756);
end

-- [AUTO-GEN] quest=574 status=0 n_index=11756
if (EVENT == 2602) then
	SelectMsg(UID, 4, 574, 20116, NPC, 3116, 2603, 23, -1);
end

-- [AUTO-GEN] quest=574 status=0 n_index=11756
if (EVENT == 2603) then
	SaveEvent(UID, 11757);
end

-- [AUTO-GEN] quest=574 status=1 n_index=11757
if (EVENT == 2605) then
	ItemA = HowmuchItem(UID, 910235000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 574, 20116, NPC, 18, 2606);
	else
		SelectMsg(UID, 4, 574, 20116, NPC, 41, 2608, 27, -1);
	end
end

-- [AUTO-GEN] quest=574 status=1 n_index=11757
if (EVENT == 2606) then
	ShowMap(UID, 11757);
end

-- [AUTO-GEN] quest=574 status=1 n_index=11757
if (EVENT == 2608) then
	QuestStatusCheck = GetQuestStatus(UID, 574)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3064);
		SaveEvent(UID, 11758);
	end
end

-- [AUTO-GEN] quest=575 status=255 n_index=11767
if (EVENT == 2700) then
	SaveEvent(UID, 11768);
end

-- [AUTO-GEN] quest=575 status=0 n_index=11768
if (EVENT == 2702) then
	SelectMsg(UID, 4, 575, 20118, NPC, 3118, 2703, 23, -1);
end

-- [AUTO-GEN] quest=575 status=0 n_index=11768
if (EVENT == 2703) then
	SaveEvent(UID, 11769);
end

-- [AUTO-GEN] quest=575 status=1 n_index=11769
if (EVENT == 2705) then
	ItemA = HowmuchItem(UID, 910200000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 575, 20118, NPC, 18, 2706);
	else
		SelectMsg(UID, 4, 575, 20118, NPC, 41, 2708, 27, -1);
	end
end

-- [AUTO-GEN] quest=575 status=1 n_index=11769
if (EVENT == 2706) then
	ShowMap(UID, 11769);
end

-- [AUTO-GEN] quest=575 status=1 n_index=11769
if (EVENT == 2708) then
	QuestStatusCheck = GetQuestStatus(UID, 575)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3065);
		SaveEvent(UID, 11770);
	end
end

-- [AUTO-GEN] quest=580 status=255 n_index=11828
if (EVENT == 2800) then
	SaveEvent(UID, 11829);
end

-- [AUTO-GEN] quest=580 status=0 n_index=11829
if (EVENT == 2802) then
	SelectMsg(UID, 4, 580, 20730, NPC, 3128, 2803, 23, -1);
end

-- [AUTO-GEN] quest=580 status=1 n_index=11830
if (EVENT == 2803) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 580, 20730, NPC, 18, 2805);
	else
		SelectMsg(UID, 4, 580, 20730, NPC, 41, 2804, 27, -1);
	end
end

-- [AUTO-GEN] quest=580 status=1 n_index=11830
if (EVENT == 2804) then
	QuestStatusCheck = GetQuestStatus(UID, 580)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3070);
		SaveEvent(UID, 11831);
	end
end

-- [AUTO-GEN] quest=580 status=3 n_index=11832
if (EVENT == 2805) then
	SelectMsg(UID, 2, 580, 20730, NPC, 10, -1);
end

-- [AUTO-GEN] quest=586 status=255 n_index=11900
if (EVENT == 2900) then
	SaveEvent(UID, 11901);
end

-- [AUTO-GEN] quest=586 status=0 n_index=11901
if (EVENT == 2902) then
	SelectMsg(UID, 4, 586, 20742, NPC, 3140, 2903, 23, -1);
end

-- [AUTO-GEN] quest=586 status=1 n_index=11902
if (EVENT == 2903) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 586, 20742, NPC, 18, 2905);
	else
		SelectMsg(UID, 4, 586, 20742, NPC, 41, 2904, 27, -1);
	end
end

-- [AUTO-GEN] quest=586 status=1 n_index=11902
if (EVENT == 2904) then
	QuestStatusCheck = GetQuestStatus(UID, 586)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3076);
		SaveEvent(UID, 11903);
	end
end

-- [AUTO-GEN] quest=586 status=3 n_index=11904
if (EVENT == 2905) then
	SelectMsg(UID, 2, 586, 20742, NPC, 10, -1);
end

-- [AUTO-GEN] quest=587 status=255 n_index=11912
if (EVENT == 3000) then
	SaveEvent(UID, 11913);
end

-- [AUTO-GEN] quest=587 status=0 n_index=11913
if (EVENT == 3002) then
	SelectMsg(UID, 4, 587, 20744, NPC, 3142, 3003, 23, -1);
end

-- [AUTO-GEN] quest=587 status=0 n_index=11913
if (EVENT == 3003) then
	SaveEvent(UID, 11914);
end

-- [AUTO-GEN] quest=587 status=1 n_index=11914
if (EVENT == 3005) then
	ItemA = HowmuchItem(UID, 910205000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 587, 20744, NPC, 18, 3006);
	else
		SelectMsg(UID, 4, 587, 20744, NPC, 41, 3008, 27, -1);
	end
end

-- [AUTO-GEN] quest=587 status=1 n_index=11914
if (EVENT == 3006) then
	ShowMap(UID, 11914);
end

-- [AUTO-GEN] quest=587 status=1 n_index=11914
if (EVENT == 3008) then
	QuestStatusCheck = GetQuestStatus(UID, 587)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3077);
		SaveEvent(UID, 11915);
	end
end

-- [AUTO-GEN] quest=594 status=255 n_index=11984
if (EVENT == 3100) then
	SaveEvent(UID, 11985);
end

-- [AUTO-GEN] quest=594 status=0 n_index=11985
if (EVENT == 3102) then
	SelectMsg(UID, 4, 594, 20756, NPC, 3154, 3103, 23, -1);
end

-- [AUTO-GEN] quest=594 status=0 n_index=11985
if (EVENT == 3103) then
	SaveEvent(UID, 11986);
end

-- [AUTO-GEN] quest=594 status=1 n_index=11986
if (EVENT == 3105) then
	ItemA = HowmuchItem(UID, 910237000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 594, 20756, NPC, 18, 3106);
	else
		SelectMsg(UID, 4, 594, 20756, NPC, 41, 3106, 27, -1);
	end
end

-- [AUTO-GEN] quest=594 status=1 n_index=11986
if (EVENT == 3106) then
	QuestStatusCheck = GetQuestStatus(UID, 594)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3083);
		SaveEvent(UID, 11987);
	end
end

-- [AUTO-GEN] quest=597 status=255 n_index=12020
if (EVENT == 3200) then
	SaveEvent(UID, 12021);
end

-- [AUTO-GEN] quest=597 status=0 n_index=12021
if (EVENT == 3202) then
	SelectMsg(UID, 4, 597, 20762, NPC, 3160, 3203, 23, -1);
end

-- [AUTO-GEN] quest=597 status=1 n_index=12022
if (EVENT == 3203) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 597, 20762, NPC, 18, 3205);
	else
		SelectMsg(UID, 4, 597, 20762, NPC, 41, 3204, 27, -1);
	end
end

-- [AUTO-GEN] quest=597 status=1 n_index=12022
if (EVENT == 3204) then
	QuestStatusCheck = GetQuestStatus(UID, 597)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3086);
		SaveEvent(UID, 12023);
	end
end

-- [AUTO-GEN] quest=597 status=3 n_index=12024
if (EVENT == 3205) then
	SelectMsg(UID, 2, 597, 20762, NPC, 10, -1);
end

-- [AUTO-GEN] quest=598 status=255 n_index=12032
if (EVENT == 3300) then
	SaveEvent(UID, 12033);
end

-- [AUTO-GEN] quest=598 status=0 n_index=12033
if (EVENT == 3302) then
	SelectMsg(UID, 4, 598, 20764, NPC, 3162, 3303, 23, -1);
end

-- [AUTO-GEN] quest=598 status=0 n_index=12033
if (EVENT == 3303) then
	SaveEvent(UID, 12034);
end

-- [AUTO-GEN] quest=598 status=1 n_index=12034
if (EVENT == 3305) then
	ItemA = HowmuchItem(UID, 910206000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 598, 20764, NPC, 18, 3306);
	else
		SelectMsg(UID, 4, 598, 20764, NPC, 41, 3308, 27, -1);
	end
end

-- [AUTO-GEN] quest=598 status=1 n_index=12034
if (EVENT == 3306) then
	ShowMap(UID, 12034);
end

-- [AUTO-GEN] quest=598 status=1 n_index=12034
if (EVENT == 3308) then
	QuestStatusCheck = GetQuestStatus(UID, 598)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3087);
		SaveEvent(UID, 12035);
	end
end

-- [AUTO-GEN] quest=607 status=255 n_index=12140
if (EVENT == 3400) then
	SaveEvent(UID, 12141);
end

-- [AUTO-GEN] quest=607 status=0 n_index=12141
if (EVENT == 3402) then
	SelectMsg(UID, 4, 607, 20782, NPC, 3180, 3403, 23, -1);
end

-- [AUTO-GEN] quest=607 status=0 n_index=12141
if (EVENT == 3403) then
	SaveEvent(UID, 12142);
end

-- [AUTO-GEN] quest=607 status=1 n_index=12142
if (EVENT == 3405) then
	ItemA = HowmuchItem(UID, 910241000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 607, 20782, NPC, 18, 3406);
	else
		SelectMsg(UID, 4, 607, 20782, NPC, 41, 3406, 27, -1);
	end
end

-- [AUTO-GEN] quest=607 status=1 n_index=12142
if (EVENT == 3406) then
	QuestStatusCheck = GetQuestStatus(UID, 607)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3096);
		SaveEvent(UID, 12143);
	end
end

-- [AUTO-GEN] quest=608 status=255 n_index=12152
if (EVENT == 3500) then
	SaveEvent(UID, 12153);
end

-- [AUTO-GEN] quest=608 status=0 n_index=12153
if (EVENT == 3502) then
	SelectMsg(UID, 4, 608, 20784, NPC, 3182, 3503, 23, -1);
end

-- [AUTO-GEN] quest=608 status=0 n_index=12153
if (EVENT == 3503) then
	SaveEvent(UID, 12154);
end

-- [AUTO-GEN] quest=608 status=1 n_index=12154
if (EVENT == 3505) then
	ItemA = HowmuchItem(UID, 910207000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 608, 20784, NPC, 18, 3506);
	else
		SelectMsg(UID, 4, 608, 20784, NPC, 41, 3506, 27, -1);
	end
end

-- [AUTO-GEN] quest=608 status=1 n_index=12154
if (EVENT == 3506) then
	QuestStatusCheck = GetQuestStatus(UID, 608)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3097);
		SaveEvent(UID, 12155);
	end
end

-- [AUTO-GEN] quest=614 status=255 n_index=12224
if (EVENT == 3600) then
	SaveEvent(UID, 12225);
end

-- [AUTO-GEN] quest=614 status=0 n_index=12225
if (EVENT == 3602) then
	SelectMsg(UID, 4, 614, 20796, NPC, 3194, 3603, 23, -1);
end

-- [AUTO-GEN] quest=614 status=1 n_index=12226
if (EVENT == 3603) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 614, 20796, NPC, 18, 3605);
	else
		SelectMsg(UID, 4, 614, 20796, NPC, 41, 3604, 27, -1);
	end
end

-- [AUTO-GEN] quest=614 status=1 n_index=12226
if (EVENT == 3604) then
	QuestStatusCheck = GetQuestStatus(UID, 614)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3103);
		SaveEvent(UID, 12227);
	end
end

-- [AUTO-GEN] quest=614 status=3 n_index=12228
if (EVENT == 3605) then
	SelectMsg(UID, 2, 614, 20796, NPC, 10, -1);
end

-- [AUTO-GEN] quest=617 status=255 n_index=12260
if (EVENT == 3700) then
	SaveEvent(UID, 12261);
end

-- [AUTO-GEN] quest=617 status=0 n_index=12261
if (EVENT == 3702) then
	SelectMsg(UID, 4, 617, 20802, NPC, 3200, 3703, 23, -1);
end

-- [AUTO-GEN] quest=617 status=0 n_index=12261
if (EVENT == 3703) then
	SaveEvent(UID, 12262);
end

-- [AUTO-GEN] quest=617 status=1 n_index=12262
if (EVENT == 3705) then
	ItemA = HowmuchItem(UID, 910244000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 617, 20802, NPC, 18, 3706);
	else
		SelectMsg(UID, 4, 617, 20802, NPC, 41, 3706, 27, -1);
	end
end

-- [AUTO-GEN] quest=617 status=1 n_index=12262
if (EVENT == 3706) then
	QuestStatusCheck = GetQuestStatus(UID, 617)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3106);
		SaveEvent(UID, 12263);
	end
end

-- [AUTO-GEN] quest=618 status=255 n_index=12272
if (EVENT == 3800) then
	SaveEvent(UID, 12273);
end

-- [AUTO-GEN] quest=618 status=0 n_index=12273
if (EVENT == 3802) then
	SelectMsg(UID, 4, 618, 20804, NPC, 3202, 3803, 23, -1);
end

-- [AUTO-GEN] quest=618 status=0 n_index=12273
if (EVENT == 3803) then
	SaveEvent(UID, 12274);
end

-- [AUTO-GEN] quest=618 status=1 n_index=12274
if (EVENT == 3805) then
	ItemA = HowmuchItem(UID, 910208000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 618, 20804, NPC, 18, 3806);
	else
		SelectMsg(UID, 4, 618, 20804, NPC, 41, 3806, 27, -1);
	end
end

-- [AUTO-GEN] quest=618 status=1 n_index=12274
if (EVENT == 3806) then
	QuestStatusCheck = GetQuestStatus(UID, 618)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3107);
		SaveEvent(UID, 12275);
	end
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
