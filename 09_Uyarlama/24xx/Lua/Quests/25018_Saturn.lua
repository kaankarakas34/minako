-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6120]={},
  [6121]={{900679000,1},{900680000,1},{900681000,1},{900682000,1}},
  [6122]={{900005000,1328}},
  [6123]={{900691000,10}},
  [6124]={{900005000,1330}},
  [6125]={{900005000,1331}},
  [6126]={{900005000,1332}},
  [6127]={{900005000,1333}},
  [6128]={{900005000,1334}},
  [6129]={},
}
local __KO_Completion = {
  [3667]={1326,6120},
  [3673]={1327,6121},
  [3679]={1328,6122},
  [3685]={1329,6123},
  [3691]={1330,6124},
  [3697]={1331,6125},
  [3703]={1332,6126},
  [3709]={1333,6127},
  [3715]={1334,6128},
  [3721]={1335,6129},
}
local __KO_Quests = {
  [6120]={1326},
  [6121]={1327},
  [6122]={1328},
  [6123]={1329},
  [6124]={1330},
  [6125]={1331},
  [6126]={1332},
  [6127]={1333},
  [6128]={1334},
  [6129]={1335},
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
local NPC = 25018;

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

-- [AUTO-GEN] quest=1326 status=255 n_index=3664
if (EVENT == 1110) then
	SaveEvent(UID, 3665);
end

-- [AUTO-GEN] quest=1326 status=0 n_index=3665
if (EVENT == 1112) then
	SelectMsg(UID, 4, 1326, 44114, NPC, 734, 1113, 23, -1);
end

-- [AUTO-GEN] quest=1326 status=0 n_index=3665
if (EVENT == 1113) then
	SaveEvent(UID, 3666);
end

-- [AUTO-GEN] quest=1326 status=1 n_index=3666
if (EVENT == 1115) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1326, 44114, NPC, 18, 1116);
	else
		SelectMsg(UID, 4, 1326, 44114, NPC, 41, 1117, 27, -1);
	end
end

-- [AUTO-GEN] quest=1326 status=1 n_index=3666
if (EVENT == 1116) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1326 status=1 n_index=3666
if (EVENT == 1117) then
	QuestStatusCheck = GetQuestStatus(UID, 1326)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6120);
		SaveEvent(UID, 3667);
	end
end

-- [AUTO-GEN] quest=1327 status=255 n_index=3670
if (EVENT == 1120) then
	SaveEvent(UID, 3671);
end

-- [AUTO-GEN] quest=1327 status=0 n_index=3671
if (EVENT == 1122) then
	SelectMsg(UID, 4, 1327, 44115, NPC, 735, 1123, 23, -1);
end

-- [AUTO-GEN] quest=1327 status=0 n_index=3671
if (EVENT == 1123) then
	SaveEvent(UID, 3672);
end

-- [AUTO-GEN] quest=1327 status=1 n_index=3672
if (EVENT == 1125) then
	ItemA = HowmuchItem(UID, 900679000);
	if (ItemA < 1) then
		SelectMsg(UID, 2, 1327, 44115, NPC, 18, 1126);
	else
		SelectMsg(UID, 4, 1327, 44115, NPC, 41, 1127, 27, -1);
	end
end

-- [AUTO-GEN] quest=1327 status=1 n_index=3672
if (EVENT == 1126) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1327 status=1 n_index=3672
if (EVENT == 1127) then
	QuestStatusCheck = GetQuestStatus(UID, 1327)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6121);
		SaveEvent(UID, 3673);
	end
end

-- [AUTO-GEN] quest=1328 status=255 n_index=3676
if (EVENT == 1130) then
	SaveEvent(UID, 3677);
end

-- [AUTO-GEN] quest=1328 status=0 n_index=3677
if (EVENT == 1132) then
	SelectMsg(UID, 4, 1328, 44116, NPC, 736, 1133, 23, -1);
end

-- [AUTO-GEN] quest=1328 status=0 n_index=3677
if (EVENT == 1133) then
	SaveEvent(UID, 3678);
end

-- [AUTO-GEN] quest=1328 status=1 n_index=3678
if (EVENT == 1135) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1328, 44116, NPC, 22, 1137, 23, -1);
	else
		SelectMsg(UID, 2, 1328, 44116, NPC, 18, 1136);
	end
end

-- [AUTO-GEN] quest=1328 status=1 n_index=3678
if (EVENT == 1136) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1328 status=1 n_index=3678
if (EVENT == 1137) then
	QuestStatusCheck = GetQuestStatus(UID, 1328)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6122);
		SaveEvent(UID, 3679);
	end
end

-- [AUTO-GEN] quest=1329 status=255 n_index=3682
if (EVENT == 1140) then
	SaveEvent(UID, 3683);
end

-- [AUTO-GEN] quest=1329 status=0 n_index=3683
if (EVENT == 1142) then
	SelectMsg(UID, 4, 1329, 44117, NPC, 737, 1143, 23, -1);
end

-- [AUTO-GEN] quest=1329 status=0 n_index=3683
if (EVENT == 1143) then
	SaveEvent(UID, 3684);
end

-- [AUTO-GEN] quest=1329 status=1 n_index=3684
if (EVENT == 1145) then
	ItemA = HowmuchItem(UID, 900691000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1329, 44117, NPC, 18, 1146);
	else
		SelectMsg(UID, 4, 1329, 44117, NPC, 41, 1147, 27, -1);
	end
end

-- [AUTO-GEN] quest=1329 status=1 n_index=3684
if (EVENT == 1146) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1329 status=1 n_index=3684
if (EVENT == 1147) then
	QuestStatusCheck = GetQuestStatus(UID, 1329)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6123);
		SaveEvent(UID, 3685);
	end
end

-- [AUTO-GEN] quest=1330 status=255 n_index=3688
if (EVENT == 1150) then
	SaveEvent(UID, 3689);
end

-- [AUTO-GEN] quest=1330 status=0 n_index=3689
if (EVENT == 1152) then
	SelectMsg(UID, 4, 1330, 44118, NPC, 738, 1153, 23, -1);
end

-- [AUTO-GEN] quest=1330 status=0 n_index=3689
if (EVENT == 1153) then
	SaveEvent(UID, 3690);
end

-- [AUTO-GEN] quest=1330 status=1 n_index=3690
if (EVENT == 1155) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1330, 44118, NPC, 22, 1157, 23, -1);
	else
		SelectMsg(UID, 2, 1330, 44118, NPC, 18, 1156);
	end
end

-- [AUTO-GEN] quest=1330 status=1 n_index=3690
if (EVENT == 1156) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1330 status=1 n_index=3690
if (EVENT == 1157) then
	QuestStatusCheck = GetQuestStatus(UID, 1330)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6124);
		SaveEvent(UID, 3691);
	end
end

-- [AUTO-GEN] quest=1331 status=255 n_index=3694
if (EVENT == 1160) then
	SaveEvent(UID, 3695);
end

-- [AUTO-GEN] quest=1331 status=0 n_index=3695
if (EVENT == 1162) then
	SelectMsg(UID, 4, 1331, 44119, NPC, 739, 1163, 23, -1);
end

-- [AUTO-GEN] quest=1331 status=0 n_index=3695
if (EVENT == 1163) then
	SaveEvent(UID, 3696);
end

-- [AUTO-GEN] quest=1331 status=1 n_index=3696
if (EVENT == 1165) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1331, 44119, NPC, 22, 1167, 23, -1);
	else
		SelectMsg(UID, 2, 1331, 44119, NPC, 18, 1166);
	end
end

-- [AUTO-GEN] quest=1331 status=1 n_index=3696
if (EVENT == 1166) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1331 status=1 n_index=3696
if (EVENT == 1167) then
	QuestStatusCheck = GetQuestStatus(UID, 1331)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6125);
		SaveEvent(UID, 3697);
	end
end

-- [AUTO-GEN] quest=1332 status=255 n_index=3700
if (EVENT == 1170) then
	SaveEvent(UID, 3701);
end

-- [AUTO-GEN] quest=1332 status=0 n_index=3701
if (EVENT == 1172) then
	SelectMsg(UID, 4, 1332, 44120, NPC, 740, 1173, 23, -1);
end

-- [AUTO-GEN] quest=1332 status=0 n_index=3701
if (EVENT == 1173) then
	SaveEvent(UID, 3702);
end

-- [AUTO-GEN] quest=1332 status=1 n_index=3702
if (EVENT == 1175) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1332, 44120, NPC, 22, 1177, 23, -1);
	else
		SelectMsg(UID, 2, 1332, 44120, NPC, 18, 1176);
	end
end

-- [AUTO-GEN] quest=1332 status=1 n_index=3702
if (EVENT == 1176) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1332 status=1 n_index=3702
if (EVENT == 1177) then
	QuestStatusCheck = GetQuestStatus(UID, 1332)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6126);
		SaveEvent(UID, 3703);
	end
end

-- [AUTO-GEN] quest=1333 status=255 n_index=3706
if (EVENT == 1180) then
	SaveEvent(UID, 3707);
end

-- [AUTO-GEN] quest=1333 status=0 n_index=3707
if (EVENT == 1182) then
	SelectMsg(UID, 4, 1333, 44121, NPC, 741, 1183, 23, -1);
end

-- [AUTO-GEN] quest=1333 status=0 n_index=3707
if (EVENT == 1183) then
	SaveEvent(UID, 3708);
end

-- [AUTO-GEN] quest=1333 status=1 n_index=3708
if (EVENT == 1185) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1333, 44121, NPC, 22, 1187, 23, -1);
	else
		SelectMsg(UID, 2, 1333, 44121, NPC, 18, 1186);
	end
end

-- [AUTO-GEN] quest=1333 status=1 n_index=3708
if (EVENT == 1186) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1333 status=1 n_index=3708
if (EVENT == 1187) then
	QuestStatusCheck = GetQuestStatus(UID, 1333)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6127);
		SaveEvent(UID, 3709);
	end
end

-- [AUTO-GEN] quest=1334 status=255 n_index=3712
if (EVENT == 1190) then
	SaveEvent(UID, 3713);
end

-- [AUTO-GEN] quest=1334 status=0 n_index=3713
if (EVENT == 1192) then
	SelectMsg(UID, 4, 1334, 44122, NPC, 742, 1193, 23, -1);
end

-- [AUTO-GEN] quest=1334 status=0 n_index=3713
if (EVENT == 1193) then
	SaveEvent(UID, 3714);
end

-- [AUTO-GEN] quest=1334 status=1 n_index=3714
if (EVENT == 1195) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 1334, 44122, NPC, 22, 1197, 23, -1);
	else
		SelectMsg(UID, 2, 1334, 44122, NPC, 18, 1196);
	end
end

-- [AUTO-GEN] quest=1334 status=1 n_index=3714
if (EVENT == 1196) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1334 status=1 n_index=3714
if (EVENT == 1197) then
	QuestStatusCheck = GetQuestStatus(UID, 1334)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6128);
		SaveEvent(UID, 3715);
	end
end

-- [AUTO-GEN] quest=1335 status=255 n_index=3718
if (EVENT == 1200) then
	SaveEvent(UID, 3719);
end

-- [AUTO-GEN] quest=1335 status=0 n_index=3719
if (EVENT == 1202) then
	SelectMsg(UID, 4, 1335, 44123, NPC, 743, 1203, 23, -1);
end

-- [AUTO-GEN] quest=1335 status=0 n_index=3719
if (EVENT == 1203) then
	SaveEvent(UID, 3720);
end

-- [AUTO-GEN] quest=1335 status=1 n_index=3720
if (EVENT == 1205) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1335, 44123, NPC, 18, 1206);
	else
		SelectMsg(UID, 4, 1335, 44123, NPC, 41, 1207, 27, -1);
	end
end

-- [AUTO-GEN] quest=1335 status=1 n_index=3720
if (EVENT == 1206) then
	ShowMap(UID, 72);
end

-- [AUTO-GEN] quest=1335 status=1 n_index=3720
if (EVENT == 1207) then
	QuestStatusCheck = GetQuestStatus(UID, 1335)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6129);
		SaveEvent(UID, 3721);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
