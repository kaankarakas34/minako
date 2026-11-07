-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6033]={{900650000,1}},
  [6034]={{900005000,1238}},
  [6035]={{900651000,20}},
  [6158]={{810095000,1},{810090000,1},{810094000,1}},
  [6159]={{379243000,1},{379244000,1},{900000000,7000000}},
  [6160]={{379244000,1},{379236000,3},{900000000,10000000}},
}
local __KO_Completion = {
  [3930]={1371,6158},
  [3940]={1377,6159},
  [3950]={1378,6160},
  [7531]={1237,6033},
  [7537]={1238,6034},
  [7543]={1239,6035},
}
local __KO_Quests = {
  [6033]={1237},
  [6034]={1238},
  [6035]={1239},
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
local NPC = 25017;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 43796, NPC, 3001, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 43803, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 122) then
	SelectMsg(UID, 4, 1238, 43803, NPC, 22, 124, 23, -1);
end

if (EVENT == 124) then
	QuestStatus = GetQuestStatus(UID, 1238)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7536);
	end
end

if (EVENT == 127) then
	QuestStatus = GetQuestStatus(UID, 1238)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount01 = CountMonsterQuestSub(UID, 1238, 1);
	MonsterCount02 = CountMonsterQuestSub(UID, 1238, 2);
		if (MonsterCount01 < 30) then
			SelectMsg(UID, 2, 1238, 43803, NPC, 4440, 128);
		elseif (MonsterCount02 < 30) then
			SelectMsg(UID, 2, 1238, 43803, NPC, 4440, 129);
		else
			SaveEvent(UID, 7538);
		end
	end
end

if (EVENT == 125) then
	QuestStatus = GetQuestStatus(UID, 1238)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount01 = CountMonsterQuestSub(UID, 1238, 1);
	MonsterCount02 = CountMonsterQuestSub(UID, 1238, 2);
		if (MonsterCount01 < 30) then
			SelectMsg(UID, 2, 1238, 43803, NPC, 4440, 128);
		elseif (MonsterCount02 < 30) then
			SelectMsg(UID, 2, 1238, 43803, NPC, 4440, 129);
		else
			SelectMsg(UID, 4, 1238, 43803, NPC, 10, 126, 27, -1);
		end
	end
end

if (EVENT == 128) then
	ShowMap(UID, 1318);
end

if (EVENT == 129) then
	ShowMap(UID, 1317);
end

if (EVENT == 126) then
	QuestStatus = GetQuestStatus(UID, 1238)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount01 = CountMonsterQuestSub(UID, 1238, 1);
	MonsterCount02 = CountMonsterQuestSub(UID, 1238, 2);
		if (MonsterCount01 < 30) then
			SelectMsg(UID, 2, 1238, 43803, NPC, 4440, 128);
		elseif (MonsterCount02 < 30) then
			SelectMsg(UID, 2, 1238, 43803, NPC, 4440, 129);
		else
			RunExchange(UID,6034);
			SaveEvent(UID, 7537);
		end
	end
end

if (EVENT == 132) then
	SelectMsg(UID, 4, 1239, 43806, NPC, 22, 133, 23, -1);
end

if (EVENT == 133) then
	QuestStatus = GetQuestStatus(UID, 1239)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7542);
	end
end

if (EVENT == 137) then
	QuestStatus = GetQuestStatus(UID, 1239)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7544);
	end
end

if (EVENT == 135) then
	QuestStatus = GetQuestStatus(UID, 1239)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	SAVAGEMEAT = HowmuchItem(UID, 900651000);
		if (SAVAGEMEAT < 20) then
			SelectMsg(UID, 2, 1239, 43806, NPC, 19, 138);
		else
			SelectMsg(UID, 4, 1239, 43806, NPC, 22, 136, 23, -1);
		end
	end
end

if (EVENT == 138) then
	ShowMap(UID, 1317);
end

if (EVENT == 136) then
	QuestStatus = GetQuestStatus(UID, 1239)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	SAVAGEMEAT = HowmuchItem(UID, 900651000);
		if (SAVAGEMEAT < 20) then
			SelectMsg(UID, 2, 1239, 43806, NPC, 19, 138);
		else
			RunExchange(UID,6035);
			SaveEvent(UID, 7543);
		end
	end
end

if (EVENT == 112) then
	SelectMsg(UID, 4, 1237, 43800, NPC, 22, 113, 23, -1);
end

if (EVENT == 113) then
	QuestStatus = GetQuestStatus(UID, 1237)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7530);
	end
end

if (EVENT == 117) then
	QuestStatus = GetQuestStatus(UID, 1237)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 7532);
	end
end

if (EVENT == 115) then
SelectMsg(UID, 4, 1237, 43800, NPC, 22, 116, 23, -1);
end

if (EVENT == 116) then
RunExchange(UID,6033);
	SaveEvent(UID, 7531);
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=1237 status=255 n_index=7528
if (EVENT == 110) then
	SaveEvent(UID, 7529);
end

-- [AUTO-GEN] quest=1238 status=255 n_index=7534
if (EVENT == 120) then
	SaveEvent(UID, 7535);
end

-- [AUTO-GEN] quest=1239 status=255 n_index=7540
if (EVENT == 130) then
	SaveEvent(UID, 7541);
end

-- [AUTO-GEN] quest=1371 status=255 n_index=7674
if (EVENT == 140) then
	SaveEvent(UID, 3928);
end

-- [AUTO-GEN] quest=1371 status=0 n_index=3928
if (EVENT == 142) then
	SelectMsg(UID, 4, 1371, 11909, NPC, 781, 143, 23, -1);
end

-- [AUTO-GEN] quest=1371 status=0 n_index=3928
if (EVENT == 143) then
	SaveEvent(UID, 3929);
end

-- [AUTO-GEN] quest=1371 status=1 n_index=3929
if (EVENT == 145) then
	ItemA = HowmuchItem(UID, 810095000);
	if (ItemA < 1) then
		SelectMsg(UID, 2, 1371, 11909, NPC, 18, 146);
	else
		SelectMsg(UID, 4, 1371, 11909, NPC, 41, 147, 27, -1);
	end
end

-- [AUTO-GEN] quest=1371 status=1 n_index=3929
if (EVENT == 146) then
	ShowMap(UID, 2);
end

-- [AUTO-GEN] quest=1371 status=1 n_index=3929
if (EVENT == 147) then
	QuestStatusCheck = GetQuestStatus(UID, 1371)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6158);
		SaveEvent(UID, 3930);
	end
end

-- [AUTO-GEN] quest=1377 status=255 n_index=7675
if (EVENT == 150) then
	SaveEvent(UID, 3938);
end

-- [AUTO-GEN] quest=1377 status=0 n_index=3938
if (EVENT == 152) then
	SelectMsg(UID, 4, 1377, 11911, NPC, 782, 153, 23, -1);
end

-- [AUTO-GEN] quest=1377 status=0 n_index=3938
if (EVENT == 153) then
	SaveEvent(UID, 3939);
end

-- [AUTO-GEN] quest=1377 status=1 n_index=3939
if (EVENT == 155) then
	ItemA = HowmuchItem(UID, 810369000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1377, 11911, NPC, 18, 156);
	else
		SelectMsg(UID, 4, 1377, 11911, NPC, 41, 157, 27, -1);
	end
end

-- [AUTO-GEN] quest=1377 status=1 n_index=3939
if (EVENT == 156) then
	ShowMap(UID, 2);
end

-- [AUTO-GEN] quest=1377 status=1 n_index=3939
if (EVENT == 157) then
	QuestStatusCheck = GetQuestStatus(UID, 1377)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6159);
		SaveEvent(UID, 3940);
	end
end

-- [AUTO-GEN] quest=1378 status=255 n_index=7676
if (EVENT == 160) then
	SaveEvent(UID, 3948);
end

-- [AUTO-GEN] quest=1378 status=0 n_index=3948
if (EVENT == 162) then
	SelectMsg(UID, 4, 1378, 11913, NPC, 783, 163, 23, -1);
end

-- [AUTO-GEN] quest=1378 status=0 n_index=3948
if (EVENT == 163) then
	SaveEvent(UID, 3949);
end

-- [AUTO-GEN] quest=1378 status=1 n_index=3949
if (EVENT == 165) then
	ItemA = HowmuchItem(UID, 810369000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1378, 11913, NPC, 18, 166);
	else
		SelectMsg(UID, 4, 1378, 11913, NPC, 41, 167, 27, -1);
	end
end

-- [AUTO-GEN] quest=1378 status=1 n_index=3949
if (EVENT == 166) then
	ShowMap(UID, 2);
end

-- [AUTO-GEN] quest=1378 status=1 n_index=3949
if (EVENT == 167) then
	QuestStatusCheck = GetQuestStatus(UID, 1378)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6160);
		SaveEvent(UID, 3950);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
