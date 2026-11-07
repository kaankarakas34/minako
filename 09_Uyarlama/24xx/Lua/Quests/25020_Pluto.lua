-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6141]={{900005000,1347}},
  [6142]={{900008000,1348}},
  [6143]={{900687000,10}},
  [6144]={},
  [6148]={{900005000,1354}},
  [6149]={{900657000,10}},
  [6150]={{900005000,1356}},
  [6151]={{900005000,1357}},
  [6155]={{900005000,1361}},
  [6156]={{900005000,1362}},
  [6157]={},
}
local __KO_Completion = {
  [3793]={1347,6141},
  [3799]={1348,6142},
  [3805]={1349,6143},
  [3811]={1350,6144},
  [3835]={1354,6148},
  [3841]={1355,6149},
  [3847]={1356,6150},
  [3853]={1357,6151},
  [3877]={1361,6155},
  [3883]={1362,6156},
  [3889]={1363,6157},
}
local __KO_Quests = {
  [6141]={1347},
  [6142]={1348},
  [6143]={1349},
  [6144]={1350},
  [6148]={1354},
  [6149]={1355},
  [6150]={1356},
  [6151]={1357},
  [6155]={1361},
  [6156]={1362},
  [6157]={1363},
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
local NPC = 25020;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 44135, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 44135, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 1112) then
	SelectMsg(UID, 4, 1347, 44135, NPC, 22, 1113, 23, -1);
end

if (EVENT == 1113) then
	QuestStatus = GetQuestStatus(UID, 1347)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 3792);
	end
end

if (EVENT == 1114) then
	QuestStatus = GetQuestStatus(UID, 1347)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1347, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 1347, 44135, NPC, 18, 1116);
		else
			SaveEvent(UID, 3794);
		end
	end
end

if (EVENT == 1115) then
	QuestStatus = GetQuestStatus(UID, 1347)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1347, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 1347, 44135, NPC, 18, 1116);
		else
			SelectMsg(UID, 4, 1347, 44135, NPC, 41, 1117, 27, -1);
		end
	end
end

if (EVENT == 1116) then
	ShowMap(UID, 1245);
end

if (EVENT == 1117) then
	QuestStatus = GetQuestStatus(UID, 1347)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1347, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 1347, 44135, NPC, 18, 1116);
		else
			RunExchange(UID,6141);
			SaveEvent(UID, 3793);   
		end
	end
end

if (EVENT == 1122) then
	SelectMsg(UID, 4, 1348, 44136, NPC, 22, 1123, 23, -1);
end

if (EVENT == 1123) then
	QuestStatus = GetQuestStatus(UID, 1348)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 3798);
	end
end

if (EVENT == 1124) then
	QuestStatus = GetQuestStatus(UID, 1348)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1348, 1);
		if (MonsterCount < 30) then
			SelectMsg(UID, 2, 1348, 44136, NPC, 18, 1126);
		else
			SaveEvent(UID, 3800);
		end
	end
end

if (EVENT == 1125) then
	QuestStatus = GetQuestStatus(UID, 1348)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1348, 1);
		if (MonsterCount < 30) then
			SelectMsg(UID, 2, 1348, 44136, NPC, 18, 1126);
		else
			SelectMsg(UID, 4, 1348, 44136, NPC, 41, 1127, 27, -1);
		end
	end
end

if (EVENT == 1126) then
	ShowMap(UID, 488);
end

if (EVENT == 1127) then
	QuestStatus = GetQuestStatus(UID, 1348)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1348, 1);
		if (MonsterCount < 30) then
			SelectMsg(UID, 2, 1348, 44136, NPC, 18, 1126);
		else
			RunExchange(UID,6142);
			SaveEvent(UID, 3799);
		end
	end
end

if (EVENT == 1132) then
	SelectMsg(UID, 4, 1349, 44137, NPC, 22, 1133, 23, -1);
end

if (EVENT == 1133) then
	QuestStatus = GetQuestStatus(UID, 1349)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 3804);
	end
end

if (EVENT == 1137) then
	QuestStatus = GetQuestStatus(UID, 1349)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	CONTTA = HowmuchItem(UID, 900687000);
		if (CONTTA < 10) then
			SelectMsg(UID, 2, 1349, 44137, NPC, 19, 1134);
		else
			SaveEvent(UID, 3806);
		end
	end
end

if (EVENT == 1134) then
	ShowMap(UID, 488);
end

if (EVENT == 1135) then
	QuestStatus = GetQuestStatus(UID, 1349)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	CONTTA = HowmuchItem(UID, 900687000);
		if (CONTTA < 10) then
			SelectMsg(UID, 2, 1349, 44137, NPC, 19, 1134);
		else
			SelectMsg(UID, 4, 1349, 44137, NPC, 22, 1136, 23, -1);
		end
	end
end

if (EVENT == 1136) then
	QuestStatus = GetQuestStatus(UID, 1349)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	CONTTA = HowmuchItem(UID, 900687000);
		if (CONTTA < 10) then
			SelectMsg(UID, 2, 1349, 44137, NPC, 19, 1134);
		else
			RunExchange(UID,6143);
			SaveEvent(UID, 3805);
		end
	end
end

if (EVENT == 1142) then
	SelectMsg(UID, 4, 1350, 44138, NPC, 22, 1143, 23, -1);
end

if (EVENT == 1143) then
	SaveEvent(UID, 3810);
	SaveEvent(UID, 3812);
end

if (EVENT == 1145) then
	SelectMsg(UID, 4, 1350, 44138, NPC, 22, 1146, 23, -1);
end

if (EVENT == 1146) then
	RunExchange(UID,6144);
	SaveEvent(UID, 3811);   
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=1347 status=255 n_index=3790
if (EVENT == 1110) then
	SaveEvent(UID, 3791);
end

-- [AUTO-GEN] quest=1348 status=255 n_index=3796
if (EVENT == 1120) then
	SaveEvent(UID, 3797);
end

-- [AUTO-GEN] quest=1349 status=255 n_index=3802
if (EVENT == 1130) then
	SaveEvent(UID, 3803);
end

-- [AUTO-GEN] quest=1350 status=255 n_index=3808
if (EVENT == 1140) then
	SaveEvent(UID, 3809);
end

-- [AUTO-GEN] quest=1350 status=1 n_index=3810
if (EVENT == 1147) then
	QuestStatusCheck = GetQuestStatus(UID, 1350)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6144);
		SaveEvent(UID, 3811);
	end
end

-- [AUTO-GEN] quest=1354 status=255 n_index=3832
if (EVENT == 1200) then
	SaveEvent(UID, 3833);
end

-- [AUTO-GEN] quest=1354 status=0 n_index=3833
if (EVENT == 1202) then
	SelectMsg(UID, 4, 1354, 44142, NPC, 764, 1203, 23, -1);
end

-- [AUTO-GEN] quest=1354 status=0 n_index=3833
if (EVENT == 1203) then
	SaveEvent(UID, 3834);
end

-- [AUTO-GEN] quest=1354 status=1 n_index=3834
if (EVENT == 1205) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1354, 44142, NPC, 22, 1207, 23, -1);
	else
		SelectMsg(UID, 2, 1354, 44142, NPC, 18, 1206);
	end
end

-- [AUTO-GEN] quest=1354 status=1 n_index=3834
if (EVENT == 1206) then
	ShowMap(UID, 71);
end

-- [AUTO-GEN] quest=1354 status=1 n_index=3834
if (EVENT == 1207) then
	QuestStatusCheck = GetQuestStatus(UID, 1354)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6148);
		SaveEvent(UID, 3835);
	end
end

-- [AUTO-GEN] quest=1355 status=255 n_index=3838
if (EVENT == 1210) then
	SaveEvent(UID, 3839);
end

-- [AUTO-GEN] quest=1355 status=0 n_index=3839
if (EVENT == 1212) then
	SelectMsg(UID, 4, 1355, 44143, NPC, 765, 1213, 23, -1);
end

-- [AUTO-GEN] quest=1355 status=0 n_index=3839
if (EVENT == 1213) then
	SaveEvent(UID, 3840);
end

-- [AUTO-GEN] quest=1355 status=1 n_index=3840
if (EVENT == 1215) then
	ItemA = HowmuchItem(UID, 900657000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1355, 44143, NPC, 18, 1216);
	else
		SelectMsg(UID, 4, 1355, 44143, NPC, 41, 1217, 27, -1);
	end
end

-- [AUTO-GEN] quest=1355 status=1 n_index=3840
if (EVENT == 1216) then
	ShowMap(UID, 71);
end

-- [AUTO-GEN] quest=1355 status=1 n_index=3840
if (EVENT == 1217) then
	QuestStatusCheck = GetQuestStatus(UID, 1355)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6149);
		SaveEvent(UID, 3841);
	end
end

-- [AUTO-GEN] quest=1356 status=255 n_index=3844
if (EVENT == 1220) then
	SaveEvent(UID, 3845);
end

-- [AUTO-GEN] quest=1356 status=0 n_index=3845
if (EVENT == 1222) then
	SelectMsg(UID, 4, 1356, 44144, NPC, 766, 1223, 23, -1);
end

-- [AUTO-GEN] quest=1356 status=0 n_index=3845
if (EVENT == 1223) then
	SaveEvent(UID, 3846);
end

-- [AUTO-GEN] quest=1356 status=1 n_index=3846
if (EVENT == 1225) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1356, 44144, NPC, 22, 1227, 23, -1);
	else
		SelectMsg(UID, 2, 1356, 44144, NPC, 18, 1226);
	end
end

-- [AUTO-GEN] quest=1356 status=1 n_index=3846
if (EVENT == 1226) then
	ShowMap(UID, 71);
end

-- [AUTO-GEN] quest=1356 status=1 n_index=3846
if (EVENT == 1227) then
	QuestStatusCheck = GetQuestStatus(UID, 1356)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6150);
		SaveEvent(UID, 3847);
	end
end

-- [AUTO-GEN] quest=1357 status=255 n_index=3850
if (EVENT == 1230) then
	SaveEvent(UID, 3851);
end

-- [AUTO-GEN] quest=1357 status=0 n_index=3851
if (EVENT == 1232) then
	SelectMsg(UID, 4, 1357, 44145, NPC, 767, 1233, 23, -1);
end

-- [AUTO-GEN] quest=1357 status=0 n_index=3851
if (EVENT == 1233) then
	SaveEvent(UID, 3852);
end

-- [AUTO-GEN] quest=1357 status=1 n_index=3852
if (EVENT == 1235) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1357, 44145, NPC, 22, 1237, 23, -1);
	else
		SelectMsg(UID, 2, 1357, 44145, NPC, 18, 1236);
	end
end

-- [AUTO-GEN] quest=1357 status=1 n_index=3852
if (EVENT == 1236) then
	ShowMap(UID, 71);
end

-- [AUTO-GEN] quest=1357 status=1 n_index=3852
if (EVENT == 1237) then
	QuestStatusCheck = GetQuestStatus(UID, 1357)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6151);
		SaveEvent(UID, 3853);
	end
end

-- [AUTO-GEN] quest=1361 status=255 n_index=3874
if (EVENT == 1240) then
	SaveEvent(UID, 3875);
end

-- [AUTO-GEN] quest=1361 status=0 n_index=3875
if (EVENT == 1242) then
	SelectMsg(UID, 4, 1361, 44149, NPC, 777, 1243, 23, -1);
end

-- [AUTO-GEN] quest=1361 status=0 n_index=3875
if (EVENT == 1243) then
	SaveEvent(UID, 3876);
end

-- [AUTO-GEN] quest=1361 status=1 n_index=3876
if (EVENT == 1245) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1361, 44149, NPC, 22, 1247, 23, -1);
	else
		SelectMsg(UID, 2, 1361, 44149, NPC, 18, 1246);
	end
end

-- [AUTO-GEN] quest=1361 status=1 n_index=3876
if (EVENT == 1246) then
	ShowMap(UID, 71);
end

-- [AUTO-GEN] quest=1361 status=1 n_index=3876
if (EVENT == 1247) then
	QuestStatusCheck = GetQuestStatus(UID, 1361)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6155);
		SaveEvent(UID, 3877);
	end
end

-- [AUTO-GEN] quest=1362 status=255 n_index=3880
if (EVENT == 1250) then
	SaveEvent(UID, 3881);
end

-- [AUTO-GEN] quest=1362 status=0 n_index=3881
if (EVENT == 1252) then
	SelectMsg(UID, 4, 1362, 44150, NPC, 778, 1253, 23, -1);
end

-- [AUTO-GEN] quest=1362 status=0 n_index=3881
if (EVENT == 1253) then
	SaveEvent(UID, 3882);
end

-- [AUTO-GEN] quest=1362 status=1 n_index=3882
if (EVENT == 1255) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1362, 44150, NPC, 22, 1257, 23, -1);
	else
		SelectMsg(UID, 2, 1362, 44150, NPC, 18, 1256);
	end
end

-- [AUTO-GEN] quest=1362 status=1 n_index=3882
if (EVENT == 1256) then
	ShowMap(UID, 71);
end

-- [AUTO-GEN] quest=1362 status=1 n_index=3882
if (EVENT == 1257) then
	QuestStatusCheck = GetQuestStatus(UID, 1362)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6156);
		SaveEvent(UID, 3883);
	end
end

-- [AUTO-GEN] quest=1363 status=255 n_index=3886
if (EVENT == 1260) then
	SaveEvent(UID, 3887);
end

-- [AUTO-GEN] quest=1363 status=0 n_index=3887
if (EVENT == 1262) then
	SelectMsg(UID, 4, 1363, 44151, NPC, 779, 1263, 23, -1);
end

-- [AUTO-GEN] quest=1363 status=0 n_index=3887
if (EVENT == 1263) then
	SaveEvent(UID, 3888);
end

-- [AUTO-GEN] quest=1363 status=1 n_index=3888
if (EVENT == 1265) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1363, 44151, NPC, 18, 1266);
	else
		SelectMsg(UID, 4, 1363, 44151, NPC, 41, 1267, 27, -1);
	end
end

-- [AUTO-GEN] quest=1363 status=1 n_index=3888
if (EVENT == 1266) then
	ShowMap(UID, 71);
end

-- [AUTO-GEN] quest=1363 status=1 n_index=3888
if (EVENT == 1267) then
	QuestStatusCheck = GetQuestStatus(UID, 1363)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6157);
		SaveEvent(UID, 3889);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
