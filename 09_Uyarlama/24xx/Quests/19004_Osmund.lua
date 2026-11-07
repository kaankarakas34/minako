-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [46]={{810418000,2}},
  [52]={{810418000,2}},
  [125]={{900005000,114}},
  [132]={{810418000,1}},
  [535]={{810418000,2}},
}
local __KO_Completion = {
  [304]={102,46},
  [334]={114,125},
  [512]={112,52},
  [822]={110,132},
  [9946]={115,535},
}
local __KO_Quests = {
  [46]={102},
  [52]={112},
  [125]={114},
  [132]={110},
  [535]={115},
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
local NPC = 19004;

if (EVENT == 165) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 567, NPC, 10, 101);
	elseif (QuestNum > 0 and QuestNum < 100) then
		NpcMsg(UID, 568, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 193) then
	Ret = 1;
end

local savenum = 102;

if (EVENT == 195) then -- 24 Level Princers Scorpion
	SaveEvent(UID, 302);
end

if (EVENT == 200) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 568, NPC, 22, 201, 23, 202);
	else
		SelectMsg(UID, 2, savenum, 568, NPC, 10, 193);
	end
end

if (EVENT == 201) then
	SaveEvent(UID, 303);
end

if (EVENT == 202) then
	SaveEvent(UID, 306);
end

if (EVENT == 205) then
	SelectMsg(UID, 2, savenum, 568, NPC, 10, 193);
	SaveEvent(UID, 305);
end

if (EVENT == 210) then
	MonsterCount = CountMonsterQuestSub(UID, 223, 1);
	if (MonsterCount < 2) then
		SelectMsg(UID, 2, savenum, 568, NPC, 18, 206);
	else
		SelectMsg(UID, 4, savenum, 568, NPC, 41, 207, 27, 193);
	end
end

if (EVENT == 206) then
	ShowMap(UID, 32);
end

if (EVENT == 207) then
	SaveEvent(UID, 304);
end

local savenum = 114;

if (EVENT == 410) then -- 28 Level War -> Boss
	SaveEvent(UID, 820);
end

if (EVENT == 412) then
	SelectMsg(UID, 4, savenum, 723, NPC, 22, 413, 23, 414);
end

if (EVENT == 413) then
	SaveEvent(UID, 821);
end

if (EVENT == 414) then
	SaveEvent(UID, 824);
end

if (EVENT == 416) then
	SelectMsg(UID, 2, savenum, 723, NPC, 10, 193);
	SaveEvent(UID, 823);
end

if (EVENT == 417) then
	ITEMA = HowmuchItem(UID, 392012000);
	if (ITEMA < 3) then
		SelectMsg(UID, 2, savenum, 723, NPC, 18, 418);
	else
		SelectMsg(UID, 4, savenum, 723, NPC, 41, 419, 27, 193);
	end
end

if (EVENT == 418) then
	ShowMap(UID, 22);
end

if (EVENT == 419) then
	RobItem(UID, 392012000, 3)
	SaveEvent(UID, 822);
end

local savenum = 112;

if (EVENT == 290) then -- 29 Level Beozar of Glyptodont
	SaveEvent(UID, 510);
end

if (EVENT == 292) then
	SelectMsg(UID, 4, savenum, 1338, NPC, 22, 293, 23, 294);
end

if (EVENT == 293) then
	SaveEvent(UID, 511);
end

if (EVENT == 294) then
	SaveEvent(UID, 514);
end

if (EVENT == 297) then
	SelectMsg(UID, 2, savenum, 1338, NPC, 10, 193);
	SaveEvent(UID, 513);
end

if (EVENT == 298) then
	ITEM = HowmuchItem(UID, 379015000);
	if (ITEM < 5) then
		SelectMsg(UID, 2, savenum, 1338, NPC, 18, 299);
	else
		SelectMsg(UID, 4, savenum, 1338, NPC, 41, 300, 27, 193);
	end
end

if (EVENT == 299) then
	ShowMap(UID, 595);
end

if (EVENT == 300) then
	RobItem(UID, 379015000, 5);
	SaveEvent(UID, 512);
end

local savenum = 112; -- Glypdont

if (EVENT == 301) then 
	SaveEvent(UID, 332);
end

if (EVENT == 303) then 
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 584, NPC, 22, 304, 23, 305);
	else
		SelectMsg(UID, 2, savenum, 584, NPC, 10, 193);
	end
end

if (EVENT == 304) then
	SaveEvent(UID, 333);
end

if (EVENT == 305) then
	SaveEvent(UID, 336);
end

if (EVENT == 307) then
	SelectMsg(UID, 2, savenum, 584, NPC, 10, 193);
	SaveEvent(UID, 335);
end

if (EVENT == 308) then
	MonsterCount = CountMonsterQuestSub(UID, 125, 1);
	if (MonsterCount < 4) then
		SelectMsg(UID, 2, savenum, 584, NPC, 15, 309);
	else
		SelectMsg(UID, 4, savenum, 584, NPC, 41, 310, 27, 193);
	end
end

if (EVENT == 309) then
	ShowMap(UID, 694);
end

if (EVENT == 310) then
	SaveEvent(UID, 334);
end

local savenum = 115;

if (EVENT == 400) then -- 30 Level Keilan Scale
	SaveEvent(UID, 9944);
end

if (EVENT == 402) then
	SelectMsg(UID, 4, savenum, 1232, NPC, 22, 403, 23, 404);
end

if (EVENT == 403) then
	SaveEvent(UID, 9945);
end

if (EVENT == 404) then
	SaveEvent(UID, 9948);
end

if (EVENT == 405) then
	SelectMsg(UID, 2, savenum, 1232, NPC, 10, 193);
	SaveEvent(UID, 9947);
end

if (EVENT == 407) then
	ITEMB = HowmuchItem(UID, 379290000);
	if (ITEMB < 5) then
		SelectMsg(UID, 2, savenum, 1232, NPC, 18, 408);
	else
		SelectMsg(UID, 4, savenum, 1232, NPC, 41, 409, 27, 193);
	end
end

if (EVENT == 408) then
	ShowMap(UID, 527);
end

if (EVENT == 409) then
	RobItem(UID, 379290000, 5)
	SaveEvent(UID, 9946);
end

-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=102 status=2 n_index=304
if (EVENT == 190) then
	SearchQuest(UID, 19004);
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
