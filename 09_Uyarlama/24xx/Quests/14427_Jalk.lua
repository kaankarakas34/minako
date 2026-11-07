-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [892]={{900005000,126}},
  [894]={{900005000,126}},
  [895]={{900005000,126}},
  [1009]={{900005000,132}},
  [1010]={{900005000,132}},
  [1011]={{900005000,132}},
  [1012]={{900005000,132}},
  [1017]={{900005000,135}},
  [1018]={{900005000,135}},
  [1019]={{900005000,135}},
  [1020]={{900005000,135}},
  [1025]={{900005000,138}},
  [1026]={{900005000,138}},
  [1027]={{900005000,138}},
  [1028]={{900005000,138}},
  [1033]={{900005000,141}},
  [1034]={{900005000,141}},
  [1035]={{900005000,141}},
  [1036]={{900005000,141}},
  [1205]={{900005000,402}},
  [1207]={{900005000,406}},
  [1208]={{900005000,408}},
  [1209]={{900005000,410}},
  [1210]={{900005000,412}},
  [3024]={},
  [3025]={{910217000,1},{910219000,1},{910220000,1}},
  [3028]={{910227000,1}},
  [3057]={},
  [3058]={{900005000,568}},
  [3059]={{900005000,569}},
  [3060]={{900005000,570}},
}
local __KO_Completion = {
  [2009]={402,1205},
  [2033]={406,1207},
  [2045]={408,1208},
  [2057]={410,1209},
  [2069]={412,1210},
  [8420]={126,892},
  [8430]={126,894},
  [8435]={126,895},
  [8534]={132,1009},
  [8539]={132,1010},
  [8544]={132,1011},
  [8549]={132,1012},
  [8576]={135,1017},
  [8581]={135,1018},
  [8586]={135,1019},
  [8591]={135,1020},
  [8618]={138,1025},
  [8623]={138,1026},
  [8628]={138,1027},
  [8633]={138,1028},
  [8660]={141,1033},
  [8665]={141,1034},
  [8670]={141,1035},
  [8675]={141,1036},
  [11291]={537,3024},
  [11303]={538,3025},
  [11339]={541,3028},
  [11680]={567,3057},
  [11692]={568,3058},
  [11704]={569,3059},
  [11716]={570,3060},
}
local __KO_Quests = {
  [892]={126},
  [894]={126},
  [895]={126},
  [1009]={132},
  [1010]={132},
  [1011]={132},
  [1012]={132},
  [1017]={135},
  [1018]={135},
  [1019]={135},
  [1020]={135},
  [1025]={138},
  [1026]={138},
  [1027]={138},
  [1028]={138},
  [1033]={141},
  [1034]={141},
  [1035]={141},
  [1036]={141},
  [1205]={402},
  [1207]={406},
  [1208]={408},
  [1209]={410},
  [1210]={412},
  [3024]={537},
  [3025]={538},
  [3028]={541},
  [3057]={567},
  [3058]={568},
  [3059]={569},
  [3060]={570},
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
local NPC = 14427;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then 
		SelectMsg(UID, 2, -1, 4703, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then 
		NpcMsg(UID, 8012, NPC)
	else
		EVENT = QuestNum
	end
end

local savenum = 402;

if (EVENT == 1002) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 8141, NPC, 22, 1003, 23, -1);
	else
		SelectMsg(UID, 2, savenum, 796, NPC, 27, -1);
	end
end

if (EVENT == 1003) then
	SaveEvent(UID, 2008);
end

if (EVENT == 1010) then
	SaveEvent(UID, 2010);
end

if (EVENT == 1006) then
	MonsterCount = CountMonsterQuestSub(UID, 402, 1);
	if (MonsterCount < 10) then
		SelectMsg(UID, 2, savenum, 8143, NPC, 18, 1007);
	else
		SelectMsg(UID, 4, savenum, 8145, NPC, 22, 1008, 23, 1008);
	end
end

if (EVENT == 1007) then
	ShowMap(UID, 96);
end

if (EVENT == 1008) then
	QuestStatusCheck = GetQuestStatus(UID, 402) 
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8012, NPC, 10, -1);
	else
	MonsterCount = CountMonsterQuestSub(UID, 402, 1);
	if (MonsterCount < 10) then
		SelectMsg(UID, 2, savenum, 8143, NPC, 18, 1007);
	else
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunQuestExchange(UID,1205)
		SaveEvent(UID, 2009);
		else
		RunQuestExchange(UID,1205)
		SaveEvent(UID, 2009);

end
end
end
end

local savenum = 496;

if (EVENT == 402) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 8141, NPC, 22, 403, 23, -1);
	else
		SelectMsg(UID, 2, savenum, 796, NPC, 27, -1);
	end
end

if (EVENT == 403) then
	SaveEvent(UID, 1809);
end

if (EVENT == 409) then
	SaveEvent(UID, 1811);
end

if (EVENT == 406) then
	MonsterCount = CountMonsterQuestSub(UID, 499, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, savenum, 8143, NPC, 18, 407);
	else
		SelectMsg(UID, 4, savenum, 8145, NPC, 22, 1008, 23, 1008);
	end
end

if (EVENT == 407) then
	ShowMap(UID, 245);
end

if (EVENT == 411) then
	QuestStatusCheck = GetQuestStatus(UID, 499) 
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8012, NPC, 10, -1);
	else
	MonsterCount = CountMonsterQuestSub(UID, 499, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, savenum, 8143, NPC, 18, 407);
	else
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunQuestExchange(UID,1185)
		SaveEvent(UID, 2009);
		else
		RunQuestExchange(UID,1173)
		SaveEvent(UID, 2009);

end
end
end
end

local savenum1 = 126;

if (EVENT == 8702) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum1, 8141, NPC, 22, 8703, 23, -1);
	else
		SelectMsg(UID, 2, savenum1, 796, NPC, 27, -1);
	end
end

if (EVENT == 8703) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 8419);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8424);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8429);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8434);
	end
end

if (EVENT == 8710) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 8421);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8426);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8431);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8436);
	end
end

if (EVENT == 8706) then
	MonsterCount = CountMonsterQuestSub(UID, 126 ,1);
	if (MonsterCount < 15) then
		SelectMsg(UID, 2, savenum1, 8143, NPC, 18, 8707);
	else
		SelectMsg(UID, 5, savenum1, 8145, NPC, 22, 8708,23,-1);
	end
end

if (EVENT == 8707) then
	ShowMap(UID, 96);
end

if (EVENT == 8708) then
	QuestStatusCheck = GetQuestStatus(UID, 126)
	SlotCheck = CheckGiveSlot(UID, 1)
	if SlotCheck == false then
	elseif(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8012, NPC, 10, -1);
	else
	MonsterCount = CountMonsterQuestSub(UID, 126 ,1);
	if (MonsterCount < 15) then
		SelectMsg(UID, 2, savenum1, 8143, NPC, 18, 8707);
	else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
RunQuestExchange(UID,892,STEP,1);
		SaveEvent(UID, 8420);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunQuestExchange(UID,893,STEP,1);
		--SaveEvent(UID, 8425);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunQuestExchange(UID,894,STEP,1);
		SaveEvent(UID, 8430);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunQuestExchange(UID,895,STEP,1);
		SaveEvent(UID, 8435);
end
end
end
end

local savenum2 = 406;

if (EVENT == 1102) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum2, 8338, NPC, 22, 1103, 23, -1);
	else
		SelectMsg(UID, 2, savenum2, 8366, NPC, 27, -1);
	end
end

if (EVENT == 1103) then
	SaveEvent(UID, 2032);
end

if (EVENT == 1110) then
	SaveEvent(UID, 2034);
end

if (EVENT == 1106) then
	MonsterCount = CountMonsterQuestSub(UID, 406, 1);
	if (MonsterCount < 10) then
		SelectMsg(UID, 2, savenum2, 8143, NPC, 18, 1107);
	else
		SelectMsg(UID, 4, savenum2, 8145, NPC, 22, 1108, 23, -1);
	end
end

if (EVENT == 1107) then
	ShowMap(UID, 100);
end

if (EVENT == 1108) then
	QuestStatusCheck = GetQuestStatus(UID, 406) 
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8012, NPC, 10, -1);
	else
	MonsterCount = CountMonsterQuestSub(UID, 406, 1);
	if (MonsterCount < 10) then
		SelectMsg(UID, 2, savenum2, 8143, NPC, 18, 1107);
	else
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunQuestExchange(UID,1207)
		SaveEvent(UID, 2033);
	else
		RunQuestExchange(UID,1207)
		SaveEvent(UID, 2033);
	end
end
end
end

local savenum3 = 132;

if (EVENT == 8302) then -- 37 Level Saber Tooth
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum3, 8141, NPC, 22, 8303, 23, -1);
	else
		SelectMsg(UID, 2, savenum3, 796, NPC, 27, -1);
	end
end

if (EVENT == 8303) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 8533);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8538);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8543);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8548);
	end
end

if (EVENT == 8310) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 8535);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8540);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8545);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8550);
	end
end

if (EVENT == 8306) then
	MonsterCount = CountMonsterQuestSub(UID, 132, 1);
	if (MonsterCount < 15) then
		SelectMsg(UID, 2, savenum3, 8143, NPC, 18, 8307);
	else
		SelectMsg(UID, 4, savenum3, 8145, NPC, 22, 8308, 23, -1);
	end
end

if (EVENT == 8307) then
	ShowMap(UID, 100);
end

if (EVENT == 8308) then
	QuestStatusCheck = GetQuestStatus(UID, 132) 
	SlotCheck = CheckGiveSlot(UID, 1)
	if SlotCheck == false then
	elseif(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8012, NPC, 10, -1);
	else
	MonsterCount = CountMonsterQuestSub(UID, 132, 1);
	if (MonsterCount < 15) then
		SelectMsg(UID, 2, savenum3, 8143, NPC, 18, 8307);
	else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then 
RunQuestExchange(UID,1009)
		SaveEvent(UID, 8534);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunQuestExchange(UID,1010)
		SaveEvent(UID, 8539);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunQuestExchange(UID,1011)
		SaveEvent(UID, 8544);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunQuestExchange(UID,1012)
		SaveEvent(UID, 8549);
end
end
end
end

local savenum4 = 408;

if (EVENT == 1302) then -- 38 Level Skeleton Warrior Premium
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum4, 8071, NPC, 22, 1303, 23, -1);
	else
		SelectMsg(UID, 2, savenum4, 8366, NPC, 27, -1);
	end
end

if (EVENT == 1303) then
	SaveEvent(UID, 2044);
end

if (EVENT == 1310) then
	SaveEvent(UID, 2046);
end

if (EVENT == 1306) then
	MonsterCount = CountMonsterQuestSub(UID, 408, 1);
	if (MonsterCount < 10) then
		SelectMsg(UID, 2, savenum4, 8143, NPC, 18, 1307);
	else
		SelectMsg(UID, 4, savenum4, 8145, NPC, 22, 1308, 23, -1);
	end
end

if (EVENT == 1307) then
	ShowMap(UID, 102);
end

if (EVENT == 1308) then
	QuestStatusCheck = GetQuestStatus(UID, 408) 
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8012, NPC, 10, -1);
	else
	MonsterCount = CountMonsterQuestSub(UID, 408, 1);
	if (MonsterCount < 10) then
		SelectMsg(UID, 2, savenum4, 8143, NPC, 18, 1307);
	else
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunQuestExchange(UID,1208)
		SaveEvent(UID, 2045);
	else
		RunQuestExchange(UID,1208)
		SaveEvent(UID, 2045);
	end
end
end
end

local savenum5 = 135;

if (EVENT == 8202) then -- 38 Level Skeleton Warrior
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum5, 8071, NPC, 22, 8203, 23, -1);
	else
		SelectMsg(UID, 2, savenum5, 8366, NPC, 27, -1);
	end
end

if (EVENT == 8203) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 8575);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8580);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8585);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8590);
	end
end

if (EVENT == 8210) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 8577);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8582);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8587);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8592);
	end
end

if (EVENT == 8206) then
	MonsterCount = CountMonsterQuestSub(UID, 135, 1);
	if (MonsterCount < 15) then
		SelectMsg(UID, 2, savenum5, 8143, NPC, 18, 8207);
	else
		SelectMsg(UID, 4, savenum5, 8145, NPC, 22, 8208, 23, -1);
	end
end

if (EVENT == 8207) then
	ShowMap(UID, 102); 
end

if (EVENT == 8208) then
	QuestStatusCheck = GetQuestStatus(UID, 135)
	SlotCheck = CheckGiveSlot(UID, 1)
	if SlotCheck == false then
	elseif(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8012, NPC, 10, -1);
	else
	MonsterCount = CountMonsterQuestSub(UID, 135, 1);
	if (MonsterCount < 15) then
		SelectMsg(UID, 2, savenum5, 8143, NPC, 18, 8207);
	else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
RunQuestExchange(UID,1017)
		SaveEvent(UID, 8576);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunQuestExchange(UID,1018)
		SaveEvent(UID, 8581);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunQuestExchange(UID,1019)
		SaveEvent(UID, 8586);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunQuestExchange(UID,1020)
		SaveEvent(UID, 8591);
end
end
end
end

local savenum6 = 410;

if (EVENT == 1402) then -- 39 Level Skeleton Knight Premium
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum6, 8352, NPC, 22, 1403, 23, -1);
	else
		SelectMsg(UID, 2, savenum6, 8356, NPC, 27, -1);
	end
end

if (EVENT == 1403) then
	SaveEvent(UID, 2056);
end

if (EVENT == 1410) then
	SaveEvent(UID, 2058);
end

if (EVENT == 1406) then
	MonsterCount = CountMonsterQuestSub(UID, 410, 1);
	if (MonsterCount < 10) then
		SelectMsg(UID, 2, savenum6, 8357, NPC, 18, 1407);
	else
		SelectMsg(UID, 4, savenum6, 8358, NPC, 22, 1408, 23, -1);
	end
end

if (EVENT == 1407) then
	ShowMap(UID, 104);
end

if (EVENT == 1408) then
	QuestStatusCheck = GetQuestStatus(UID, 410)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8012, NPC, 10, -1);
	else
	MonsterCount = CountMonsterQuestSub(UID, 410, 1);
	if (MonsterCount < 10) then
		SelectMsg(UID, 2, savenum6, 8357, NPC, 18, 1407);
	else
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunQuestExchange(UID,1209)
		SaveEvent(UID, 2057);
	else
		RunQuestExchange(UID,1209)
		SaveEvent(UID, 2057);
	end
end
end
end

local savenum7 = 138;

if (EVENT == 8102) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum7, 8352, NPC, 22, 8103, 23, -1);
	else
		SelectMsg(UID, 2, savenum7, 8356, NPC, 27, -1);
	end
end

if (EVENT == 8103) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 8617);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8622);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8627);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8632);
	end
end

if (EVENT == 8110) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 8619);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8624);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8629);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8634);
	end
end

if (EVENT == 8106) then
	MonsterCount = CountMonsterQuestSub(UID, 138, 1);
	if (MonsterCount < 15) then
		SelectMsg(UID, 2, savenum7, 8357, NPC, 18, 8107);
	else
		SelectMsg(UID, 4, savenum7, 8358, NPC, 22, 8108, 23, -1);
	end
end

if (EVENT == 8107) then
	ShowMap(UID, 104);
end

if (EVENT == 8108) then
	QuestStatusCheck = GetQuestStatus(UID, 138)
	SlotCheck = CheckGiveSlot(UID, 1)
	if SlotCheck == false then
	elseif(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8012, NPC, 10, -1);
	else
	MonsterCount = CountMonsterQuestSub(UID, 138, 1);
	if (MonsterCount < 15) then
		SelectMsg(UID, 2, savenum7, 8357, NPC, 18, 8107);
	else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
RunQuestExchange(UID,1025)
		SaveEvent(UID, 8618);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunQuestExchange(UID,1026)
		SaveEvent(UID, 8623);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunQuestExchange(UID,1027)
		SaveEvent(UID, 8628);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunQuestExchange(UID,1028)
		SaveEvent(UID, 8633);
end
end
end
end

local savenum8 = 412;

if (EVENT == 1502) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum8, 8360, NPC, 22, 1503, 23, -1);
	else
		SelectMsg(UID, 2, savenum8, 8356, NPC, 27, -1);
	end
end

if (EVENT == 1503) then
	SaveEvent(UID, 2068);
end

if (EVENT == 1510) then
	SaveEvent(UID, 2070);
end

if (EVENT == 1506) then
	MonsterCount = CountMonsterQuestSub(UID, 412, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, savenum8, 8357, NPC, 18, 1507);
	else
		SelectMsg(UID, 4, savenum8, 8358, NPC, 22, 1508, 23, -1);
	end
end

if (EVENT == 1507) then
	ShowMap(UID, 106);
end

if (EVENT == 1508) then
	QuestStatusCheck = GetQuestStatus(UID, 412) 
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8012, NPC, 10, -1);
	else
	MonsterCount = CountMonsterQuestSub(UID, 412, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, savenum8, 8357, NPC, 18, 1507);
	else
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunQuestExchange(UID,1210)
		SaveEvent(UID, 2069);
	else
		RunQuestExchange(UID,1210)
		SaveEvent(UID, 2069);
	end
end
end
end

local savenum9 = 141;

if (EVENT == 8022) then
	DeathKnight2SCount = ExistMonsterQuestSub(UID);
	if (DeathKnight2SCount == 0) then
		SelectMsg(UID, 4, savenum9, 8352, NPC, 22, 8023, 23, -1);
	else
		SelectMsg(UID, 2, savenum9, 8356, NPC, 27, -1);
	end
end

if (EVENT == 8023) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 8659);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8664);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8669);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8674);
	end
end

if (EVENT == 8030) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 8661);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8666);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8671);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8676);
	end
end

if (EVENT == 8026) then
	MonsterCount = CountMonsterQuestSub(UID, 141, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, savenum9, 8357, NPC, 18, 8027);
	else
		SelectMsg(UID, 4, savenum9, 8358, NPC, 22, 8028, 23, -1);
	end
end

if (EVENT == 8027) then
	ShowMap(UID, 106);
end

if (EVENT == 8028) then
	QuestStatusCheck = GetQuestStatus(UID, 141) 
	SlotCheck = CheckGiveSlot(UID, 3)
	if SlotCheck == false then
	elseif(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8012, NPC, 10, -1);
	else
	MonsterCount = CountMonsterQuestSub(UID, 141, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, savenum9, 8357, NPC, 18, 8027);
	else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
RunQuestExchange(UID,1033)
		SaveEvent(UID, 8660);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunQuestExchange(UID,1034)
		SaveEvent(UID, 8665);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunQuestExchange(UID,1035)
		SaveEvent(UID, 8670);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunQuestExchange(UID,1036)
		SaveEvent(UID, 8675);
end
end
end
end

if (EVENT == 1602)then
	SelectMsg(UID, 4, 537, 20043, NPC, 22, 1603,23,-1);
end

if (EVENT == 1603)then
	SaveEvent(UID, 11290);
	SaveEvent(UID, 11292);
end

if (EVENT == 1605)then
	SelectMsg(UID, 2, 537, 20043, NPC, 10,-1);
	SaveEvent(UID, 11291);
	SaveEvent(UID, 11302);
end

if (EVENT == 1702)then
	SelectMsg(UID, 4, 538, 20045, NPC, 22, 1703,23,-1);
end

if (EVENT == 1703)then
SaveEvent(UID, 11302);
end

if (EVENT == 1706)then
SaveEvent(UID, 11304);
end

if (EVENT == 1705) then
		SelectMsg(UID, 4, 538, 20045, NPC, 22, 1707, 27, -1); 
end

if (EVENT == 1707)then
RunQuestExchange(UID,3025)
	SaveEvent(UID,11303)
	SaveEvent(UID,11314)
end


if (EVENT == 1802)then
	SelectMsg(UID, 4, 541, 20051, NPC, 22, 1803,23,-1);
end

if (EVENT == 1803)then
SaveEvent(UID, 11338);
end

if (EVENT == 1808)then
SaveEvent(UID, 11340);
end


if (EVENT == 1805) then
	ITEM1_COUNT = HowmuchItem(UID, 910227000);   
	if (ITEM1_COUNT < 1) then
		SelectMsg(UID, 2, 541, 20051, NPC, 18,-1);
	else
		SelectMsg(UID, 4, 541, 20051, NPC, 22, 1806, 27, -1);
end
end		
	
	
if (EVENT == 1806)then
	QuestStatusCheck = GetQuestStatus(UID, 541) 
	SlotCheck = CheckGiveSlot(UID, 1)
	if SlotCheck == false then
	elseif(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8012, NPC, 10, -1);
	else
	ITEM1_COUNT = HowmuchItem(UID, 910227000);   
	if (ITEM1_COUNT < 1) then
		SelectMsg(UID, 2, 541, 20051, NPC, 18,-1);
	else
RunQuestExchange(UID,3028)
	SaveEvent(UID,11339)
	SaveEvent(UID,11350)
	SelectMsg(UID, 2, 541, 20343, NPC, 10,-1);
end
end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=496 status=2 n_index=1810
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 496)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 1186);
		SaveEvent(UID, 1812);
	end
end

-- [AUTO-GEN] quest=402 status=2 n_index=2009
if (EVENT == 190) then
	SearchQuest(UID, 14427);
end

-- [AUTO-GEN] quest=541 status=2 n_index=11339
if (EVENT == 193) then
	QuestStatusCheck = GetQuestStatus(UID, 541)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3028);
		SaveEvent(UID, 11341);
	end
end

-- [AUTO-GEN] quest=499 status=255 n_index=1802
if (EVENT == 400) then
	SaveEvent(UID, 1803);
end

-- [AUTO-GEN] quest=402 status=255 n_index=2006
if (EVENT == 1000) then
	SaveEvent(UID, 2007);
end

-- [AUTO-GEN] quest=406 status=255 n_index=2030
if (EVENT == 1100) then
	SaveEvent(UID, 2031);
end

-- [AUTO-GEN] quest=408 status=255 n_index=2042
if (EVENT == 1300) then
	SaveEvent(UID, 2043);
end

-- [AUTO-GEN] quest=410 status=255 n_index=2054
if (EVENT == 1400) then
	SaveEvent(UID, 2055);
end

-- [AUTO-GEN] quest=412 status=255 n_index=2066
if (EVENT == 1500) then
	SaveEvent(UID, 2067);
end

-- [AUTO-GEN] quest=412 status=1 n_index=2068
if (EVENT == 1530) then
	QuestStatusCheck = GetQuestStatus(UID, 412)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 1210);
		SaveEvent(UID, 2069);
	end
end

-- [AUTO-GEN] quest=537 status=255 n_index=11288
if (EVENT == 1600) then
	SaveEvent(UID, 11289);
end

-- [AUTO-GEN] quest=538 status=255 n_index=11300
if (EVENT == 1700) then
	SaveEvent(UID, 11301);
end

-- [AUTO-GEN] quest=541 status=255 n_index=11336
if (EVENT == 1800) then
	SaveEvent(UID, 11337);
end

-- [AUTO-GEN] quest=567 status=255 n_index=11677
if (EVENT == 1900) then
	SaveEvent(UID, 11678);
end

-- [AUTO-GEN] quest=567 status=0 n_index=11678
if (EVENT == 1902) then
	SelectMsg(UID, 4, 567, 20103, NPC, 3103, 1903, 23, -1);
end

-- [AUTO-GEN] quest=567 status=1 n_index=11679
if (EVENT == 1903) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 567, 20103, NPC, 18, 1905);
	else
		SelectMsg(UID, 4, 567, 20103, NPC, 41, 1904, 27, -1);
	end
end

-- [AUTO-GEN] quest=567 status=1 n_index=11679
if (EVENT == 1904) then
	QuestStatusCheck = GetQuestStatus(UID, 567)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3057);
		SaveEvent(UID, 11680);
	end
end

-- [AUTO-GEN] quest=567 status=3 n_index=11681
if (EVENT == 1905) then
	SelectMsg(UID, 2, 567, 20103, NPC, 10, -1);
end

-- [AUTO-GEN] quest=568 status=255 n_index=11689
if (EVENT == 2000) then
	SaveEvent(UID, 11690);
end

-- [AUTO-GEN] quest=568 status=0 n_index=11690
if (EVENT == 2002) then
	SelectMsg(UID, 4, 568, 20105, NPC, 3105, 2003, 23, -1);
end

-- [AUTO-GEN] quest=568 status=0 n_index=11690
if (EVENT == 2003) then
	SaveEvent(UID, 11691);
end

-- [AUTO-GEN] quest=568 status=1 n_index=11691
if (EVENT == 2005) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 568, 20105, NPC, 22, 2006, 23, -1);
	else
		SelectMsg(UID, 2, 568, 20105, NPC, 18, 2006);
	end
end

-- [AUTO-GEN] quest=568 status=1 n_index=11691
if (EVENT == 2006) then
	QuestStatusCheck = GetQuestStatus(UID, 568)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3058);
		SaveEvent(UID, 11692);
	end
end

-- [AUTO-GEN] quest=569 status=255 n_index=11701
if (EVENT == 2100) then
	SaveEvent(UID, 11702);
end

-- [AUTO-GEN] quest=569 status=0 n_index=11702
if (EVENT == 2102) then
	SelectMsg(UID, 4, 569, 20107, NPC, 3107, 2103, 23, -1);
end

-- [AUTO-GEN] quest=569 status=0 n_index=11702
if (EVENT == 2103) then
	SaveEvent(UID, 11703);
end

-- [AUTO-GEN] quest=569 status=1 n_index=11703
if (EVENT == 2105) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 569, 20107, NPC, 22, 2106, 23, -1);
	else
		SelectMsg(UID, 2, 569, 20107, NPC, 18, 2106);
	end
end

-- [AUTO-GEN] quest=569 status=1 n_index=11703
if (EVENT == 2106) then
	QuestStatusCheck = GetQuestStatus(UID, 569)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3059);
		SaveEvent(UID, 11704);
	end
end

-- [AUTO-GEN] quest=570 status=255 n_index=11713
if (EVENT == 2200) then
	SaveEvent(UID, 11714);
end

-- [AUTO-GEN] quest=570 status=0 n_index=11714
if (EVENT == 2202) then
	SelectMsg(UID, 4, 570, 20109, NPC, 3109, 2203, 23, -1);
end

-- [AUTO-GEN] quest=570 status=0 n_index=11714
if (EVENT == 2203) then
	SaveEvent(UID, 11715);
end

-- [AUTO-GEN] quest=570 status=1 n_index=11715
if (EVENT == 2205) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 570, 20109, NPC, 22, 2206, 23, -1);
	else
		SelectMsg(UID, 2, 570, 20109, NPC, 18, 2206);
	end
end

-- [AUTO-GEN] quest=570 status=1 n_index=11715
if (EVENT == 2206) then
	QuestStatusCheck = GetQuestStatus(UID, 570)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3060);
		SaveEvent(UID, 11716);
	end
end

-- [AUTO-GEN] quest=141 status=255 n_index=8657
if (EVENT == 8020) then
	SaveEvent(UID, 8658);
end

-- [AUTO-GEN] quest=138 status=255 n_index=8615
if (EVENT == 8100) then
	SaveEvent(UID, 8616);
end

-- [AUTO-GEN] quest=135 status=255 n_index=8573
if (EVENT == 8200) then
	SaveEvent(UID, 8574);
end

-- [AUTO-GEN] quest=132 status=255 n_index=8531
if (EVENT == 8300) then
	SaveEvent(UID, 8532);
end

-- [AUTO-GEN] quest=126 status=255 n_index=8417
if (EVENT == 8700) then
	SaveEvent(UID, 8418);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
