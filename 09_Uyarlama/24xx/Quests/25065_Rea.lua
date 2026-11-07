-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6038]={{900005000,1242}},
  [6039]={{900005000,1243}},
  [6040]={{900653000,1}},
  [6042]={{900654000,1},{900655000,1}},
  [6043]={{900005000,1247}},
  [6044]={{900005000,1248}},
  [6045]={{900005000,1249}},
  [6046]={{900005000,1250}},
  [6047]={},
}
local __KO_Completion = {
  [7561]={1242,6038},
  [7567]={1243,6039},
  [7573]={1244,6040},
  [7585]={1246,6042},
  [7591]={1247,6043},
  [7597]={1248,6044},
  [7603]={1249,6045},
  [7609]={1250,6046},
  [7615]={1251,6047},
}
local __KO_Quests = {
  [6038]={1242},
  [6039]={1243},
  [6040]={1244},
  [6042]={1246},
  [6043]={1247},
  [6044]={1248},
  [6045]={1249},
  [6046]={1250},
  [6047]={1251},
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
local NPC = 25065;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 43829, NPC)
	else
		EVENT = QuestNum
	end
end

if(EVENT == 112) then 
	SelectMsg(UID, 4, 1242, 43829, NPC, 22, 113, 23, -1);
end

if(EVENT == 113) then
	QuestStatus = GetQuestStatus(UID, 1242)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
			SaveEvent(UID, 7560);
	end
end

if(EVENT == 117) then
	QuestStatus = GetQuestStatus(UID, 1242)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1242, 1);
		if (MonsterCount < 1) then
			SelectMsg(UID, 2, 1242, 43829, NPC, 10, 116);
		else
			SaveEvent(UID, 7562);
		end
	end
end

if (EVENT == 115) then
	QuestStatus = GetQuestStatus(UID, 1242)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1242, 1);
		if (MonsterCount < 1) then
			SelectMsg(UID, 2, 1242, 43829, NPC, 10, 116);
		else
			SelectMsg(UID, 4, 1242, 43829, NPC, 10, 118, 27, -1);
		end
	end
end

if(EVENT == 116) then
	ShowMap(UID, 1337);
end

if(EVENT == 118) then
	QuestStatus = GetQuestStatus(UID, 1242)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1242, 1);
		if (MonsterCount < 1) then
			SelectMsg(UID, 2, 1242, 43829, NPC, 10, 116);
		else
			RunExchange(UID,6038);
			SaveEvent(UID, 7561);
		end
	end
end

if(EVENT == 122) then 
	SelectMsg(UID, 4, 1243, 43826, NPC, 10, 123, 23, -1);
end

if(EVENT == 123) then
	QuestStatus = GetQuestStatus(UID, 1243)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
			SaveEvent(UID, 7566);
	end
end

if(EVENT == 127) then
	QuestStatus = GetQuestStatus(UID, 1243)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1243, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 1243, 43826, NPC, 10, 126);
		else
			SaveEvent(UID, 7568);
		end
	end
end
	
if (EVENT == 125) then
	QuestStatus = GetQuestStatus(UID, 1243)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1243, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 1243, 43826, NPC, 10, 126);
		else
			SelectMsg(UID, 4, 1243, 43826, NPC, 10, 128, 27, -1);
		end
	end
end

if(EVENT == 126) then
	ShowMap(UID, 114);
end

if(EVENT == 128) then
	QuestStatus = GetQuestStatus(UID, 1243)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1243, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 1243, 43826, NPC, 10, 126);
		else
			RunExchange(UID,6039);
			SaveEvent(UID, 7567);
		end
	end
end

if (EVENT == 132) then
	SelectMsg(UID, 4, 1244, 43833, NPC, 10, 133, 23, -1);
end

if(EVENT == 133) then
	QuestStatus = GetQuestStatus(UID, 1244)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
			SaveEvent(UID, 7572);
	end
end

if(EVENT == 137) then
	QuestStatus = GetQuestStatus(UID, 1244)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	KINGAIF = HowmuchItem(UID, 900653000)
		if( KINGAIF < 1) then
			SelectMsg(UID, 2, 1244, 43833, NPC, 18, 136);
		else
			SaveEvent(UID, 7574);
		end
	end
end
	
if(EVENT == 135) then
	QuestStatus = GetQuestStatus(UID, 1244)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	KINGAIF = HowmuchItem(UID, 900653000)
		if( KINGAIF < 1) then
			SelectMsg(UID, 2, 1244, 43833, NPC, 18, 136);
		else
			SelectMsg(UID, 4, 1244, 43833, NPC, 10, 138, 27, -1);
		end
	end
end

if(EVENT == 136) then
	ShowMap(UID, 1246);
end

if(EVENT == 138) then
	QuestStatus = GetQuestStatus(UID, 1244)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	KINGAIF = HowmuchItem(UID, 900653000)
		if( KINGAIF < 1) then
			SelectMsg(UID, 2, 1244, 43833, NPC, 18, 136);
		else
			RunExchange(UID,6040);
			SaveEvent(UID, 7573);
		end
	end
end

if (EVENT == 152) then
	SelectMsg(UID, 4, 1246, 43835, NPC, 10, 153, 23, -1);
end

if(EVENT == 153) then
	QuestStatus = GetQuestStatus(UID, 1246)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
			SaveEvent(UID, 7584);
	end
end

if(EVENT == 157) then
	QuestStatus = GetQuestStatus(UID, 1246)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	BRACE = HowmuchItem(UID, 900654000)
	EARRIN = HowmuchItem(UID, 900655000) 
		if (BRACE < 1) then
			SelectMsg(UID, 2, 1246, 43833, NPC, 18, 156);
		elseif (EARRIN < 1) then
			SelectMsg(UID, 2, 1246, 43833, NPC, 18, 159);
		else
			SaveEvent(UID, 7586);
		end
	end
end

if(EVENT == 155) then
	QuestStatus = GetQuestStatus(UID, 1246)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	BRACE = HowmuchItem(UID, 900654000)
	EARRIN = HowmuchItem(UID, 900655000) 
		if (BRACE < 1) then
			SelectMsg(UID, 2, 1246, 43833, NPC, 18, 156);
		elseif (EARRIN < 1) then
			SelectMsg(UID, 2, 1246, 43833, NPC, 18, 159);
		else
			SelectMsg(UID, 4, 1246, 43833, NPC, 10, 158, 27, -1);
		end
	end
end

if(EVENT == 156) then
	ShowMap(UID, 1314);
end		
	
if(EVENT == 159) then
	ShowMap(UID, 1316);
end	

if(EVENT == 158) then
	QuestStatus = GetQuestStatus(UID, 1246)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	BRACE = HowmuchItem(UID, 900654000)
	EARRIN = HowmuchItem(UID, 900655000) 
		if (BRACE < 1) then
			SelectMsg(UID, 2, 1246, 43833, NPC, 18, 156);
		elseif (EARRIN < 1) then
			SelectMsg(UID, 2, 1246, 43833, NPC, 18, 159);
		else
			RunExchange(UID,6042);
			SaveEvent(UID, 7585);
		end
	end
end

if (EVENT == 162) then
	SelectMsg(UID, 4, 1247, 43839, NPC, 10, 163, 23, -1);
end

if(EVENT == 163) then
	QuestStatus = GetQuestStatus(UID, 1247)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
			SaveEvent(UID, 7590);
	end
end

if(EVENT == 167) then
	QuestStatus = GetQuestStatus(UID, 1247)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1247, 1);
		if (MonsterCount < 1) then
			SelectMsg(UID, 2, 1247, 43839, NPC, 10, 166);
		else
			SaveEvent(UID, 7592);
		end
	end
end

if (EVENT == 165) then
	QuestStatus = GetQuestStatus(UID, 1247)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1247, 1);
		if (MonsterCount < 1) then
			SelectMsg(UID, 2, 1247, 43839, NPC, 10, 166);
		else
			SelectMsg(UID, 4, 1247, 43839, NPC, 10, 168, 27, -1);
		end
	end
end

if(EVENT == 166) then
	ShowMap(UID, 1314);
end

if(EVENT == 168) then
	QuestStatus = GetQuestStatus(UID, 1247)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1247, 1);
		if (MonsterCount < 1) then
			SelectMsg(UID, 2, 1247, 43839, NPC, 10, 166);
		else
			RunExchange(UID,6043);
			SaveEvent(UID, 7591);
		end
	end
end

if (EVENT == 172) then
	SelectMsg(UID, 4, 1248, 43842, NPC, 10, 173, 23, -1);
end

if(EVENT == 173) then
	QuestStatus = GetQuestStatus(UID, 1248)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
			SaveEvent(UID, 7596);
	end
end

if(EVENT == 177) then
	QuestStatus = GetQuestStatus(UID, 1248)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1248, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 1248, 43842, NPC, 10, 176);
		else
			SaveEvent(UID, 7598);
		end
	end
end

if (EVENT == 175) then
	QuestStatus = GetQuestStatus(UID, 1248)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1248, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 1248, 43842, NPC, 10, 176);
		else
			SelectMsg(UID, 4, 1248, 43842, NPC, 10, 178, 27, -1);
		end
	end
end

if(EVENT == 176) then
ShowMap(UID, 106);
end

if(EVENT == 178) then
	QuestStatus = GetQuestStatus(UID, 1248)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1248, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 1248, 43842, NPC, 10, 176);
		else
			RunExchange(UID,6044);
			SaveEvent(UID, 7597);
		end
	end
end

if (EVENT == 182) then
	SelectMsg(UID, 4, 1249, 43845, NPC, 10, 183, 23, -1);
end

if(EVENT == 183) then
	QuestStatus = GetQuestStatus(UID, 1249)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
			SaveEvent(UID, 7602);
	end
end

if(EVENT == 187) then
	QuestStatus = GetQuestStatus(UID, 1249)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1249, 1);
		if (MonsterCount < 1) then
			SelectMsg(UID, 2, 1249, 43845, NPC, 10, 186);
		else
			SaveEvent(UID, 7604);
		end
	end
end

if (EVENT == 185) then
	QuestStatus = GetQuestStatus(UID, 1249)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1249, 1);
		if (MonsterCount < 1) then
			SelectMsg(UID, 2, 1249, 43845, NPC, 10, 186);
		else
			SelectMsg(UID, 4, 1249, 43845, NPC, 10, 188, 27, -1);
		end
	end
end

if(EVENT == 186) then
ShowMap(UID, 1316);
end

if(EVENT == 188) then
	QuestStatus = GetQuestStatus(UID, 1249)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1249, 1);
		if (MonsterCount < 1) then
			SelectMsg(UID, 2, 1249, 43845, NPC, 10, 186);
		else
			RunExchange(UID,6045);
			SaveEvent(UID, 7603);
		end
	end
end

if (EVENT == 192) then
	SelectMsg(UID, 4, 1250, 43848, NPC, 10, 193, 23, -1);
end

if(EVENT == 193) then
	QuestStatus = GetQuestStatus(UID, 1250)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
			SaveEvent(UID, 7608);
	end
end

if(EVENT == 197) then
	QuestStatus = GetQuestStatus(UID, 1250)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1250, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 1250, 43848, NPC, 10, 196);
		else
			SaveEvent(UID, 7610);
		end
	end
end

if (EVENT == 195) then
	QuestStatus = GetQuestStatus(UID, 1250)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1250, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 1250, 43848, NPC, 10, 196);
		else
			SelectMsg(UID, 4, 1250, 43848, NPC, 10, 198, 27, -1);
		end
	end
end

if(EVENT == 196) then
	ShowMap(UID, 546);
end

if(EVENT == 198) then
	QuestStatus = GetQuestStatus(UID, 1250)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43829, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1250, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 1250, 43848, NPC, 10, 196);
		else
			RunExchange(UID,6046);
			SaveEvent(UID, 7609);
		end
	end
end

if (EVENT == 202) then
	SelectMsg(UID, 4, 1251, 43851, NPC, 10, 205, 23, -1);
end

if(EVENT == 205) then
    RunExchange(UID,6047);
    SaveEvent(UID, 7614);
	SaveEvent(UID, 7616);
	SaveEvent(UID, 7615);
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=1242 status=255 n_index=7558
if (EVENT == 110) then
	SaveEvent(UID, 7559);
end

-- [AUTO-GEN] quest=1243 status=255 n_index=7564
if (EVENT == 120) then
	SaveEvent(UID, 7565);
end

-- [AUTO-GEN] quest=1244 status=255 n_index=7570
if (EVENT == 130) then
	SaveEvent(UID, 7571);
end

-- [AUTO-GEN] quest=1246 status=255 n_index=7582
if (EVENT == 150) then
	SaveEvent(UID, 7583);
end

-- [AUTO-GEN] quest=1247 status=255 n_index=7588
if (EVENT == 160) then
	SaveEvent(UID, 7589);
end

-- [AUTO-GEN] quest=1248 status=255 n_index=7594
if (EVENT == 170) then
	SaveEvent(UID, 7595);
end

-- [AUTO-GEN] quest=1249 status=255 n_index=7600
if (EVENT == 180) then
	SaveEvent(UID, 7601);
end

-- [AUTO-GEN] quest=1250 status=255 n_index=7606
if (EVENT == 190) then
	SearchQuest(UID, 25065);
end

-- [AUTO-GEN] quest=1251 status=255 n_index=7612
if (EVENT == 200) then
	SaveEvent(UID, 7613);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
