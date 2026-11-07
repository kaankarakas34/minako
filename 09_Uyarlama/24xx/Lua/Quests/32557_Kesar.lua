-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [127]={{900071000,1}},
  [128]={{900068000,1}},
  [133]={{900008000,340}},
  [182]={{900019000,1},{900019000,2},{900019000,3},{900019000,4}},
  [193]={{900038000,1}},
}
local __KO_Completion = {
  [748]={295,128},
  [761]={296,127},
  [771]={297,128},
  [781]={298,127},
  [791]={299,128},
  [801]={300,127},
  [811]={301,128},
  [828]={340,133},
  [1050]={371,182},
  [1060]={372,182},
  [1070]={373,182},
  [1080]={374,182},
  [1090]={375,182},
  [1100]={376,182},
  [1110]={377,182},
  [1292]={191,193},
}
local __KO_Quests = {
  [127]={296,298,300},
  [128]={295,297,299,301},
  [133]={340},
  [182]={371,372,373,374,375,376,377},
  [193]={191},
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
local Ret = 0;
local NPC = 32557;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 1043, NPC, 10, 101);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 1043, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 101) then
	Ret = 1;
end

local savenum = 1016;

if (EVENT == 102) then -- 61 Level 1st Class Document
	SaveEvent(UID, 746);
end

if (EVENT == 104) then
	SelectMsg(UID, 4, savenum, 1043, NPC, 22, 105, 23, 106);
end

if (EVENT == 105) then
	SaveEvent(UID, 747);
end

if (EVENT == 106) then
	SaveEvent(UID, 750);
end

if (EVENT == 111) then
	SaveEvent(UID, 749);
end

if (EVENT == 112) then
	ITEMD = HowmuchItem(UID, 900068000);
	if (ITEMD < 1) then
		SelectMsg(UID, 2, savenum, 1043, NPC, 18, 113);
	else
		SelectMsg(UID, 4, savenum, 8986, NPC, 4006, 114, 4005, 101);
	end
end

if (EVENT == 113) then
	ShowMap(UID, 356);
end

if (EVENT == 114) then
	RobItem(UID, 900068000, 1)
	ExpChange(UID, 2000000)
	GiveLoyalty(UID, 150)
	SaveEvent(UID, 748);
end

local savenum = 1017;

if (EVENT == 184) then -- 61 Level Sealed Soul
	SelectMsg(UID, 4, savenum, 1062, NPC, 22, 185, 23, 186);
end

if (EVENT == 185) then
	SaveEvent(UID, 760);
end

if (EVENT == 186) then
	SaveEvent(UID, 763);
end

if (EVENT == 191) then
	SaveEvent(UID, 762);
end

if (EVENT == 192) then
	ITEMP = HowmuchItem(UID, 900071000);
	if (ITEMP < 1) then
		SelectMsg(UID, 2, savenum, 1062, NPC, 18, 193);
	else
		SelectMsg(UID, 4, savenum, 1062, NPC, 4006, 194, 4005, 101);
	end
end

if (EVENT == 193) then
	ShowMap(UID, 356);
end

if (EVENT == 194) then
	RobItem(UID, 900071000, 1)
	ExpChange(UID, 1000000)
	GiveLoyalty(UID, 200)
	SaveEvent(UID, 761);
end

local savenum = 1054;

if (EVENT == 240) then -- 61 Level Ronark Intelligence
	SelectMsg(UID, 4, savenum, 1484, NPC, 22, 241, 23, 242);
end

if (EVENT == 241) then
	SaveEvent(UID, 1049);
end

if (EVENT == 242) then
	SaveEvent(UID, 1052);
end

if (EVENT == 243) then
	SaveEvent(UID, 1051);
end

if (EVENT == 244) then
	ITEMP = HowmuchItem(UID, 900019000);
	if (ITEMP < 1) then
		SelectMsg(UID, 2, savenum, 1484, NPC, 18, 245);
	else
		SelectMsg(UID, 4, savenum, 1484, NPC, 4006, 246, 4005, 101);
	end
end

if (EVENT == 245) then
	ShowMap(UID, 356);
end

if (EVENT == 246) then
	RobItem(UID, 900019000, 1)
	ExpChange(UID, 500000)
	SaveEvent(UID, 1050);
end

if (EVENT == 530) then -- 70 Level 100 Kill
	SaveEvent(UID, 826);
	SelectMsg(UID, 2, savenum, 723, NPC, 4080, 193);
end

if (EVENT == 532) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 723, NPC, 22, 533, 23, 534);
	else
		SelectMsg(UID, 2, savenum, 723, NPC, 10, 193);
	end
end

if (EVENT == 533) then
	SaveEvent(UID, 827);
end

if (EVENT == 534) then
	SaveEvent(UID, 830);
end

if (EVENT == 535) then
	SaveEvent(UID, 829);
	SelectMsg(UID, 2, savenum, 723, NPC, 14, 193);
end

if (EVENT == 536) then
	MonsterCount = CountMonsterQuestSub(UID, 1024, 1);
	if (MonsterCount < 100) then
		SelectMsg(UID, 2, savenum, 723, NPC, 18, 538);
	else
		SelectMsg(UID, 4, savenum, 723, NPC, 4172, 537, 4173, 193);
	end
end

if (EVENT == 538) then
	ShowMap(UID, 489);
end

if (EVENT == 537) then
	ExpChange(UID, 20000000)
	SaveEvent(UID, 828);   
end

-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=191 status=0 n_index=1290
if (EVENT == 400) then
	SelectMsg(UID, 4, 191, 8881, NPC, 173, 401, 23, -1);
end

-- [AUTO-GEN] quest=191 status=0 n_index=1290
if (EVENT == 401) then
	SaveEvent(UID, 1291);
end

-- [AUTO-GEN] quest=191 status=1 n_index=1291
if (EVENT == 420) then
	QuestStatusCheck = GetQuestStatus(UID, 191)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 193);
		SaveEvent(UID, 1292);
	end
end

-- [AUTO-GEN] quest=297 status=0 n_index=769
if (EVENT == 124) then
	SelectMsg(UID, 4, 297, 1043, NPC, 128, 125, 23, -1);
end

-- [AUTO-GEN] quest=297 status=0 n_index=769
if (EVENT == 125) then
	SaveEvent(UID, 770);
end

-- [AUTO-GEN] quest=297 status=1 n_index=770
if (EVENT == 131) then
	QuestStatusCheck = GetQuestStatus(UID, 297)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 128);
		SaveEvent(UID, 771);
	end
end

-- [AUTO-GEN] quest=297 status=1 n_index=770
if (EVENT == 132) then
	ItemA = HowmuchItem(UID, 900068000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 297, 1043, NPC, 18, 133);
	else
		SelectMsg(UID, 4, 297, 1043, NPC, 41, 131, 27, -1);
	end
end

-- [AUTO-GEN] quest=297 status=1 n_index=770
if (EVENT == 133) then
	ShowMap(UID, 770);
end

-- [AUTO-GEN] quest=299 status=0 n_index=789
if (EVENT == 144) then
	SelectMsg(UID, 4, 299, 1043, NPC, 128, 145, 23, -1);
end

-- [AUTO-GEN] quest=299 status=0 n_index=789
if (EVENT == 145) then
	SaveEvent(UID, 790);
end

-- [AUTO-GEN] quest=299 status=1 n_index=790
if (EVENT == 151) then
	QuestStatusCheck = GetQuestStatus(UID, 299)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 128);
		SaveEvent(UID, 791);
	end
end

-- [AUTO-GEN] quest=299 status=1 n_index=790
if (EVENT == 152) then
	ItemA = HowmuchItem(UID, 900068000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 299, 1043, NPC, 18, 153);
	else
		SelectMsg(UID, 4, 299, 1043, NPC, 41, 151, 27, -1);
	end
end

-- [AUTO-GEN] quest=299 status=1 n_index=790
if (EVENT == 153) then
	ShowMap(UID, 790);
end

-- [AUTO-GEN] quest=301 status=0 n_index=809
if (EVENT == 164) then
	SelectMsg(UID, 4, 301, 1043, NPC, 128, 165, 23, -1);
end

-- [AUTO-GEN] quest=301 status=0 n_index=809
if (EVENT == 165) then
	SaveEvent(UID, 810);
end

-- [AUTO-GEN] quest=301 status=1 n_index=810
if (EVENT == 171) then
	QuestStatusCheck = GetQuestStatus(UID, 301)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 128);
		SaveEvent(UID, 811);
	end
end

-- [AUTO-GEN] quest=301 status=1 n_index=810
if (EVENT == 172) then
	ItemA = HowmuchItem(UID, 900068000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 301, 1043, NPC, 18, 173);
	else
		SelectMsg(UID, 4, 301, 1043, NPC, 41, 171, 27, -1);
	end
end

-- [AUTO-GEN] quest=301 status=1 n_index=810
if (EVENT == 173) then
	ShowMap(UID, 810);
end

-- [AUTO-GEN] quest=298 status=0 n_index=779
if (EVENT == 204) then
	SelectMsg(UID, 4, 298, 1062, NPC, 129, 205, 23, -1);
end

-- [AUTO-GEN] quest=298 status=0 n_index=779
if (EVENT == 205) then
	SaveEvent(UID, 780);
end

-- [AUTO-GEN] quest=298 status=1 n_index=780
if (EVENT == 211) then
	QuestStatusCheck = GetQuestStatus(UID, 298)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 127);
		SaveEvent(UID, 781);
	end
end

-- [AUTO-GEN] quest=298 status=1 n_index=780
if (EVENT == 212) then
	ItemA = HowmuchItem(UID, 900071000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 298, 1062, NPC, 18, 213);
	else
		SelectMsg(UID, 4, 298, 1062, NPC, 41, 211, 27, -1);
	end
end

-- [AUTO-GEN] quest=298 status=1 n_index=780
if (EVENT == 213) then
	ShowMap(UID, 780);
end

-- [AUTO-GEN] quest=300 status=0 n_index=799
if (EVENT == 224) then
	SelectMsg(UID, 4, 300, 1062, NPC, 129, 225, 23, -1);
end

-- [AUTO-GEN] quest=300 status=0 n_index=799
if (EVENT == 225) then
	SaveEvent(UID, 800);
end

-- [AUTO-GEN] quest=300 status=1 n_index=800
if (EVENT == 231) then
	QuestStatusCheck = GetQuestStatus(UID, 300)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 127);
		SaveEvent(UID, 801);
	end
end

-- [AUTO-GEN] quest=300 status=1 n_index=800
if (EVENT == 232) then
	ItemA = HowmuchItem(UID, 900071000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 300, 1062, NPC, 18, 233);
	else
		SelectMsg(UID, 4, 300, 1062, NPC, 41, 231, 27, -1);
	end
end

-- [AUTO-GEN] quest=300 status=1 n_index=800
if (EVENT == 233) then
	ShowMap(UID, 800);
end

-- [AUTO-GEN] quest=372 status=0 n_index=1058
if (EVENT == 250) then
	SelectMsg(UID, 4, 372, 1484, NPC, 157, 251, 23, -1);
end

-- [AUTO-GEN] quest=372 status=0 n_index=1058
if (EVENT == 251) then
	SaveEvent(UID, 1059);
end

-- [AUTO-GEN] quest=372 status=1 n_index=1059
if (EVENT == 253) then
	QuestStatusCheck = GetQuestStatus(UID, 372)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 182);
		SaveEvent(UID, 1060);
	end
end

-- [AUTO-GEN] quest=372 status=1 n_index=1059
if (EVENT == 254) then
	ItemA = HowmuchItem(UID, 900019000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 372, 1484, NPC, 18, 255);
	else
		SelectMsg(UID, 4, 372, 1484, NPC, 41, 253, 27, -1);
	end
end

-- [AUTO-GEN] quest=372 status=1 n_index=1059
if (EVENT == 255) then
	ShowMap(UID, 1059);
end

-- [AUTO-GEN] quest=373 status=0 n_index=1068
if (EVENT == 260) then
	SelectMsg(UID, 4, 373, 1484, NPC, 157, 261, 23, -1);
end

-- [AUTO-GEN] quest=373 status=0 n_index=1068
if (EVENT == 261) then
	SaveEvent(UID, 1069);
end

-- [AUTO-GEN] quest=373 status=1 n_index=1069
if (EVENT == 263) then
	QuestStatusCheck = GetQuestStatus(UID, 373)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 182);
		SaveEvent(UID, 1070);
	end
end

-- [AUTO-GEN] quest=373 status=1 n_index=1069
if (EVENT == 264) then
	ItemA = HowmuchItem(UID, 900019000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 373, 1484, NPC, 18, 265);
	else
		SelectMsg(UID, 4, 373, 1484, NPC, 41, 263, 27, -1);
	end
end

-- [AUTO-GEN] quest=373 status=1 n_index=1069
if (EVENT == 265) then
	ShowMap(UID, 1069);
end

-- [AUTO-GEN] quest=374 status=0 n_index=1078
if (EVENT == 270) then
	SelectMsg(UID, 4, 374, 1484, NPC, 157, 271, 23, -1);
end

-- [AUTO-GEN] quest=374 status=0 n_index=1078
if (EVENT == 271) then
	SaveEvent(UID, 1079);
end

-- [AUTO-GEN] quest=374 status=1 n_index=1079
if (EVENT == 273) then
	QuestStatusCheck = GetQuestStatus(UID, 374)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 182);
		SaveEvent(UID, 1080);
	end
end

-- [AUTO-GEN] quest=374 status=1 n_index=1079
if (EVENT == 274) then
	ItemA = HowmuchItem(UID, 900019000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 374, 1484, NPC, 18, 275);
	else
		SelectMsg(UID, 4, 374, 1484, NPC, 41, 273, 27, -1);
	end
end

-- [AUTO-GEN] quest=374 status=1 n_index=1079
if (EVENT == 275) then
	ShowMap(UID, 1079);
end

-- [AUTO-GEN] quest=375 status=0 n_index=1088
if (EVENT == 280) then
	SelectMsg(UID, 4, 375, 1484, NPC, 157, 281, 23, -1);
end

-- [AUTO-GEN] quest=375 status=0 n_index=1088
if (EVENT == 281) then
	SaveEvent(UID, 1089);
end

-- [AUTO-GEN] quest=375 status=1 n_index=1089
if (EVENT == 283) then
	QuestStatusCheck = GetQuestStatus(UID, 375)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 182);
		SaveEvent(UID, 1090);
	end
end

-- [AUTO-GEN] quest=375 status=1 n_index=1089
if (EVENT == 284) then
	ItemA = HowmuchItem(UID, 900019000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 375, 1484, NPC, 18, 285);
	else
		SelectMsg(UID, 4, 375, 1484, NPC, 41, 283, 27, -1);
	end
end

-- [AUTO-GEN] quest=375 status=1 n_index=1089
if (EVENT == 285) then
	ShowMap(UID, 1089);
end

-- [AUTO-GEN] quest=376 status=0 n_index=1098
if (EVENT == 290) then
	SelectMsg(UID, 4, 376, 1484, NPC, 157, 291, 23, -1);
end

-- [AUTO-GEN] quest=376 status=0 n_index=1098
if (EVENT == 291) then
	SaveEvent(UID, 1099);
end

-- [AUTO-GEN] quest=376 status=1 n_index=1099
if (EVENT == 293) then
	QuestStatusCheck = GetQuestStatus(UID, 376)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 182);
		SaveEvent(UID, 1100);
	end
end

-- [AUTO-GEN] quest=376 status=1 n_index=1099
if (EVENT == 294) then
	ItemA = HowmuchItem(UID, 900019000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 376, 1484, NPC, 18, 295);
	else
		SelectMsg(UID, 4, 376, 1484, NPC, 41, 293, 27, -1);
	end
end

-- [AUTO-GEN] quest=376 status=1 n_index=1099
if (EVENT == 295) then
	ShowMap(UID, 1099);
end

-- [AUTO-GEN] quest=377 status=0 n_index=1108
if (EVENT == 300) then
	SelectMsg(UID, 4, 377, 1484, NPC, 157, 301, 23, -1);
end

-- [AUTO-GEN] quest=377 status=0 n_index=1108
if (EVENT == 301) then
	SaveEvent(UID, 1109);
end

-- [AUTO-GEN] quest=377 status=1 n_index=1109
if (EVENT == 303) then
	QuestStatusCheck = GetQuestStatus(UID, 377)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 182);
		SaveEvent(UID, 1110);
	end
end

-- [AUTO-GEN] quest=377 status=1 n_index=1109
if (EVENT == 304) then
	ItemA = HowmuchItem(UID, 900019000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 377, 1484, NPC, 18, 305);
	else
		SelectMsg(UID, 4, 377, 1484, NPC, 41, 303, 27, -1);
	end
end

-- [AUTO-GEN] quest=377 status=1 n_index=1109
if (EVENT == 305) then
	ShowMap(UID, 1109);
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
