-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [3071]={},
  [3072]={{508110000,3},{508109000,3}},
  [3075]={{910236000,1}},
  [3085]={},
  [3090]={},
  [3094]={{910240000,1}},
  [3095]={{900005000,606}},
  [3100]={},
  [3101]={{900005000,612}},
  [3102]={{900005000,613}},
}
local __KO_Completion = {
  [11843]={581,3071},
  [11855]={582,3072},
  [11891]={585,3075},
  [12011]={596,3085},
  [12071]={601,3090},
  [12119]={605,3094},
  [12131]={606,3095},
  [12191]={611,3100},
  [12203]={612,3101},
  [12215]={613,3102},
}
local __KO_Quests = {
  [3071]={581},
  [3072]={582},
  [3075]={585},
  [3085]={596},
  [3090]={601},
  [3094]={605},
  [3095]={606},
  [3100]={611},
  [3101]={612},
  [3102]={613},
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
local NPC = 31702;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 22146, NPC, 10, -1);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 22146, NPC)
	else
		EVENT = QuestNum
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=581 status=2 n_index=11843
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 581)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3071);
		SaveEvent(UID, 11845);
	end
end

-- [AUTO-GEN] quest=581 status=255 n_index=11840
if (EVENT == 1000) then
	SaveEvent(UID, 11841);
end

-- [AUTO-GEN] quest=581 status=0 n_index=11841
if (EVENT == 1002) then
	SelectMsg(UID, 4, 581, 20732, NPC, 3130, 1003, 23, -1);
end

-- [AUTO-GEN] quest=581 status=1 n_index=11842
if (EVENT == 1003) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 581, 20732, NPC, 18, 1005);
	else
		SelectMsg(UID, 4, 581, 20732, NPC, 41, 1004, 27, -1);
	end
end

-- [AUTO-GEN] quest=581 status=1 n_index=11842
if (EVENT == 1004) then
	QuestStatusCheck = GetQuestStatus(UID, 581)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3071);
		SaveEvent(UID, 11843);
	end
end

-- [AUTO-GEN] quest=581 status=3 n_index=11844
if (EVENT == 1005) then
	SelectMsg(UID, 2, 581, 20732, NPC, 10, -1);
end

-- [AUTO-GEN] quest=582 status=255 n_index=11852
if (EVENT == 1100) then
	SaveEvent(UID, 11853);
end

-- [AUTO-GEN] quest=582 status=0 n_index=11853
if (EVENT == 1102) then
	SelectMsg(UID, 4, 582, 20734, NPC, 3132, 1103, 23, -1);
end

-- [AUTO-GEN] quest=582 status=0 n_index=11853
if (EVENT == 1103) then
	SaveEvent(UID, 11854);
end

-- [AUTO-GEN] quest=582 status=1 n_index=11854
if (EVENT == 1105) then
	ItemA = HowmuchItem(UID, 508110000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 582, 20734, NPC, 18, 1106);
	else
		SelectMsg(UID, 4, 582, 20734, NPC, 41, 1106, 27, -1);
	end
end

-- [AUTO-GEN] quest=582 status=1 n_index=11854
if (EVENT == 1106) then
	QuestStatusCheck = GetQuestStatus(UID, 582)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3072);
		SaveEvent(UID, 11855);
	end
end

-- [AUTO-GEN] quest=585 status=255 n_index=11888
if (EVENT == 1200) then
	SaveEvent(UID, 11889);
end

-- [AUTO-GEN] quest=585 status=0 n_index=11889
if (EVENT == 1202) then
	SelectMsg(UID, 4, 585, 20740, NPC, 3138, 1203, 23, -1);
end

-- [AUTO-GEN] quest=585 status=0 n_index=11889
if (EVENT == 1203) then
	SaveEvent(UID, 11890);
end

-- [AUTO-GEN] quest=585 status=1 n_index=11890
if (EVENT == 1205) then
	ItemA = HowmuchItem(UID, 910236000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 585, 20740, NPC, 18, 1206);
	else
		SelectMsg(UID, 4, 585, 20740, NPC, 41, 1206, 27, -1);
	end
end

-- [AUTO-GEN] quest=585 status=1 n_index=11890
if (EVENT == 1206) then
	QuestStatusCheck = GetQuestStatus(UID, 585)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3075);
		SaveEvent(UID, 11891);
	end
end

-- [AUTO-GEN] quest=596 status=255 n_index=12008
if (EVENT == 1300) then
	SaveEvent(UID, 12009);
end

-- [AUTO-GEN] quest=596 status=0 n_index=12009
if (EVENT == 1302) then
	SelectMsg(UID, 4, 596, 20760, NPC, 3158, 1303, 23, -1);
end

-- [AUTO-GEN] quest=596 status=1 n_index=12010
if (EVENT == 1303) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 596, 20760, NPC, 18, 1305);
	else
		SelectMsg(UID, 4, 596, 20760, NPC, 41, 1304, 27, -1);
	end
end

-- [AUTO-GEN] quest=596 status=1 n_index=12010
if (EVENT == 1304) then
	QuestStatusCheck = GetQuestStatus(UID, 596)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3085);
		SaveEvent(UID, 12011);
	end
end

-- [AUTO-GEN] quest=596 status=3 n_index=12012
if (EVENT == 1305) then
	SelectMsg(UID, 2, 596, 20760, NPC, 10, -1);
end

-- [AUTO-GEN] quest=601 status=255 n_index=12068
if (EVENT == 1400) then
	SaveEvent(UID, 12069);
end

-- [AUTO-GEN] quest=601 status=0 n_index=12069
if (EVENT == 1402) then
	SelectMsg(UID, 4, 601, 20770, NPC, 3168, 1403, 23, -1);
end

-- [AUTO-GEN] quest=601 status=1 n_index=12070
if (EVENT == 1403) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 601, 20770, NPC, 18, 1405);
	else
		SelectMsg(UID, 4, 601, 20770, NPC, 41, 1404, 27, -1);
	end
end

-- [AUTO-GEN] quest=601 status=1 n_index=12070
if (EVENT == 1404) then
	QuestStatusCheck = GetQuestStatus(UID, 601)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3090);
		SaveEvent(UID, 12071);
	end
end

-- [AUTO-GEN] quest=601 status=3 n_index=12072
if (EVENT == 1405) then
	SelectMsg(UID, 2, 601, 20770, NPC, 10, -1);
end

-- [AUTO-GEN] quest=605 status=255 n_index=12116
if (EVENT == 1500) then
	SaveEvent(UID, 12117);
end

-- [AUTO-GEN] quest=605 status=0 n_index=12117
if (EVENT == 1502) then
	SelectMsg(UID, 4, 605, 20778, NPC, 3176, 1503, 23, -1);
end

-- [AUTO-GEN] quest=605 status=0 n_index=12117
if (EVENT == 1503) then
	SaveEvent(UID, 12118);
end

-- [AUTO-GEN] quest=605 status=1 n_index=12118
if (EVENT == 1505) then
	ItemA = HowmuchItem(UID, 910240000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 605, 20778, NPC, 18, 1506);
	else
		SelectMsg(UID, 4, 605, 20778, NPC, 41, 1506, 27, -1);
	end
end

-- [AUTO-GEN] quest=605 status=1 n_index=12118
if (EVENT == 1506) then
	QuestStatusCheck = GetQuestStatus(UID, 605)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3094);
		SaveEvent(UID, 12119);
	end
end

-- [AUTO-GEN] quest=606 status=255 n_index=12128
if (EVENT == 1600) then
	SaveEvent(UID, 12129);
end

-- [AUTO-GEN] quest=606 status=0 n_index=12129
if (EVENT == 1602) then
	SelectMsg(UID, 4, 606, 20780, NPC, 3178, 1603, 23, -1);
end

-- [AUTO-GEN] quest=606 status=0 n_index=12129
if (EVENT == 1603) then
	SaveEvent(UID, 12130);
end

-- [AUTO-GEN] quest=606 status=1 n_index=12130
if (EVENT == 1605) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 606, 20780, NPC, 22, 1606, 23, -1);
	else
		SelectMsg(UID, 2, 606, 20780, NPC, 18, 1606);
	end
end

-- [AUTO-GEN] quest=606 status=1 n_index=12130
if (EVENT == 1606) then
	QuestStatusCheck = GetQuestStatus(UID, 606)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3095);
		SaveEvent(UID, 12131);
	end
end

-- [AUTO-GEN] quest=611 status=255 n_index=12188
if (EVENT == 1700) then
	SaveEvent(UID, 12189);
end

-- [AUTO-GEN] quest=611 status=0 n_index=12189
if (EVENT == 1702) then
	SelectMsg(UID, 4, 611, 20790, NPC, 3188, 1703, 23, -1);
end

-- [AUTO-GEN] quest=611 status=1 n_index=12190
if (EVENT == 1703) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 611, 20790, NPC, 18, 1705);
	else
		SelectMsg(UID, 4, 611, 20790, NPC, 41, 1704, 27, -1);
	end
end

-- [AUTO-GEN] quest=611 status=1 n_index=12190
if (EVENT == 1704) then
	QuestStatusCheck = GetQuestStatus(UID, 611)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3100);
		SaveEvent(UID, 12191);
	end
end

-- [AUTO-GEN] quest=611 status=3 n_index=12192
if (EVENT == 1705) then
	SelectMsg(UID, 2, 611, 20790, NPC, 10, -1);
end

-- [AUTO-GEN] quest=612 status=255 n_index=12200
if (EVENT == 1800) then
	SaveEvent(UID, 12201);
end

-- [AUTO-GEN] quest=612 status=0 n_index=12201
if (EVENT == 1802) then
	SelectMsg(UID, 4, 612, 20792, NPC, 3190, 1803, 23, -1);
end

-- [AUTO-GEN] quest=612 status=0 n_index=12201
if (EVENT == 1803) then
	SaveEvent(UID, 12202);
end

-- [AUTO-GEN] quest=612 status=1 n_index=12202
if (EVENT == 1805) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 612, 20792, NPC, 22, 1806, 23, -1);
	else
		SelectMsg(UID, 2, 612, 20792, NPC, 18, 1806);
	end
end

-- [AUTO-GEN] quest=612 status=1 n_index=12202
if (EVENT == 1806) then
	QuestStatusCheck = GetQuestStatus(UID, 612)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3101);
		SaveEvent(UID, 12203);
	end
end

-- [AUTO-GEN] quest=613 status=255 n_index=12212
if (EVENT == 1900) then
	SaveEvent(UID, 12213);
end

-- [AUTO-GEN] quest=613 status=0 n_index=12213
if (EVENT == 1902) then
	SelectMsg(UID, 4, 613, 20794, NPC, 3192, 1903, 23, -1);
end

-- [AUTO-GEN] quest=613 status=0 n_index=12213
if (EVENT == 1903) then
	SaveEvent(UID, 12214);
end

-- [AUTO-GEN] quest=613 status=1 n_index=12214
if (EVENT == 1905) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 613, 20794, NPC, 22, 1906, 23, -1);
	else
		SelectMsg(UID, 2, 613, 20794, NPC, 18, 1906);
	end
end

-- [AUTO-GEN] quest=613 status=1 n_index=12214
if (EVENT == 1906) then
	QuestStatusCheck = GetQuestStatus(UID, 613)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3102);
		SaveEvent(UID, 12215);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
