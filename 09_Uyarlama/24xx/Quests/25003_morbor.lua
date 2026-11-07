-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6100]={{900650000,1}},
  [6101]={{900005000,1308}},
  [6102]={{900651000,20}},
  [6158]={{810095000,1},{810090000,1},{810094000,1}},
  [6159]={{379243000,1},{379244000,1},{900000000,7000000}},
  [6160]={{379244000,1},{379236000,3},{900000000,10000000}},
}
local __KO_Completion = {
  [3553]={1307,6100},
  [3559]={1308,6101},
  [3565]={1309,6102},
  [3935]={1371,6158},
  [3945]={1377,6159},
  [3955]={1378,6160},
}
local __KO_Quests = {
  [6100]={1307},
  [6101]={1308},
  [6102]={1309},
  [6158]={1371},
  [6159]={1377},
  [6160]={1378},
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
local NPC = 25003;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 43796, NPC, 3001, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 43796, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 1122) then
	SelectMsg(UID, 4, 1308, 43803, NPC, 22, 1124, 23, -1);
end

if (EVENT == 1124) then
	QuestStatus = GetQuestStatus(UID, 1308)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 3558);
	end
end

if (EVENT == 1127) then
	QuestStatus = GetQuestStatus(UID, 1308)
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount01 = CountMonsterQuestSub(UID, 1308, 1);
	MonsterCount02 = CountMonsterQuestSub(UID, 1308, 2);
		if (MonsterCount01 < 30) then
			SelectMsg(UID, 2, 1308, 43803, NPC, 4440, 1128);
		elseif (MonsterCount02 < 30) then
			SelectMsg(UID, 2, 1308, 43803, NPC, 4440, 1129);
		else
			SaveEvent(UID, 3560);
		end
	end
end

if (EVENT == 1125) then
	QuestStatus = GetQuestStatus(UID, 1308)
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount01 = CountMonsterQuestSub(UID, 1308, 1);
	MonsterCount02 = CountMonsterQuestSub(UID, 1308, 2);
		if (MonsterCount01 < 30) then
			SelectMsg(UID, 2, 1308, 43803, NPC, 4440, 1128);
		elseif (MonsterCount02 < 30) then
			SelectMsg(UID, 2, 1308, 43803, NPC, 4440, 1129);
		else
			SelectMsg(UID, 4, 1308, 43803, NPC, 10, 1126, 27, -1);
		end
	end
end

if (EVENT == 1128) then
	ShowMap(UID, 1323);
end

if (EVENT == 1129) then
	ShowMap(UID, 1322);
end

if (EVENT == 1126) then
	QuestStatus = GetQuestStatus(UID, 1308)
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount01 = CountMonsterQuestSub(UID, 1308, 1);
	MonsterCount02 = CountMonsterQuestSub(UID, 1308, 2);
		if (MonsterCount01 < 30) then
			SelectMsg(UID, 2, 1308, 43803, NPC, 4440, 1128);
		elseif (MonsterCount02 < 30) then
			SelectMsg(UID, 2, 1308, 43803, NPC, 4440, 1129);
		else
			RunExchange(UID,6101);
			SaveEvent(UID, 3559);
		end
	end
end

if (EVENT == 1132) then
	SelectMsg(UID, 4, 1309, 43806, NPC, 22, 1133, 23, -1);
end

if (EVENT == 1133) then
	QuestStatus = GetQuestStatus(UID, 1309)
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 3564);
	end
end

if (EVENT == 1137) then
	QuestStatus = GetQuestStatus(UID, 1309)
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	SAVAGEMEAT = HowmuchItem(UID, 900651000);
		if (SAVAGEMEAT < 20) then
			SelectMsg(UID, 2, 1309, 43806, NPC, 19, 1138);
		else
			SaveEvent(UID, 3566);
		end
	end
end

if (EVENT == 1135) then
	QuestStatus = GetQuestStatus(UID, 1309)
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	SAVAGEMEAT = HowmuchItem(UID, 900651000);
		if (SAVAGEMEAT < 20) then
			SelectMsg(UID, 2, 1309, 43806, NPC, 19, 1138);
		else
			SelectMsg(UID, 4, 1309, 43806, NPC, 22, 1136, 23, -1);
		end
	end
end

if (EVENT == 1138) then
	ShowMap(UID, 1322);
end

if (EVENT == 1136) then
	QuestStatus = GetQuestStatus(UID, 1309)
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	SAVAGEMEAT = HowmuchItem(UID, 900651000);
		if (SAVAGEMEAT < 20) then
			SelectMsg(UID, 2, 1309, 43806, NPC, 19, 1138);
		else
			RunExchange(UID,6102);
			SaveEvent(UID, 3565);
		end
	end
end

if (EVENT == 1112) then
	SelectMsg(UID, 4, 1307, 43800, NPC, 22, 1113, 23, -1);
end

if (EVENT == 1113) then
	QuestStatus = GetQuestStatus(UID, 1307)
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 3552);
	end
end

if (EVENT == 1117) then
	QuestStatus = GetQuestStatus(UID, 1307)
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 3554);
	end
end

if (EVENT == 1115) then
	SelectMsg(UID, 4, 1307, 43800, NPC, 22, 1116, 23, -1);
end

if (EVENT == 1116) then
RunExchange(UID,6100);
	SaveEvent(UID, 3553);
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=1371 status=0 n_index=3933
if (EVENT == 142) then
	SelectMsg(UID, 4, 1371, 11910, NPC, 784, 143, 23, -1);
end

-- [AUTO-GEN] quest=1371 status=0 n_index=3933
if (EVENT == 143) then
	SaveEvent(UID, 3934);
end

-- [AUTO-GEN] quest=1371 status=1 n_index=3934
if (EVENT == 145) then
	ItemA = HowmuchItem(UID, 810095000);
	if (ItemA < 1) then
		SelectMsg(UID, 2, 1371, 11910, NPC, 18, 146);
	else
		SelectMsg(UID, 4, 1371, 11910, NPC, 41, 147, 27, -1);
	end
end

-- [AUTO-GEN] quest=1371 status=1 n_index=3934
if (EVENT == 146) then
	ShowMap(UID, 1);
end

-- [AUTO-GEN] quest=1371 status=1 n_index=3934
if (EVENT == 147) then
	QuestStatusCheck = GetQuestStatus(UID, 1371)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6158);
		SaveEvent(UID, 3935);
	end
end

-- [AUTO-GEN] quest=1377 status=0 n_index=3943
if (EVENT == 152) then
	SelectMsg(UID, 4, 1377, 11912, NPC, 785, 153, 23, -1);
end

-- [AUTO-GEN] quest=1377 status=0 n_index=3943
if (EVENT == 153) then
	SaveEvent(UID, 3944);
end

-- [AUTO-GEN] quest=1377 status=1 n_index=3944
if (EVENT == 155) then
	ItemA = HowmuchItem(UID, 810369000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1377, 11912, NPC, 18, 156);
	else
		SelectMsg(UID, 4, 1377, 11912, NPC, 41, 157, 27, -1);
	end
end

-- [AUTO-GEN] quest=1377 status=1 n_index=3944
if (EVENT == 156) then
	ShowMap(UID, 1);
end

-- [AUTO-GEN] quest=1377 status=1 n_index=3944
if (EVENT == 157) then
	QuestStatusCheck = GetQuestStatus(UID, 1377)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6159);
		SaveEvent(UID, 3945);
	end
end

-- [AUTO-GEN] quest=1378 status=0 n_index=3953
if (EVENT == 162) then
	SelectMsg(UID, 4, 1378, 11914, NPC, 786, 163, 23, -1);
end

-- [AUTO-GEN] quest=1378 status=0 n_index=3953
if (EVENT == 163) then
	SaveEvent(UID, 3954);
end

-- [AUTO-GEN] quest=1378 status=1 n_index=3954
if (EVENT == 165) then
	ItemA = HowmuchItem(UID, 810369000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1378, 11914, NPC, 18, 166);
	else
		SelectMsg(UID, 4, 1378, 11914, NPC, 41, 167, 27, -1);
	end
end

-- [AUTO-GEN] quest=1378 status=1 n_index=3954
if (EVENT == 166) then
	ShowMap(UID, 1);
end

-- [AUTO-GEN] quest=1378 status=1 n_index=3954
if (EVENT == 167) then
	QuestStatusCheck = GetQuestStatus(UID, 1378)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6160);
		SaveEvent(UID, 3955);
	end
end

-- [AUTO-GEN] quest=1307 status=255 n_index=3550
if (EVENT == 1110) then
	SaveEvent(UID, 3551);
end

-- [AUTO-GEN] quest=1308 status=255 n_index=3556
if (EVENT == 1120) then
	SaveEvent(UID, 3557);
end

-- [AUTO-GEN] quest=1309 status=255 n_index=3562
if (EVENT == 1130) then
	SaveEvent(UID, 3563);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
