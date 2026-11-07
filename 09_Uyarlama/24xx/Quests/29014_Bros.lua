-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [3169]={},
  [3170]={{900216000,1},{900217000,1}},
  [3171]={{900218000,1}},
  [3172]={{900005000,699}},
  [3173]={{900219000,1},{900220000,1}},
  [3174]={{900221000,1},{900222000,1},{900223000,1}},
  [3175]={{900005000,703}},
  [3176]={{900005000,705}},
  [3177]={{900225000,1},{900226000,1}},
  [3178]={{900227000,1},{900228000,1},{900229000,1}},
  [3179]={{900005000,709}},
  [3180]={{900005000,711}},
  [3181]={{900231000,1},{900232000,1}},
  [3182]={{900233000,1},{900234000,1},{900235000,1}},
  [3183]={{900005000,715}},
  [3184]={{900005000,717}},
  [3185]={{900237000,1},{900238000,1}},
  [3186]={{900239000,1},{900240000,1},{900241000,1}},
  [3187]={{900005000,721}},
  [3188]={{900005000,723}},
  [3189]={{900243000,1},{900244000,1}},
  [3190]={{900245000,1},{900246000,1},{900247000,1}},
  [3191]={{900005000,727}},
  [3192]={{900005000,729}},
  [3193]={{900249000,1},{900250000,1}},
  [3194]={{900251000,1},{900252000,1},{900253000,1}},
  [3195]={{900005000,733}},
  [3196]={{900005000,735}},
  [3197]={{900255000,1},{900256000,1}},
  [3198]={{900257000,1},{900258000,1},{900259000,1}},
  [3199]={{900005000,739}},
  [3200]={{900005000,741}},
  [3201]={{900261000,1},{900262000,1}},
  [3202]={{900263000,1},{900264000,1},{900265000,1}},
  [3203]={{900005000,745}},
  [3204]={{900005000,747}},
  [3205]={{900267000,1},{900268000,1}},
  [3206]={{900269000,1},{900270000,1},{900271000,1}},
  [3207]={{900005000,751}},
  [3208]={{900005000,753}},
  [3209]={{900273000,1},{900274000,1}},
  [3210]={{900275000,1},{900276000,1},{900277000,1}},
  [3211]={{900005000,757}},
  [3212]={{900005000,759}},
  [3213]={{900279000,1},{900280000,1}},
  [3214]={{900281000,1},{900282000,1},{900283000,1}},
  [3215]={{900005000,763}},
  [3216]={{900005000,765}},
  [3217]={{900285000,1},{900286000,1}},
  [3218]={{900287000,1},{900288000,1},{900289000,1}},
  [3219]={{900005000,769}},
  [3222]={{900294000,1}},
  [3223]={},
  [3224]={{900005000,775}},
}
local __KO_Completion = {
  [13004]={696,3169},
  [13016]={697,3170},
  [13028]={698,3171},
  [13040]={699,3172},
  [13052]={701,3173},
  [13064]={702,3174},
  [13076]={703,3175},
  [13088]={705,3176},
  [13100]={707,3177},
  [13112]={708,3178},
  [13124]={709,3179},
  [13136]={711,3180},
  [13148]={713,3181},
  [13160]={714,3182},
  [13172]={715,3183},
  [13184]={717,3184},
  [13196]={719,3185},
  [13208]={720,3186},
  [13220]={721,3187},
  [13232]={723,3188},
  [13244]={725,3189},
  [13256]={726,3190},
  [13268]={727,3191},
  [13280]={729,3192},
  [13292]={731,3193},
  [13304]={732,3194},
  [13316]={733,3195},
  [13328]={735,3196},
  [13340]={737,3197},
  [13352]={738,3198},
  [13364]={739,3199},
  [13376]={741,3200},
  [13388]={743,3201},
  [13400]={744,3202},
  [13412]={745,3203},
  [13424]={747,3204},
  [13436]={749,3205},
  [13448]={750,3206},
  [13460]={751,3207},
  [13472]={753,3208},
  [13484]={755,3209},
  [13496]={756,3210},
  [13508]={757,3211},
  [13520]={759,3212},
  [13532]={761,3213},
  [13544]={762,3214},
  [13556]={763,3215},
  [13568]={765,3216},
  [13580]={767,3217},
  [13592]={768,3218},
  [13604]={769,3219},
  [13640]={773,3222},
  [13652]={774,3223},
  [13664]={775,3224},
}
local __KO_Quests = {
  [3169]={696},
  [3170]={697},
  [3171]={698},
  [3172]={699},
  [3173]={701},
  [3174]={702},
  [3175]={703},
  [3176]={705},
  [3177]={707},
  [3178]={708},
  [3179]={709},
  [3180]={711},
  [3181]={713},
  [3182]={714},
  [3183]={715},
  [3184]={717},
  [3185]={719},
  [3186]={720},
  [3187]={721},
  [3188]={723},
  [3189]={725},
  [3190]={726},
  [3191]={727},
  [3192]={729},
  [3193]={731},
  [3194]={732},
  [3195]={733},
  [3196]={735},
  [3197]={737},
  [3198]={738},
  [3199]={739},
  [3200]={741},
  [3201]={743},
  [3202]={744},
  [3203]={745},
  [3204]={747},
  [3205]={749},
  [3206]={750},
  [3207]={751},
  [3208]={753},
  [3209]={755},
  [3210]={756},
  [3211]={757},
  [3212]={759},
  [3213]={761},
  [3214]={762},
  [3215]={763},
  [3216]={765},
  [3217]={767},
  [3218]={768},
  [3219]={769},
  [3222]={773},
  [3223]={774},
  [3224]={775},
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
if EVENT == 1305 or EVENT == 1605 or EVENT == 1705 or EVENT == 2005 or EVENT == 2105 or EVENT == 2405 or EVENT == 2505 or EVENT == 2805 or EVENT == 2905 or EVENT == 3205 or EVENT == 3305 or EVENT == 3605 or EVENT == 3705 or EVENT == 4005 or EVENT == 4105 or EVENT == 4405 or EVENT == 4505 or EVENT == 4805 or EVENT == 4905 or EVENT == 5205 or EVENT == 5305 or EVENT == 5605 or EVENT == 5705 or EVENT == 6005 or EVENT == 6505 then
  SelectMsg(UID, 2, -1, 10526, 29014, 10, -1)
  return
end
local Ret = 0;
local NPC = 29014;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 23029, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 23029, NPC)
	else
		EVENT = QuestNum
	end
	end
	
if (EVENT == 1001)then
SelectMsg(UID, 2, 696, 22293, NPC, 10,1002);
end

if (EVENT == 1002)then
SelectMsg(UID, 2, 696, 22299, NPC, 3000, 1003,3005,-1);
SaveEvent(UID, 13003);
end

if (EVENT == 1003)then
SelectMsg(UID, 4, 696, 22299, NPC, 3000, 1004,3005,-1);
SaveEvent(UID, 13005);
end

if (EVENT == 1004)then
SelectMsg(UID, 2, 696, 22301, NPC, 10, -1);
SaveEvent(UID, 13004);
SaveEvent(UID, 13015);
end

if (EVENT == 1101)then
	SelectMsg(UID, 4, 697, 22158, NPC, 3000,1102,4005,-1);
end

if (EVENT == 1102)then
	SaveEvent(UID, 13015);
end

if (EVENT == 1106)then
	SaveEvent(UID, 13017);
end

if (EVENT == 1105)then
	ITEM1_COUNT = HowmuchItem(UID, 900216000);  
    ITEM2_COUNT = HowmuchItem(UID, 900217000); 	
	if (ITEM1_COUNT < 1) then
	SelectMsg(UID, 2, 697, 22158, NPC, 18, 1108);
	elseif (ITEM2_COUNT < 1) then
	SelectMsg(UID, 2, 697, 22158, NPC, 18, 1109);
	else
	SelectMsg(UID, 4, 697, 22158, NPC, 22, 1107, 27, -1);
end
end

if (EVENT == 1108) then
	ShowMap(UID, 5);
end

if (EVENT == 1109) then
	ShowMap(UID, 674);
end

if (EVENT == 1107) then
    SaveEvent(UID, 13016);
	SaveEvent(UID, 13027);
    RunExchange(UID, 3170)
	SelectMsg(UID, 2, -1, 22313, NPC, 10, -1);
end

if (EVENT == 1201)then
	SelectMsg(UID, 4, 698, 22160, NPC, 3000,1202,4005,-1);
end

if (EVENT == 1202)then
	SaveEvent(UID, 13027);
end

if (EVENT == 1206)then
	SaveEvent(UID, 13029);
end

if (EVENT == 1205)then
	ITEM1_COUNT = HowmuchItem(UID, 900218000);  
	if (ITEM1_COUNT < 1) then
	SelectMsg(UID, 2, 698, 22160, NPC, 18, -1);
	else
	SelectMsg(UID, 4, 698, 22160, NPC, 22, 1207, 27, -1);
end
end

if (EVENT == 1208) then
	ShowMap(UID, 1340);
end

if (EVENT == 1207) then
    SaveEvent(UID, 13028);
	SaveEvent(UID, 13039);
    RunExchange(UID, 3171);
	SelectMsg(UID, 2, -1, 22334, NPC, 10, 1208);
end

if (EVENT == 1301)then
	SelectMsg(UID, 4, 699, 22160, NPC, 3000,1302,4005,-1);
end

if (EVENT == 1302)then
	SaveEvent(UID, 13039);
end

if (EVENT == 1306)then
	SaveEvent(UID, 13041);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 1307) then
	ShowMap(UID, 858);
end

if (EVENT == 1308) then
	ShowMap(UID, 860);
end

if (EVENT == 1309) then
SLOTKONTROL = CheckGiveSlot(UID, 4)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13040);
	SaveEvent(UID, 13051);
    RunExchange(UID, 3172)
	ShowEffect(UID, 300391)
	SelectMsg(UID, 2, -1, 22777, NPC, 10, -1);
end
end

if (EVENT == 1401)then
	SelectMsg(UID, 4, 701, 22164, NPC, 3000,1402,4005,-1);
end

if (EVENT == 1402)then
	SaveEvent(UID, 13051);
end

if (EVENT == 1406)then
	SaveEvent(UID, 13053);
end

if (EVENT == 1405)then
	ITEM1_COUNT = HowmuchItem(UID, 900219000);  
	ITEM2_COUNT = HowmuchItem(UID, 900220000); 
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1) then
	SelectMsg(UID, 2, 701, 22164, NPC, 10, -1);
	else
	SelectMsg(UID, 4, 701, 22164, NPC, 22, 1407, 27, -1);
end
end

if (EVENT == 1407) then
    SaveEvent(UID, 13052);
	SaveEvent(UID, 13063);
    RunExchange(UID, 3173)
	SelectMsg(UID, 2, -1, 22349, NPC, 10, 1408,4005,-1);
end

if (EVENT == 1501)then
	SelectMsg(UID, 4, 702, 22166, NPC, 3000,1502,4005,-1);
end

if (EVENT == 1502)then
	SaveEvent(UID, 13063);
end

if (EVENT == 1506)then
	SaveEvent(UID, 13065);
end

if (EVENT == 1505)then
	QuestStatus = SearchQuest(UID, 702)	
	if(QuestStatus == 1) then
	SelectMsg(UID, 2, -1, 22349, NPC, 10, 1408,4005,-1);
	else
	ITEM1_COUNT = HowmuchItem(UID, 900221000);  
    ITEM2_COUNT = HowmuchItem(UID, 900222000); 
    ITEM3_COUNT = HowmuchItem(UID, 900223000); 	
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1 and ITEM3_COUNT < 1) then
	SelectMsg(UID, 2, -1, 22349, NPC, 10, 1408,4005,-1);
	else
	SelectMsg(UID, 5, 702, 22166, NPC,3000,1507,3005,1507,3005,1507,3005,1507,3005,1507,3005,1507,3005,1507);
end
end
end

if (EVENT == 1408)then
ZoneChange(UID, 81, 203, 197)
end

if (EVENT == 1507) then
SLOTKONTROL = CheckGiveSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13064);
	SaveEvent(UID, 13075);
    RunExchange(UID, 3174)
	SelectMsg(UID, 2, -1, 22370, NPC, 10, -1);
	RobItem(UID, 900221000, 1)
	RobItem(UID, 900222000, 1)
	RobItem(UID, 900223000, 1)
end
end

if (EVENT == 1601)then
	SelectMsg(UID, 4, 703, 22168, NPC, 3000,1602,4005,-1);
end

if (EVENT == 1602)then
	SaveEvent(UID, 13075);
end

if (EVENT == 1606)then
	SaveEvent(UID, 13077);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 1607) then
	ShowMap(UID, 829);
end

if (EVENT == 1608) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13076);
	SaveEvent(UID, 13087);
	RunExchange(UID,3175)
	SelectMsg(UID, 2, -1, 22382, NPC, 10, -1);
	end
end

if (EVENT == 1701)then
	SelectMsg(UID, 4, 705, 22170, NPC, 3000,1702,4005,-1);
end

if (EVENT == 1702)then
	SaveEvent(UID, 13087);
end

if (EVENT == 1706)then
	SaveEvent(UID, 13089);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 1707) then
	ShowMap(UID, 859);
end

if (EVENT == 1708) then
	ShowMap(UID, 861);
end

if (EVENT == 1709) then
SLOTKONTROL = CheckGiveSlot(UID, 4)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13088);
	SaveEvent(UID, 13099);
    RunExchange(UID, 3176)
	ShowEffect(UID, 300391)
	SelectMsg(UID, 2, -1, 22777, NPC, 10, -1);
end
end

if (EVENT == 1801)then
	SelectMsg(UID, 4, 707, 22172, NPC, 3000,1802,4005,-1);
end

if (EVENT == 1802)then
	SaveEvent(UID, 13099);
end

if (EVENT == 1806)then
	SaveEvent(UID, 13101);
end

if (EVENT == 1805)then
	ITEM1_COUNT = HowmuchItem(UID, 900225000);  
	ITEM2_COUNT = HowmuchItem(UID, 900226000); 
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1) then
	SelectMsg(UID, 2, 707, 22172, NPC, 10, -1);
	else
	SelectMsg(UID, 4, 707, 22172, NPC, 22, 1807, 27, -1);
end
end

if (EVENT == 1807) then
    SaveEvent(UID, 13100);
	SaveEvent(UID, 13111);
    RunExchange(UID, 3177)
	SelectMsg(UID, 2, -1, 22397, NPC, 10, 1808,4005,-1);
end

if (EVENT == 1808)then
ZoneChange(UID, 82, 203, 197)
end

if (EVENT == 1901)then
	SelectMsg(UID, 4, 708, 22172, NPC, 3000,1902,4005,-1);
end

if (EVENT == 1902)then
	SaveEvent(UID, 13111);
end

if (EVENT == 1906)then
	SaveEvent(UID, 13113);
end

if (EVENT == 1905)then
	QuestStatus = SearchQuest(UID, 708)	
	if(QuestStatus == 1) then
	SelectMsg(UID, 2, -1, 22397, NPC, 10, 1808,4005,-1);
	else
	ITEM1_COUNT = HowmuchItem(UID, 900227000);  
    ITEM2_COUNT = HowmuchItem(UID, 900228000); 
    ITEM3_COUNT = HowmuchItem(UID, 900229000); 	
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1 and ITEM3_COUNT < 1) then
	SelectMsg(UID, 2, -1, 22397, NPC, 10, 1808,4005,-1);
	else
	SelectMsg(UID, 5, 708, 22172, NPC,3000,1907,3005,1907,3005,1907,3005,1907,3005,1907,3005,1907,3005,1907);
end
end
end

if (EVENT == 1907) then
SLOTKONTROL = CheckGiveSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13112);
	SaveEvent(UID, 13123);
    RunExchange(UID, 3178)
	RobItem(UID, 900227000, 1)
	RobItem(UID, 900228000, 1)
	RobItem(UID, 900229000, 1)
	SelectMsg(UID, 2, -1, 22409, NPC, 10, -1);
end
end

if (EVENT == 2001)then
	SelectMsg(UID, 4, 709, 22176, NPC, 3000,2002,4005,-1);
end

if (EVENT == 2002)then
	SaveEvent(UID, 13123);
end

if (EVENT == 2006)then
	SaveEvent(UID, 13125);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 2007) then
	ShowMap(UID, 830);
end

if (EVENT == 2008) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SaveEvent(UID, 13124);
	SaveEvent(UID, 13135);
    RunExchange(UID, 3179)
	SelectMsg(UID, 2, -1, 22409, NPC, 10, -1);
end
end

if (EVENT == 2101)then
	SelectMsg(UID, 4, 711, 22178, NPC, 3000,2102,4005,-1);
end

if (EVENT == 2102)then
	SaveEvent(UID, 13135);
end

if (EVENT == 2106)then
	SaveEvent(UID, 13137);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 2107) then
	ShowMap(UID, 870);
end

if (EVENT == 2108) then
	ShowMap(UID, 872);
end

if (EVENT == 2109) then
SLOTKONTROL = CheckGiveSlot(UID, 4)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13136);
	SaveEvent(UID, 13147);
    RunExchange(UID, 3180)
	ShowEffect(UID, 300391)
	--SelectMsg(UID, 2, -1, 22777, NPC, 10, -1);
end
end

if (EVENT == 2201)then
	SelectMsg(UID, 4, 713, 22180, NPC, 3000,2202,4005,-1);
end

if (EVENT == 2202)then
	SaveEvent(UID, 13147);
end

if (EVENT == 2206)then
	SaveEvent(UID, 13149);
end

if (EVENT == 2205)then
	ITEM1_COUNT = HowmuchItem(UID, 900231000);  
	ITEM2_COUNT = HowmuchItem(UID, 900232000); 
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1) then
	SelectMsg(UID, 2, 713, 22180, NPC, 10, -1);
	else
	SelectMsg(UID, 4, 713, 22180, NPC, 22, 2207, 27, -1);
end
end

if (EVENT == 2207) then
    SaveEvent(UID, 13148);
	SaveEvent(UID, 13159);
    RunExchange(UID, 3181)
	SelectMsg(UID, 2, -1, 22456, NPC, 10, 2308,4005,-1);
end

if (EVENT == 2301)then
	SelectMsg(UID, 4, 714, 22182, NPC, 3000,2302,4005,-1);
end

if (EVENT == 2302)then
	SaveEvent(UID, 13159);
end

if (EVENT == 2306)then
	SaveEvent(UID, 13161);
end

if (EVENT == 2305)then
	QuestStatus = SearchQuest(UID, 714)	
	if(QuestStatus == 1) then
	SelectMsg(UID, 2, -1, 22456, NPC, 10, 2308,4005,-1);
	else
	ITEM1_COUNT = HowmuchItem(UID, 900233000);  
    ITEM2_COUNT = HowmuchItem(UID, 900234000); 
    ITEM3_COUNT = HowmuchItem(UID, 900235000); 	
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1 and ITEM3_COUNT < 1) then
	SelectMsg(UID, 2, -1, 22456, NPC, 10, 2308,4005,-1);
	else
	SelectMsg(UID, 5, 714, 22182, NPC,3000,2307,3005,2307,3005,2307,3005,2307,3005,2307,3005,2307,3005,2307);
end
end
end

if (EVENT == 2307) then
SLOTKONTROL = CheckGiveSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13160);
	SaveEvent(UID, 13171);
    RunExchange(UID, 3182)
	RobItem(UID, 900233000, 1)
	RobItem(UID, 900234000, 1)
	RobItem(UID, 900235000, 1)
	SelectMsg(UID, 2, -1, 22468, NPC, 10, -1);
end
end

if (EVENT == 2401)then
	SelectMsg(UID, 4, 715, 22184, NPC, 3000,2402,4005,-1);
end

if (EVENT == 2402)then
	SaveEvent(UID, 13171);
end

if (EVENT == 2406)then
	SaveEvent(UID, 13173);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 2407) then
	ShowMap(UID, 831);
end

if (EVENT == 2408) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13172);
	SaveEvent(UID, 13183);
    RunExchange(UID, 3183)
end
end

if (EVENT == 2501)then
	SelectMsg(UID, 4, 717, 22186, NPC, 3000,2502,4005,-1);
end

if (EVENT == 2502)then
	SaveEvent(UID, 13183);
end

if (EVENT == 2506)then
	SaveEvent(UID, 13185);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 2507) then
	ShowMap(UID, 871);
end

if (EVENT == 2508) then
	ShowMap(UID, 873);
end

if (EVENT == 2509) then
SLOTKONTROL = CheckGiveSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13184);
	SaveEvent(UID, 13195);
    RunExchange(UID, 3184)
	ShowEffect(UID, 300391)
end
end

if (EVENT == 2601)then
	SelectMsg(UID, 4, 719, 22188, NPC, 3000,2602,4005,-1);
end

if (EVENT == 2602)then
	SaveEvent(UID, 13195);
end

if (EVENT == 2606)then
	SaveEvent(UID, 13197);
end

if (EVENT == 2605)then
	ITEM1_COUNT = HowmuchItem(UID, 900237000);  
	ITEM2_COUNT = HowmuchItem(UID, 900238000); 
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1) then
	SelectMsg(UID, 2, 719, 22188, NPC, 10, -1);
	else
	SelectMsg(UID, 4, 719, 22188, NPC, 22, 2607, 27, -1);
end
end

if (EVENT == 2607) then
    SaveEvent(UID, 13196);
	SaveEvent(UID, 13207);
    RunExchange(UID, 3185)
	SelectMsg(UID, 2, -1, 22370, NPC, 10, 2708,4005,-1);
end

if (EVENT == 2701)then
	SelectMsg(UID, 4, 720, 22190, NPC, 3000,2702,4005,-1);
end

if (EVENT == 2702)then
	SaveEvent(UID, 13207);
end

if (EVENT == 2706)then
	SaveEvent(UID, 13209);
end

if (EVENT == 2705)then
	QuestStatus = SearchQuest(UID, 720)	
	if(QuestStatus == 1) then
	SelectMsg(UID, 2, -1, 22370, NPC, 10, 2708,4005,-1);
	else
	ITEM1_COUNT = HowmuchItem(UID, 900239000);  
    ITEM2_COUNT = HowmuchItem(UID, 900240000); 
    ITEM3_COUNT = HowmuchItem(UID, 900241000); 	
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1 and ITEM3_COUNT < 1) then
	SelectMsg(UID, 2, -1, 22370, NPC, 10, 2708,4005,-1);
	else
	SelectMsg(UID, 5, 720, 22190, NPC,3000,2707,3005,2707,3005,2707,3005,2707,3005,2707,3005,2707,3005,2707);
end
end
end

if (EVENT == 2708)then
ZoneChange(UID, 81, 203, 197)
end

if (EVENT == 2707) then
SLOTKONTROL = CheckGiveSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13208);
	SaveEvent(UID, 13219);
    RunExchange(UID, 3186)
	RobItem(UID, 900239000, 1)
	RobItem(UID, 900240000, 1)
	RobItem(UID, 900241000, 1)
	SelectMsg(UID, 2, -1, 22507, NPC, 10, -1);
end
end

if (EVENT == 2801)then
	SelectMsg(UID, 4, 721, 22192, NPC, 3000,2802,4005,-1);
end

if (EVENT == 2802)then
	SaveEvent(UID, 13219);
end

if (EVENT == 2806)then
	SaveEvent(UID, 13221);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 2807) then
	ShowMap(UID, 832);
end

if (EVENT == 2808) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13220);
	SaveEvent(UID, 13231);
    RunExchange(UID, 3187)
	SelectMsg(UID, 2, -1, 22530, NPC, 10, -1);
end
end

if (EVENT == 2901)then
	SelectMsg(UID, 4, 723, 22194, NPC, 3000,2902,4005,-1);
end

if (EVENT == 2902)then
	SaveEvent(UID, 13231);
end

if (EVENT == 2906)then
	SaveEvent(UID, 13233);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 2907) then
	ShowMap(UID, 882);
end

if (EVENT == 2908) then
	ShowMap(UID, 884);
end

if (EVENT == 2909) then
SLOTKONTROL = CheckGiveSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13232);
	SaveEvent(UID, 13243);
    RunExchange(UID, 3188)
	ShowEffect(UID, 300391)
	SelectMsg(UID, 2, -1, 22777, NPC, 10, -1);
end
end

if (EVENT == 3001)then
	SelectMsg(UID, 4, 725, 22196, NPC, 3000,3002,4005,-1);
end

if (EVENT == 3002)then
	SaveEvent(UID, 13243);
end

if (EVENT == 3006)then
	SaveEvent(UID, 13245);
end

if (EVENT == 3005)then
	ITEM1_COUNT = HowmuchItem(UID, 900243000);  
	ITEM2_COUNT = HowmuchItem(UID, 900244000); 
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1) then
	SelectMsg(UID, 2, 725, 22196, NPC, 10, -1);
	else
	SelectMsg(UID, 4, 725, 22196, NPC, 22, 3007, 27, -1);
end
end

if (EVENT == 3007) then
    SaveEvent(UID, 13244);
	SaveEvent(UID, 13255);
    RunExchange(UID, 3189)
	SelectMsg(UID, 2, -1, 22554, NPC, 10, 3008,4005,-1);
end

if (EVENT == 3008)then
ZoneChange(UID, 82, 203, 197)
end

if (EVENT == 3101)then
	SelectMsg(UID, 4, 726, 22198, NPC, 3000,3102,4005,-1);
end

if (EVENT == 3102)then
	SaveEvent(UID, 13255);
end

if (EVENT == 3106)then
	SaveEvent(UID, 13257);
end

if (EVENT == 3105)then
	QuestStatus = SearchQuest(UID, 726)	
	if(QuestStatus == 1) then
	SelectMsg(UID, 2, -1, 22554, NPC, 10, 3008,4005,-1);
	else
	ITEM1_COUNT = HowmuchItem(UID, 900245000);  
    ITEM2_COUNT = HowmuchItem(UID, 900246000); 
    ITEM3_COUNT = HowmuchItem(UID, 900247000); 	
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1 and ITEM3_COUNT < 1) then
	SelectMsg(UID, 2, -1, 22554, NPC, 10, 3008,4005,-1);
	else
	SelectMsg(UID, 5, 726, 22190, NPC,3000,3107,3005,3107,3005,3107,3005,3107,3005,3107,3005,3107,3005,3107);
end
end
end

if (EVENT == 3107) then
SLOTKONTROL = CheckGiveSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13256);
	SaveEvent(UID, 13267);
    RunExchange(UID, 3190)
	RobItem(UID, 900245000, 1)
	RobItem(UID, 900246000, 1)
	RobItem(UID, 900247000, 1)
	SelectMsg(UID, 2, -1, 22566, NPC, 10, -1);
end
end

if (EVENT == 3201)then
	SelectMsg(UID, 4, 727, 22200, NPC, 3000,3202,4005,-1);
end

if (EVENT == 3202)then
	SaveEvent(UID, 13267);
end

if (EVENT == 3206)then
	SaveEvent(UID, 13269);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 3207) then
	ShowMap(UID, 833);
end

if (EVENT == 3208) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13268);
	SaveEvent(UID, 13279);
    RunExchange(UID, 3191)
	SelectMsg(UID, 2, -1, 22578, NPC, 10, -1);
end
end

if (EVENT == 3301)then
	SelectMsg(UID, 4, 729, 22202, NPC, 3000,3302,4005,-1);
end

if (EVENT == 3302)then
	SaveEvent(UID, 13279);
end

if (EVENT == 3306)then
	SaveEvent(UID, 13281);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 3307) then
	ShowMap(UID, 883);
end

if (EVENT == 3308) then
	ShowMap(UID, 885);
end

if (EVENT == 3309) then
SLOTKONTROL = CheckGiveSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13280);
	SaveEvent(UID, 13291);
    RunExchange(UID, 3192)
	SelectMsg(UID, 2, -1, 22777, NPC, 10, -1);
end
end

if (EVENT == 3401)then
	SelectMsg(UID, 4, 731, 22204, NPC, 3000,3402,4005,-1);
end

if (EVENT == 3402)then
	SaveEvent(UID, 13291);
end

if (EVENT == 3406)then
	SaveEvent(UID, 13293);
end

if (EVENT == 3405)then
	ITEM1_COUNT = HowmuchItem(UID, 900249000);  
	ITEM2_COUNT = HowmuchItem(UID, 900250000); 
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1) then
	SelectMsg(UID, 2, 731, 22204, NPC, 10, -1);
	else
	SelectMsg(UID, 4, 731, 22204, NPC, 22, 3407, 27, -1);
end
end

if (EVENT == 3407) then
    SaveEvent(UID, 13292);
	SaveEvent(UID, 13303);
    RunExchange(UID, 3193)
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 3408,4005,-1);
end

if (EVENT == 3408)then
ZoneChange(UID, 83, 203, 197)
end

if (EVENT == 3501)then
	SelectMsg(UID, 4, 732, 22206, NPC, 3000,3502,4005,-1);
end

if (EVENT == 3502)then
	SaveEvent(UID, 13303);
end

if (EVENT == 3506)then
	SaveEvent(UID, 13305);
end

if (EVENT == 3505)then
	QuestStatus = SearchQuest(UID, 732)	
	if(QuestStatus == 1) then
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 3408,4005,-1);
	else
	ITEM1_COUNT = HowmuchItem(UID, 900251000);  
    ITEM2_COUNT = HowmuchItem(UID, 900252000); 
    ITEM3_COUNT = HowmuchItem(UID, 900253000); 	
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1 and ITEM3_COUNT < 1) then
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 3408,4005,-1);
	else
	SelectMsg(UID, 4, 732, 22206, NPC,3000,3507,3005,-1);
end
end
end

if (EVENT == 3507) then
    SaveEvent(UID, 13304);
	SaveEvent(UID, 13315);
    RunExchange(UID, 3194)
	SelectMsg(UID, 2, -1, 22615, NPC, 10,-1);
end

if (EVENT == 3601)then
	SelectMsg(UID, 4, 733, 22208, NPC, 3000,3602,4005,-1);
end

if (EVENT == 3602)then
	SaveEvent(UID, 13315);
end

if (EVENT == 3606)then
	SaveEvent(UID, 13317);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 3607) then
	ShowMap(UID, 834);
end

if (EVENT == 3608) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13316);
	SaveEvent(UID, 13327);
    RunExchange(UID, 3195)
	SelectMsg(UID, 2, -1, 22628, NPC, 10,-1);
end
end

if (EVENT == 3701)then
	SelectMsg(UID, 4, 735, 22210, NPC, 3000,3702,4005,-1);
end

if (EVENT == 3702)then
	SaveEvent(UID, 13327);
end

if (EVENT == 3706)then
	SaveEvent(UID, 13329);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 3707) then
	ShowMap(UID, 894);
end

if (EVENT == 3708) then
	ShowMap(UID, 896);
end

if (EVENT == 3709) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13328);
	SaveEvent(UID, 13339);
    RunExchange(UID, 3196)
	SelectMsg(UID, 2, -1, 22628, NPC, 10,-1);
end
end

if (EVENT == 3801)then
	SelectMsg(UID, 4, 737, 22212, NPC, 3000,3802,4005,-1);
end

if (EVENT == 3802)then
	SaveEvent(UID, 13339);
end

if (EVENT == 3806)then
	SaveEvent(UID, 13341);
end

if (EVENT == 3805)then
	ITEM1_COUNT = HowmuchItem(UID, 900255000);  
	ITEM2_COUNT = HowmuchItem(UID, 900256000); 
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1) then
	SelectMsg(UID, 2, 737, 22212, NPC, 10, -1);
	else
	SelectMsg(UID, 4, 737, 22212, NPC, 22, 3807, 27, -1);
end
end

if (EVENT == 3807) then
    SaveEvent(UID, 13340);
	SaveEvent(UID, 13351);
    RunExchange(UID, 3197)
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 3808,4005,-1);
end

if (EVENT == 3901)then
	SelectMsg(UID, 4, 738, 22214, NPC, 3000,3902,4005,-1);
end

if (EVENT == 3902)then
	SaveEvent(UID, 13351);
end

if (EVENT == 3906)then
	SaveEvent(UID, 13353);
end

if (EVENT == 3905)then
	QuestStatus = SearchQuest(UID, 738)	
	if(QuestStatus == 1) then
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 3808,4005,-1);
	else
	ITEM1_COUNT = HowmuchItem(UID, 900257000);  
    ITEM2_COUNT = HowmuchItem(UID, 900258000); 
    ITEM3_COUNT = HowmuchItem(UID, 900259000); 	
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1 and ITEM3_COUNT < 1) then
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 3808,4005,-1);
	else
	SelectMsg(UID, 4, 738, 22206, NPC,3000,3907,3005,-1);
end
end
end

if (EVENT == 3907) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13352);
	SaveEvent(UID, 13363);
    RunExchange(UID, 3198)
	--SelectMsg(UID, 2, -1, 22615, NPC, 10,-1);
end
end

if (EVENT == 4001)then
	SelectMsg(UID, 4, 739, 22216, NPC, 3000,4002,4005,-1);
end

if (EVENT == 4002)then
	SaveEvent(UID, 13363);
end

if (EVENT == 4006)then
	SaveEvent(UID, 13365);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 4008) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13364);
	SaveEvent(UID, 13375);
    RunExchange(UID, 3199)
	--SelectMsg(UID, 2, -1, 22615, NPC, 10,-1);
end
end

if (EVENT == 4101)then
	SelectMsg(UID, 4, 741, 22218, NPC, 3000,4102,4005,-1);
end

if (EVENT == 4102)then
	SaveEvent(UID, 13375);
end

if (EVENT == 4106)then
	SaveEvent(UID, 13377);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 4107) then
	ShowMap(UID, 895);
end

if (EVENT == 4108) then
	ShowMap(UID, 897);
end

if (EVENT == 4109) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13376);
	SaveEvent(UID, 13387);
    RunExchange(UID, 3200)
	--SelectMsg(UID, 2, -1, 22615, NPC, 10,-1);
end
end

if (EVENT == 4201)then
	SelectMsg(UID, 4, 743, 22220, NPC, 3000,4202,4005,-1);
end

if (EVENT == 4202)then
	SaveEvent(UID, 13387);
end

if (EVENT == 4206)then
	SaveEvent(UID, 13389);
end

if (EVENT == 4205)then
	ITEM1_COUNT = HowmuchItem(UID, 900261000);  
	ITEM2_COUNT = HowmuchItem(UID, 900262000); 
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1) then
	SelectMsg(UID, 2, 743, 22220, NPC, 10, -1);
	else
	SelectMsg(UID, 4, 743, 22220, NPC, 22, 4208, 27, -1);
end
end

if (EVENT == 4208) then
    SaveEvent(UID, 13388);
	SaveEvent(UID, 13399);
    RunExchange(UID, 3201)
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 4209,4005,-1);
end

if (EVENT == 4301)then
	SelectMsg(UID, 4, 744, 22222, NPC, 3000,4302,4005,-1);
end

if (EVENT == 4302)then
	SaveEvent(UID, 13399);
end

if (EVENT == 4306)then
	SaveEvent(UID, 13401);
end

if (EVENT == 4305)then
	QuestStatus = SearchQuest(UID, 744)	
	if(QuestStatus == 1) then
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 4209,4005,-1);
	else
	ITEM1_COUNT = HowmuchItem(UID, 900263000);  
    ITEM2_COUNT = HowmuchItem(UID, 900264000); 
    ITEM3_COUNT = HowmuchItem(UID, 900265000); 	
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1 and ITEM3_COUNT < 1) then
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 4209,4005,-1);
	else
	SelectMsg(UID, 4, 744, 22222, NPC,3000,4307,3005,-1);
end
end
end

if (EVENT == 4307) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13400);
	SaveEvent(UID, 13411);
    RunExchange(UID, 3202)
	--SelectMsg(UID, 2, -1, 22602, NPC, 10, 4209,4005,-1);
end
end

if (EVENT == 4401)then
	SelectMsg(UID, 4, 745, 22224, NPC, 3000,4402,4005,-1);
end

if (EVENT == 4402)then
	SaveEvent(UID, 13411);
end

if (EVENT == 4406)then
	SaveEvent(UID, 13413);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 4407) then
	ShowMap(UID, 836);
end

if (EVENT == 4408) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13412);
	SaveEvent(UID, 13423);
    RunExchange(UID, 3203)
	--SelectMsg(UID, 2, -1, 22615, NPC, 10,-1);
end
end

if (EVENT == 4501)then
	SelectMsg(UID, 4, 747, 22226, NPC, 3000,4502,4005,-1);
end

if (EVENT == 4502)then
	SaveEvent(UID, 13423);
end

if (EVENT == 4506)then
	SaveEvent(UID, 13425);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 4507) then
	ShowMap(UID, 906);
end

if (EVENT == 4508) then
	ShowMap(UID, 908);
end

if (EVENT == 4509) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13424);
	SaveEvent(UID, 13435);
    RunExchange(UID, 3204)
	--SelectMsg(UID, 2, -1, 22615, NPC, 10,-1);
end
end

if (EVENT == 4601)then
	SelectMsg(UID, 4, 749, 22228, NPC, 3000,4602,4005,-1);
end

if (EVENT == 4602)then
	SaveEvent(UID, 13435);
end

if (EVENT == 4606)then
	SaveEvent(UID, 13437);
end

if (EVENT == 4605)then
	ITEM1_COUNT = HowmuchItem(UID, 900267000);  
	ITEM2_COUNT = HowmuchItem(UID, 900268000); 
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1) then
	SelectMsg(UID, 2, 749, 22228, NPC, 10, -1);
	else
	SelectMsg(UID, 4, 749, 22228, NPC, 22, 4608, 27, -1);
end
end

if (EVENT == 4608) then
    SaveEvent(UID, 13436);
	SaveEvent(UID, 13447);
    RunExchange(UID, 3205)
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 4609,4005,-1);
end

if (EVENT == 4701)then
	SelectMsg(UID, 4, 750, 22230, NPC, 3000,4702,4005,-1);
end

if (EVENT == 4702)then
	SaveEvent(UID, 13447);
end

if (EVENT == 4706)then
	SaveEvent(UID, 13449);
end

if (EVENT == 4705)then
	QuestStatus = SearchQuest(UID, 750)	
	if(QuestStatus == 1) then
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 4609,4005,-1);
	else
	ITEM1_COUNT = HowmuchItem(UID, 900269000);  
    ITEM2_COUNT = HowmuchItem(UID, 900270000); 
    ITEM3_COUNT = HowmuchItem(UID, 900271000); 	
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1 and ITEM3_COUNT < 1) then
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 4609,4005,-1);
	else
	SelectMsg(UID, 4, 750, 22230, NPC,3000,4707,3005,-1);
end
end
end

if (EVENT == 4707) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13448);
	SaveEvent(UID, 13459);
    RunExchange(UID, 3206)
	--SelectMsg(UID, 2, -1, 22602, NPC, 10, 4209,4005,-1);
end
end

if (EVENT == 4801)then
	SelectMsg(UID, 4, 751, 22232, NPC, 3000,4802,4005,-1);
end

if (EVENT == 4802)then
	SaveEvent(UID, 13459);
end

if (EVENT == 4806)then
	SaveEvent(UID, 13461);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 4807) then
	ShowMap(UID, 904);
end

if (EVENT == 4808) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13460);
	SaveEvent(UID, 13471);
    RunExchange(UID, 3207)
	SelectMsg(UID, 2, -1, 22774, NPC, 10,-1);
end
end

if (EVENT == 4901)then
	SelectMsg(UID, 4, 753, 22234, NPC, 3000,4902,4005,-1);
end

if (EVENT == 4902)then
	SaveEvent(UID, 13471);
end

if (EVENT == 4906)then
	SaveEvent(UID, 13473);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 4907) then
	ShowMap(UID, 907);
end
if (EVENT == 4908) then
	ShowMap(UID, 909);
end

if (EVENT == 4909) then
SLOTKONTROL = CheckGiveSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13472);
	SaveEvent(UID, 13483);
    RunExchange(UID, 3208)
	SelectMsg(UID, 2, -1, 22615, NPC, 10,-1);
end
end

if (EVENT == 5001)then
	SelectMsg(UID, 4, 755, 22236, NPC, 3000,5002,4005,-1);
end

if (EVENT == 5002)then
	SaveEvent(UID, 13483);
end

if (EVENT == 5006)then
	SaveEvent(UID, 13485);
end

if (EVENT == 5005)then
	ITEM1_COUNT = HowmuchItem(UID, 900273000);  
	ITEM2_COUNT = HowmuchItem(UID, 900274000); 
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1) then
	SelectMsg(UID, 2, 755, 22236, NPC, 10, -1);
	else
	SelectMsg(UID, 4, 755, 22236, NPC, 22, 5008, 27, -1);
end
end

if (EVENT == 5008) then
    SaveEvent(UID, 13484);
	SaveEvent(UID, 13495);
    RunExchange(UID, 3209)
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 5009,4005,-1);
end

if (EVENT == 5101)then
	SelectMsg(UID, 4, 756, 22238, NPC, 3000,5102,4005,-1);
end

if (EVENT == 5102)then
	SaveEvent(UID, 13495);
end

if (EVENT == 5106)then
	SaveEvent(UID, 13497);
end

if (EVENT == 5105)then
	QuestStatus = SearchQuest(UID, 756)	
	if(QuestStatus == 1) then
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 5009,4005,-1);
	else
	ITEM1_COUNT = HowmuchItem(UID, 900275000);  
    ITEM2_COUNT = HowmuchItem(UID, 900276000); 
    ITEM3_COUNT = HowmuchItem(UID, 900277000); 	
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1 and ITEM3_COUNT < 1) then
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 5009,4005,-1);
	else
	SelectMsg(UID, 4, 756, 22238, NPC,3000,5107,3005,-1);
end
end
end

if (EVENT == 5107) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13496);
	SaveEvent(UID, 13507);
    RunExchange(UID, 3210)
	--SelectMsg(UID, 2, -1, 22602, NPC, 10, 4209,4005,-1);
end
end

if (EVENT == 5201)then
	SelectMsg(UID, 4, 757, 22240, NPC, 3000,5202,4005,-1);
end

if (EVENT == 5202)then
	SaveEvent(UID, 13507);
end

if (EVENT == 5206)then
	SaveEvent(UID, 13509);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 5207) then
	ShowMap(UID, 905);
end

if (EVENT == 5208) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13508);
	SaveEvent(UID, 13519);
    RunExchange(UID, 3211)
	SelectMsg(UID, 2, -1, 22774, NPC, 10,-1);
end
end

if (EVENT == 5301)then
	SelectMsg(UID, 4, 759, 22242, NPC, 3000,5302,4005,-1);
end

if (EVENT == 5302)then
	SaveEvent(UID, 13519);
end

if (EVENT == 5306)then
	SaveEvent(UID, 13521);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 5307) then
	ShowMap(UID, 907);
end
if (EVENT == 5308) then
	ShowMap(UID, 909);
end

if (EVENT == 5309) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13520);
	SaveEvent(UID, 13531);
    RunExchange(UID, 3212)
	SelectMsg(UID, 2, -1, 22615, NPC, 10,-1);
end
end

if (EVENT == 5401)then
	SelectMsg(UID, 4, 761, 22244, NPC, 3000,5402,4005,-1);
end

if (EVENT == 5402)then
	SaveEvent(UID, 13531);
end

if (EVENT == 5406)then
	SaveEvent(UID, 13533);
end

if (EVENT == 5405)then
	ITEM1_COUNT = HowmuchItem(UID, 900279000);  
	ITEM2_COUNT = HowmuchItem(UID, 900280000); 
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1) then
	SelectMsg(UID, 2, 761, 22244, NPC, 10, -1);
	else
	SelectMsg(UID, 4, 761, 22244, NPC, 22, 5408, 27, -1);
end
end

if (EVENT == 5408) then
    SaveEvent(UID, 13532);
	SaveEvent(UID, 13543);
    RunExchange(UID, 3213)
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 5409,4005,-1);
end

if (EVENT == 5501)then
	SelectMsg(UID, 4, 762, 22246, NPC, 3000,5502,4005,-1);
end

if (EVENT == 5502)then
	SaveEvent(UID, 13543);
end

if (EVENT == 5506)then
	SaveEvent(UID, 13545);
end

if (EVENT == 5505)then
	QuestStatus = SearchQuest(UID, 762)	
	if(QuestStatus == 1) then
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 5409,4005,-1);
	else
	ITEM1_COUNT = HowmuchItem(UID, 900281000);  
    ITEM2_COUNT = HowmuchItem(UID, 900282000); 
    ITEM3_COUNT = HowmuchItem(UID, 900283000); 	
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1 and ITEM3_COUNT < 1) then
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 5409,4005,-1);
	else
	SelectMsg(UID, 4, 762, 22246, NPC,3000,5507,3005,-1);
end
end
end

if (EVENT == 5507) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13544);
	SaveEvent(UID, 13555);
    RunExchange(UID, 3214)
	--SelectMsg(UID, 2, -1, 22602, NPC, 10, 4209,4005,-1);
end
end

if (EVENT == 5601)then
	SelectMsg(UID, 4, 763, 22248, NPC, 3000,5602,4005,-1);
end

if (EVENT == 5602)then
	SaveEvent(UID, 13555);
end

if (EVENT == 5606)then
	SaveEvent(UID, 13557);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 5607) then
	ShowMap(UID, 905);
end

if (EVENT == 5608) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13556);
	SaveEvent(UID, 13567);
    RunExchange(UID, 3215)
	SelectMsg(UID, 2, -1, 22774, NPC, 10,-1);
end
end

if (EVENT == 5701)then
	SelectMsg(UID, 4, 765, 22250, NPC, 3000,5702,4005,-1);
end

if (EVENT == 5702)then
	SaveEvent(UID, 13567);
end

if (EVENT == 5706)then
	SaveEvent(UID, 13569);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 5707) then
	ShowMap(UID, 919);
end
if (EVENT == 5708) then
	ShowMap(UID, 921);
end

if (EVENT == 5709) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13568);
	SaveEvent(UID, 13579);
    RunExchange(UID, 3216)
	SelectMsg(UID, 2, -1, 22615, NPC, 10,-1);
end
end

if (EVENT == 5801)then
	SelectMsg(UID, 4, 767, 22252, NPC, 3000,5802,4005,-1);
end

if (EVENT == 5802)then
	SaveEvent(UID, 13579);
end

if (EVENT == 5806)then
	SaveEvent(UID, 13581);
end

if (EVENT == 5805)then
	ITEM1_COUNT = HowmuchItem(UID, 900285000);  
	ITEM2_COUNT = HowmuchItem(UID, 900286000); 
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1) then
	SelectMsg(UID, 2, 767, 22252, NPC, 10, -1);
	else
	SelectMsg(UID, 4, 767, 22252, NPC, 22, 5808, 27, -1);
end
end

if (EVENT == 5808) then
    SaveEvent(UID, 13580);
	SaveEvent(UID, 13591);
    RunExchange(UID, 3217)
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 5809,4005,-1);
end

if (EVENT == 5901)then
	SelectMsg(UID, 4, 768, 22254, NPC, 3000,5902,4005,-1);
end

if (EVENT == 5902)then
	SaveEvent(UID, 13591);
end

if (EVENT == 5906)then
	SaveEvent(UID, 13593);
end

if (EVENT == 5905)then
	QuestStatus = SearchQuest(UID, 768)	
	if(QuestStatus == 1) then
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 5809,4005,-1);
	else
	ITEM1_COUNT = HowmuchItem(UID, 900287000);  
    ITEM2_COUNT = HowmuchItem(UID, 900288000); 
    ITEM3_COUNT = HowmuchItem(UID, 900289000); 	
	if (ITEM1_COUNT < 1 and ITEM2_COUNT < 1 and ITEM3_COUNT < 1) then
	SelectMsg(UID, 2, -1, 22602, NPC, 10, 5809,4005,-1);
	else
	SelectMsg(UID, 4, 768, 22254, NPC,3000,5907,3005,-1);
end
end
end

if (EVENT == 5907) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13592);
	SaveEvent(UID, 13603);
    RunExchange(UID, 3218)
	--SelectMsg(UID, 2, -1, 22602, NPC, 10, 4209,4005,-1);
end
end

if (EVENT == 6001)then
	SelectMsg(UID, 4, 769, 22256, NPC, 3000,6002,4005,-1);
end

if (EVENT == 6002)then
	SaveEvent(UID, 13603);
end

if (EVENT == 6006)then
	SaveEvent(UID, 13605);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 6007) then
	ShowMap(UID, 905);
end

if (EVENT == 6008) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13604);
	SaveEvent(UID, 13615);
    RunExchange(UID, 3219)
	SelectMsg(UID, 2, -1, 22258, NPC, 10,-1);
end
end

if (EVENT == 6301)then
	SelectMsg(UID, 4, 773, 22262, NPC, 3000,6302,4005,-1);
end

if (EVENT == 6302)then
	SaveEvent(UID, 13639);
end

if (EVENT == 6306)then
	SaveEvent(UID, 13641);
end

if (EVENT == 6305)then
	ITEM1_COUNT = HowmuchItem(UID, 900294000);  
	if (ITEM1_COUNT < 1) then
	SelectMsg(UID, 2, 773, 22262, NPC, 10, -1);
	else
	SelectMsg(UID, 4, 773, 22262, NPC, 22, 6307, 27, -1);
end
end

if (EVENT == 6307) then
    SaveEvent(UID, 13640);
	SaveEvent(UID, 13651);
    RunExchange(UID, 3222)
end

if (EVENT == 6401)then
	SelectMsg(UID, 2, 774, 22264, NPC, 3000,6402,4005,-1);
end

if (EVENT == 6402)then
	SaveEvent(UID, 13651);
end

if (EVENT == 6403)then
    SelectMsg(UID, 4, 774, 22264, NPC, 3000,6404,4005,-1);
	SaveEvent(UID, 13653);
end

if (EVENT == 6404)then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    SaveEvent(UID, 13663);
	SaveEvent(UID, 13652);
	RunExchange(UID, 3223)
end
end

if (EVENT == 6501)then
	SelectMsg(UID, 4, 775, 22266, NPC, 3000,6502,4005,-1);
end

if (EVENT == 6502)then
	SaveEvent(UID, 13663);
end

if (EVENT == 6506)then
	SaveEvent(UID, 13665);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 6507) then
	ShowMap(UID, 855);
end

if (EVENT == 6508)then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	ShowMap(UID, 792);
    SaveEvent(UID, 13664);
	SaveEvent(UID, 13675);
	RunExchange(UID, 3224)
end
end

-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=696 status=2 n_index=13004
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 696)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3169);
		SaveEvent(UID, 13006);
	end
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
