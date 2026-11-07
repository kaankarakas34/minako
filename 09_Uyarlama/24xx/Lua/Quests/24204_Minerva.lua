-- Adapted for bundled GameServer SHA256 19e92a27...; source Orcun
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [210]={{900033000,1}},
  [211]={{900033000,1}},
  [212]={{900033000,1}},
  [213]={{900033000,1}},
  [307]={{900017000,7}},
  [332]={{379249000,1},{379250000,1},{900000000,7000000}},
  [464]={{810095000,1},{810091000,1},{810093000,1}},
  [528]={{379250000,1},{379236000,1},{900000000,10000000}},
  [529]={{379249000,1},{379236000,1},{900000000,10000000}},
  [530]={{379250000,1},{379236000,2},{900000000,10000000}},
  [531]={{379249000,1},{379236000,2},{900000000,10000000}},
  [532]={{379250000,1},{379236000,3},{900000000,10000000}},
  [533]={{379249000,1},{379236000,3},{900000000,10000000}},
  [3018]={},
  [3019]={{389083000,1},{379006000,3},{379062000,100}},
  [3073]={},
  [3074]={{379006000,2},{389014000,10}},
}
local __KO_Completion = {
  [3094]={310,307},
  [3474]={337,332},
  [3503]={456,210},
  [3508]={456,211},
  [3513]={456,212},
  [3518]={456,213},
  [4119]={273,464},
  [5205]={349,528},
  [5217]={357,529},
  [5229]={362,530},
  [5241]={363,531},
  [5253]={364,532},
  [5265]={368,533},
  [11219]={531,3018},
  [11231]={532,3019},
  [11867]={583,3073},
  [11879]={584,3074},
}
local __KO_Quests = {
  [210]={456},
  [211]={456},
  [212]={456},
  [213]={456},
  [307]={310},
  [332]={337},
  [464]={273},
  [528]={349},
  [529]={357},
  [530]={362},
  [531]={363},
  [532]={364},
  [533]={368},
  [3018]={531},
  [3019]={532},
  [3073]={583},
  [3074]={584},
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
local NPC = 24204;

if (EVENT == 190) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 3826, NPC, 10, 193);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 3826, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 224) then
	SelectMsg(UID, 4, 310, 3038, NPC, 22, 225, 23, -1);
end

if (EVENT == 225) then
	--GiveItem(UID,900017000,7);
	SaveEvent(UID, 3093);
end

if (EVENT == 226) then
	SaveEvent(UID, 3095);
	SelectMsg(UID, 2, 310, 3045, NPC, 32, -1);
end

if (EVENT == 228) then
	ITEM_COUNT = HowmuchItem(UID, 900017000);
	if (ITEM_COUNT > 6) then
		SelectMsg(UID, 4, 310, 3043, NPC, 41, 230, 27, 193);
	else
		SelectMsg(UID, 2, 310, 3038, NPC, 18, 229);
	end
end

if (EVENT == 229) then
	ShowMap(UID, 226);
end

if (EVENT == 230) then
	ITEM_COUNT = HowmuchItem(UID, 900017000);
		if (ITEM_COUNT < 7) then
			SelectMsg(UID, 2, 310, 3038, NPC, 18, 229);
		else
			--RunQuestExchange(UID,307);
			SaveEvent(UID, 3094);
			SelectMsg(UID, 2, 310, 3044, NPC, 10, -1);
	end
end

if (EVENT == 303) then
	SelectMsg(UID, 2, 327, 3048, NPC, 10, 304);
end

if (EVENT == 304) then
	SelectMsg(UID, 4, 327, 3049, NPC, 22, 305, 23, -1);
end

if (EVENT == 305) then
	SaveEvent(UID, 3113);
end

if (EVENT == 306) then
	SaveEvent(UID, 3115);
	SelectMsg(UID, 2, 327, 3054, NPC, 3009, -1);
end

if (EVENT == 308) then
	ITEM_COUNTA = HowmuchItem(UID, 379047000);
	ITEM_COUNTB = HowmuchItem(UID, 379041000);
	ITEM_COUNTC = HowmuchItem(UID, 379236000);
		if (ITEM_COUNTA < 5) then
			SelectMsg(UID, 2, 327, 3052, NPC, 18, 309);
		elseif (ITEM_COUNTB < 1) then
			SelectMsg(UID, 2, 327, 3052, NPC, 18, 311);
		elseif (ITEM_COUNTC < 2) then
			SelectMsg(UID, 2, 327, 3052, NPC, 18, 312);
		else
			SelectMsg(UID, 4, 327, 3055, NPC, 41, 310, 27, -1);
	end
end

if (EVENT == 309) then
	ShowMap(UID, 312);
end

if (EVENT == 311) then
	ShowMap(UID, 317);
end

if (EVENT == 312) then
	ShowMap(UID, 19);
end

if (EVENT == 310) then
	ITEM_COUNTA = HowmuchItem(UID, 379047000);
	ITEM_COUNTB = HowmuchItem(UID, 379041000);
	ITEM_COUNTC = HowmuchItem(UID, 379236000);
		if (ITEM_COUNTA < 5) then
			SelectMsg(UID, 2, 327, 3052, NPC, 18, 309);
		elseif (ITEM_COUNTB < 1) then
			SelectMsg(UID, 2, 327, 3052, NPC, 18, 311);
		elseif (ITEM_COUNTC < 2) then
			SelectMsg(UID, 2, 327, 3052, NPC, 18, 312);
		else
			--RunQuestExchange(UID, 308);
			SaveEvent(UID, 3116);
	end
end

if (EVENT == 403) then
	SelectMsg(UID, 2, 328, 3056, NPC, 10, 404);
end

if (EVENT == 404) then
	SelectMsg(UID, 4, 328, 3057, NPC, 22, 405, 23, -1);
end

if (EVENT == 405) then
	SaveEvent(UID, 3133);
end

if (EVENT == 406) then
	SaveEvent(UID, 3135);
	SelectMsg(UID, 2, 328, 3062, NPC, 3006, -1);
end

if (EVENT == 408) then
	ITEM_COUNTA = HowmuchItem(UID, 320410013);
	ITEM_COUNTB = HowmuchItem(UID, 320410011);
	ITEM_COUNTC = HowmuchItem(UID, 379067000);
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 328, 3060, NPC, 18, 409);
		elseif (ITEM_COUNTB < 1) then
			SelectMsg(UID, 2, 328, 3060, NPC, 18, 411);
		elseif (ITEM_COUNTC < 1) then
			SelectMsg(UID, 2, 328, 3060, NPC, 18, 412);
		else
		SelectMsg(UID, 4, 328, 3063, NPC, 41, 410, 27, -1);
	end
end

if (EVENT == 409) then
	ShowMap(UID, 311);
end

if (EVENT == 411) then
	ShowMap(UID, 309);
end

if (EVENT == 412) then
	ShowMap(UID, 30);
end

if (EVENT == 410) then
	ITEM_COUNTA = HowmuchItem(UID, 320410013);
	ITEM_COUNTB = HowmuchItem(UID, 320410011);
	ITEM_COUNTC = HowmuchItem(UID, 379067000);
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 328, 3060, NPC, 18, 409);
		elseif (ITEM_COUNTB < 1) then
			SelectMsg(UID, 2, 328, 3060, NPC, 18, 411);
		elseif (ITEM_COUNTC < 1) then
			SelectMsg(UID, 2, 328, 3060, NPC, 18, 412);
		else
			--RunQuestExchange(UID, 309);
			SaveEvent(UID, 3136);
	end
end

if (EVENT == 623) then
	SelectMsg(UID, 2, 337, 3246, NPC, 10, 624);
end

if (EVENT == 624) then
	SelectMsg(UID, 4, 337, 3247, NPC, 22, 625, 23, -1);
end

if (EVENT == 625) then
	SaveEvent(UID, 3473);
	SelectMsg(UID, 2, 337, 3248, NPC, 10, -1);
end

if (EVENT == 626) then
	SaveEvent(UID, 3475);
	SelectMsg(UID, 2, 337, 3252, NPC, 32, -1);
end

if (EVENT == 628) then
	ITEM_COUNT1 = HowmuchItem(UID, 379249000);
	ITEM_COUNT2 = HowmuchItem(UID, 379250000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
		if (ITEM_COUNTA < 1 or ITEM_COUNTB < 1) then
			SelectMsg(UID, 2, 337, 3250, NPC, 18, 629);
		elseif (ITEM_COUNTC < 7000000) then
			SelectMsg(UID, 2, 337, 3250, NPC, 18, 632);
		else
		SelectMsg(UID, 4, 337, 3253, NPC, 41, 630, 27, -1);
	end
end

if (EVENT == 629) then
	ShowMap(UID, 303);
end

if (EVENT == 632) then
	ShowMap(UID, 336);
end

if (EVENT == 630) then
	ITEM_COUNT1 = HowmuchItem(UID, 379249000);
	ITEM_COUNT2 = HowmuchItem(UID, 379250000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
		if (ITEM_COUNTA < 1 or ITEM_COUNTB < 1) then
			SelectMsg(UID, 2, 337, 3250, NPC, 18, 629);
		elseif (ITEM_COUNTC < 7000000) then
			SelectMsg(UID, 2, 337, 3250, NPC, 18, 632);
		else
			--RunQuestExchange(UID,332);
			SaveEvent(UID, 3474);
			--Skill Açma Komutu--
	end
end

if (EVENT == 197) then
	SelectMsg(UID, 4, 456, 3009, NPC, 3018, 198, 3019, -1);
end

if (EVENT == 198) then
	QuestStatusCheck = GetQuestStatus(UID, 456) 
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 187, NPC, 10, -1);
	else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 3502);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 3507);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 3512);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 3517);
		end
	end
end

if (EVENT == 201) then
	QuestStatusCheck = GetQuestStatus(UID, 456) 
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 187, NPC, 10, -1);
	else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 3504);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 3509);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 3514);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 3519);
		end
	end
end

if EVENT == 210 then
   ITEM_COUNT = HowmuchItem(UID, 900033000);
   if ITEM_COUNT > 0 then
		SelectMsg(UID, 4, 456, 3022, NPC, 10, 214, 27, -1);   
   else
		SelectMsg(UID, 2, 456, 3019, NPC, 18, 213);
   end
end

if (EVENT == 213) then
	ShowMap(UID, 308);
end

if (EVENT == 214) then
	QuestStatusCheck = GetQuestStatus(UID, 456) 
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 187, NPC, 10, -1);
	else
   ITEM_COUNT = HowmuchItem(UID, 900033000);
		if (ITEM_COUNT == 0) then
		SelectMsg(UID, 2, 456, 3019, NPC, 18, 213);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
			--RunQuestExchange(UID,210);
			SaveEvent(UID, 3503);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			--RunQuestExchange(UID,211);
			SaveEvent(UID, 3508);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			--RunQuestExchange(UID,212);
			SaveEvent(UID, 3513);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			--RunQuestExchange(UID,213);
			SaveEvent(UID, 3518);
			end
		end
	end
end

if (EVENT == 532) then   
	SelectMsg(UID, 4, 273, 4120, NPC, 22, 533, 23, -1);
end

if (EVENT == 533) then
	SaveEvent(UID, 4118);
end

if (EVENT == 535) then
	SaveEvent(UID, 4120);
	SelectMsg(UID, 2, 273, 4124, NPC, 4080, -1);
end

if (EVENT == 536) then
	ITEM_COUNTA = HowmuchItem(UID, 810095000);
	ITEM_COUNTB = HowmuchItem(UID, 810091000);
	ITEM_COUNTC = HowmuchItem(UID, 810093000);
	if (ITEM_COUNTA > 0 and ITEM_COUNTB > 0 and ITEM_COUNTC > 0) then 
		SelectMsg(UID, 4, 273, 4125, NPC, 4062, 537, 4063, -1);
	else
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 273, 4121, NPC, 18, 538);
		elseif (ITEM_COUNTB < 1) then
			SelectMsg(UID, 2, 273, 4121, NPC, 18, 539);
		elseif (ITEM_COUNTC < 1) then
			SelectMsg(UID, 2, 273, 4121, NPC, 18, 540);
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
	ShowMap(UID, 710);
end

if (EVENT == 537) then
	ITEM_COUNTA = HowmuchItem(UID, 810095000);
	ITEM_COUNTB = HowmuchItem(UID, 810091000);
	ITEM_COUNTC = HowmuchItem(UID, 810093000);
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 273, 4121, NPC, 18, 538);
		elseif (ITEM_COUNTB < 1) then
			SelectMsg(UID, 2, 273, 4121, NPC, 18, 539);
		elseif (ITEM_COUNTC < 1) then
			SelectMsg(UID, 2, 273, 4121, NPC, 18, 540);
		else
			--RunQuestExchange(UID,464);
			SaveEvent(UID, 4119);
			PromoteUser(UID);
			SelectMsg(UID, 2, 273, 4093, NPC, 4064, -1);
	end
end

if (EVENT == 723) then
	SelectMsg(UID, 2, 349, 5191, NPC, 10, 724);
end

if (EVENT == 724) then
	SelectMsg(UID, 4, 349, 5192, NPC, 22, 725, 23, -1);
end

if (EVENT == 725) then
	SaveEvent(UID, 5204);
	SelectMsg(UID, 2, 349, 5193, NPC, 10, -1);
end

if (EVENT == 726) then
	SaveEvent(UID, 5206);
	SelectMsg(UID, 2, 349, 5197, NPC, 32, -1);
end

if (EVENT == 728) then
	ITEM_COUNT1 = HowmuchItem(UID, 379250000);
	ITEM_COUNT2 = HowmuchItem(UID, 379236000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 349, 5195, NPC, 18, 729);
		elseif (ITEM_COUNTB < 1) then
			SelectMsg(UID, 2, 349, 5195, NPC, 18, 732);
		elseif (ITEM_COUNTC < 10000000) then
			SelectMsg(UID, 2, 349, 5195, NPC, 18, 733);
		else
			SelectMsg(UID, 2, 349, 5198, NPC, 41, 730, 27, -1);
	end
end

if (EVENT == 729) then
	ShowMap(UID, 303);
end

if (EVENT == 732) then
	ShowMap(UID, 19);
end

if (EVENT == 733) then
	ShowMap(UID, 336);
end

if (EVENT == 730) then
	ITEM_COUNT1 = HowmuchItem(UID, 379250000);
	ITEM_COUNT2 = HowmuchItem(UID, 379236000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 349, 5195, NPC, 18, 729);
		elseif (ITEM_COUNTB < 1) then
			SelectMsg(UID, 2, 349, 5195, NPC, 18, 732);
		elseif (ITEM_COUNTC < 10000000) then
			SelectMsg(UID, 2, 349, 5195, NPC, 18, 733);
		else
			--RunQuestExchange(UID, 528);
			SaveEvent(UID, 5205);
			--Skill Açma Komutu--
	end
end

if (EVENT == 1302) then
	SelectMsg(UID, 4, 531, 20245, NPC, 4552, 1304);
end

if (EVENT == 1304) then
	SaveEvent(UID, 11218);
end

if (EVENT == 1303) then
	SelectMsg(UID, 2, 531, 20245, NPC, 4552, 1305);
end

if (EVENT == 1305) then
	SaveEvent(UID, 11220);
	SaveEvent(UID, 11219);
end

if (EVENT == 1402) then
	SelectMsg(UID, 4, 532, 20032, NPC, 22, 1403,23,-1);
end

if (EVENT == 1403) then
	QuestStatus = GetQuestStatus(UID, 532)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 11230);
	end
end

if (EVENT == 1408) then
	QuestStatus = GetQuestStatus(UID, 532)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 11232);
	end
end

if (EVENT == 1405) then
	QuestStatus = GetQuestStatus(UID, 532)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 389083000);   
	ITEM2_COUNT = HowmuchItem(UID, 379006000);  
	ITEM3_COUNT = HowmuchItem(UID, 379062000);  
		if (ITEM1_COUNT < 1 and ITEM2_COUNT < 3 and ITEM3_COUNT < 100) then
			SelectMsg(UID, 2, 532, 20032, NPC, 18,1406);
		else
			SelectMsg(UID, 4, 532, 20032, NPC, 22, 1407, 27, -1); 
		end
	end
end

if (EVENT == 1406) then
	ShowMap(UID, 414);
end

if (EVENT == 1407) then
	QuestStatus = GetQuestStatus(UID, 532)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 389083000);   
	ITEM2_COUNT = HowmuchItem(UID, 379006000);  
	ITEM3_COUNT = HowmuchItem(UID, 379062000);  
		if (ITEM1_COUNT < 1 and ITEM2_COUNT < 3 and ITEM3_COUNT < 100) then
			SelectMsg(UID, 2, 532, 20032, NPC, 18,1406);
		else
			--RunQuestExchange(UID,3019);
			SaveEvent(UID, 11231);
			SaveEvent(UID, 11236);
		end
	end
end

if (EVENT == 823) then
	SelectMsg(UID, 2, 357, 5202, NPC, 10, 824);
end

if (EVENT == 824) then
	SelectMsg(UID, 4, 357, 5203, NPC, 22, 825, 23, -1);
end

if (EVENT == 825) then
	SaveEvent(UID, 5216);
	SelectMsg(UID, 2, 357, 5204, NPC, 10, 193);
end

if (EVENT == 826) then
	SaveEvent(UID, 5218);
	SelectMsg(UID, 2, 357, 5208, NPC, 32, 193);
end

if (EVENT == 828) then
	ITEM_COUNT1 = HowmuchItem(UID, 379249000);
	ITEM_COUNT2 = HowmuchItem(UID, 379236000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 357, 5206, NPC, 10, 829);
		elseif (ITEM_COUNTB < 1) then
			SelectMsg(UID, 2, 357, 5206, NPC, 10, 832);
		elseif (ITEM_COUNTC < 10000000) then
			SelectMsg(UID, 2, 357, 5206, NPC, 10, 833);
		else
			SelectMsg(UID, 4, 357, 5209, NPC, 41, 830, 27, -1);
	end
end

if (EVENT == 829) then
	ShowMap(UID, 303);
end

if (EVENT == 832) then
	ShowMap(UID, 19);
end

if (EVENT == 833) then
	ShowMap(UID, 336);
end

if (EVENT == 830) then
	ITEM_COUNT1 = HowmuchItem(UID, 379249000);
	ITEM_COUNT2 = HowmuchItem(UID, 379236000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 357, 5206, NPC, 10, 829);
		elseif (ITEM_COUNTB < 1) then
			SelectMsg(UID, 2, 357, 5206, NPC, 10, 832);
		elseif (ITEM_COUNTC < 10000000) then
			SelectMsg(UID, 2, 357, 5206, NPC, 10, 833);
		else
			--Skill Açma Komutu--
			--RunQuestExchange(UID, 529);
			SaveEvent(UID, 5217);
	end	
end

if (EVENT == 923) then
	SelectMsg(UID, 2, 362, 5213, NPC, 10, 924);
end

if (EVENT == 924) then
	SelectMsg(UID, 4, 362, 5214, NPC, 22, 925, 23, -1);
end

if (EVENT == 925) then
	SaveEvent(UID, 5228);
	SelectMsg(UID, 2, 362, 5215, NPC, 10, -1);
end

if (EVENT == 926) then
	SaveEvent(UID, 5230);
	SelectMsg(UID, 2, 362, 5219, NPC, 32, -1);
end

if (EVENT == 928) then
	ITEM_COUNT1 = HowmuchItem(UID, 379250000);
	ITEM_COUNT2 = HowmuchItem(UID, 379236000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 362, 5217, NPC, 18, 929);
		elseif (ITEM_COUNTB < 2) then
			SelectMsg(UID, 2, 362, 5217, NPC, 18, 932);
		elseif (ITEM_COUNTC < 10000000) then
			SelectMsg(UID, 2, 362, 5217, NPC, 18, 933);
		else
			SelectMsg(UID, 4, 362, 5220, NPC, 41, 930, 27, -1);
	end
end

if (EVENT == 929) then
	ShowMap(UID, 303);
end

if (EVENT == 932) then
	ShowMap(UID, 19);
end

if (EVENT == 933) then
	ShowMap(UID, 336);
end

if (EVENT == 930) then
	ITEM_COUNT1 = HowmuchItem(UID, 379250000);
	ITEM_COUNT2 = HowmuchItem(UID, 379236000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 362, 5217, NPC, 18, 929);
		elseif (ITEM_COUNTB < 2) then
			SelectMsg(UID, 2, 362, 5217, NPC, 18, 932);
		elseif (ITEM_COUNTC < 10000000) then
			SelectMsg(UID, 2, 362, 5217, NPC, 18, 933);
		else
			--Skill Açma Komutu--
			--RunQuestExchange(UID, 530);
			SaveEvent(UID, 5229);
	end
end

if (EVENT == 1023) then
	SelectMsg(UID, 2, 363, 5224, NPC, 10, 1024);
end

if (EVENT == 1024) then
	SelectMsg(UID, 4, 363, 5225, NPC, 22, 1025, 23, -1);
end

if (EVENT == 1025) then
	SaveEvent(UID, 5240);
	SelectMsg(UID, 2, 363, 5226, NPC, 10, -1);
end

if (EVENT == 1026) then
	SaveEvent(UID, 5242);
	SelectMsg(UID, 2, 363, 5230, NPC, 32, -1);
end

if (EVENT == 1028) then
	ITEM_COUNT1 = HowmuchItem(UID, 379249000);
	ITEM_COUNT2 = HowmuchItem(UID, 379236000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 363, 5228, NPC, 18, 1029);
		elseif (ITEM_COUNTB < 2) then
			SelectMsg(UID, 2, 363, 5228, NPC, 18, 1032);
		elseif (ITEM_COUNTC < 10000000) then
			SelectMsg(UID, 2, 363, 5228, NPC, 18, 1033);
		else
			SelectMsg(UID, 4, 363, 5231, NPC, 41, 1030, 27, -1);
	end
end

if (EVENT == 1029) then
	ShowMap(UID, 303);
end

if (EVENT == 1032) then
	ShowMap(UID, 19);
end

if (EVENT == 1033) then
	ShowMap(UID, 336);
end

if (EVENT == 1030) then
	ITEM_COUNT1 = HowmuchItem(UID, 379249000);
	ITEM_COUNT2 = HowmuchItem(UID, 379236000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 363, 5228, NPC, 18, 1029);
		elseif (ITEM_COUNTB < 2) then
			SelectMsg(UID, 2, 363, 5228, NPC, 18, 1032);
		elseif (ITEM_COUNTC < 10000000) then
			SelectMsg(UID, 2, 363, 5228, NPC, 18, 1033);
		else
			--RunQuestExchange(UID, 531);
			SaveEvent(UID, 5241);
			--Skill Açma Komutu--
	end
end

if (EVENT == 1123) then
	SelectMsg(UID, 2, 364, 5235, NPC, 10, 1124);
end

if (EVENT == 1124) then
	SelectMsg(UID, 4, 364, 5236, NPC, 22, 1125, 23, -1);
end

if (EVENT == 1125) then
	SaveEvent(UID, 5252);
	SelectMsg(UID, 2, 364, 5237, NPC, 10, 193);
end

if (EVENT == 1126) then
	SaveEvent(UID, 5254);
	SelectMsg(UID, 2, 364, 5241, NPC, 32, 193);
end

if (EVENT == 1128) then
	ITEM_COUNT1 = HowmuchItem(UID, 379250000);
	ITEM_COUNT2 = HowmuchItem(UID, 379236000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 364, 5239, NPC, 18, 1129);
		elseif (ITEM_COUNTB < 3) then
			SelectMsg(UID, 2, 364, 5239, NPC, 18, 1132);
		elseif (ITEM_COUNTC < 10000000) then
			SelectMsg(UID, 2, 364, 5239, NPC, 18, 1133);
		else
			SelectMsg(UID, 4, 364, 5242, NPC, 41, 1130, 27, -1);
	end
end

if (EVENT == 1129) then
	ShowMap(UID, 303);
end

if (EVENT == 1132) then
	ShowMap(UID, 19);
end

if (EVENT == 1133) then
	ShowMap(UID, 336);
end

if (EVENT == 1130) then
	ITEM_COUNT1 = HowmuchItem(UID, 379250000);
	ITEM_COUNT2 = HowmuchItem(UID, 379236000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 364, 5239, NPC, 18, 1129);
		elseif (ITEM_COUNTB < 3) then
			SelectMsg(UID, 2, 364, 5239, NPC, 18, 1132);
		elseif (ITEM_COUNTC < 10000000) then
			SelectMsg(UID, 2, 364, 5239, NPC, 18, 1133);
		else
			--RunQuestExchange(UID, 532);
			SaveEvent(UID, 5253); 
			--Skill Açma Komutu--
	end
end

if (EVENT == 1223) then
	SelectMsg(UID, 2, 368, 5246, NPC, 10, 1224);
end

if (EVENT == 1224) then
	SelectMsg(UID, 4, 368, 5247, NPC, 22, 1225, 23, -1);
end

if (EVENT == 1225) then
	SaveEvent(UID, 5264);
	SelectMsg(UID, 2, 368, 5248, NPC, 10, -1);
end

if (EVENT == 1226) then
	SaveEvent(UID, 5266);
	SelectMsg(UID, 2, 368, 5252, NPC, 32, -1);
end

if (EVENT == 1228) then
	ITEM_COUNT1 = HowmuchItem(UID, 379249000);
	ITEM_COUNT2 = HowmuchItem(UID, 379236000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 368, 5251, NPC, 18, 1229);
		elseif (ITEM_COUNTB < 3) then
			SelectMsg(UID, 2, 368, 5251, NPC, 18, 1232);
		elseif (ITEM_COUNTC < 10000000) then
			SelectMsg(UID, 2, 368, 5251, NPC, 18, 1233);
		else
			SelectMsg(UID, 4, 368, 5253, NPC, 41, 1230, 27, -1);
	end
end

if (EVENT == 1229) then
	ShowMap(UID, 303);
end

if (EVENT == 1232) then
	ShowMap(UID, 19);
end

if (EVENT == 1233) then
	ShowMap(UID, 336);
end

if (EVENT == 1230) then
	ITEM_COUNT1 = HowmuchItem(UID, 379249000);
	ITEM_COUNT2 = HowmuchItem(UID, 379236000);
	ITEM_COUNT3 = HowmuchItem(UID, 900000000);
		if (ITEM_COUNTA < 1) then
			SelectMsg(UID, 2, 368, 5251, NPC, 18, 1229);
		elseif (ITEM_COUNTB < 3) then
			SelectMsg(UID, 2, 368, 5251, NPC, 18, 1232);
		elseif (ITEM_COUNTC < 10000000) then
			SelectMsg(UID, 2, 368, 5251, NPC, 18, 1233);
		else
			--RunQuestExchange(UID, 533);
			SaveEvent(UID, 5265);
			--Skill Açma Komutu--
	end
end

-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=531 status=2 n_index=11219
if (EVENT == 193) then
	QuestStatusCheck = GetQuestStatus(UID, 531)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3018);
		SaveEvent(UID, 11221);
	end
end

-- [AUTO-GEN] quest=531 status=255 n_index=11216
if (EVENT == 1300) then
	SaveEvent(UID, 11217);
end

-- [AUTO-GEN] quest=456 status=255 n_index=3500
if (EVENT == 195) then
	SaveEvent(UID, 3501);
end

-- [AUTO-GEN] quest=310 status=255 n_index=3090
if (EVENT == 220) then
	SaveEvent(UID, 3092);
end

-- [AUTO-GEN] quest=327 status=255 n_index=3111
if (EVENT == 300) then
	SaveEvent(UID, 3112);
end

-- [AUTO-GEN] quest=328 status=255 n_index=3131
if (EVENT == 400) then
	SaveEvent(UID, 3132);
end

-- [AUTO-GEN] quest=273 status=255 n_index=4116
if (EVENT == 530) then
	SaveEvent(UID, 4117);
end

-- [AUTO-GEN] quest=337 status=255 n_index=3471
if (EVENT == 620) then
	SaveEvent(UID, 3472);
end

-- [AUTO-GEN] quest=349 status=255 n_index=5202
if (EVENT == 720) then
	SaveEvent(UID, 5203);
end

-- [AUTO-GEN] quest=357 status=255 n_index=5214
if (EVENT == 820) then
	SaveEvent(UID, 5215);
end

-- [AUTO-GEN] quest=362 status=255 n_index=5226
if (EVENT == 920) then
	SaveEvent(UID, 5227);
end

-- [AUTO-GEN] quest=363 status=255 n_index=5238
if (EVENT == 1020) then
	SaveEvent(UID, 5239);
end

-- [AUTO-GEN] quest=364 status=255 n_index=5250
if (EVENT == 1120) then
	SaveEvent(UID, 5251);
end

-- [AUTO-GEN] quest=368 status=255 n_index=5262
if (EVENT == 1220) then
	SaveEvent(UID, 5263);
end

-- [AUTO-GEN] quest=532 status=255 n_index=11228
if (EVENT == 1400) then
	SaveEvent(UID, 11229);
end

-- [AUTO-GEN] quest=583 status=255 n_index=11864
if (EVENT == 1500) then
	SaveEvent(UID, 11865);
end

-- [AUTO-GEN] quest=583 status=0 n_index=11865
if (EVENT == 1502) then
	SelectMsg(UID, 4, 583, 20736, NPC, 3134, 1503, 23, -1);
end

-- [AUTO-GEN] quest=583 status=1 n_index=11866
if (EVENT == 1503) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 583, 20736, NPC, 18, 1505);
	else
		SelectMsg(UID, 4, 583, 20736, NPC, 41, 1504, 27, -1);
	end
end

-- [AUTO-GEN] quest=583 status=1 n_index=11866
if (EVENT == 1504) then
	QuestStatusCheck = GetQuestStatus(UID, 583)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3073);
		SaveEvent(UID, 11867);
	end
end

-- [AUTO-GEN] quest=583 status=3 n_index=11868
if (EVENT == 1505) then
	SelectMsg(UID, 2, 583, 20736, NPC, 10, -1);
end

-- [AUTO-GEN] quest=584 status=255 n_index=11876
if (EVENT == 1600) then
	SaveEvent(UID, 11877);
end

-- [AUTO-GEN] quest=584 status=0 n_index=11877
if (EVENT == 1602) then
	SelectMsg(UID, 4, 584, 20738, NPC, 3136, 1603, 23, -1);
end

-- [AUTO-GEN] quest=584 status=0 n_index=11877
if (EVENT == 1603) then
	SaveEvent(UID, 11878);
end

-- [AUTO-GEN] quest=584 status=1 n_index=11878
if (EVENT == 1605) then
	ItemA = HowmuchItem(UID, 379006000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 584, 20738, NPC, 18, 1606);
	else
		SelectMsg(UID, 4, 584, 20738, NPC, 41, 1606, 27, -1);
	end
end

-- [AUTO-GEN] quest=584 status=1 n_index=11878
if (EVENT == 1606) then
	QuestStatusCheck = GetQuestStatus(UID, 584)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3074);
		SaveEvent(UID, 11879);
	end
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
