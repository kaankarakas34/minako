-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6048]={{900628000,1},{900629000,1},{900630000,1}},
  [6049]={{900616000,5}},
  [6050]={{900005000,1254}},
  [6097]={{900005000,1298}},
}
local __KO_Completion = {
  [7621]={1252,6048},
  [7627]={1253,6049},
  [7633]={1254,6050},
  [7983]={1298,6097},
}
local __KO_Quests = {
  [6048]={1252},
  [6049]={1253},
  [6050]={1254},
  [6097]={1298},
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
local NPC = 25146;


-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=0 status=0 n_index=5699
if (EVENT == 100) then
	SearchQuest(UID, 25146);
end

-- [AUTO-GEN] quest=1298 status=255 n_index=7980
if (EVENT == 120) then
	SaveEvent(UID, 7981);
end

-- [AUTO-GEN] quest=1298 status=0 n_index=7981
if (EVENT == 122) then
	SelectMsg(UID, 4, 1298, 44146, NPC, 774, 123, 23, -1);
end

-- [AUTO-GEN] quest=1298 status=0 n_index=7981
if (EVENT == 123) then
	SaveEvent(UID, 7982);
end

-- [AUTO-GEN] quest=1298 status=1 n_index=7982
if (EVENT == 125) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1298, 44146, NPC, 22, 127, 23, -1);
	else
		SelectMsg(UID, 2, 1298, 44146, NPC, 18, 126);
	end
end

-- [AUTO-GEN] quest=1298 status=1 n_index=7982
if (EVENT == 126) then
	ShowMap(UID, 2);
end

-- [AUTO-GEN] quest=1298 status=1 n_index=7982
if (EVENT == 127) then
	QuestStatusCheck = GetQuestStatus(UID, 1298)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6097);
		SaveEvent(UID, 7983);
	end
end

-- [AUTO-GEN] quest=1252 status=255 n_index=7618
if (EVENT == 210) then
	SaveEvent(UID, 7619);
end

-- [AUTO-GEN] quest=1252 status=0 n_index=7619
if (EVENT == 212) then
	SelectMsg(UID, 4, 1252, 43860, NPC, 724, 213, 23, -1);
end

-- [AUTO-GEN] quest=1252 status=0 n_index=7619
if (EVENT == 213) then
	SaveEvent(UID, 7620);
end

-- [AUTO-GEN] quest=1252 status=1 n_index=7620
if (EVENT == 215) then
	ItemA = HowmuchItem(UID, 900628000);
	if (ItemA < 1) then
		SelectMsg(UID, 2, 1252, 43860, NPC, 18, 216);
	else
		SelectMsg(UID, 4, 1252, 43860, NPC, 41, 217, 27, -1);
	end
end

-- [AUTO-GEN] quest=1252 status=1 n_index=7620
if (EVENT == 216) then
	ShowMap(UID, 2);
end

-- [AUTO-GEN] quest=1252 status=1 n_index=7620
if (EVENT == 217) then
	QuestStatusCheck = GetQuestStatus(UID, 1252)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6048);
		SaveEvent(UID, 7621);
	end
end

-- [AUTO-GEN] quest=1253 status=255 n_index=7624
if (EVENT == 220) then
	SaveEvent(UID, 7625);
end

-- [AUTO-GEN] quest=1253 status=0 n_index=7625
if (EVENT == 222) then
	SelectMsg(UID, 4, 1253, 43874, NPC, 725, 223, 23, -1);
end

-- [AUTO-GEN] quest=1253 status=0 n_index=7625
if (EVENT == 223) then
	SaveEvent(UID, 7626);
end

-- [AUTO-GEN] quest=1253 status=1 n_index=7626
if (EVENT == 225) then
	ItemA = HowmuchItem(UID, 900616000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1253, 43874, NPC, 18, 226);
	else
		SelectMsg(UID, 4, 1253, 43874, NPC, 41, 227, 27, -1);
	end
end

-- [AUTO-GEN] quest=1253 status=1 n_index=7626
if (EVENT == 226) then
	ShowMap(UID, 2);
end

-- [AUTO-GEN] quest=1253 status=1 n_index=7626
if (EVENT == 227) then
	QuestStatusCheck = GetQuestStatus(UID, 1253)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6049);
		SaveEvent(UID, 7627);
	end
end

-- [AUTO-GEN] quest=1254 status=255 n_index=7630
if (EVENT == 230) then
	SaveEvent(UID, 7631);
end

-- [AUTO-GEN] quest=1254 status=0 n_index=7631
if (EVENT == 232) then
	SelectMsg(UID, 4, 1254, 43883, NPC, 726, 233, 23, -1);
end

-- [AUTO-GEN] quest=1254 status=0 n_index=7631
if (EVENT == 233) then
	SaveEvent(UID, 7632);
end

-- [AUTO-GEN] quest=1254 status=1 n_index=7632
if (EVENT == 235) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1254, 43883, NPC, 22, 237, 23, -1);
	else
		SelectMsg(UID, 2, 1254, 43883, NPC, 18, 236);
	end
end

-- [AUTO-GEN] quest=1254 status=1 n_index=7632
if (EVENT == 236) then
	ShowMap(UID, 2);
end

-- [AUTO-GEN] quest=1254 status=1 n_index=7632
if (EVENT == 237) then
	QuestStatusCheck = GetQuestStatus(UID, 1254)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6050);
		SaveEvent(UID, 7633);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
