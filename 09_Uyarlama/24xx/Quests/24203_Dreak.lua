-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [34]={{910090000,3}},
  [331]={{379247000,1},{379248000,1},{900000000,7000000}},
  [463]={{810095000,1},{810091000,1},{810092000,1}},
  [525]={{379248000,1},{379236000,2},{900000000,10000000}},
  [526]={{379248000,1},{379236000,2},{900000000,10000000}},
  [527]={{379247000,1},{379236000,2},{900000000,10000000}},
  [3015]={{508104000,3}},
  [3092]={{910239000,1}},
  [3093]={{508111000,1}},
}
local __KO_Completion = {
  [137]={217,34},
  [3454]={336,331},
  [4107]={273,463},
  [5169]={348,525},
  [5181]={361,526},
  [5193]={367,527},
  [11177]={528,3015},
  [12095]={603,3092},
  [12107]={604,3093},
}
local __KO_Quests = {
  [34]={217},
  [331]={336},
  [463]={273},
  [525]={348},
  [526]={361},
  [527]={367},
  [3015]={528},
  [3092]={603},
  [3093]={604},
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

local function RunQuestExchange(uid, exchange, selected, allExp)
  if selected == nil then return RunExchange(uid, exchange) end
  if selected ~= STEP or selected < 0 or selected > 4 or allExp ~= 1 then return false end
  return RunSelectExchange(uid, exchange)
end
local NPC = 24203;

if (EVENT == 190) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 335, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 336,NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 200) then
	SelectMsg(UID, 2, 217, 1014, NPC, 10, 201);
end

if (EVENT == 201) then
	SelectMsg(UID, 4, 217, 1015, NPC, 22, 202, 23, -1);
end

if (EVENT == 202) then
	QuestStatusCheck = GetQuestStatus(UID, 217) 
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 344, NPC, 10, -1);
	else
		SaveEvent(UID, 136);
	end
end

if (EVENT == 205) then
	QuestStatusCheck = GetQuestStatus(UID, 217) 
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 344, NPC, 10, -1);
	else
		SaveEvent(UID, 138);
		SelectMsg(UID, 2, 217, 1016, NPC, 21, -1);
	end
end

if (EVENT == 210) then
	QuestStatusCheck = GetQuestStatus(UID, 217) 
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 344, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 910090000);
		if (ITEM_COUNT < 3) then
			SelectMsg(UID, 2, 217, 1017, NPC, 18, 213);
		else
			SelectMsg(UID, 4, 217, 1018, NPC, 41, 214, 27, -1);
		end
	end
end

if (EVENT == 213) then
	ShowMap(UID, 16);
end

if (EVENT == 214) then
	QuestStatusCheck = GetQuestStatus(UID, 217) 
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 344, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 910090000);
		if (ITEM_COUNT < 3) then
			SelectMsg(UID, 2, 217, 1017, NPC, 18, 213);
		else
			RunQuestExchange(UID,34);       
			SaveEvent(UID, 137);
		end
	end
end


if (EVENT == 336) then
	SelectMsg(UID, 2, 308, 375, NPC, 10, 337);
end

if (EVENT == 337) then
	SelectMsg(UID, 4, 308, 376, NPC, 22, 338, 23, -1);
end

if (EVENT == 338) then
	if CheckGiveSlot(UID, 1) then
		GiveItem(UID, 900017000, 7);
		SaveEvent(UID, 556);
	end
end

if (EVENT == 339) then
	SaveEvent(UID, 558);
	SelectMsg(UID, 2, 308, 378, NPC, 21, -1);
end

if (EVENT == 341) then
	ITEM_COUNT1 = HowmuchItem(UID, 379022000);
	ITEM_COUNT2 = HowmuchItem(UID, 379031000);
	ITEM_COUNT3 = HowmuchItem(UID, 379030000);
	ITEM_COUNT4 = HowmuchItem(UID, 900000000);
	if (ITEM_COUNT1 < 3 and ITEM_COUNT2 < 3 and ITEM_COUNT3 < 3 and ITEM_COUNT4 < 10000000) then
		SelectMsg(UID, 2, 308, 379, NPC, 18, 342);
	else
		SelectMsg(UID, 4, 308, 380, NPC, 41, 346, 27, -1);
	end
end

if (EVENT == 342) then
	ShowMap(UID, 726);
end

if (EVENT == 346) then
AGIRLIKKONTROL = CheckWeight(UID,379243000,1)
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
	 elseif AGIRLIKKONTROL == false then	
     else
			RunQuestExchange(UID,38);
			SaveEvent(UID, 559);
end
end

if (EVENT == 551) then
	SelectMsg(UID, 4, 273, 4108, NPC, 22, 552, 23, -1);
end

if (EVENT == 552) then
	SaveEvent(UID, 4106);
end

if (EVENT == 535) then
	SelectMsg(UID, 2, 273, 4110, NPC, 10, -1);
	SaveEvent(UID, 4108);
end

if (EVENT == 536) then
	ITEM01 = HowmuchItem(UID, 330310014); --- Kekuri Ring
	ITEM02 = HowmuchItem(UID, 379046000); --- Harpy Tüyü
	ITEM03 = HowmuchItem(UID, 379044000); --- Zombie Eye 50x
	ITEM04 = HowmuchItem(UID, 379236000); --- Magic Jewel Powder 2x
	if (ITEM01 > 0 and ITEM02 > 0 and ITEM03 > 49 and ITEM04 > 1) then
		SelectMsg(UID, 4, 273, 4111, NPC, 4006, 537, 4005, -1);
	else
		if (ITEM01 < 1) then
			SelectMsg(UID, 2, 273, 4109, NPC, 18, 538);
		elseif (ITEM02 < 1) then
			SelectMsg(UID, 2, 273, 4109, NPC, 18, 539);
		elseif (ITEM03 < 50) then
			SelectMsg(UID, 2, 273, 4109, NPC, 18, 540);
		elseif (ITEM04 < 2) then
			SelectMsg(UID, 2, 273, 4109, NPC, 18, 540);
		end
	end
end

if (EVENT == 538) then
	ShowMap(UID, 681);
end

if (EVENT == 539) then
	ShowMap(UID, 714);
end

if (EVENT == 540) then
	ShowMap(UID, 712);
end

if (EVENT == 537) then
AGIRLIKKONTROL = CheckWeight(UID,379243000,1)
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
	 elseif AGIRLIKKONTROL == false then	
     else
			RunQuestExchange(UID,463);
			PromoteUser(UID);
			SaveEvent(UID, 4107);
end
end

if (EVENT == 349) then
	SelectMsg(UID, 2, 323, 386, NPC, 10, 350);
end

if (EVENT == 350) then
	SelectMsg(UID, 4, 323, 387, NPC, 22, 351, 23, -1);
end

if (EVENT == 351) then
	SaveEvent(UID, 562);
end

if (EVENT == 352) then
	SaveEvent(UID, 564);
	SelectMsg(UID, 2, 323, 389, NPC, 21, -1);
end

if (EVENT == 354) then
	ITEM_COUNT1 = HowmuchItem(UID, 379098000);
	ITEM_COUNT2 = HowmuchItem(UID, 379203000);
	ITEM_COUNT3 = HowmuchItem(UID, 379040000);
	if (ITEM_COUNT1 < 20) then
		SelectMsg(UID, 2, 323, 390, NPC, 18, 355);
	elseif (ITEM_COUNT2 < 50) then
		SelectMsg(UID, 2, 323, 390, NPC, 18, 356);
	elseif (ITEM_COUNT3 < 1) then
		SelectMsg(UID, 2, 323, 390, NPC, 18, 357);
	elseif (ITEM_COUNT1 > 19 and ITEM_COUNT2 > 49 and ITEM_COUNT3 > 0) then
		SelectMsg(UID, 4, 323, 393, NPC, 41, 358, 27, -1);
	end
end

if (EVENT == 355) then
	ShowMap(UID, 24);
end

if (EVENT == 356) then
	ShowMap(UID, 317);
end

if (EVENT == 357) then
	ShowMap(UID, 19);
end

if (EVENT == 358) then
AGIRLIKKONTROL = CheckWeight(UID,379243000,1)
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
	 elseif AGIRLIKKONTROL == false then	
     else
			RunQuestExchange(UID,39);
			SaveEvent(UID, 565);
end
end

if (EVENT == 361) then
	SelectMsg(UID, 2, 325, 501, NPC, 10, 362);
end

if (EVENT == 362) then
	SelectMsg(UID, 4, 325, 502, NPC, 22, 363, 23, -1);
end

if (EVENT == 363) then
	SaveEvent(UID, 568);
end

if (EVENT == 364) then
	SaveEvent(UID, 570);
	SelectMsg(UID, 2, 325, 503, NPC, 32, -1);
end

if (EVENT == 366) then
	ITEM_COUNT1 = HowmuchItem(UID, 379011000);
	ITEM_COUNT2 = HowmuchItem(UID, 389074000);
	ITEM_COUNT3 = HowmuchItem(UID, 379067000);
	if (ITEM_COUNT1 < 30) then
		SelectMsg(UID, 2, 325, 505, NPC, 18, 367);
	elseif (ITEM_COUNT2 < 30) then
		SelectMsg(UID, 2, 325, 506, NPC, 18, 368);
	elseif (ITEM_COUNT3 < 1) then
		SelectMsg(UID, 2, 325, 507, NPC, 18, 369);
	elseif (ITEM_COUNT1 > 29 and ITEM_COUNT2 > 29 and ITEM_COUNT3 > 0) then 
		SelectMsg(UID, 4, 325, 508, NPC, 41, 370, 27, -1);
	end
end

if (EVENT == 367) then
	ShowMap(UID, 310);
end

if (EVENT == 368) then
	ShowMap(UID, 311);
end

if (EVENT == 369) then
	ShowMap(UID, 30);
end

if (EVENT == 370) then
AGIRLIKKONTROL = CheckWeight(UID,379243000,1)
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
	 elseif AGIRLIKKONTROL == false then	
     else
			RunQuestExchange(UID,40);
			SaveEvent(UID, 571);
end
end

if (EVENT == 373) then
	SelectMsg(UID, 2, 235, 511, NPC, 10, 374);
end

if (EVENT == 374) then
	SelectMsg(UID, 4, 235, 512, NPC, 22, 375, 23, -1);
end

if (EVENT == 375) then
	SaveEvent(UID, 574);
end

if (EVENT == 376) then
	SaveEvent(UID, 576);
	SelectMsg(UID, 2, 235, 514, NPC, 21, -1);
end

if (EVENT == 378) then
	ITEM_COUNT1 = HowmuchItem(UID, 389074000);
	ITEM_COUNT2 = HowmuchItem(UID, 389075000);
	ITEM_COUNT3 = HowmuchItem(UID, 389076000);
	if (ITEM_COUNT1 < 10) then
		SelectMsg(UID, 2, 235, 515, NPC, 18, 379);
	elseif (ITEM_COUNT2 < 10) then
		SelectMsg(UID, 2, 235, 516, NPC, 18, 379);
	elseif (ITEM_COUNT3 < 10) then
		SelectMsg(UID, 2, 235, 517, NPC, 18, 379);
	elseif (ITEM_COUNT1 > 9 and ITEM_COUNT2 > 9 and ITEM_COUNT3 > 9) then
		SelectMsg(UID, 4, 235, 518, NPC, 41, 382, 27, -1);
	end   
end

if (EVENT == 379) then
	ShowMap(UID, 23);
end

if (EVENT == 382) then
AGIRLIKKONTROL = CheckWeight(UID,379243000,1)
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
	 elseif AGIRLIKKONTROL == false then	
     else
			RunQuestExchange(UID,41);
			SaveEvent(UID, 577);
end
end

if (EVENT == 623) then
	SelectMsg(UID, 2, 336, 3236, NPC, 10, 624);
end

if (EVENT == 624) then
	SelectMsg(UID, 4, 336, 3237, NPC, 22, 625, 23, -1);
end

if (EVENT == 625) then
	SaveEvent(UID, 3453);
	SelectMsg(UID, 2, 336, 3238, NPC, 10, -1);
end

if (EVENT == 626) then
	SaveEvent(UID, 3455);
	SelectMsg(UID, 2, 336, 3242, NPC, 32, -1);
end

if (EVENT == 628) then
	ITEM_COUNT1 = HowmuchItem(UID, 379247000);
	ITEM_COUNT2 = HowmuchItem(UID, 379248000);
	ITEM_COUNT3 = HowmuchItem(UID, 379065000);
	if (ITEM_COUNT1 > 0 and ITEM_COUNT2 > 0 and ITEM_COUNT3 > 0) then
		SelectMsg(UID, 4, 336, 3243, NPC, 41, 630, 27, -1);
	else
		if (ITEM_COUNT1 < 1 or ITEM_COUNT2 < 1) then
			SelectMsg(UID, 2, 336, 3240, NPC, 18, 629);
		elseif (ITEM_COUNT3 < 1) then
			SelectMsg(UID, 2, 336, 3240, NPC, 18, 632);
		end
	end
end

if (EVENT == 629) then
	ShowMap(UID, 19);
end

if (EVENT == 632) then
	ShowMap(UID, 336);
end


if (EVENT == 630) then
AGIRLIKKONTROL = CheckWeight(UID,379243000,1)
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
	 elseif AGIRLIKKONTROL == false then	
     else
			RunQuestExchange(UID,331);
			SaveEvent(UID, 3454);
			--Skill Açma Komutu--
end
end

if (EVENT == 923) then
	SelectMsg(UID, 2, 348, 5158, NPC, 10, 924);
end

if (EVENT == 924) then
	SelectMsg(UID, 4, 348, 5159, NPC, 22, 925, 23, -1);
end

if (EVENT == 925) then
	SaveEvent(UID, 5168);
	SelectMsg(UID, 2, 348, 5160, NPC, 10, -1);
end

if (EVENT == 926) then
	SaveEvent(UID, 5170);
	SelectMsg(UID, 2, 348, 5164, NPC, 32, -1);
end

if (EVENT == 928) then
	ITEM_COUNT1 = HowmuchItem(UID, 379044000); --- Zombie Eye 50x
	ITEM_COUNT2 = HowmuchItem(UID, 379043000); --- Gavolt Wing 50x
	ITEM_COUNT3 = HowmuchItem(UID, 379236000); --- Magic Jewel Powder 2x
	ITEM_COUNT4 = HowmuchItem(UID, 900000000); --- 10M Coin
	if (ITEM_COUNT1 > 49 and ITEM_COUNT2 > 49 and ITEM_COUNT3 > 1 and ITEM_COUNT4 > 9999999) then
		SelectMsg(UID, 4, 348, 5165, NPC, 41, 930, 27, -1);
	else
		if (ITEM_COUNT1 < 50 or ITEM_COUNT2 < 50 or ITEM_COUNT3 < 2) then
			SelectMsg(UID, 2, 348, 5162, NPC, 18, 929);
		elseif (ITEM_COUNT4 < 10000000) then
			SelectMsg(UID, 2, 348, 5162, NPC, 18, 932);
		end
	end
end

if (EVENT == 929) then
	ShowMap(UID, 19);
end

if (EVENT == 932) then
	ShowMap(UID, 336);
end

if (EVENT == 930) then
AGIRLIKKONTROL = CheckWeight(UID,379243000,1)
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
	 elseif AGIRLIKKONTROL == false then	
     else
			RunQuestExchange(UID,525);
			SaveEvent(UID, 5169);
			--Skill Açma Komutu--
end
end

if (EVENT == 1023) then
	SelectMsg(UID, 2, 361, 5169, NPC, 10, 1024);
end

if (EVENT == 1024) then
	SelectMsg(UID, 4, 361, 5170, NPC, 22, 1025, 23, -1);
end

if (EVENT == 1025) then
	SaveEvent(UID, 5174);
	SelectMsg(UID, 2, 361, 5171, NPC, 10, -1);
end

if (EVENT == 1026) then
	SaveEvent(UID, 5176);
	SelectMsg(UID, 2, 361, 5175, NPC, 32, -1);
end

if (EVENT == 1028) then
	ITEM_COUNT1 = HowmuchItem(UID, 379248000);
	ITEM_COUNT2 = HowmuchItem(UID, 379236000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
	if (ITEM_COUNT1 > 0 and ITEM_COUNT2 > 1 and ITEM_COUNT3 > 9999999) then
		SelectMsg(UID, 4, 361, 5176, NPC, 41, 1030, 27, -1);
	else
		if (ITEM_COUNT1 < 1 or ITEM_COUNT2 < 2) then
			SelectMsg(UID, 2, 361, 5173, NPC, 18, 1029);
		elseif (ITEM_COUNT3 < 10000000) then
			SelectMsg(UID, 2, 361, 5173, NPC, 18, 1032);
		end
	end
end

if (EVENT == 1029) then
	ShowMap(UID, 19);
end

if (EVENT == 1032) then
	ShowMap(UID, 336);
end

if (EVENT == 1030) then
AGIRLIKKONTROL = CheckWeight(UID,379243000,1)
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
	 elseif AGIRLIKKONTROL == false then	
     else
			RunQuestExchange(UID,526);
			SaveEvent(UID, 5181);
			--Skill Açma Komutu--
end
end

if (EVENT == 1123) then
	SelectMsg(UID, 2, 367, 5180, NPC, 10, 1124);
end

if (EVENT == 1124) then
	SelectMsg(UID, 4, 367, 5181, NPC, 22, 1125, 23, -1);
end

if (EVENT == 1125) then
	SaveEvent(UID, 5192);
	SelectMsg(UID, 2, 367, 5182, NPC, 10, -1);
end

if (EVENT == 1126) then
	SaveEvent(UID, 5194);
	SelectMsg(UID, 2, 367, 5186, NPC, 32, -1);
end

if (EVENT == 1128) then
	ITEM_COUNT1 = HowmuchItem(UID, 379247000);
	ITEM_COUNT2 = HowmuchItem(UID, 379236000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
	if (ITEM_COUNT1 > 0 and ITEM_COUNT2 > 1 and ITEM_COUNT3 > 9999999) then
		SelectMsg(UID, 4, 367, 5187, NPC, 41, 1130, 27, -1);
	else
		if (ITEM_COUNT1 < 1 or ITEM_COUNT2 < 2) then
			SelectMsg(UID, 2, 367, 5184, NPC, 18, 1129);
		elseif (ITEM_COUNT3 < 10000000) then
			SelectMsg(UID, 2, 367, 5184, NPC, 18, 1132);
		end
	end
end

if (EVENT == 1129) then
	ShowMap(UID, 19);
end

if (EVENT == 1132) then
	ShowMap(UID, 336);
end

if (EVENT == 1130) then
AGIRLIKKONTROL = CheckWeight(UID,379243000,1)
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
	 elseif AGIRLIKKONTROL == false then	
     else
			RunQuestExchange(UID,527);
			SaveEvent(UID, 5193);
			--Skill Açma Komutu--
end
end

if (EVENT == 1302) then
	SelectMsg(UID, 4, 528, 20025, NPC, 22, 1303, 27, -1);
end

if (EVENT == 1303) then
	QuestStatusCheck = GetQuestStatus(UID, 528) 
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 344, NPC, 10, -1);
		else
			SaveEvent(UID, 11176);
	end
end

if (EVENT == 1308) then
	QuestStatusCheck = GetQuestStatus(UID, 528) 
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 344, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 508104000);   
		if (ITEM_COUNT < 3) then
			SelectMsg(UID, 2, 528, 20025, NPC, 18,1306);
		else
			SaveEvent(UID, 11178);
		end
	end
end

if (EVENT == 1305) then
	QuestStatusCheck = GetQuestStatus(UID, 528) 
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 344, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 508104000);   
		if (ITEM_COUNT < 3) then
			SelectMsg(UID, 2, 528, 20025, NPC, 18,1306);
		else
			SelectMsg(UID, 5, 528, 20025, NPC, 22, 1307,27, -1); 
		end
	end
end

if (EVENT == 1306) then
	ShowMap(UID, 17);
end

if (EVENT == 1307)then
	QuestStatusCheck = GetQuestStatus(UID, 528) 
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 344, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 508104000);   
		if (ITEM_COUNT < 3) then
			SelectMsg(UID, 2, 528, 20025, NPC, 18,1306);
		else
			RunQuestExchange(UID,3015,STEP,1);
			SaveEvent(UID,11177);
			SaveEvent(UID,11188);
		end
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=528 status=2 n_index=11177
if (EVENT == 193) then
	QuestStatusCheck = GetQuestStatus(UID, 528)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3015);
		SaveEvent(UID, 11179);
	end
end

-- [AUTO-GEN] quest=217 status=255 n_index=134
if (EVENT == 195) then
	SaveEvent(UID, 135);
end

-- [AUTO-GEN] quest=308 status=255 n_index=554
if (EVENT == 334) then
	SaveEvent(UID, 555);
end

-- [AUTO-GEN] quest=323 status=255 n_index=560
if (EVENT == 347) then
	SaveEvent(UID, 561);
end

-- [AUTO-GEN] quest=325 status=255 n_index=566
if (EVENT == 359) then
	SaveEvent(UID, 567);
end

-- [AUTO-GEN] quest=235 status=255 n_index=572
if (EVENT == 371) then
	SaveEvent(UID, 573);
end

-- [AUTO-GEN] quest=273 status=255 n_index=4104
if (EVENT == 550) then
	SaveEvent(UID, 4105);
end

-- [AUTO-GEN] quest=336 status=255 n_index=3451
if (EVENT == 620) then
	SaveEvent(UID, 3452);
end

-- [AUTO-GEN] quest=348 status=255 n_index=5166
if (EVENT == 920) then
	SaveEvent(UID, 5167);
end

-- [AUTO-GEN] quest=361 status=255 n_index=5178
if (EVENT == 1020) then
	SaveEvent(UID, 5179);
end

-- [AUTO-GEN] quest=367 status=255 n_index=5190
if (EVENT == 1120) then
	SaveEvent(UID, 5191);
end

-- [AUTO-GEN] quest=528 status=255 n_index=11174
if (EVENT == 1300) then
	SaveEvent(UID, 11175);
end

-- [AUTO-GEN] quest=603 status=255 n_index=12092
if (EVENT == 1400) then
	SaveEvent(UID, 12093);
end

-- [AUTO-GEN] quest=603 status=0 n_index=12093
if (EVENT == 1402) then
	SelectMsg(UID, 4, 603, 20774, NPC, 3172, 1403, 23, -1);
end

-- [AUTO-GEN] quest=603 status=0 n_index=12093
if (EVENT == 1403) then
	SaveEvent(UID, 12094);
end

-- [AUTO-GEN] quest=603 status=1 n_index=12094
if (EVENT == 1405) then
	ItemA = HowmuchItem(UID, 910239000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 603, 20774, NPC, 18, 1406);
	else
		SelectMsg(UID, 4, 603, 20774, NPC, 41, 1406, 27, -1);
	end
end

-- [AUTO-GEN] quest=603 status=1 n_index=12094
if (EVENT == 1406) then
	QuestStatusCheck = GetQuestStatus(UID, 603)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3092);
		SaveEvent(UID, 12095);
	end
end

-- [AUTO-GEN] quest=604 status=255 n_index=12104
if (EVENT == 1500) then
	SaveEvent(UID, 12105);
end

-- [AUTO-GEN] quest=604 status=0 n_index=12105
if (EVENT == 1502) then
	SelectMsg(UID, 4, 604, 20776, NPC, 3174, 1503, 23, -1);
end

-- [AUTO-GEN] quest=604 status=0 n_index=12105
if (EVENT == 1503) then
	SaveEvent(UID, 12106);
end

-- [AUTO-GEN] quest=604 status=1 n_index=12106
if (EVENT == 1505) then
	ItemA = HowmuchItem(UID, 508111000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 604, 20776, NPC, 18, 1506);
	else
		SelectMsg(UID, 4, 604, 20776, NPC, 41, 1506, 27, -1);
	end
end

-- [AUTO-GEN] quest=604 status=1 n_index=12106
if (EVENT == 1506) then
	QuestStatusCheck = GetQuestStatus(UID, 604)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3093);
		SaveEvent(UID, 12107);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
