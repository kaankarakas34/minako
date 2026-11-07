-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [47]={{810418000,3}},
  [48]={{810418000,3}},
  [49]={{810418000,3}},
  [50]={{810418000,3}},
  [814]={{900005000,103}},
  [815]={{900005000,103}},
  [816]={{900005000,103}},
  [817]={{900005000,103}},
  [820]={{900005000,104}},
  [821]={{900005000,104}},
  [822]={{900005000,104}},
  [823]={{900005000,104}},
  [824]={{900005000,101}},
  [825]={{900005000,101}},
  [826]={{900005000,101}},
  [827]={{900005000,101}},
  [828]={{900005000,108}},
  [829]={{900005000,108}},
  [830]={{900005000,108}},
  [831]={{900005000,108}},
  [832]={{900005000,105}},
  [833]={{900005000,105}},
  [834]={{900005000,105}},
  [835]={{900005000,105}},
  [848]={{900005000,113}},
  [849]={{900005000,113}},
  [850]={{900005000,113}},
  [851]={{900005000,113}},
  [856]={{900005000,116}},
  [857]={{900005000,116}},
  [858]={{900005000,116}},
  [859]={{900005000,116}},
  [864]={{900005000,118}},
  [865]={{900005000,118}},
  [866]={{900005000,118}},
  [867]={{900005000,118}},
  [872]={{900005000,120}},
  [873]={{900005000,120}},
  [874]={{900005000,120}},
  [875]={{900005000,120}},
  [880]={{900005000,122}},
  [881]={{900005000,122}},
  [882]={{900005000,122}},
  [883]={{900005000,122}},
  [1086]={{900005000,100}},
}
local __KO_Completion = {
  [485]={109,47},
  [490]={109,48},
  [495]={109,49},
  [500]={109,50},
  [5318]={100,1086},
  [7919]={101,824},
  [7924]={101,825},
  [7929]={101,826},
  [7934]={101,827},
  [7961]={103,814},
  [7966]={103,815},
  [7971]={103,816},
  [7976]={103,817},
  [8015]={104,820},
  [8020]={104,821},
  [8025]={104,822},
  [8030]={104,823},
  [8057]={105,832},
  [8062]={105,833},
  [8067]={105,834},
  [8072]={105,835},
  [8105]={108,828},
  [8110]={108,829},
  [8115]={108,830},
  [8120]={108,831},
  [8189]={113,848},
  [8194]={113,849},
  [8199]={113,850},
  [8204]={113,851},
  [8231]={116,856},
  [8236]={116,857},
  [8241]={116,858},
  [8246]={116,859},
  [8273]={118,864},
  [8278]={118,865},
  [8283]={118,866},
  [8288]={118,867},
  [8315]={120,872},
  [8320]={120,873},
  [8325]={120,874},
  [8330]={120,875},
  [8357]={122,880},
  [8362]={122,881},
  [8367]={122,882},
  [8372]={122,883},
}
local __KO_Quests = {
  [47]={109},
  [48]={109},
  [49]={109},
  [50]={109},
  [814]={103},
  [815]={103},
  [816]={103},
  [817]={103},
  [820]={104},
  [821]={104},
  [822]={104},
  [823]={104},
  [824]={101},
  [825]={101},
  [826]={101},
  [827]={101},
  [828]={108},
  [829]={108},
  [830]={108},
  [831]={108},
  [832]={105},
  [833]={105},
  [834]={105},
  [835]={105},
  [848]={113},
  [849]={113},
  [850]={113},
  [851]={113},
  [856]={116},
  [857]={116},
  [858]={116},
  [859]={116},
  [864]={118},
  [865]={118},
  [866]={118},
  [867]={118},
  [872]={120},
  [873]={120},
  [874]={120},
  [875]={120},
  [880]={122},
  [881]={122},
  [882]={122},
  [883]={122},
  [1086]={100},
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
local NPC = 19003;

if (EVENT == 150) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 8255, NPC, 10, 163);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 8257, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 163) then
	Ret = 1;
end

local savenum = 101;

if (EVENT == 8230) then -- 24 Level Spoiler
	SelectMsg(UID, 2, savenum, 8034, NPC, 10, 8231);
end

if (EVENT == 8231) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 7917);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 7922);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 7927);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 7932);
	end
end

if (EVENT == 8232) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub >= 0) then
		SelectMsg(UID, 4, savenum, 8034, NPC, 22, 8233, 23, 8234);
	else
		SelectMsg(UID, 2, savenum, 8034, NPC, 10, 163);
	end
end

if (EVENT == 8233) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 7918);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 7923);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 7928);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 7933);
	end
end

if (EVENT == 8234) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 7921);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 7926);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 7931);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 7936);
	end
end

if (EVENT == 8240) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 7920);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 7925);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 7930);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 7935);
	end
end

if (EVENT == 8236) then
	MonsterCount = CountMonsterQuestSub(UID, 101, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, savenum, 8034, NPC, 18, 8237);
	else
		SelectMsg(UID, 4, savenum, 8034, NPC, 41, 8238, 23, 163);
	end
end

if (EVENT == 8237) then
	ShowMap(UID, 521);
end

if (EVENT == 8238) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		ExpChange(UID, 30000)
		GiveItem(UID, 203005281, 1)
		SaveEvent(UID, 7919);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		ExpChange(UID, 30000)
		GiveItem(UID, 243005282, 1)
		SaveEvent(UID, 7924);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		ExpChange(UID, 30000)
		GiveItem(UID, 263005283, 1)
		SaveEvent(UID, 7929);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		ExpChange(UID, 30000)
		GiveItem(UID, 283005284, 1)
		SaveEvent(UID, 7934);
	end
end

local savenum = 103;

if (EVENT == 8330) then -- 25 Level Scorpion
	SelectMsg(UID, 2, savenum, 8034, NPC, 10, 8331);
end

if (EVENT == 8331) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 7959);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 7964);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 7969);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 7974);
	end
end

if (EVENT == 8332) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub >= 0) then
		SelectMsg(UID, 4, savenum, 8034, NPC, 22, 8333, 23, 8334);
	else
		SelectMsg(UID, 2, savenum, 8034, NPC, 10, 163);
	end
end

if (EVENT == 8333) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 7960);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 7965);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 7970);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 7975);
	end
end

if (EVENT == 8334) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 7963);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 7968);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 7973);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 7978);
	end
end

if (EVENT == 8340) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 7962);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 7967);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 7972);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 7977);
	end
end

if (EVENT == 8336) then
	MonsterCount = CountMonsterQuestSub(UID, 803, 1);
	if (MonsterCount < 10) then
		SelectMsg(UID, 2, savenum, 8034, NPC, 18, 8337);
	else
		SelectMsg(UID, 4, savenum, 8034, NPC, 41, 8338, 23, 163);
	end
end

if (EVENT == 8337) then
	ShowMap(UID, 567);
end

if (EVENT == 8338) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		ExpChange(UID, 30000)
		GiveItem(UID, 203004281, 1)
		SaveEvent(UID, 7961);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		ExpChange(UID, 30000)
		GiveItem(UID, 243004282, 1)
		SaveEvent(UID, 7966);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		ExpChange(UID, 30000)
		GiveItem(UID, 263004283, 1)
		SaveEvent(UID, 7971);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		ExpChange(UID, 30000)
		GiveItem(UID, 283004284, 1)
		SaveEvent(UID, 7976);
	end
end

local savenum = 104;

if (EVENT == 8430) then -- 26 Level Lycaon
	SelectMsg(UID, 2, savenum, 8034, NPC, 10, 8431);
end

if (EVENT == 8431) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8013);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8018);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8023);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8028);
	end
end

if (EVENT == 8432) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub >= 0) then
		SelectMsg(UID, 4, savenum, 8034, NPC, 22, 8433, 23, 8434);
	else
		SelectMsg(UID, 2, savenum, 8034, NPC, 10, 163);
	end
end

if (EVENT == 8433) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8014);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8019);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8024);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8029);
	end
end

if (EVENT == 8434) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8017);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8022);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8027);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8032);
	end
end

if (EVENT == 8440) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8016);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8021);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8026);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8031);
	end
end

if (EVENT == 8436) then
	MonsterCount = CountMonsterQuestSub(UID, 801, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, savenum, 8034, NPC, 18, 8437);
	else
		SelectMsg(UID, 4, savenum, 8034, NPC, 41, 8438, 23, 163);
	end
end

if (EVENT == 8437) then
	ShowMap(UID, 61);
end

if (EVENT == 8438) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		ExpChange(UID, 45000)
		GiveItem(UID, 203003281, 1)
		SaveEvent(UID, 8015);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		ExpChange(UID, 45000)
		GiveItem(UID, 243003282, 1)
		SaveEvent(UID, 8020);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		ExpChange(UID, 45000)
		GiveItem(UID, 263003283, 1)
		SaveEvent(UID, 8025);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		ExpChange(UID, 45000)
		GiveItem(UID, 283003284, 1)
		SaveEvent(UID, 8030);
	end
end

local savenum = 105;

if (EVENT == 8530) then -- 27 Level Loup Garou
	SelectMsg(UID, 2, savenum, 8034, NPC, 10, 8531);
end

if (EVENT == 8531) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8055);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8060);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8065);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8070);
	end
end

if (EVENT == 8532) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub >= 0) then
		SelectMsg(UID, 4, savenum, 8034, NPC, 22, 8533, 23, 8534);
	else
		SelectMsg(UID, 2, savenum, 8034, NPC, 10, 163);
	end
end

if (EVENT == 8533) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8056);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8061);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8066);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8071);
	end
end

if (EVENT == 8534) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8059);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8064);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8069);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8074);
	end
end

if (EVENT == 8540) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8058);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8063);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8068);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8073);
	end
end

if (EVENT == 8536) then
	MonsterCount = CountMonsterQuestSub(UID, 816, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, savenum, 8034, NPC, 18, 8537);
	else
		SelectMsg(UID, 4, savenum, 8034, NPC, 41, 8538, 23, 163);
	end
end

if (EVENT == 8537) then
	ShowMap(UID, 68);
end

if (EVENT == 8538) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		ExpChange(UID, 70000)
		GiveItem(UID, 203002281, 1)
		SaveEvent(UID, 8057);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		ExpChange(UID, 70000)
		GiveItem(UID, 243002282, 1)
		SaveEvent(UID, 8062);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		ExpChange(UID, 70000)
		GiveItem(UID, 263002283, 1)
		SaveEvent(UID, 8067);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		ExpChange(UID, 70000)
		GiveItem(UID, 283002284, 1)
		SaveEvent(UID, 8072);
	end
end

local savenum = 109; -- 113 ?

if (EVENT == 215) then -- 28 Level Skull
	SelectMsg(UID, 2, savenum, 1323, NPC, 10, 216);
end

if (EVENT == 216) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 483);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 488);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 493);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 498);
	end
end

if (EVENT == 217) then
	SelectMsg(UID, 4, savenum, 1323, NPC, 22, 218, 23, 219);
end

if (EVENT == 218) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 484);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 489);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 494);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 499);
	end
end

if (EVENT == 219) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 487);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 492);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 497);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 502);
	end
end

if (EVENT == 221) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 486);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 491);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 496);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 501);
	end
end

if (EVENT == 224) then
	ITEMSKULL = HowmuchItem(UID, 379253000);
	if (ITEMSKULL < 3) then
		SelectMsg(UID, 2, savenum, 1323, NPC, 18, 225);
	else
		SelectMsg(UID, 4, savenum, 1323, NPC, 41, 227, 23, 163);
	end
end

if (EVENT == 225) then
	ShowMap(UID, 23);
end

if (EVENT == 227) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		ExpChange(UID, 50000)
		RobItem(UID, 379253000, 3)
		GiveItem(UID, 971980793, 1)   
		SaveEvent(UID, 485);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		ExpChange(UID, 50000)
		RobItem(UID, 379253000, 3)
		GiveItem(UID, 971950493, 1)
		GiveItem(UID, 971950493, 1)
		GiveItem(UID, 971990921, 1)
		SaveEvent(UID, 490);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		ExpChange(UID, 50000)
		RobItem(UID, 379253000, 3)
		GiveItem(UID, 971960361, 1)
		GiveItem(UID, 971960369, 1)
		GiveItem(UID, 971960377, 1)
		SaveEvent(UID, 495);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		ExpChange(UID, 50000)
		RobItem(UID, 379253000, 3)
		GiveItem(UID, 971970763, 1)
		GiveItem(UID, 972000446, 1)
		SaveEvent(UID, 500);
	end
end

local savenum = 108; 

if (EVENT == 8130) then -- 28 Level Dark Eyes
	SelectMsg(UID, 2, savenum, 8034, NPC, 10, 8131);
end

if (EVENT == 8131) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
	SaveEvent(UID, 8103);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8108);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8113);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8118);
	end
end

if (EVENT == 8132) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub >= 0) then
		SelectMsg(UID, 4, savenum, 8034, NPC, 22, 8133, 23, 8134);
	else
		SelectMsg(UID, 2, savenum, 8034, NPC, 10, 163);
	end
end

if (EVENT == 8133) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8104);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8109);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8114);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8119);
	end
end

if (EVENT == 8134) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8107);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8112);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8117);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8122);
	end
end

if (EVENT == 8140) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8106);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8111);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8116);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8121);
	end
end

if (EVENT == 8136) then
	MonsterCount = CountMonsterQuestSub(UID, 810, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, savenum, 8034, NPC, 18, 8137);
	else
		SelectMsg(UID, 4, savenum, 8034, NPC, 41, 8138, 23, 163);
	end
end

if (EVENT == 8137) then
	ShowMap(UID, 568);
end

if (EVENT == 8138) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		ExpChange(UID, 60000)
		GiveItem(UID, 203001281, 1)
		SaveEvent(UID, 8105);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		ExpChange(UID, 60000)
		GiveItem(UID, 243001282, 1)
		SaveEvent(UID, 8110);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		ExpChange(UID, 60000)
		GiveItem(UID, 263001283, 1)
		SaveEvent(UID, 8115);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		ExpChange(UID, 60000)
		GiveItem(UID, 283001284, 1)
		SaveEvent(UID, 8120);
	end
end

if (EVENT == 9300) then -- 29 Level Keilan
	SaveEvent(UID, 5316);
end

if (EVENT == 9305) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 100, 8673, NPC, 22, 9306, 23, 9307);
	else
		SelectMsg(UID, 2, 100, 8673, NPC, 10, 163);
	end
end

if (EVENT == 9306) then
	SaveEvent(UID, 5317);
end

if (EVENT == 9307) then
	SaveEvent(UID, 5320);
end

if (EVENT == 9310) then
	SaveEvent(UID, 5319);
end

if (EVENT == 9315) then
	MonsterCount = CountMonsterQuestSub(UID, 100, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, 100, 8673, NPC, 18, 9308);
	else
		SelectMsg(UID, 4, 100, 8673, NPC, 41, 9309, 27, 163);
	end
end

if (EVENT == 9308) then
	ShowMap(UID, 527);
end

if (EVENT == 9309) then
	ExpChange(UID, 60000)
	GoldGain(UID, 300000)
	SaveEvent(UID, 5318);
end

local savenum = 113;

if (EVENT == 8730) then -- 30 Level Skeleton
	SelectMsg(UID, 2, savenum, 8034, NPC, 10, 8731);
end

if (EVENT == 8731) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8187);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8192);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8197);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8202);
	end
end

if (EVENT == 8732) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub >= 0) then
		SelectMsg(UID, 4, savenum, 8034, NPC, 22, 8733, 23, 8734);
	else
		SelectMsg(UID, 2, savenum, 8034, NPC, 10, 163);
	end
end

if (EVENT == 8733) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8188);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8193);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8198);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8203);
	end
end

if (EVENT == 8734) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8191);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8196);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8201);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8206);
	end
end

if (EVENT == 8740) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8190);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8195);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8200);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8205);
	end
end

if (EVENT == 8736) then
	MonsterCount = CountMonsterQuestSub(UID, 805, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, savenum, 8034, NPC, 18, 8737);
	else
		SelectMsg(UID, 4, savenum, 8034, NPC, 41, 8738, 23, 163);
	end
end

if (EVENT == 8737) then
	ShowMap(UID, 23);
end

if (EVENT == 8738) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		ExpChange(UID, 100000)
		GiveItem(UID, 204005005, 1)
		GiveItem(UID, 204005285, 1)
		SaveEvent(UID, 8189);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		ExpChange(UID, 100000)
		GiveItem(UID, 244005005, 1)
		GiveItem(UID, 244005286, 1)
		SaveEvent(UID, 8194);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		ExpChange(UID, 100000)
		GiveItem(UID, 264005005, 1)
		GiveItem(UID, 264005287, 1)
		SaveEvent(UID, 8199);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		ExpChange(UID, 100000)
		GiveItem(UID, 284005005, 1)
		GiveItem(UID, 284005288, 1)
		SaveEvent(UID, 8204);
	end
end

local savenum = 116;

if (EVENT == 8830) then -- 31 Level Paralyzer
	SelectMsg(UID, 2, savenum, 8034, NPC, 10, 8831);
end

if (EVENT == 8831) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8229);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8234);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8239);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8244);
	end
end

if (EVENT == 8832) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub >= 0) then
		SelectMsg(UID, 4, savenum, 8034, NPC, 22, 8833, 23, 8834);
	else
		SelectMsg(UID, 2, savenum, 8034, NPC, 10, 163);
	end
end

if (EVENT == 8833) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8230);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8235);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8240);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8245);
	end
end

if (EVENT == 8834) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8233);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8238);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8243);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8248);
	end
end

if (EVENT == 8840) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8232);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8237);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8242);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8247);
	end
end

if (EVENT == 8836) then
	MonsterCount = CountMonsterQuestSub(UID, 806, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, savenum, 8034, NPC, 18, 8837);
	else
		SelectMsg(UID, 4, savenum, 8034, NPC, 41, 8838, 23, 163);
	end
end

if (EVENT == 8837) then
	ShowMap(UID, 570);
end

if (EVENT == 8838) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		ExpChange(UID, 150000)
		GiveItem(UID, 204004005, 1)
		GiveItem(UID, 204004285, 1)
		SaveEvent(UID, 8231);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		ExpChange(UID, 150000)
		GiveItem(UID, 244004005, 1)
		GiveItem(UID, 244004286, 1)
		SaveEvent(UID, 8236);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		ExpChange(UID, 150000)
		GiveItem(UID, 264004005, 1)
		GiveItem(UID, 264004287, 1)
		SaveEvent(UID, 8241);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		ExpChange(UID, 150000)
		GiveItem(UID, 284004005, 1)
		GiveItem(UID, 284004288, 1)
		SaveEvent(UID, 8246);
	end
end

local savenum = 118;

if (EVENT == 8930) then -- 32 Level Dire Wolf
	SelectMsg(UID, 2, savenum, 8034, NPC, 10, 8931);
end

if (EVENT == 8931) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8271);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8276);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8281);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8286);
	end
end

if (EVENT == 8932) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub >= 0) then
		SelectMsg(UID, 4, savenum, 8034, NPC, 22, 8933, 23, 8934);
	else
		SelectMsg(UID, 2, savenum, 8034, NPC, 10, 163);
	end
end

if (EVENT == 8933) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8272);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8277);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8282);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8287);
	end
end

if (EVENT == 8934) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8275);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8280);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8285);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8290);
	end
end

if (EVENT == 8940) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8274);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8279);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8284);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8289);
	end
end

if (EVENT == 8936) then
	MonsterCount = CountMonsterQuestSub(UID, 807, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, savenum, 8034, NPC, 18, 8937);
	else
		SelectMsg(UID, 4, savenum, 8034, NPC, 41, 8938, 23, 163);
	end
end

if (EVENT == 8937) then
	ShowMap(UID, 523);
end

if (EVENT == 8938) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		ExpChange(UID, 170000)
		GiveItem(UID, 204003005, 1)
		GiveItem(UID, 204003285, 1)
		SaveEvent(UID, 8273);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		ExpChange(UID, 170000)
		GiveItem(UID, 244003005, 1)
		GiveItem(UID, 244003286, 1)
		SaveEvent(UID, 8278);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		ExpChange(UID, 170000)
		GiveItem(UID, 264003005, 1)
		GiveItem(UID, 264003287, 1)
		SaveEvent(UID, 8283);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		ExpChange(UID, 170000)
		GiveItem(UID, 284003005, 1)
		GiveItem(UID, 284003288, 1)
		SaveEvent(UID, 8288);
	end
end

local savenum = 120;

if (EVENT == 8900) then -- 33 Level Smildon
	SelectMsg(UID, 2, savenum, 8034, NPC, 10, 8901);
end

if (EVENT == 8901) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8313);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8318);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8323);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8328);
	end
end

if (EVENT == 8902) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub >= 0) then
		SelectMsg(UID, 4, savenum, 8034, NPC, 22, 8903, 23, 8904);
	else
		SelectMsg(UID, 2, savenum, 8034, NPC, 10, 163);
	end
end

if (EVENT == 8903) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8314);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8319);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8324);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8329);
	end
end

if (EVENT == 8904) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8317);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8322);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8327);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8332);
	end
end

if (EVENT == 8910) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8316);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8321);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8326);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8331);
	end
end

if (EVENT == 8906) then
	MonsterCount = CountMonsterQuestSub(UID, 120, 1);
	if (MonsterCount < 10) then
		SelectMsg(UID, 2, savenum, 8034, NPC, 18, 8907);
	else
		SelectMsg(UID, 4, savenum, 8034, NPC, 41, 8908, 23, 163);
	end
end

if (EVENT == 8907) then
	ShowMap(UID, 525);
end

if (EVENT == 8908) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		ExpChange(UID, 200000)
		GiveItem(UID, 204002005, 1)
		GiveItem(UID, 204002285, 1)
		SaveEvent(UID, 8315);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		ExpChange(UID, 200000)
		GiveItem(UID, 244002005, 1)
		GiveItem(UID, 244002286, 1)
		SaveEvent(UID, 8320);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		ExpChange(UID, 200000)
		GiveItem(UID, 264002005, 1)
		GiveItem(UID, 264002287, 1)
		SaveEvent(UID, 8325);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		ExpChange(UID, 200000)
		GiveItem(UID, 284002005, 1)
		GiveItem(UID, 284002288, 1)
		SaveEvent(UID, 8330);
	end
end

local savenum = 122;

if (EVENT == 8800) then -- 34 Level Wild Smildon
	SelectMsg(UID, 2, savenum, 8034, NPC, 10, 8801);
end

if (EVENT == 8801) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8355);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8360);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8365);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8370);
	end
end

if (EVENT == 8802) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub >= 0) then
		SelectMsg(UID, 4, savenum, 8034, NPC, 22, 8803, 23, 8804);
	else
		SelectMsg(UID, 2, savenum, 8034, NPC, 10, 163);
	end
end

if (EVENT == 8803) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8356);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8361);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8366);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8371);
	end
end

if (EVENT == 8804) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8359);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8364);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8369);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8374);
	end
end

if (EVENT == 8810) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8358);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8363);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8368);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8373);
	end
end

if (EVENT == 8806) then
	MonsterCount = CountMonsterQuestSub(UID, 122, 1);
	if (MonsterCount < 10) then
		SelectMsg(UID, 2, savenum, 8034, NPC, 18, 8807);
	else
		SelectMsg(UID, 4, savenum, 8034, NPC, 41, 8808, 23, 163);
	end
end

if (EVENT == 8807) then
	ShowMap(UID, 572);
end

if (EVENT == 8808) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		ExpChange(UID, 220000)
		GiveItem(UID, 204001005, 1)
		GiveItem(UID, 204001285, 1)
		SaveEvent(UID, 8357);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		ExpChange(UID, 220000)
		GiveItem(UID, 244001005, 1)
		GiveItem(UID, 244001286, 1)
		SaveEvent(UID, 8362);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		ExpChange(UID, 220000)
		GiveItem(UID, 264001005, 1)
		GiveItem(UID, 264001287, 1)
		SaveEvent(UID, 8367);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		ExpChange(UID, 220000)
		GiveItem(UID, 284001005, 1)
		GiveItem(UID, 284001288, 1)
		SaveEvent(UID, 8372);
	end
end

-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=109 status=2 n_index=485
if (EVENT == 190) then
	SearchQuest(UID, 19003);
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
