-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6115]={{900628000,1},{900629000,1},{900630000,1}},
  [6116]={{900616000,5}},
  [6117]={{900005000,1323}},
  [6152]={{900005000,1358}},
}
local __KO_Completion = {
  [3637]={1321,6115},
  [3643]={1322,6116},
  [3649]={1323,6117},
  [3859]={1358,6152},
}
local __KO_Quests = {
  [6115]={1321},
  [6116]={1322},
  [6117]={1323},
  [6152]={1358},
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
local NPC = 25171;


-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=1321 status=2 n_index=3637
if (EVENT == 100) then
	SearchQuest(UID, 25171);
end

-- [AUTO-GEN] quest=1358 status=255 n_index=3856
if (EVENT == 1120) then
	SaveEvent(UID, 3857);
end

-- [AUTO-GEN] quest=1358 status=0 n_index=3857
if (EVENT == 1122) then
	SelectMsg(UID, 4, 1358, 44146, NPC, 774, 1123, 23, -1);
end

-- [AUTO-GEN] quest=1358 status=0 n_index=3857
if (EVENT == 1123) then
	SaveEvent(UID, 3858);
end

-- [AUTO-GEN] quest=1358 status=1 n_index=3858
if (EVENT == 1125) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1358, 44146, NPC, 22, 1127, 23, -1);
	else
		SelectMsg(UID, 2, 1358, 44146, NPC, 18, 1126);
	end
end

-- [AUTO-GEN] quest=1358 status=1 n_index=3858
if (EVENT == 1126) then
	ShowMap(UID, 1);
end

-- [AUTO-GEN] quest=1358 status=1 n_index=3858
if (EVENT == 1127) then
	QuestStatusCheck = GetQuestStatus(UID, 1358)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6152);
		SaveEvent(UID, 3859);
	end
end

-- [AUTO-GEN] quest=1321 status=255 n_index=3634
if (EVENT == 1210) then
	SaveEvent(UID, 3635);
end

-- [AUTO-GEN] quest=1321 status=0 n_index=3635
if (EVENT == 1212) then
	SelectMsg(UID, 4, 1321, 43860, NPC, 724, 1213, 23, -1);
end

-- [AUTO-GEN] quest=1321 status=0 n_index=3635
if (EVENT == 1213) then
	SaveEvent(UID, 3636);
end

-- [AUTO-GEN] quest=1321 status=1 n_index=3636
if (EVENT == 1215) then
	ItemA = HowmuchItem(UID, 900628000);
	if (ItemA < 1) then
		SelectMsg(UID, 2, 1321, 43860, NPC, 18, 1216);
	else
		SelectMsg(UID, 4, 1321, 43860, NPC, 41, 1217, 27, -1);
	end
end

-- [AUTO-GEN] quest=1321 status=1 n_index=3636
if (EVENT == 1216) then
	ShowMap(UID, 1);
end

-- [AUTO-GEN] quest=1321 status=1 n_index=3636
if (EVENT == 1217) then
	QuestStatusCheck = GetQuestStatus(UID, 1321)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6115);
		SaveEvent(UID, 3637);
	end
end

-- [AUTO-GEN] quest=1322 status=255 n_index=3640
if (EVENT == 1220) then
	SaveEvent(UID, 3641);
end

-- [AUTO-GEN] quest=1322 status=0 n_index=3641
if (EVENT == 1222) then
	SelectMsg(UID, 4, 1322, 43874, NPC, 725, 1223, 23, -1);
end

-- [AUTO-GEN] quest=1322 status=0 n_index=3641
if (EVENT == 1223) then
	SaveEvent(UID, 3642);
end

-- [AUTO-GEN] quest=1322 status=1 n_index=3642
if (EVENT == 1225) then
	ItemA = HowmuchItem(UID, 900616000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1322, 43874, NPC, 18, 1226);
	else
		SelectMsg(UID, 4, 1322, 43874, NPC, 41, 1227, 27, -1);
	end
end

-- [AUTO-GEN] quest=1322 status=1 n_index=3642
if (EVENT == 1226) then
	ShowMap(UID, 1);
end

-- [AUTO-GEN] quest=1322 status=1 n_index=3642
if (EVENT == 1227) then
	QuestStatusCheck = GetQuestStatus(UID, 1322)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6116);
		SaveEvent(UID, 3643);
	end
end

-- [AUTO-GEN] quest=1323 status=255 n_index=3646
if (EVENT == 1230) then
	SaveEvent(UID, 3647);
end

-- [AUTO-GEN] quest=1323 status=0 n_index=3647
if (EVENT == 1232) then
	SelectMsg(UID, 4, 1323, 43883, NPC, 726, 1233, 23, -1);
end

-- [AUTO-GEN] quest=1323 status=0 n_index=3647
if (EVENT == 1233) then
	SaveEvent(UID, 3648);
end

-- [AUTO-GEN] quest=1323 status=1 n_index=3648
if (EVENT == 1235) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1323, 43883, NPC, 22, 1237, 23, -1);
	else
		SelectMsg(UID, 2, 1323, 43883, NPC, 18, 1236);
	end
end

-- [AUTO-GEN] quest=1323 status=1 n_index=3648
if (EVENT == 1236) then
	ShowMap(UID, 1);
end

-- [AUTO-GEN] quest=1323 status=1 n_index=3648
if (EVENT == 1237) then
	QuestStatusCheck = GetQuestStatus(UID, 1323)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6117);
		SaveEvent(UID, 3649);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
