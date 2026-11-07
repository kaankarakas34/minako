-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [18]={{900005000,274}},
  [192]={{900037000,1}},
  [1101]={{900005000,318}},
  [3078]={},
  [3079]={{900005000,589}},
  [3080]={{900005000,590}},
  [3082]={{900005000,593}},
  [3084]={{910238000,1}},
  [3088]={},
  [3089]={{900005000,600}},
  [13081]={{900005000,592}},
}
local __KO_Completion = {
  [1287]={190,192},
  [1694]={274,18},
  [9443]={318,1101},
  [11933]={588,3078},
  [11945]={589,3079},
  [11957]={590,3080},
  [11969]={592,13081},
  [11981]={593,3082},
  [12005]={595,3084},
  [12053]={599,3088},
  [12065]={600,3089},
}
local __KO_Quests = {
  [18]={274},
  [192]={190},
  [1101]={318},
  [3078]={588},
  [3079]={589},
  [3080]={590},
  [3082]={593},
  [3084]={595},
  [3088]={599},
  [3089]={600},
  [13081]={592},
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
if EVENT == 120 or EVENT == 122 or EVENT == 123 or EVENT == 125 or EVENT == 128 or EVENT == 1002 or EVENT == 1003 or EVENT == 1005 or EVENT == 1102 or EVENT == 1105 or EVENT == 1106 or EVENT == 1202 or EVENT == 1205 or EVENT == 1206 or EVENT == 1302 or EVENT == 1305 or EVENT == 1306 then
  SelectMsg(UID, 2, -1, 10526, 32532, 10, -1)
  return
end
local Ret = 0;
local NPC = 32532;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 8996, NPC, 10, 101);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 8996, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 101) then
	Ret = 1;
end

local savenum = 981;

if (EVENT == 110) then -- 60 Level Paramun
	SaveEvent(UID, 1692);
end

if (EVENT == 111) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 8996, NPC, 22, 112, 23, 113);
	else
		SelectMsg(UID, 2, savenum, 8996, NPC, 10, 101);
	end
end

if (EVENT == 112) then
	SaveEvent(UID, 1693);
end

if (EVENT == 113) then
	SaveEvent(UID, 1696);
end

if (EVENT == 115) then
	SaveEvent(UID, 1695);
end

if (EVENT == 116) then
	MonsterCount = CountMonsterQuestSub(UID, 981, 1);
	if (MonsterCount < 200) then
		SelectMsg(UID, 2, savenum, 8996, NPC, 18, 117);
	else
		SelectMsg(UID, 4, savenum, 8996, NPC, 41, 118, 23, 117);
	end
end

if (EVENT == 117) then
	ShowMap(UID, 79);
end

if (EVENT == 118) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 1100000);
		SaveEvent(UID, 1694);
	else
		ExpChange(UID, 550000);
		SaveEvent(UID, 1694);
	end
end

local savenum = 1078;

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 121) then
	SelectMsg(UID, 4, savenum, 1597, NPC, 22, 122, 23, 123);
end

-- Unsupported EVENT branch is retained in the review copy.


-- Unsupported EVENT branch is retained in the review copy.


-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 126) then
	ITEMP = HowmuchItem(UID, 900037000);
	if (ITEMP < 1) then
		SelectMsg(UID, 2, savenum, 1597, NPC, 21, 127);
	else
		SelectMsg(UID, 4, savenum, 1597, NPC, 4006, 128, 4005, 101);
	end
end

if (EVENT == 127) then
	ShowMap(UID, 356);
end

-- Unsupported EVENT branch is retained in the review copy.


local savenum = 906;

if (EVENT == 9400) then -- 66 Level Duke & Bishop & Bach
	SaveEvent(UID, 9441);
end

if (EVENT == 9402) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 8692, NPC, 22, 9403, 23, 9404);
	else
		SelectMsg(UID, 2, savenum, 8692, NPC, 10, 101);
	end
end

if (EVENT == 9403) then
	SaveEvent(UID, 9442);
end

if (EVENT == 9404) then
	SaveEvent(UID, 9445);
end

if (EVENT == 9405) then
	SaveEvent(UID, 9444);
end

if (EVENT == 9407) then
	MonsterCount1 = CountMonsterQuestSub(UID, 906, 1);
	MonsterCount2 = CountMonsterQuestSub(UID, 1207, 1);
	MonsterCount2 = CountMonsterQuestSub(UID, 1206, 1);
	if (MonsterCount1 > 0 and MonsterCount2 > 0 or MonsterCount3 > 0) then
		SelectMsg(UID, 4, savenum, 8692, NPC, 41, 9409, 23, 101);
	else
		if (MonsterCount1 < 1) then
			SelectMsg(UID, 2, savenum, 8692, NPC, 18, 9408);
		elseif (MonsterCount2 < 1) then
			SelectMsg(UID, 2, savenum, 8692, NPC, 18, 1000);
		elseif (MonsterCount2 < 1) then
			SelectMsg(UID, 2, savenum, 8692, NPC, 18, 1001);
		end
	end
end

if (EVENT == 9408) then
	ShowMap(UID, 614);
end

if (EVENT == 1000) then
	ShowMap(UID, 613);
end

if (EVENT == 1001) then
	ShowMap(UID, 612);
end

if (EVENT == 9409) then
	ExpChange(UID, 21000000)
	SaveEvent(UID, 9443);
end

-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=190 status=0 n_index=1285
if (EVENT == 200) then
	SelectMsg(UID, 4, 190, 8880, NPC, 172, 201, 23, -1);
end

-- [AUTO-GEN] quest=190 status=0 n_index=1285
if (EVENT == 201) then
	SaveEvent(UID, 1286);
end

-- [AUTO-GEN] quest=190 status=1 n_index=1286
if (EVENT == 220) then
	QuestStatusCheck = GetQuestStatus(UID, 190)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 192);
		SaveEvent(UID, 1287);
	end
end

-- [AUTO-GEN] quest=318 status=2 n_index=9443
if (EVENT == 190) then
	SearchQuest(UID, 32532);
end

-- [AUTO-GEN] quest=577 status=255 n_index=11798
if (EVENT == 1100) then
	SaveEvent(UID, 11799);
end

-- [AUTO-GEN] quest=578 status=255 n_index=11810
if (EVENT == 1200) then
	SaveEvent(UID, 11811);
end

-- [AUTO-GEN] quest=579 status=255 n_index=11822
if (EVENT == 1300) then
	SaveEvent(UID, 11823);
end

-- [AUTO-GEN] quest=588 status=255 n_index=11930
if (EVENT == 1400) then
	SaveEvent(UID, 11931);
end

-- [AUTO-GEN] quest=588 status=0 n_index=11931
if (EVENT == 1402) then
	SelectMsg(UID, 4, 588, 20747, NPC, 3145, 1403, 23, -1);
end

-- [AUTO-GEN] quest=588 status=1 n_index=11932
if (EVENT == 1403) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 588, 20747, NPC, 18, 1405);
	else
		SelectMsg(UID, 4, 588, 20747, NPC, 41, 1404, 27, -1);
	end
end

-- [AUTO-GEN] quest=588 status=1 n_index=11932
if (EVENT == 1404) then
	QuestStatusCheck = GetQuestStatus(UID, 588)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3078);
		SaveEvent(UID, 11933);
	end
end

-- [AUTO-GEN] quest=588 status=3 n_index=11934
if (EVENT == 1405) then
	SelectMsg(UID, 2, 588, 20747, NPC, 10, -1);
end

-- [AUTO-GEN] quest=589 status=255 n_index=11942
if (EVENT == 1500) then
	SaveEvent(UID, 11943);
end

-- [AUTO-GEN] quest=589 status=0 n_index=11943
if (EVENT == 1502) then
	SelectMsg(UID, 4, 589, 20749, NPC, 3147, 1503, 23, -1);
end

-- [AUTO-GEN] quest=589 status=0 n_index=11943
if (EVENT == 1503) then
	SaveEvent(UID, 11944);
end

-- [AUTO-GEN] quest=589 status=1 n_index=11944
if (EVENT == 1505) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 589, 20749, NPC, 22, 1506, 23, -1);
	else
		SelectMsg(UID, 2, 589, 20749, NPC, 18, 1506);
	end
end

-- [AUTO-GEN] quest=589 status=1 n_index=11944
if (EVENT == 1506) then
	QuestStatusCheck = GetQuestStatus(UID, 589)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3079);
		SaveEvent(UID, 11945);
	end
end

-- [AUTO-GEN] quest=590 status=255 n_index=11954
if (EVENT == 1600) then
	SaveEvent(UID, 11955);
end

-- [AUTO-GEN] quest=590 status=0 n_index=11955
if (EVENT == 1602) then
	SelectMsg(UID, 4, 590, 20751, NPC, 3149, 1603, 23, -1);
end

-- [AUTO-GEN] quest=590 status=0 n_index=11955
if (EVENT == 1603) then
	SaveEvent(UID, 11956);
end

-- [AUTO-GEN] quest=590 status=1 n_index=11956
if (EVENT == 1605) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 590, 20751, NPC, 22, 1606, 23, -1);
	else
		SelectMsg(UID, 2, 590, 20751, NPC, 18, 1606);
	end
end

-- [AUTO-GEN] quest=590 status=1 n_index=11956
if (EVENT == 1606) then
	QuestStatusCheck = GetQuestStatus(UID, 590)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3080);
		SaveEvent(UID, 11957);
	end
end

-- [AUTO-GEN] quest=592 status=255 n_index=11966
if (EVENT == 1700) then
	SaveEvent(UID, 11967);
end

-- [AUTO-GEN] quest=592 status=0 n_index=11967
if (EVENT == 1702) then
	SelectMsg(UID, 4, 592, 20753, NPC, 3151, 1703, 23, -1);
end

-- [AUTO-GEN] quest=592 status=0 n_index=11967
if (EVENT == 1703) then
	SaveEvent(UID, 11968);
end

-- [AUTO-GEN] quest=592 status=1 n_index=11968
if (EVENT == 1705) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 592, 20753, NPC, 22, 1706, 23, -1);
	else
		SelectMsg(UID, 2, 592, 20753, NPC, 18, 1706);
	end
end

-- [AUTO-GEN] quest=592 status=1 n_index=11968
if (EVENT == 1706) then
	QuestStatusCheck = GetQuestStatus(UID, 592)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 13081);
		SaveEvent(UID, 11969);
	end
end

-- [AUTO-GEN] quest=593 status=255 n_index=11978
if (EVENT == 1800) then
	SaveEvent(UID, 11979);
end

-- [AUTO-GEN] quest=593 status=0 n_index=11979
if (EVENT == 1802) then
	SelectMsg(UID, 4, 593, 20755, NPC, 3153, 1803, 23, -1);
end

-- [AUTO-GEN] quest=593 status=0 n_index=11979
if (EVENT == 1803) then
	SaveEvent(UID, 11980);
end

-- [AUTO-GEN] quest=593 status=1 n_index=11980
if (EVENT == 1805) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 593, 20755, NPC, 22, 1806, 23, -1);
	else
		SelectMsg(UID, 2, 593, 20755, NPC, 18, 1806);
	end
end

-- [AUTO-GEN] quest=593 status=1 n_index=11980
if (EVENT == 1806) then
	QuestStatusCheck = GetQuestStatus(UID, 593)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3082);
		SaveEvent(UID, 11981);
	end
end

-- [AUTO-GEN] quest=595 status=255 n_index=12002
if (EVENT == 1900) then
	SaveEvent(UID, 12003);
end

-- [AUTO-GEN] quest=595 status=0 n_index=12003
if (EVENT == 1902) then
	SelectMsg(UID, 4, 595, 20759, NPC, 3157, 1903, 23, -1);
end

-- [AUTO-GEN] quest=595 status=0 n_index=12003
if (EVENT == 1903) then
	SaveEvent(UID, 12004);
end

-- [AUTO-GEN] quest=595 status=1 n_index=12004
if (EVENT == 1905) then
	ItemA = HowmuchItem(UID, 910238000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 595, 20759, NPC, 18, 1906);
	else
		SelectMsg(UID, 4, 595, 20759, NPC, 41, 1906, 27, -1);
	end
end

-- [AUTO-GEN] quest=595 status=1 n_index=12004
if (EVENT == 1906) then
	QuestStatusCheck = GetQuestStatus(UID, 595)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3084);
		SaveEvent(UID, 12005);
	end
end

-- [AUTO-GEN] quest=599 status=255 n_index=12050
if (EVENT == 2000) then
	SaveEvent(UID, 12051);
end

-- [AUTO-GEN] quest=599 status=0 n_index=12051
if (EVENT == 2002) then
	SelectMsg(UID, 4, 599, 20767, NPC, 3165, 2003, 23, -1);
end

-- [AUTO-GEN] quest=599 status=1 n_index=12052
if (EVENT == 2003) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 599, 20767, NPC, 18, 2005);
	else
		SelectMsg(UID, 4, 599, 20767, NPC, 41, 2004, 27, -1);
	end
end

-- [AUTO-GEN] quest=599 status=1 n_index=12052
if (EVENT == 2004) then
	QuestStatusCheck = GetQuestStatus(UID, 599)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3088);
		SaveEvent(UID, 12053);
	end
end

-- [AUTO-GEN] quest=599 status=3 n_index=12054
if (EVENT == 2005) then
	SelectMsg(UID, 2, 599, 20767, NPC, 10, -1);
end

-- [AUTO-GEN] quest=600 status=255 n_index=12062
if (EVENT == 2100) then
	SaveEvent(UID, 12063);
end

-- [AUTO-GEN] quest=600 status=0 n_index=12063
if (EVENT == 2102) then
	SelectMsg(UID, 4, 600, 20769, NPC, 3167, 2103, 23, -1);
end

-- [AUTO-GEN] quest=600 status=0 n_index=12063
if (EVENT == 2103) then
	SaveEvent(UID, 12064);
end

-- [AUTO-GEN] quest=600 status=1 n_index=12064
if (EVENT == 2105) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 600, 20769, NPC, 22, 2106, 23, -1);
	else
		SelectMsg(UID, 2, 600, 20769, NPC, 18, 2106);
	end
end

-- [AUTO-GEN] quest=600 status=1 n_index=12064
if (EVENT == 2106) then
	QuestStatusCheck = GetQuestStatus(UID, 600)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3089);
		SaveEvent(UID, 12065);
	end
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
