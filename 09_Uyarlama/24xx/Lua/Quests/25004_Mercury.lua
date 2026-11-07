-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6060]={},
  [6061]={{900679000,1},{900680000,1},{900681000,1},{900682000,1}},
  [6062]={{900005000,1266}},
  [6063]={{900691000,10}},
  [6064]={{900005000,1268}},
  [6065]={{900005000,1269}},
  [6066]={{900005000,1270}},
  [6067]={{900005000,1271}},
  [6068]={{900005000,1272}},
  [6069]={},
}
local __KO_Completion = {
  [7693]={1264,6060},
  [7699]={1265,6061},
  [7705]={1266,6062},
  [7711]={1267,6063},
  [7717]={1268,6064},
  [7723]={1269,6065},
  [7729]={1270,6066},
  [7773]={1271,6067},
  [7779]={1272,6068},
  [7785]={1273,6069},
}
local __KO_Quests = {
  [6060]={1264},
  [6061]={1265},
  [6062]={1266},
  [6063]={1267},
  [6064]={1268},
  [6065]={1269},
  [6066]={1270},
  [6067]={1271},
  [6068]={1272},
  [6069]={1273},
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
local NPC = 25004;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 187, NPC, 10, -1);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 187, NPC)
	else
		EVENT = QuestNum
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=1264 status=255 n_index=7690
if (EVENT == 110) then
	SaveEvent(UID, 7691);
end

-- [AUTO-GEN] quest=1264 status=0 n_index=7691
if (EVENT == 112) then
	SelectMsg(UID, 4, 1264, 44114, NPC, 734, 113, 23, -1);
end

-- [AUTO-GEN] quest=1264 status=0 n_index=7691
if (EVENT == 113) then
	SaveEvent(UID, 7692);
end

-- [AUTO-GEN] quest=1264 status=1 n_index=7692
if (EVENT == 115) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1264, 44114, NPC, 18, 116);
	else
		SelectMsg(UID, 4, 1264, 44114, NPC, 41, 117, 27, -1);
	end
end

-- [AUTO-GEN] quest=1264 status=1 n_index=7692
if (EVENT == 116) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1264 status=1 n_index=7692
if (EVENT == 117) then
	QuestStatusCheck = GetQuestStatus(UID, 1264)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6060);
		SaveEvent(UID, 7693);
	end
end

-- [AUTO-GEN] quest=1265 status=255 n_index=7696
if (EVENT == 120) then
	SaveEvent(UID, 7697);
end

-- [AUTO-GEN] quest=1265 status=0 n_index=7697
if (EVENT == 122) then
	SelectMsg(UID, 4, 1265, 44115, NPC, 735, 123, 23, -1);
end

-- [AUTO-GEN] quest=1265 status=0 n_index=7697
if (EVENT == 123) then
	SaveEvent(UID, 7698);
end

-- [AUTO-GEN] quest=1265 status=1 n_index=7698
if (EVENT == 125) then
	ItemA = HowmuchItem(UID, 900679000);
	if (ItemA < 1) then
		SelectMsg(UID, 2, 1265, 44115, NPC, 18, 126);
	else
		SelectMsg(UID, 4, 1265, 44115, NPC, 41, 127, 27, -1);
	end
end

-- [AUTO-GEN] quest=1265 status=1 n_index=7698
if (EVENT == 126) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1265 status=1 n_index=7698
if (EVENT == 127) then
	QuestStatusCheck = GetQuestStatus(UID, 1265)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6061);
		SaveEvent(UID, 7699);
	end
end

-- [AUTO-GEN] quest=1266 status=255 n_index=7702
if (EVENT == 130) then
	SaveEvent(UID, 7703);
end

-- [AUTO-GEN] quest=1266 status=0 n_index=7703
if (EVENT == 132) then
	SelectMsg(UID, 4, 1266, 44116, NPC, 736, 133, 23, -1);
end

-- [AUTO-GEN] quest=1266 status=0 n_index=7703
if (EVENT == 133) then
	SaveEvent(UID, 7704);
end

-- [AUTO-GEN] quest=1266 status=1 n_index=7704
if (EVENT == 135) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1266, 44116, NPC, 22, 137, 23, -1);
	else
		SelectMsg(UID, 2, 1266, 44116, NPC, 18, 136);
	end
end

-- [AUTO-GEN] quest=1266 status=1 n_index=7704
if (EVENT == 136) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1266 status=1 n_index=7704
if (EVENT == 137) then
	QuestStatusCheck = GetQuestStatus(UID, 1266)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6062);
		SaveEvent(UID, 7705);
	end
end

-- [AUTO-GEN] quest=1267 status=255 n_index=7708
if (EVENT == 140) then
	SaveEvent(UID, 7709);
end

-- [AUTO-GEN] quest=1267 status=0 n_index=7709
if (EVENT == 142) then
	SelectMsg(UID, 4, 1267, 44117, NPC, 737, 143, 23, -1);
end

-- [AUTO-GEN] quest=1267 status=0 n_index=7709
if (EVENT == 143) then
	SaveEvent(UID, 7710);
end

-- [AUTO-GEN] quest=1267 status=1 n_index=7710
if (EVENT == 145) then
	ItemA = HowmuchItem(UID, 900691000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1267, 44117, NPC, 18, 146);
	else
		SelectMsg(UID, 4, 1267, 44117, NPC, 41, 147, 27, -1);
	end
end

-- [AUTO-GEN] quest=1267 status=1 n_index=7710
if (EVENT == 146) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1267 status=1 n_index=7710
if (EVENT == 147) then
	QuestStatusCheck = GetQuestStatus(UID, 1267)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6063);
		SaveEvent(UID, 7711);
	end
end

-- [AUTO-GEN] quest=1268 status=255 n_index=7714
if (EVENT == 150) then
	SaveEvent(UID, 7715);
end

-- [AUTO-GEN] quest=1268 status=0 n_index=7715
if (EVENT == 152) then
	SelectMsg(UID, 4, 1268, 44118, NPC, 738, 153, 23, -1);
end

-- [AUTO-GEN] quest=1268 status=0 n_index=7715
if (EVENT == 153) then
	SaveEvent(UID, 7716);
end

-- [AUTO-GEN] quest=1268 status=1 n_index=7716
if (EVENT == 155) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1268, 44118, NPC, 22, 157, 23, -1);
	else
		SelectMsg(UID, 2, 1268, 44118, NPC, 18, 156);
	end
end

-- [AUTO-GEN] quest=1268 status=1 n_index=7716
if (EVENT == 156) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1268 status=1 n_index=7716
if (EVENT == 157) then
	QuestStatusCheck = GetQuestStatus(UID, 1268)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6064);
		SaveEvent(UID, 7717);
	end
end

-- [AUTO-GEN] quest=1269 status=255 n_index=7720
if (EVENT == 160) then
	SaveEvent(UID, 7721);
end

-- [AUTO-GEN] quest=1269 status=0 n_index=7721
if (EVENT == 162) then
	SelectMsg(UID, 4, 1269, 44119, NPC, 739, 163, 23, -1);
end

-- [AUTO-GEN] quest=1269 status=0 n_index=7721
if (EVENT == 163) then
	SaveEvent(UID, 7722);
end

-- [AUTO-GEN] quest=1269 status=1 n_index=7722
if (EVENT == 165) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1269, 44119, NPC, 22, 167, 23, -1);
	else
		SelectMsg(UID, 2, 1269, 44119, NPC, 18, 166);
	end
end

-- [AUTO-GEN] quest=1269 status=1 n_index=7722
if (EVENT == 166) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1269 status=1 n_index=7722
if (EVENT == 167) then
	QuestStatusCheck = GetQuestStatus(UID, 1269)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6065);
		SaveEvent(UID, 7723);
	end
end

-- [AUTO-GEN] quest=1270 status=255 n_index=7726
if (EVENT == 170) then
	SaveEvent(UID, 7727);
end

-- [AUTO-GEN] quest=1270 status=0 n_index=7727
if (EVENT == 172) then
	SelectMsg(UID, 4, 1270, 44120, NPC, 740, 173, 23, -1);
end

-- [AUTO-GEN] quest=1270 status=0 n_index=7727
if (EVENT == 173) then
	SaveEvent(UID, 7728);
end

-- [AUTO-GEN] quest=1270 status=1 n_index=7728
if (EVENT == 175) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1270, 44120, NPC, 22, 177, 23, -1);
	else
		SelectMsg(UID, 2, 1270, 44120, NPC, 18, 176);
	end
end

-- [AUTO-GEN] quest=1270 status=1 n_index=7728
if (EVENT == 176) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1270 status=1 n_index=7728
if (EVENT == 177) then
	QuestStatusCheck = GetQuestStatus(UID, 1270)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6066);
		SaveEvent(UID, 7729);
	end
end

-- [AUTO-GEN] quest=1271 status=255 n_index=7770
if (EVENT == 180) then
	SaveEvent(UID, 7771);
end

-- [AUTO-GEN] quest=1271 status=0 n_index=7771
if (EVENT == 182) then
	SelectMsg(UID, 4, 1271, 44121, NPC, 741, 183, 23, -1);
end

-- [AUTO-GEN] quest=1271 status=0 n_index=7771
if (EVENT == 183) then
	SaveEvent(UID, 7772);
end

-- [AUTO-GEN] quest=1271 status=1 n_index=7772
if (EVENT == 185) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1271, 44121, NPC, 22, 187, 23, -1);
	else
		SelectMsg(UID, 2, 1271, 44121, NPC, 18, 186);
	end
end

-- [AUTO-GEN] quest=1271 status=1 n_index=7772
if (EVENT == 186) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1271 status=1 n_index=7772
if (EVENT == 187) then
	QuestStatusCheck = GetQuestStatus(UID, 1271)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6067);
		SaveEvent(UID, 7773);
	end
end

-- [AUTO-GEN] quest=1272 status=255 n_index=7776
if (EVENT == 190) then
	SearchQuest(UID, 25004);
end

-- [AUTO-GEN] quest=1272 status=0 n_index=7777
if (EVENT == 192) then
	SelectMsg(UID, 4, 1272, 44122, NPC, 742, 193, 23, -1);
end

-- [AUTO-GEN] quest=1272 status=0 n_index=7777
if (EVENT == 193) then
	SaveEvent(UID, 7778);
end

-- [AUTO-GEN] quest=1272 status=1 n_index=7778
if (EVENT == 195) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1272, 44122, NPC, 22, 197, 23, -1);
	else
		SelectMsg(UID, 2, 1272, 44122, NPC, 18, 196);
	end
end

-- [AUTO-GEN] quest=1272 status=1 n_index=7778
if (EVENT == 196) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1272 status=1 n_index=7778
if (EVENT == 197) then
	QuestStatusCheck = GetQuestStatus(UID, 1272)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6068);
		SaveEvent(UID, 7779);
	end
end

-- [AUTO-GEN] quest=1273 status=255 n_index=7782
if (EVENT == 200) then
	SaveEvent(UID, 7783);
end

-- [AUTO-GEN] quest=1273 status=0 n_index=7783
if (EVENT == 202) then
	SelectMsg(UID, 4, 1273, 44123, NPC, 743, 203, 23, -1);
end

-- [AUTO-GEN] quest=1273 status=0 n_index=7783
if (EVENT == 203) then
	SaveEvent(UID, 7784);
end

-- [AUTO-GEN] quest=1273 status=1 n_index=7784
if (EVENT == 205) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1273, 44123, NPC, 18, 206);
	else
		SelectMsg(UID, 4, 1273, 44123, NPC, 41, 207, 27, -1);
	end
end

-- [AUTO-GEN] quest=1273 status=1 n_index=7784
if (EVENT == 206) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1273 status=1 n_index=7784
if (EVENT == 207) then
	QuestStatusCheck = GetQuestStatus(UID, 1273)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6069);
		SaveEvent(UID, 7785);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
