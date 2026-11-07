-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6081]={{900005000,1285}},
  [6082]={{900008000,1286}},
  [6083]={{900687000,10}},
  [6084]={},
  [6090]={{900005000,1294}},
  [6091]={{900657000,10}},
  [6092]={{900005000,1296}},
  [6093]={{900005000,1297}},
  [6094]={{900005000,1301}},
  [6095]={{900005000,1302}},
  [6096]={},
}
local __KO_Completion = {
  [7857]={1285,6081},
  [7863]={1286,6082},
  [7869]={1287,6083},
  [7875]={1288,6084},
  [7911]={1294,6090},
  [7943]={1295,6091},
  [7949]={1296,6092},
  [7955]={1297,6093},
  [8007]={1301,6094},
  [8078]={1302,6095},
  [8084]={1303,6096},
}
local __KO_Quests = {
  [6081]={1285},
  [6082]={1286},
  [6083]={1287},
  [6084]={1288},
  [6090]={1294},
  [6091]={1295},
  [6092]={1296},
  [6093]={1297},
  [6094]={1301},
  [6095]={1302},
  [6096]={1303},
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
local NPC = 25006;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 4515, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 4516, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 112) then
	SelectMsg(UID, 4, 1285, 44135, NPC, 22, 113, 23, -1);
end

if (EVENT == 113) then
	QuestStatus = GetQuestStatus(UID, 1285)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7856);
	end
end

if (EVENT == 114) then
	QuestStatus = GetQuestStatus(UID, 1285)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7858);
	end
end

if (EVENT == 115) then
	QuestStatus = GetQuestStatus(UID, 1285)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1285, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 1285, 44135, NPC, 18, 116);
		else
			SelectMsg(UID, 4, 1285, 44135, NPC, 41, 117, 27, -1);
		end
	end
end

if (EVENT == 116) then
	ShowMap(UID, 1245);
end

if (EVENT == 117) then
	QuestStatus = GetQuestStatus(UID, 1285)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1285, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 1285, 44135, NPC, 18, 116);
		else
			RunExchange(UID,6081);
			SaveEvent(UID, 7857);
		end
	end
end

if (EVENT == 122) then
	SelectMsg(UID, 4, 1286, 44136, NPC, 22, 123, 23, -1);
end

if (EVENT == 123) then
	QuestStatus = GetQuestStatus(UID, 1286)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7862);
	end
end

if (EVENT == 124) then
	QuestStatus = GetQuestStatus(UID, 1286)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1286, 1);
		if (MonsterCount < 30) then
			SelectMsg(UID, 2, 1286, 44136, NPC, 18, 126);
		else
			SaveEvent(UID, 7864);
		end
	end
end

if (EVENT == 125) then
	QuestStatus = GetQuestStatus(UID, 1286)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1286, 1);
		if (MonsterCount < 30) then
			SelectMsg(UID, 2, 1286, 44136, NPC, 18, 126);
		else
			SelectMsg(UID, 4, 1286, 44136, NPC, 41, 127, 27, -1);
		end
	end
end

if (EVENT == 126) then
	ShowMap(UID, 488);
end

if (EVENT == 127) then
	QuestStatus = GetQuestStatus(UID, 1286)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1286, 1);
		if (MonsterCount < 30) then
			SelectMsg(UID, 2, 1286, 44136, NPC, 18, 126);
		else
			RunExchange(UID,6082);
			SaveEvent(UID, 7863);   
		end
	end
end

if (EVENT == 132) then
	SelectMsg(UID, 4, 1287, 44137, NPC, 22, 133, 23, -1);
end

if (EVENT == 133) then
	QuestStatus = GetQuestStatus(UID, 1287)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7868);
	end
end

if (EVENT == 137) then
	QuestStatus = GetQuestStatus(UID, 1287)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	CONTTA = HowmuchItem(UID, 900687000);
		if (CONTTA < 10) then
			SelectMsg(UID, 2, 1287, 44137, NPC, 19, 134);
		else
			SaveEvent(UID, 7870);
		end
	end
end

if (EVENT == 134) then
	ShowMap(UID, 488);
end

if (EVENT == 135) then
	QuestStatus = GetQuestStatus(UID, 1287)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	CONTTA = HowmuchItem(UID, 900687000);
		if (CONTTA < 10) then
			SelectMsg(UID, 2, 1287, 44137, NPC, 19, 134);
		else
			SelectMsg(UID, 4, 1287, 44137, NPC, 22, 136, 23, -1);
		end
	end
end

if (EVENT == 136) then
	QuestStatus = GetQuestStatus(UID, 1287)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	CONTTA = HowmuchItem(UID, 900687000);
		if (CONTTA < 10) then
			SelectMsg(UID, 2, 1287, 44137, NPC, 19, 134);
		else
			RunExchange(UID,6083);
			SaveEvent(UID, 7869);
		end
	end
end

if (EVENT == 142) then
	SelectMsg(UID, 4, 1288, 44138, NPC, 22, 143, 23, -1);
end

if (EVENT == 143) then
	SaveEvent(UID, 7874);
	SaveEvent(UID, 7876);
end

if (EVENT == 145) then
	SelectMsg(UID, 4, 1288, 44138, NPC, 22, 146, 23, -1);
end

if (EVENT == 146) then
	RunExchange(UID,6084);
	SaveEvent(UID, 7875);   
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=1285 status=255 n_index=7854
if (EVENT == 110) then
	SaveEvent(UID, 7855);
end

-- [AUTO-GEN] quest=1286 status=255 n_index=7860
if (EVENT == 120) then
	SaveEvent(UID, 7861);
end

-- [AUTO-GEN] quest=1287 status=255 n_index=7866
if (EVENT == 130) then
	SaveEvent(UID, 7867);
end

-- [AUTO-GEN] quest=1288 status=255 n_index=7872
if (EVENT == 140) then
	SaveEvent(UID, 7873);
end

-- [AUTO-GEN] quest=1288 status=1 n_index=7874
if (EVENT == 147) then
	QuestStatusCheck = GetQuestStatus(UID, 1288)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6084);
		SaveEvent(UID, 7875);
	end
end

-- [AUTO-GEN] quest=1294 status=255 n_index=7908
if (EVENT == 200) then
	SaveEvent(UID, 7909);
end

-- [AUTO-GEN] quest=1294 status=0 n_index=7909
if (EVENT == 202) then
	SelectMsg(UID, 4, 1294, 44142, NPC, 764, 203, 23, -1);
end

-- [AUTO-GEN] quest=1294 status=0 n_index=7909
if (EVENT == 203) then
	SaveEvent(UID, 7910);
end

-- [AUTO-GEN] quest=1294 status=1 n_index=7910
if (EVENT == 205) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1294, 44142, NPC, 22, 207, 23, -1);
	else
		SelectMsg(UID, 2, 1294, 44142, NPC, 18, 206);
	end
end

-- [AUTO-GEN] quest=1294 status=1 n_index=7910
if (EVENT == 206) then
	ShowMap(UID, 71);
end

-- [AUTO-GEN] quest=1294 status=1 n_index=7910
if (EVENT == 207) then
	QuestStatusCheck = GetQuestStatus(UID, 1294)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6090);
		SaveEvent(UID, 7911);
	end
end

-- [AUTO-GEN] quest=1295 status=255 n_index=7940
if (EVENT == 210) then
	SaveEvent(UID, 7941);
end

-- [AUTO-GEN] quest=1295 status=0 n_index=7941
if (EVENT == 212) then
	SelectMsg(UID, 4, 1295, 44143, NPC, 765, 213, 23, -1);
end

-- [AUTO-GEN] quest=1295 status=0 n_index=7941
if (EVENT == 213) then
	SaveEvent(UID, 7942);
end

-- [AUTO-GEN] quest=1295 status=1 n_index=7942
if (EVENT == 215) then
	ItemA = HowmuchItem(UID, 900657000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1295, 44143, NPC, 18, 216);
	else
		SelectMsg(UID, 4, 1295, 44143, NPC, 41, 217, 27, -1);
	end
end

-- [AUTO-GEN] quest=1295 status=1 n_index=7942
if (EVENT == 216) then
	ShowMap(UID, 71);
end

-- [AUTO-GEN] quest=1295 status=1 n_index=7942
if (EVENT == 217) then
	QuestStatusCheck = GetQuestStatus(UID, 1295)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6091);
		SaveEvent(UID, 7943);
	end
end

-- [AUTO-GEN] quest=1296 status=255 n_index=7946
if (EVENT == 220) then
	SaveEvent(UID, 7947);
end

-- [AUTO-GEN] quest=1296 status=0 n_index=7947
if (EVENT == 222) then
	SelectMsg(UID, 4, 1296, 44144, NPC, 766, 223, 23, -1);
end

-- [AUTO-GEN] quest=1296 status=0 n_index=7947
if (EVENT == 223) then
	SaveEvent(UID, 7948);
end

-- [AUTO-GEN] quest=1296 status=1 n_index=7948
if (EVENT == 225) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1296, 44144, NPC, 22, 227, 23, -1);
	else
		SelectMsg(UID, 2, 1296, 44144, NPC, 18, 226);
	end
end

-- [AUTO-GEN] quest=1296 status=1 n_index=7948
if (EVENT == 226) then
	ShowMap(UID, 71);
end

-- [AUTO-GEN] quest=1296 status=1 n_index=7948
if (EVENT == 227) then
	QuestStatusCheck = GetQuestStatus(UID, 1296)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6092);
		SaveEvent(UID, 7949);
	end
end

-- [AUTO-GEN] quest=1297 status=255 n_index=7952
if (EVENT == 230) then
	SaveEvent(UID, 7953);
end

-- [AUTO-GEN] quest=1297 status=0 n_index=7953
if (EVENT == 232) then
	SelectMsg(UID, 4, 1297, 44145, NPC, 767, 233, 23, -1);
end

-- [AUTO-GEN] quest=1297 status=0 n_index=7953
if (EVENT == 233) then
	SaveEvent(UID, 7954);
end

-- [AUTO-GEN] quest=1297 status=1 n_index=7954
if (EVENT == 235) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1297, 44145, NPC, 22, 237, 23, -1);
	else
		SelectMsg(UID, 2, 1297, 44145, NPC, 18, 236);
	end
end

-- [AUTO-GEN] quest=1297 status=1 n_index=7954
if (EVENT == 236) then
	ShowMap(UID, 71);
end

-- [AUTO-GEN] quest=1297 status=1 n_index=7954
if (EVENT == 237) then
	QuestStatusCheck = GetQuestStatus(UID, 1297)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6093);
		SaveEvent(UID, 7955);
	end
end

-- [AUTO-GEN] quest=1301 status=255 n_index=8004
if (EVENT == 240) then
	SaveEvent(UID, 8005);
end

-- [AUTO-GEN] quest=1301 status=0 n_index=8005
if (EVENT == 242) then
	SelectMsg(UID, 4, 1301, 44149, NPC, 777, 243, 23, -1);
end

-- [AUTO-GEN] quest=1301 status=0 n_index=8005
if (EVENT == 243) then
	SaveEvent(UID, 8006);
end

-- [AUTO-GEN] quest=1301 status=1 n_index=8006
if (EVENT == 245) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1301, 44149, NPC, 22, 247, 23, -1);
	else
		SelectMsg(UID, 2, 1301, 44149, NPC, 18, 246);
	end
end

-- [AUTO-GEN] quest=1301 status=1 n_index=8006
if (EVENT == 246) then
	ShowMap(UID, 71);
end

-- [AUTO-GEN] quest=1301 status=1 n_index=8006
if (EVENT == 247) then
	QuestStatusCheck = GetQuestStatus(UID, 1301)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6094);
		SaveEvent(UID, 8007);
	end
end

-- [AUTO-GEN] quest=1302 status=255 n_index=8075
if (EVENT == 250) then
	SaveEvent(UID, 8076);
end

-- [AUTO-GEN] quest=1302 status=0 n_index=8076
if (EVENT == 252) then
	SelectMsg(UID, 4, 1302, 44150, NPC, 778, 253, 23, -1);
end

-- [AUTO-GEN] quest=1302 status=0 n_index=8076
if (EVENT == 253) then
	SaveEvent(UID, 8077);
end

-- [AUTO-GEN] quest=1302 status=1 n_index=8077
if (EVENT == 255) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1302, 44150, NPC, 22, 257, 23, -1);
	else
		SelectMsg(UID, 2, 1302, 44150, NPC, 18, 256);
	end
end

-- [AUTO-GEN] quest=1302 status=1 n_index=8077
if (EVENT == 256) then
	ShowMap(UID, 71);
end

-- [AUTO-GEN] quest=1302 status=1 n_index=8077
if (EVENT == 257) then
	QuestStatusCheck = GetQuestStatus(UID, 1302)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6095);
		SaveEvent(UID, 8078);
	end
end

-- [AUTO-GEN] quest=1303 status=255 n_index=8081
if (EVENT == 260) then
	SaveEvent(UID, 8082);
end

-- [AUTO-GEN] quest=1303 status=0 n_index=8082
if (EVENT == 262) then
	SelectMsg(UID, 4, 1303, 44151, NPC, 779, 263, 23, -1);
end

-- [AUTO-GEN] quest=1303 status=0 n_index=8082
if (EVENT == 263) then
	SaveEvent(UID, 8083);
end

-- [AUTO-GEN] quest=1303 status=1 n_index=8083
if (EVENT == 265) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1303, 44151, NPC, 18, 266);
	else
		SelectMsg(UID, 4, 1303, 44151, NPC, 41, 267, 27, -1);
	end
end

-- [AUTO-GEN] quest=1303 status=1 n_index=8083
if (EVENT == 266) then
	ShowMap(UID, 71);
end

-- [AUTO-GEN] quest=1303 status=1 n_index=8083
if (EVENT == 267) then
	QuestStatusCheck = GetQuestStatus(UID, 1303)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6096);
		SaveEvent(UID, 8084);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
