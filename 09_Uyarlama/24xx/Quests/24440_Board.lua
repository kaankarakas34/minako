-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [23]={{900005000,167}},
  [24]={{900005000,168}},
  [25]={{900005000,169}},
  [26]={{900005000,170}},
  [27]={{900005000,171}},
  [57]={{900005000,172}},
  [58]={{900005000,173}},
  [59]={{900005000,174}},
}
local __KO_Completion = {
  [277]={167,23},
  [290]={168,24},
  [307]={169,25},
  [317]={170,26},
  [327]={171,27},
  [343]={172,57},
  [353]={173,58},
  [370]={174,59},
}
local __KO_Quests = {
  [23]={167},
  [24]={168},
  [25]={169},
  [26]={170},
  [27]={171},
  [57]={172},
  [58]={173},
  [59]={174},
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
local NPC = 24440;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 411, NPC, 10, 168);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 411, NPC);
	else
		EVENT = QuestNum
	end
end   

if (EVENT == 102) then
	Ret = 1;
end

local savenum = 997;

if (EVENT == 111) then -- Dragon Tooth Soldier
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 412, NPC, 22, 112, 23, 113);
	else
		SelectMsg(UID, 2, savenum, 412, NPC, 10, 102);
	end
end

if (EVENT == 112) then
	SaveEvent(UID, 276);
end

if (EVENT == 113) then
	SaveEvent(UID, 279);
end

if (EVENT == 114) then
	SaveEvent(UID, 278);
end

if (EVENT == 115) then
	MonsterCount = CountMonsterQuestSub(UID, 997, 1);
	if (MonsterCount < 100) then
		SelectMsg(UID, 2, savenum, 412, NPC, 21, 117);
	else
		SelectMsg(UID, 4, savenum, 412, NPC, 41, 118, 23, 117);
	end
end

if (EVENT == 117) then
	ShowMap(UID, 585);
end

if (EVENT == 118) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 900000)
		SaveEvent(UID, 277);
	else
		ExpChange(UID, 450000)
		SaveEvent(UID, 277);
	end
end

local savenum = 998;

if (EVENT == 120) then -- Dragon Tooth Skeleton
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 425, NPC, 22, 121, 23, 122);
	else
		SelectMsg(UID, 2, savenum, 425, NPC, 10, 102);
	end
end

if (EVENT == 121) then
	SaveEvent(UID, 289);
end

if (EVENT == 122) then
	SaveEvent(UID, 292);
end

if (EVENT == 123) then
	SaveEvent(UID, 291);
end

if (EVENT == 124) then
	MonsterCount = CountMonsterQuestSub(UID, 998, 1);
	if (MonsterCount < 100) then
		SelectMsg(UID, 2, savenum, 425, NPC, 21, 126);
	else
		SelectMsg(UID, 4, savenum, 425, NPC, 41, 127, 23, 126);
	end
end

if (EVENT == 126) then
	ShowMap(UID, 186);
end

if (EVENT == 127) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 900000)
		SaveEvent(UID, 290);
	else
		ExpChange(UID, 450000)
		SaveEvent(UID, 290);
	end
end

local savenum = 999;

if (EVENT == 130) then -- Dragon Tooth Commander
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 430, NPC, 22, 131, 23, 132);
	else
		SelectMsg(UID, 2, savenum, 430, NPC, 10, 102);
	end
end

if (EVENT == 131) then
	SaveEvent(UID, 299);
end

if (EVENT == 132) then
	SaveEvent(UID, 309);
end

if (EVENT == 133) then
	SaveEvent(UID, 308);
end

if (EVENT == 134) then
	MonsterCount = CountMonsterQuestSub(UID, 999, 1);
	if (MonsterCount < 100) then
		SelectMsg(UID, 2, savenum, 430, NPC, 21, 136);
	else
		SelectMsg(UID, 4, savenum, 430, NPC, 41, 137, 23, 136);
	end
end

if (EVENT == 136) then
	ShowMap(UID, 587);
end

if (EVENT == 137) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 1400000)
		SaveEvent(UID, 307);
	else
		ExpChange(UID, 700000)
		SaveEvent(UID, 307);
	end
end

local savenum = 1000;

if (EVENT == 140) then -- Lich
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 441, NPC, 22, 141, 23, 142);
	else
		SelectMsg(UID, 2, savenum, 441, NPC, 10, 102);
	end
end

if (EVENT == 141) then
	SaveEvent(UID, 316);
end

if (EVENT == 142) then
	SaveEvent(UID, 319);
end

if (EVENT == 143) then
	SaveEvent(UID, 318);
end

if (EVENT == 144) then
	MonsterCount = CountMonsterQuestSub(UID, 1000, 1);
	if (MonsterCount < 80) then
		SelectMsg(UID, 2, savenum, 441, NPC, 21, 146);
	else
		SelectMsg(UID, 4, savenum, 441, NPC, 41, 147, 23, 146);
	end
end

if (EVENT == 146) then
	ShowMap(UID, 17);
end

if (EVENT == 147) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 2000000)
		SaveEvent(UID, 317);
	else
		ExpChange(UID, 1000000)
		SaveEvent(UID, 317);
	end
end

local savenum = 1001;

if (EVENT == 150) then -- Deruvish
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 446, NPC, 22, 151, 23, 152);
	else
		SelectMsg(UID, 2, savenum, 446, NPC, 10, 102);
	end
end

if (EVENT == 151) then
	SaveEvent(UID, 326);
end

if (EVENT == 152) then
	SaveEvent(UID, 329);
end

if (EVENT == 153) then
	SaveEvent(UID, 328);
end

if (EVENT == 154) then
	MonsterCount = CountMonsterQuestSub(UID, 1001, 1);
	if (MonsterCount < 100) then
		SelectMsg(UID, 2, savenum, 446, NPC, 21, 156);
	else
		SelectMsg(UID, 4, savenum, 446, NPC, 41, 157, 23, 156);
	end
end

if (EVENT == 156) then
	ShowMap(UID, 518);
end

if (EVENT == 157) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 1000000)
		SaveEvent(UID, 327);
	else
		ExpChange(UID, 500000)
		SaveEvent(UID, 327);
	end
end

local savenum = 1003;

if (EVENT == 170) then -- Troll
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 454, NPC, 22, 171, 23, 172);
	else
		SelectMsg(UID, 2, savenum, 454, NPC, 10, 102);
	end
end

if (EVENT == 171) then
	SaveEvent(UID, 352);
end

if (EVENT == 172) then
	SaveEvent(UID, 355);
end

if (EVENT == 173) then
	SaveEvent(UID, 354);
end

if (EVENT == 174) then
	MonsterCount = CountMonsterQuestSub(UID, 1003, 1);
	if (MonsterCount < 60) then
		SelectMsg(UID, 2, savenum, 454, NPC, 21, 176);
	else
		SelectMsg(UID, 4, savenum, 454, NPC, 41, 177, 23, 176);
	end
end

if (EVENT == 176) then
	ShowMap(UID, 555);
end

if (EVENT == 177) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 1600000)
		SaveEvent(UID, 353);
	else
		ExpChange(UID, 800000)
		SaveEvent(UID, 353);
	end
end

local savenum = 1002;

if (EVENT == 160) then -- Apostle
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 446, NPC, 22, 161, 23, 162);
	else
		SelectMsg(UID, 2, savenum, 446, NPC, 10, 102);
	end
end

if (EVENT == 161) then
	SaveEvent(UID, 342);
end

if (EVENT == 162) then
	SaveEvent(UID, 345);
end

if (EVENT == 163) then
	SaveEvent(UID, 344);
end

if (EVENT == 164) then
	MonsterCount = CountMonsterQuestSub(UID, 1002, 1);
	if (MonsterCount < 60) then
		SelectMsg(UID, 2, savenum, 446, NPC, 21, 166);
	else
		SelectMsg(UID, 4, savenum, 446, NPC, 41, 167, 23, 166);
	end
end

if (EVENT == 166) then
	ShowMap(UID, 553);
end

if (EVENT == 167) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 1400000)
		SaveEvent(UID, 343);
	else
		ExpChange(UID, 700000)
		SaveEvent(UID, 343);
	end
end

local savenum = 1004;

if (EVENT == 180) then -- Harpy
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 464, NPC, 22, 181, 23, 182);
	else
		SelectMsg(UID, 2, savenum, 464, NPC, 10, 102);
	end
end

if (EVENT == 181) then
	SaveEvent(UID, 369);
end

if (EVENT == 182) then
	SaveEvent(UID, 372);
end

if (EVENT == 183) then
	SaveEvent(UID, 371);
end

if (EVENT == 184) then
	MonsterCount = CountMonsterQuestSub(UID, 1004, 1);
	if (MonsterCount < 100) then
		SelectMsg(UID, 2, savenum, 464, NPC, 21, 186);
	else
		SelectMsg(UID, 4, savenum, 464, NPC, 41, 187, 23, 186);
	end
end

if (EVENT == 186) then
	ShowMap(UID, 549);
end

if (EVENT == 187) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 1200000)
		SaveEvent(UID, 370);
	else
		ExpChange(UID, 600000)
		SaveEvent(UID, 370);
	end
end

-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=167 status=255 n_index=274
if (EVENT == 110) then
	SaveEvent(UID, 275);
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
