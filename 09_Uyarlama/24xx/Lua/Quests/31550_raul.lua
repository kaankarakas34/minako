-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [3110]={},
  [3111]={{900005000,622}},
  [3112]={{900005000,624}},
  [3113]={{900005000,626}},
  [3114]={{900005000,628}},
  [13111]={{900005000,623}},
  [13112]={{900005000,625}},
  [13113]={{900005000,627}},
  [13114]={{900005000,629}},
}
local __KO_Completion = {
  [12301]={621,3110},
  [12313]={622,3111},
  [12325]={624,3112},
  [12337]={626,3113},
  [12349]={628,3114},
}
local __KO_Quests = {
  [3110]={621},
  [3111]={622},
  [3112]={624},
  [3113]={626},
  [3114]={628},
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
local NPC = 31550;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then 
		SelectMsg(UID, 2, -1, 4703, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then 
		NpcMsg(UID, 1179, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 1001)then
	SelectMsg(UID, 2, 621, 21367, NPC, 10, 1002);
end

if (EVENT == 1002)then
	SelectMsg(UID, 2, 621, 21368, NPC, 3000, 1003,3005,-1);
	SaveEvent(UID, 12300);
end

if (EVENT == 1003)then
	SelectMsg(UID, 4, 621, 21231, NPC, 22, 1004,23,-1);
	SaveEvent(UID, 12302);
end

if (EVENT == 1004)then
	SelectMsg(UID, 2, 621, 21370, NPC, 10,-1);
	SaveEvent(UID, 12301);
	SaveEvent(UID, 12312);
	SaveEvent(UID, 12372);
end

if (EVENT == 1101) then
	SelectMsg(UID, 4, 622, 21232, NPC, 22, 1102, 27, -1);
end

if (EVENT == 1102) then
	QuestStatusCheck = GetQuestStatus(UID, 622)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12312);
	end
end

if (EVENT == 1106) then
	QuestStatusCheck = GetQuestStatus(UID, 622)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 622, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 622, 21232, NPC, 18, 1107);
		else
			SaveEvent(UID, 12314);
		end
	end
end

if (EVENT == 1105) then
	QuestStatusCheck = GetQuestStatus(UID, 622)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 622, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 622, 21232, NPC, 18, 1107);
		else
			SelectMsg(UID, 4, 622, 21232, NPC, 22, 1108, 23, -1);
		end
	end
end

if (EVENT == 1107) then
	ShowMap(UID, 822);
end

if (EVENT == 1108) then
	QuestStatusCheck = GetQuestStatus(UID, 622)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 622, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 622, 21232, NPC, 18, 1107);
		else
			SelectMsg(UID, 2, 622, 21396, NPC, 10, -1);
			RunExchange(UID,13111);
			SaveEvent(UID, 12313);
			SaveEvent(UID, 12324);
		end
	end
end

if (EVENT == 1201) then
	SelectMsg(UID, 4, 624, 21234, NPC, 22, 1202, 27, -1);
end

if (EVENT == 1202) then
	QuestStatusCheck = GetQuestStatus(UID, 624)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12324);
	end
end

if (EVENT == 1206) then
	QuestStatusCheck = GetQuestStatus(UID, 624)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 624, 1);
		if (MonsterCount < 100) then
			SelectMsg(UID, 2, 624, 21234, NPC, 18, 1207);
		else
			SaveEvent(UID, 12326);
		end
	end
end

if (EVENT == 1205) then
	QuestStatusCheck = GetQuestStatus(UID, 624)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 624, 1);
		if (MonsterCount < 100) then
			SelectMsg(UID, 2, 624, 21234, NPC, 18, 1207);
		else
			SelectMsg(UID, 4, 624, 21234, NPC, 22, 1208, 23, -1);
		end
	end
end

if (EVENT == 1207) then
	ShowMap(UID, 824);
end

if (EVENT == 1208) then
	QuestStatusCheck = GetQuestStatus(UID, 624)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 624, 1);
		if (MonsterCount < 100) then
			SelectMsg(UID, 2, 624, 21234, NPC, 18, 1207);
		else
			RunExchange(UID,13112);
			SaveEvent(UID, 12325);
			SaveEvent(UID, 12336);
		end
	end
end

if (EVENT == 1301) then
	SelectMsg(UID, 4, 626, 21236, NPC, 22, 1302, 27, -1);
end

if (EVENT == 1302) then
	QuestStatusCheck = GetQuestStatus(UID, 626)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12336);
	end
end

if (EVENT == 1306) then
	QuestStatusCheck = GetQuestStatus(UID, 626)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 626, 1);
		if (MonsterCount < 100) then
			SelectMsg(UID, 2, 626, 21236, NPC, 18, 1307);
		else
			SaveEvent(UID, 12338);
		end
	end
end

if (EVENT == 1305) then
	QuestStatusCheck = GetQuestStatus(UID, 626)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 626, 1);
		if (MonsterCount < 100) then
			SelectMsg(UID, 2, 626, 21236, NPC, 18, 1307);
		else
			SelectMsg(UID, 4, 626, 21236, NPC, 22, 1308, 23, -1);
		end
	end
end

if (EVENT == 1307) then
	ShowMap(UID, 826);
end

if (EVENT == 1308) then
	QuestStatusCheck = GetQuestStatus(UID, 626)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 626, 1);
		if (MonsterCount < 100) then
			SelectMsg(UID, 2, 626, 21236, NPC, 18, 1307);
		else
			RunExchange(UID,13113);
			SaveEvent(UID, 12337);
			SaveEvent(UID, 12348);
		end
	end
end

if (EVENT == 1401) then
	SelectMsg(UID, 4, 628, 21238, NPC, 22, 1402, 27, -1);
end

if (EVENT == 1402) then
	QuestStatusCheck = GetQuestStatus(UID, 628)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12348);
	end
end

if (EVENT == 1406) then
	QuestStatusCheck = GetQuestStatus(UID, 628)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 628, 1);
		if (MonsterCount < 100) then
			SelectMsg(UID, 2, 628, 21238, NPC, 18, 1407);
		else
			SaveEvent(UID, 12350);
		end
	end
end

if (EVENT == 1405) then
	QuestStatusCheck = GetQuestStatus(UID, 628)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 628, 1);
		if (MonsterCount < 100) then
			SelectMsg(UID, 2, 628, 21238, NPC, 18, 1407);
		else
			SelectMsg(UID, 4, 628, 21238, NPC, 22, 1408, 23, -1);
		end
	end
end

if (EVENT == 1407) then
	ShowMap(UID, 825);
end

if (EVENT == 1408) then
	QuestStatusCheck = GetQuestStatus(UID, 628)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 628, 1);
		if (MonsterCount < 100) then
			SelectMsg(UID, 2, 628, 21238, NPC, 18, 1407);
		else
			RunExchange(UID,13114);
			SaveEvent(UID, 12349);
			SaveEvent(UID, 12360);
		end
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=621 status=2 n_index=12301
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 621)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3110);
		SaveEvent(UID, 12303);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
