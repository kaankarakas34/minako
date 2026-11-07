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
  [182]={{900019000,1},{900019000,2},{900019000,3},{900019000,4}},
  [194]={{900038000,1}},
}
local __KO_Completion = {
  [754]={295,128},
  [766]={296,127},
  [776]={297,128},
  [786]={298,127},
  [796]={299,128},
  [806]={300,127},
  [816]={301,128},
  [1055]={371,182},
  [1065]={372,182},
  [1075]={373,182},
  [1085]={374,182},
  [1095]={375,182},
  [1105]={376,182},
  [1115]={377,182},
  [1297]={191,194},
}
local __KO_Quests = {
  [127]={296,298,300},
  [128]={295,297,299,301},
  [182]={371,372,373,374,375,376,377},
  [194]={191},
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
local NPC = 32558;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 1055, NPC, 10, 101);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 1055, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 101) then
	Ret = 1;
end

local savenum = 1016;

if (EVENT == 102) then -- 61 Level 1st Class Document
	SaveEvent(UID, 752);
end

if (EVENT == 104) then
	SelectMsg(UID, 4, savenum, 1055, NPC, 22, 105, 23, 106);
end

if (EVENT == 105) then
	SaveEvent(UID, 753);
end

if (EVENT == 106) then
	SaveEvent(UID, 756);
end

if (EVENT == 111) then
	SaveEvent(UID, 755);
end

if (EVENT == 112) then
	ITEMD = HowmuchItem(UID, 900068000);
	if (ITEMD < 1) then
		SelectMsg(UID, 2, savenum, 1055, NPC, 18, 113);
	else
		SelectMsg(UID, 4, savenum, 1055, NPC, 4006, 114, 4005, 101);
	end
end

if (EVENT == 113) then
	ShowMap(UID, 356);
end

if (EVENT == 114) then
	RobItem(UID, 900068000, 1)
	ExpChange(UID, 2000000)
	GiveLoyalty(UID, 150)
	SaveEvent(UID, 754);
end

local savenum = 1017;

if (EVENT == 184) then -- 61 Level Sealed Soul
	SelectMsg(UID, 4, savenum, 1074, NPC, 22, 185, 23, 186);
end

if (EVENT == 185) then
	SaveEvent(UID, 765);
end

if (EVENT == 186) then
	SaveEvent(UID, 768);
end

if (EVENT == 191) then
	SaveEvent(UID, 767);
end

if (EVENT == 192) then
	ITEMP = HowmuchItem(UID, 900071000);
	if (ITEMP < 1) then
		SelectMsg(UID, 2, savenum, 1074, NPC, 18, 193);
	else
		SelectMsg(UID, 4, savenum, 1074, NPC, 4006, 194, 4005, 101);
	end
end

if (EVENT == 193) then
	ShowMap(UID, 356);
end

if (EVENT == 194) then
	RobItem(UID, 900071000, 1)
	ExpChange(UID, 1000000)
	GiveLoyalty(UID, 200)
	SaveEvent(UID, 766);
end

local savenum = 1054;

if (EVENT == 240) then -- 61 Level Ronark Intelligence
	SelectMsg(UID, 4, savenum, 1483, NPC, 22, 241, 23, 242);
end

if (EVENT == 241) then
	SaveEvent(UID, 1054);
end

if (EVENT == 242) then
	SaveEvent(UID, 1057);
end

if (EVENT == 243) then
	SaveEvent(UID, 1056);
end

if (EVENT == 244) then
	ITEMP = HowmuchItem(UID, 900019000);
	if (ITEMP < 1) then
		SelectMsg(UID, 2, savenum, 1483, NPC, 18, 245);
	else
		SelectMsg(UID, 4, savenum, 1483, NPC, 4006, 246, 4005, 101);
	end
end

if (EVENT == 245) then
	ShowMap(UID, 356);
end

if (EVENT == 246) then
	RobItem(UID, 900019000, 1)
	ExpChange(UID, 500000)
	SaveEvent(UID, 1055);
end

-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=191 status=0 n_index=1295
if (EVENT == 400) then
	SelectMsg(UID, 4, 191, 8882, NPC, 174, 401, 23, -1);
end

-- [AUTO-GEN] quest=191 status=0 n_index=1295
if (EVENT == 401) then
	SaveEvent(UID, 1296);
end

-- [AUTO-GEN] quest=191 status=1 n_index=1296
if (EVENT == 420) then
	QuestStatusCheck = GetQuestStatus(UID, 191)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 194);
		SaveEvent(UID, 1297);
	end
end

-- [AUTO-GEN] quest=297 status=0 n_index=774
if (EVENT == 124) then
	SelectMsg(UID, 4, 297, 1055, NPC, 128, 125, 23, -1);
end

-- [AUTO-GEN] quest=297 status=0 n_index=774
if (EVENT == 125) then
	SaveEvent(UID, 775);
end

-- [AUTO-GEN] quest=297 status=1 n_index=775
if (EVENT == 131) then
	QuestStatusCheck = GetQuestStatus(UID, 297)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 128);
		SaveEvent(UID, 776);
	end
end

-- [AUTO-GEN] quest=297 status=1 n_index=775
if (EVENT == 132) then
	ItemA = HowmuchItem(UID, 900068000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 297, 1055, NPC, 18, 133);
	else
		SelectMsg(UID, 4, 297, 1055, NPC, 41, 131, 27, -1);
	end
end

-- [AUTO-GEN] quest=297 status=1 n_index=775
if (EVENT == 133) then
	ShowMap(UID, 775);
end

-- [AUTO-GEN] quest=299 status=0 n_index=794
if (EVENT == 144) then
	SelectMsg(UID, 4, 299, 1055, NPC, 128, 145, 23, -1);
end

-- [AUTO-GEN] quest=299 status=0 n_index=794
if (EVENT == 145) then
	SaveEvent(UID, 795);
end

-- [AUTO-GEN] quest=299 status=1 n_index=795
if (EVENT == 151) then
	QuestStatusCheck = GetQuestStatus(UID, 299)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 128);
		SaveEvent(UID, 796);
	end
end

-- [AUTO-GEN] quest=299 status=1 n_index=795
if (EVENT == 152) then
	ItemA = HowmuchItem(UID, 900068000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 299, 1055, NPC, 18, 153);
	else
		SelectMsg(UID, 4, 299, 1055, NPC, 41, 151, 27, -1);
	end
end

-- [AUTO-GEN] quest=299 status=1 n_index=795
if (EVENT == 153) then
	ShowMap(UID, 795);
end

-- [AUTO-GEN] quest=301 status=0 n_index=814
if (EVENT == 164) then
	SelectMsg(UID, 4, 301, 1055, NPC, 128, 165, 23, -1);
end

-- [AUTO-GEN] quest=301 status=0 n_index=814
if (EVENT == 165) then
	SaveEvent(UID, 815);
end

-- [AUTO-GEN] quest=301 status=1 n_index=815
if (EVENT == 171) then
	QuestStatusCheck = GetQuestStatus(UID, 301)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 128);
		SaveEvent(UID, 816);
	end
end

-- [AUTO-GEN] quest=301 status=1 n_index=815
if (EVENT == 172) then
	ItemA = HowmuchItem(UID, 900068000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 301, 1055, NPC, 18, 173);
	else
		SelectMsg(UID, 4, 301, 1055, NPC, 41, 171, 27, -1);
	end
end

-- [AUTO-GEN] quest=301 status=1 n_index=815
if (EVENT == 173) then
	ShowMap(UID, 815);
end

-- [AUTO-GEN] quest=298 status=0 n_index=784
if (EVENT == 204) then
	SelectMsg(UID, 4, 298, 1074, NPC, 129, 205, 23, -1);
end

-- [AUTO-GEN] quest=298 status=0 n_index=784
if (EVENT == 205) then
	SaveEvent(UID, 785);
end

-- [AUTO-GEN] quest=298 status=1 n_index=785
if (EVENT == 211) then
	QuestStatusCheck = GetQuestStatus(UID, 298)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 127);
		SaveEvent(UID, 786);
	end
end

-- [AUTO-GEN] quest=298 status=1 n_index=785
if (EVENT == 212) then
	ItemA = HowmuchItem(UID, 900071000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 298, 1074, NPC, 18, 213);
	else
		SelectMsg(UID, 4, 298, 1074, NPC, 41, 211, 27, -1);
	end
end

-- [AUTO-GEN] quest=298 status=1 n_index=785
if (EVENT == 213) then
	ShowMap(UID, 785);
end

-- [AUTO-GEN] quest=300 status=0 n_index=804
if (EVENT == 224) then
	SelectMsg(UID, 4, 300, 1074, NPC, 129, 225, 23, -1);
end

-- [AUTO-GEN] quest=300 status=0 n_index=804
if (EVENT == 225) then
	SaveEvent(UID, 805);
end

-- [AUTO-GEN] quest=300 status=1 n_index=805
if (EVENT == 231) then
	QuestStatusCheck = GetQuestStatus(UID, 300)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 127);
		SaveEvent(UID, 806);
	end
end

-- [AUTO-GEN] quest=300 status=1 n_index=805
if (EVENT == 232) then
	ItemA = HowmuchItem(UID, 900071000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 300, 1074, NPC, 18, 233);
	else
		SelectMsg(UID, 4, 300, 1074, NPC, 41, 231, 27, -1);
	end
end

-- [AUTO-GEN] quest=300 status=1 n_index=805
if (EVENT == 233) then
	ShowMap(UID, 805);
end

-- [AUTO-GEN] quest=372 status=0 n_index=1063
if (EVENT == 250) then
	SelectMsg(UID, 4, 372, 1483, NPC, 157, 251, 23, -1);
end

-- [AUTO-GEN] quest=372 status=0 n_index=1063
if (EVENT == 251) then
	SaveEvent(UID, 1064);
end

-- [AUTO-GEN] quest=372 status=1 n_index=1064
if (EVENT == 253) then
	QuestStatusCheck = GetQuestStatus(UID, 372)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 182);
		SaveEvent(UID, 1065);
	end
end

-- [AUTO-GEN] quest=372 status=1 n_index=1064
if (EVENT == 254) then
	ItemA = HowmuchItem(UID, 900019000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 372, 1483, NPC, 18, 255);
	else
		SelectMsg(UID, 4, 372, 1483, NPC, 41, 253, 27, -1);
	end
end

-- [AUTO-GEN] quest=372 status=1 n_index=1064
if (EVENT == 255) then
	ShowMap(UID, 1064);
end

-- [AUTO-GEN] quest=373 status=0 n_index=1073
if (EVENT == 260) then
	SelectMsg(UID, 4, 373, 1483, NPC, 157, 261, 23, -1);
end

-- [AUTO-GEN] quest=373 status=0 n_index=1073
if (EVENT == 261) then
	SaveEvent(UID, 1074);
end

-- [AUTO-GEN] quest=373 status=1 n_index=1074
if (EVENT == 263) then
	QuestStatusCheck = GetQuestStatus(UID, 373)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 182);
		SaveEvent(UID, 1075);
	end
end

-- [AUTO-GEN] quest=373 status=1 n_index=1074
if (EVENT == 264) then
	ItemA = HowmuchItem(UID, 900019000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 373, 1483, NPC, 18, 265);
	else
		SelectMsg(UID, 4, 373, 1483, NPC, 41, 263, 27, -1);
	end
end

-- [AUTO-GEN] quest=373 status=1 n_index=1074
if (EVENT == 265) then
	ShowMap(UID, 1074);
end

-- [AUTO-GEN] quest=374 status=0 n_index=1083
if (EVENT == 270) then
	SelectMsg(UID, 4, 374, 1483, NPC, 157, 271, 23, -1);
end

-- [AUTO-GEN] quest=374 status=0 n_index=1083
if (EVENT == 271) then
	SaveEvent(UID, 1084);
end

-- [AUTO-GEN] quest=374 status=1 n_index=1084
if (EVENT == 273) then
	QuestStatusCheck = GetQuestStatus(UID, 374)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 182);
		SaveEvent(UID, 1085);
	end
end

-- [AUTO-GEN] quest=374 status=1 n_index=1084
if (EVENT == 274) then
	ItemA = HowmuchItem(UID, 900019000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 374, 1483, NPC, 18, 275);
	else
		SelectMsg(UID, 4, 374, 1483, NPC, 41, 273, 27, -1);
	end
end

-- [AUTO-GEN] quest=374 status=1 n_index=1084
if (EVENT == 275) then
	ShowMap(UID, 1084);
end

-- [AUTO-GEN] quest=375 status=0 n_index=1093
if (EVENT == 280) then
	SelectMsg(UID, 4, 375, 1483, NPC, 157, 281, 23, -1);
end

-- [AUTO-GEN] quest=375 status=0 n_index=1093
if (EVENT == 281) then
	SaveEvent(UID, 1094);
end

-- [AUTO-GEN] quest=375 status=1 n_index=1094
if (EVENT == 283) then
	QuestStatusCheck = GetQuestStatus(UID, 375)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 182);
		SaveEvent(UID, 1095);
	end
end

-- [AUTO-GEN] quest=375 status=1 n_index=1094
if (EVENT == 284) then
	ItemA = HowmuchItem(UID, 900019000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 375, 1483, NPC, 18, 285);
	else
		SelectMsg(UID, 4, 375, 1483, NPC, 41, 283, 27, -1);
	end
end

-- [AUTO-GEN] quest=375 status=1 n_index=1094
if (EVENT == 285) then
	ShowMap(UID, 1094);
end

-- [AUTO-GEN] quest=376 status=0 n_index=1103
if (EVENT == 290) then
	SelectMsg(UID, 4, 376, 1483, NPC, 157, 291, 23, -1);
end

-- [AUTO-GEN] quest=376 status=0 n_index=1103
if (EVENT == 291) then
	SaveEvent(UID, 1104);
end

-- [AUTO-GEN] quest=376 status=1 n_index=1104
if (EVENT == 293) then
	QuestStatusCheck = GetQuestStatus(UID, 376)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 182);
		SaveEvent(UID, 1105);
	end
end

-- [AUTO-GEN] quest=376 status=1 n_index=1104
if (EVENT == 294) then
	ItemA = HowmuchItem(UID, 900019000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 376, 1483, NPC, 18, 295);
	else
		SelectMsg(UID, 4, 376, 1483, NPC, 41, 293, 27, -1);
	end
end

-- [AUTO-GEN] quest=376 status=1 n_index=1104
if (EVENT == 295) then
	ShowMap(UID, 1104);
end

-- [AUTO-GEN] quest=377 status=0 n_index=1113
if (EVENT == 300) then
	SelectMsg(UID, 4, 377, 1483, NPC, 157, 301, 23, -1);
end

-- [AUTO-GEN] quest=377 status=0 n_index=1113
if (EVENT == 301) then
	SaveEvent(UID, 1114);
end

-- [AUTO-GEN] quest=377 status=1 n_index=1114
if (EVENT == 303) then
	QuestStatusCheck = GetQuestStatus(UID, 377)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 182);
		SaveEvent(UID, 1115);
	end
end

-- [AUTO-GEN] quest=377 status=1 n_index=1114
if (EVENT == 304) then
	ItemA = HowmuchItem(UID, 900019000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 377, 1483, NPC, 18, 305);
	else
		SelectMsg(UID, 4, 377, 1483, NPC, 41, 303, 27, -1);
	end
end

-- [AUTO-GEN] quest=377 status=1 n_index=1114
if (EVENT == 305) then
	ShowMap(UID, 1114);
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
