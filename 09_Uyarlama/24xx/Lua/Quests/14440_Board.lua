-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [115]={{900005000,1005}},
  [116]={{900005000,1006}},
  [117]={{900005000,169}},
  [118]={{900005000,170}},
  [119]={{900005000,171}},
  [120]={{900005000,172}},
  [121]={{900005000,173}},
  [122]={{900005000,174}},
}
local __KO_Completion = {
  [283]={167,115},
  [295]={168,116},
  [312]={169,117},
  [322]={170,118},
  [338]={171,119},
  [348]={172,120},
  [365]={173,121},
  [375]={174,122},
}
local __KO_Quests = {
  [115]={167},
  [116]={168},
  [117]={169},
  [118]={170},
  [119]={171},
  [120]={172},
  [121]={173},
  [122]={174},
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
local NPC = 14440;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 422, NPC, 10, 168);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 422, NPC);
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
		SelectMsg(UID, 4, savenum, 422, NPC, 22, 112, 23, 113);
	else
		SelectMsg(UID, 2, savenum, 422, NPC, 10, 102);
	end
end

if (EVENT == 112) then
	SaveEvent(UID, 282);
end

if (EVENT == 113) then
	SaveEvent(UID, 285);
end

if (EVENT == 114) then
	SaveEvent(UID, 284);
end

if (EVENT == 115) then
	MonsterCount = CountMonsterQuestSub(UID, 997, 1);
	if (MonsterCount < 100) then
		SelectMsg(UID, 2, savenum, 412, NPC, 18, 117);
	else
		SelectMsg(UID, 4, savenum, 412, NPC, 41, 118, 23, 117);
	end
end

if (EVENT == 117) then
	ShowMap(UID, 584);
end

if (EVENT == 118) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 900000)
		SaveEvent(UID, 283);
	else
		ExpChange(UID, 450000)
		SaveEvent(UID, 283);
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
	SaveEvent(UID, 294);
end

if (EVENT == 122) then
	SaveEvent(UID, 297);
end

if (EVENT == 123) then
	SaveEvent(UID, 296);
end

if (EVENT == 124) then
	MonsterCount = CountMonsterQuestSub(UID, 998, 1);
	if (MonsterCount < 100) then
		SelectMsg(UID, 2, savenum, 425, NPC, 18, 126);
	else
		SelectMsg(UID, 4, savenum, 425, NPC, 41, 127, 23, 126);
	end
end

if (EVENT == 126) then
	ShowMap(UID, 187);
end

if (EVENT == 127) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 900000)
		SaveEvent(UID, 295);
	else
		ExpChange(UID, 450000)
		SaveEvent(UID, 295);
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
	SaveEvent(UID, 311);
end

if (EVENT == 132) then
	SaveEvent(UID, 314);
end

if (EVENT == 133) then
	SaveEvent(UID, 313);
end

if (EVENT == 134) then
	MonsterCount = CountMonsterQuestSub(UID, 999, 1);
	if (MonsterCount < 100) then
		SelectMsg(UID, 2, savenum, 430, NPC, 18, 136);
	else
		SelectMsg(UID, 4, savenum, 430, NPC, 41, 137, 23, 136);
	end
end

if (EVENT == 136) then
	ShowMap(UID, 586);
end

if (EVENT == 137) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 1400000)
		SaveEvent(UID, 312);
	else
		ExpChange(UID, 700000)
		SaveEvent(UID, 312);
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
	SaveEvent(UID, 321);
end

if (EVENT == 142) then
	SaveEvent(UID, 324);
end

if (EVENT == 143) then
	SaveEvent(UID, 323);
end

if (EVENT == 144) then
	MonsterCount = CountMonsterQuestSub(UID, 1000, 1);
	if (MonsterCount < 80) then
		SelectMsg(UID, 2, savenum, 441, NPC, 18, 146);
	else
		SelectMsg(UID, 4, savenum, 441, NPC, 41, 147, 23, 146);
	end
end

if (EVENT == 146) then
	ShowMap(UID, 16);
end

if (EVENT == 147) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 2000000)
		SaveEvent(UID, 322);
	else
		ExpChange(UID, 1000000)
		SaveEvent(UID, 322);
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
	SaveEvent(UID, 337);
end

if (EVENT == 152) then
	SaveEvent(UID, 340);
end

if (EVENT == 153) then
	SaveEvent(UID, 339);
end

if (EVENT == 154) then
	MonsterCount = CountMonsterQuestSub(UID, 1001, 1);
	if (MonsterCount < 100) then
		SelectMsg(UID, 2, savenum, 446, NPC, 18, 156);
	else
		SelectMsg(UID, 4, savenum, 446, NPC, 41, 157, 23, 156);
	end
end

if (EVENT == 156) then
	ShowMap(UID, 517);
end

if (EVENT == 157) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 1000000)
		SaveEvent(UID, 338);
	else
		ExpChange(UID, 500000)
		SaveEvent(UID, 338);
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
	SaveEvent(UID, 357);
end

if (EVENT == 172) then
	SaveEvent(UID, 367);
end

if (EVENT == 173) then
	SaveEvent(UID, 366);
end

if (EVENT == 174) then
	MonsterCount = CountMonsterQuestSub(UID, 1003, 1);
	if (MonsterCount < 60) then
		SelectMsg(UID, 2, savenum, 454, NPC, 18, 176);
	else
		SelectMsg(UID, 4, savenum, 454, NPC, 41, 177, 23, 176);
	end
end

if (EVENT == 176) then
	ShowMap(UID, 554);
end

if (EVENT == 177) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 1600000)
		SaveEvent(UID, 365);
	else
		ExpChange(UID, 800000)
		SaveEvent(UID, 365);
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
	SaveEvent(UID, 347);
end

if (EVENT == 162) then
	SaveEvent(UID, 350);
end

if (EVENT == 163) then
	SaveEvent(UID, 349);
end

if (EVENT == 164) then
	MonsterCount = CountMonsterQuestSub(UID, 1002, 1);
	if (MonsterCount < 60) then
		SelectMsg(UID, 2, savenum, 446, NPC, 18, 166);
	else
		SelectMsg(UID, 4, savenum, 446, NPC, 41, 167, 23, 166);
	end
end

if (EVENT == 166) then
	ShowMap(UID, 552);
end

if (EVENT == 167) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 1400000)
		SaveEvent(UID, 348);
	else
		ExpChange(UID, 700000)
		SaveEvent(UID, 348);
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
	SaveEvent(UID, 374);
end

if (EVENT == 182) then
	SaveEvent(UID, 377);
end

if (EVENT == 183) then
	SaveEvent(UID, 376);
end

if (EVENT == 184) then
	MonsterCount = CountMonsterQuestSub(UID, 1004, 1);
	if (MonsterCount < 100) then
		SelectMsg(UID, 2, savenum, 464, NPC, 18, 186);
	else
		SelectMsg(UID, 4, savenum, 464, NPC, 41, 187, 23, 186);
	end
end

if (EVENT == 186) then
	ShowMap(UID, 548);
end

if (EVENT == 187) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		ExpChange(UID, 1200000)
		SaveEvent(UID, 375);
	else
		ExpChange(UID, 600000)
		SaveEvent(UID, 375);
	end
end

-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=167 status=255 n_index=280
if (EVENT == 110) then
	SaveEvent(UID, 281);
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
