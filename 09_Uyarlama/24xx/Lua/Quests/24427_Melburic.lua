-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [888]={{900005000,125}},
  [889]={{900005000,125}},
  [890]={{900005000,125}},
  [891]={{900005000,125}},
  [1013]={{900005000,131}},
  [1014]={{900005000,131}},
  [1015]={{900005000,131}},
  [1016]={{900005000,131}},
  [1021]={{900005000,134}},
  [1022]={{900005000,134}},
  [1023]={{900005000,134}},
  [1024]={{900005000,134}},
  [1029]={{900005000,137}},
  [1030]={{900005000,137}},
  [1031]={{900005000,137}},
  [1032]={{900005000,137}},
  [1174]={{900005000,496}},
  [1189]={{900005000,401}},
  [1191]={{900005000,405}},
  [1192]={{900005000,407}},
  [1193]={{900005000,409}},
  [1194]={{900005000,411}},
  [3024]={},
  [3025]={{910217000,1},{910219000,1},{910220000,1}},
  [3028]={{910227000,1}},
  [3057]={},
  [3058]={{900005000,568}},
  [3059]={{900005000,569}},
  [3060]={{900005000,570}},
}
local __KO_Completion = {
  [1789]={496,1174},
  [2003]={401,1189},
  [2027]={405,1191},
  [2039]={407,1192},
  [2051]={409,1193},
  [2063]={411,1194},
  [8399]={125,888},
  [8404]={125,889},
  [8409]={125,890},
  [8414]={125,891},
  [8513]={131,1013},
  [8518]={131,1014},
  [8523]={131,1015},
  [8528]={131,1016},
  [8555]={134,1021},
  [8560]={134,1022},
  [8565]={134,1023},
  [8570]={134,1024},
  [8597]={137,1029},
  [8602]={137,1030},
  [8607]={137,1031},
  [8612]={137,1032},
  [11285]={537,3024},
  [11297]={538,3025},
  [11333]={541,3028},
  [11674]={567,3057},
  [11686]={568,3058},
  [11698]={569,3059},
  [11710]={570,3060},
}
local __KO_Quests = {
  [888]={125},
  [889]={125},
  [890]={125},
  [891]={125},
  [1013]={131},
  [1014]={131},
  [1015]={131},
  [1016]={131},
  [1021]={134},
  [1022]={134},
  [1023]={134},
  [1024]={134},
  [1029]={137},
  [1030]={137},
  [1031]={137},
  [1032]={137},
  [1174]={496},
  [1189]={401},
  [1191]={405},
  [1192]={407},
  [1193]={409},
  [1194]={411},
  [3024]={537},
  [3025]={538},
  [3028]={541},
  [3057]={567},
  [3058]={568},
  [3059]={569},
  [3060]={570},
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

local function RunQuestExchange(uid, exchange, selected, allExp)
  if selected == nil then return RunExchange(uid, exchange) end
  if selected ~= STEP or selected < 0 or selected > 4 or allExp ~= 1 then return false end
  return RunSelectExchange(uid, exchange)
end
local NPC = 24427;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then 
		SelectMsg(UID, 2, -1, 8004, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then 
		NpcMsg(UID, 8004, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 1002) then 
	SelectMsg(UID, 4, 401, 8141, NPC, 22, 1003, 23, -1);
end

if (EVENT == 1003) then
	QuestStatus = GetQuestStatus(UID, 401)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 2002);
	end
end

if (EVENT == 1010) then
	QuestStatus = GetQuestStatus(UID, 401)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 401, 1);
		if (MonsterCount < 10) then
			SelectMsg(UID, 2, 401, 8369, NPC, 18, 1007);
		else
			SaveEvent(UID, 2004);
		end
	end
end

if (EVENT == 1006) then
	QuestStatus = GetQuestStatus(UID, 401)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 401, 1);
		if (MonsterCount < 10) then
			SelectMsg(UID, 2, 401, 8369, NPC, 18, 1007);
		else
			SelectMsg(UID, 4, 401, 8004, NPC, 22, 1008, 23, -1);
		end
	end
end

if (EVENT == 1007) then
	ShowMap(UID, 95);
end

if (EVENT == 1008) then
	QuestStatus = GetQuestStatus(UID, 401)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 401, 1);
		if (MonsterCount < 10) then
			SelectMsg(UID, 2, 401, 8369, NPC, 18, 1007);
		else
			RunQuestExchange(UID,1189);
			SaveEvent(UID, 2003);
		end
	end
end

local savenum = 496;

if (EVENT == 402) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 8369, NPC, 22, 403, 23, -1);
	else
		SelectMsg(UID, 2, savenum, 796, NPC, 27, -1);
	end
end

if (EVENT == 403) then
	SaveEvent(UID, 1788);
end

if (EVENT == 409) then
	SaveEvent(UID, 1790);
end

if (EVENT == 406) then
	MonsterCount = CountMonsterQuestSub(UID, 499, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, savenum, 8143, NPC, 18, 407);
	else
		SelectMsg(UID, 4, savenum, 8369, NPC, 22, 1008, 23, 1008);
	end
end

if (EVENT == 407) then
	ShowMap(UID, 246);
end

if (EVENT == 411) then
	QuestStatusCheck = GetQuestStatus(UID, 499) 
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8004, NPC, 10, -1);
	else
	MonsterCount = CountMonsterQuestSub(UID, 499, 1);
	if (MonsterCount < 20) then
		SelectMsg(UID, 2, savenum, 8143, NPC, 18, 407);
	else
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunQuestExchange(UID,1173)
		SaveEvent(UID, 1789);
		else
		RunQuestExchange(UID,1173)
		SaveEvent(UID, 1789);

end
end
end
end

if (EVENT == 8702) then 
	SelectMsg(UID, 4, 125, 8141, NPC, 22, 8703, 23, -1);
end

if (EVENT == 8703) then
	QuestStatus = GetQuestStatus(UID, 125)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
			SaveEvent(UID, 8398);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			SaveEvent(UID, 8403);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			SaveEvent(UID, 8408);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			SaveEvent(UID, 8413);
		end
	end
end

if (EVENT == 8710) then
	QuestStatus = GetQuestStatus(UID, 125)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 125, 1);
		if (MonsterCount < 15) then
			SelectMsg(UID, 2, 125, 8369, NPC, 18, 8707);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
			SaveEvent(UID, 8400);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			SaveEvent(UID, 8405);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			SaveEvent(UID, 8410);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			SaveEvent(UID, 8415);
			end
		end
	end
end

if (EVENT == 8706) then
	QuestStatus = GetQuestStatus(UID, 125)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 125, 1);
		if (MonsterCount < 15) then
			SelectMsg(UID, 2, 125, 8369, NPC, 18, 8707);
		else
			SelectMsg(UID, 5, 125, 8004, NPC, 22, 8708,23,-1);
		end
	end
end

if (EVENT == 8707) then
	ShowMap(UID, 95);
end

if (EVENT == 8708) then
	QuestStatus = GetQuestStatus(UID, 125)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 125, 1);
		if (MonsterCount < 15) then
			SelectMsg(UID, 2, 125, 8369, NPC, 18, 8707);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then 
			RunQuestExchange(UID,888,STEP,1);
			SaveEvent(UID, 8399);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			RunQuestExchange(UID,889,STEP,1);
			SaveEvent(UID, 8404);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			RunQuestExchange(UID,890,STEP,1);
			SaveEvent(UID, 8409);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			RunQuestExchange(UID,891,STEP,1);
			SaveEvent(UID, 8414);
			end
		end
	end
end

if (EVENT == 1102) then
	SelectMsg(UID, 4, 405, 8365, NPC, 22, 1103, 23, -1);
end

if (EVENT == 1103) then
	QuestStatus = GetQuestStatus(UID, 405)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 2026);
	end
end

if (EVENT == 1110) then
	QuestStatus = GetQuestStatus(UID, 405)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 405, 1);
		if (MonsterCount < 10) then
			SelectMsg(UID, 2, 405, 8144, NPC, 18, 1107);
		else
			SaveEvent(UID, 2028);
		end
	end
end

if (EVENT == 1106) then
	QuestStatus = GetQuestStatus(UID, 405)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 405, 1);
		if (MonsterCount < 10) then
			SelectMsg(UID, 2, 405, 8144, NPC, 18, 1107);
		else
			SelectMsg(UID, 4, 405, 8004, NPC, 22, 1108, 23, -1);
		end
	end
end

if (EVENT == 1107) then
	ShowMap(UID, 99);
end

if (EVENT == 1108) then
	QuestStatus = GetQuestStatus(UID, 405)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 405, 1);
		if (MonsterCount < 10) then
			SelectMsg(UID, 2, 405, 8144, NPC, 18, 1107);
		else
			RunQuestExchange(UID,1191);
			SaveEvent(UID, 2027);
		end
	end
end

if (EVENT == 8302) then
	SelectMsg(UID, 4, 131, 8365, NPC, 22, 8303, 23, -1);
end

if (EVENT == 8303) then
	QuestStatus = GetQuestStatus(UID, 131)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
			SaveEvent(UID, 8512);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			SaveEvent(UID, 8517);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			SaveEvent(UID, 8522);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			SaveEvent(UID, 8527);
		end
	end
end

if (EVENT == 8310) then
	QuestStatus = GetQuestStatus(UID, 131)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 131, 1);
		if (MonsterCount < 15) then
			SelectMsg(UID, 2, 131, 8144, NPC, 18, 8307);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
			SaveEvent(UID, 8514);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			SaveEvent(UID, 8519);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			SaveEvent(UID, 8524);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			SaveEvent(UID, 8529);
			end
		end
	end
end

if (EVENT == 8306) then
	QuestStatus = GetQuestStatus(UID, 131)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 131, 1);
		if (MonsterCount < 15) then
			SelectMsg(UID, 2, 131, 8144, NPC, 18, 8307);
		else
			SelectMsg(UID, 4, 131, 8004, NPC, 22, 8308, 23, -1);
		end
	end
end

if (EVENT == 8307) then
	ShowMap(UID, 99);
end

if (EVENT == 8308) then
	QuestStatus = GetQuestStatus(UID, 131)	
	SlotCheck = CheckGiveSlot(UID, 1)
	if SlotCheck == false then
		elseif(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 131, 1);
		if (MonsterCount < 15) then
			SelectMsg(UID, 2, 131, 8144, NPC, 18, 8307);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
			RunQuestExchange(UID,1013);
			SaveEvent(UID, 8513);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			RunQuestExchange(UID,1014);
			SaveEvent(UID, 8518);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			RunQuestExchange(UID,1015);
			SaveEvent(UID, 8523);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			RunQuestExchange(UID,1016);
			SaveEvent(UID, 8528);
			end
		end
	end
end

if (EVENT == 1302) then
	SelectMsg(UID, 4, 407, 8076, NPC, 22, 1303, 23, -1);
end

if (EVENT == 1303) then
	QuestStatus = GetQuestStatus(UID, 407)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 2038);
	end
end

if (EVENT == 1310) then
	QuestStatus = GetQuestStatus(UID, 407)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 407, 1);
		if (MonsterCount < 10) then
			SelectMsg(UID, 2, 407, 8144, NPC, 18, 1307);
		else
			SaveEvent(UID, 2040);
		end
	end
end

if (EVENT == 1306) then
	QuestStatus = GetQuestStatus(UID, 407)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 407, 1);
		if (MonsterCount < 10) then
			SelectMsg(UID, 2, 407, 8144, NPC, 18, 1307);
		else
			SelectMsg(UID, 4, 407, 8004, NPC, 22, 1308, 23, -1);
		end
	end
end

if (EVENT == 1307) then
	ShowMap(UID, 101);
end

if (EVENT == 1308) then
	QuestStatus = GetQuestStatus(UID, 407)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 407, 1);
		if (MonsterCount < 10) then
			SelectMsg(UID, 2, 407, 8144, NPC, 18, 1307);
		else
			RunQuestExchange(UID,1192);
			SaveEvent(UID, 2039);
		end
	end
end

if (EVENT == 8202) then
	SelectMsg(UID, 4, 134, 8076, NPC, 22, 8203, 23, -1);
end

if (EVENT == 8203) then
	QuestStatus = GetQuestStatus(UID, 134)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
			SaveEvent(UID, 8554);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			SaveEvent(UID, 8559);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			SaveEvent(UID, 8564);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			SaveEvent(UID, 8569);
		end
	end
end

if (EVENT == 8210) then
	QuestStatus = GetQuestStatus(UID, 134)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 134, 1);
		if (MonsterCount < 15) then
			SelectMsg(UID, 2, 134, 8144, NPC, 18, 8207);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
			SaveEvent(UID, 8556);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			SaveEvent(UID, 8561);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			SaveEvent(UID, 8566);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			SaveEvent(UID, 8571);
			end
		end
	end
end

if (EVENT == 8206) then
	QuestStatus = GetQuestStatus(UID, 134)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 134, 1);
		if (MonsterCount < 15) then
			SelectMsg(UID, 2, 134, 8144, NPC, 18, 8207);
		else
			SelectMsg(UID, 4, 134, 8004, NPC, 22, 8208, 23, -1);
		end
	end
end

if (EVENT == 8207) then
	ShowMap(UID, 101); 
end

if (EVENT == 8208) then
	QuestStatus = GetQuestStatus(UID, 134)	
	SlotCheck = CheckGiveSlot(UID, 1)
	if SlotCheck == false then
		elseif(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 134, 1);
		if (MonsterCount < 15) then
			SelectMsg(UID, 2, 134, 8144, NPC, 18, 8207);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
			RunQuestExchange(UID,1021);
			SaveEvent(UID, 8555);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			RunQuestExchange(UID,1022);
			SaveEvent(UID, 8560);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			RunQuestExchange(UID,1023);
			SaveEvent(UID, 8565);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			RunQuestExchange(UID,1024);
			SaveEvent(UID, 8570);
			end   
		end
	end
end

if (EVENT == 1402) then
	SelectMsg(UID, 4, 409, 8353, NPC, 22, 1403, 23, -1);
end

if (EVENT == 1403) then
	QuestStatus = GetQuestStatus(UID, 409)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 2050);
	end
end

if (EVENT == 1410) then
	QuestStatus = GetQuestStatus(UID, 409)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 409, 1);
		if (MonsterCount < 10) then
			SelectMsg(UID, 2, 409, 8144, NPC, 18, 1407);
		else
			SaveEvent(UID, 2052);
		end
	end
end

if (EVENT == 1406) then
	QuestStatus = GetQuestStatus(UID, 409)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 409, 1);
		if (MonsterCount < 10) then
			SelectMsg(UID, 2, 409, 8144, NPC, 18, 1407);
		else
			SelectMsg(UID, 4, 409, 8004, NPC, 22, 1408, 23, -1);
		end
	end
end

if (EVENT == 1407) then
	ShowMap(UID, 103);
end

if (EVENT == 1408) then
	QuestStatus = GetQuestStatus(UID, 409)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 409, 1);
		if (MonsterCount < 10) then
			SelectMsg(UID, 2, 409, 8144, NPC, 18, 1407);
		else
			RunQuestExchange(UID,1193);
			SaveEvent(UID, 2051);
		end
	end
end

if (EVENT == 8102) then
	SelectMsg(UID, 4, 137, 8353, NPC, 22, 8103, 23, -1);
end

if (EVENT == 8103) then
	QuestStatus = GetQuestStatus(UID, 137)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
			SaveEvent(UID, 8596);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			SaveEvent(UID, 8601);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			SaveEvent(UID, 8606);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			SaveEvent(UID, 8611);
		end
	end
end

if (EVENT == 8110) then
	QuestStatus = GetQuestStatus(UID, 137)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 137, 1);
		if (MonsterCount < 15) then
			SelectMsg(UID, 2, 137, 8144, NPC, 18, 8107);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
			SaveEvent(UID, 8598);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			SaveEvent(UID, 8603);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			SaveEvent(UID, 8608);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			SaveEvent(UID, 8613);
			end
		end
	end
end

if (EVENT == 8106) then
	QuestStatus = GetQuestStatus(UID, 137)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 137, 1);
		if (MonsterCount < 15) then
			SelectMsg(UID, 2, 137, 8144, NPC, 18, 8107);
		else
			SelectMsg(UID, 4, 137, 8004, NPC, 22, 8108, 23, -1);
		end
	end
end

if (EVENT == 8107) then
	ShowMap(UID, 103);
end

if (EVENT == 8108) then
	QuestStatus = GetQuestStatus(UID, 137)	
	SlotCheck = CheckGiveSlot(UID, 1)
	if SlotCheck == false then
		elseif(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 137, 1);
		if (MonsterCount < 15) then
			SelectMsg(UID, 2, 137, 8144, NPC, 18, 8107);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
			RunQuestExchange(UID,1029)
			SaveEvent(UID, 8597);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			RunQuestExchange(UID,1030)
			SaveEvent(UID, 8602);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			RunQuestExchange(UID,1031)
			SaveEvent(UID, 8607);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			RunQuestExchange(UID,1032)
			SaveEvent(UID, 8612);
			end
		end
	end
end

if (EVENT == 1502) then
	SelectMsg(UID, 4, 411, 8360, NPC, 22, 1503, 23, -1);
end

if (EVENT == 1503) then
	QuestStatus = GetQuestStatus(UID, 411)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 2062);
	end
end

if (EVENT == 1510) then
	QuestStatus = GetQuestStatus(UID, 411)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 411, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 411, 8144, NPC, 18, 1507);
		else
			SaveEvent(UID, 2064);
		end
	end
end

if (EVENT == 1506) then
	QuestStatus = GetQuestStatus(UID, 411)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 411, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 411, 8144, NPC, 18, 1507);
		else
			SelectMsg(UID, 4, 411, 8004, NPC, 22, 1508, 23, -1);
		end
	end
end

if (EVENT == 1507) then
	ShowMap(UID, 105);
end

if (EVENT == 1508) then
	QuestStatus = GetQuestStatus(UID, 411)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 411, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 411, 8144, NPC, 18, 1507);
		else
			RunQuestExchange(UID,1194);
			SaveEvent(UID, 2063);
		end
	end
end

if (EVENT == 8022) then -- 40 Level Death Knight
	SelectMsg(UID, 4, 140, 8353, NPC, 22, 8023, 23, -1);
end

if (EVENT == 8023) then
	QuestStatus = GetQuestStatus(UID, 140)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
			SaveEvent(UID, 8638);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			SaveEvent(UID, 8643);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			SaveEvent(UID, 8648);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			SaveEvent(UID, 8653);
		end
	end
end

if (EVENT == 8030) then
	QuestStatus = GetQuestStatus(UID, 140)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 140, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 140, 8144, NPC, 18, 8027);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
			SaveEvent(UID, 8640);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			SaveEvent(UID, 8645);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			SaveEvent(UID, 8650);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			SaveEvent(UID, 8655);
			end
		end
	end
end

if (EVENT == 8026) then
	QuestStatus = GetQuestStatus(UID, 140)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 140, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 140, 8144, NPC, 18, 8027);
		else
			SelectMsg(UID, 4, 140, 8004, NPC, 22, 8028, 23, -1);
		end
	end
end

if (EVENT == 8027) then
	ShowMap(UID, 105);
end

if (EVENT == 8028) then
	QuestStatus = GetQuestStatus(UID, 140)	
	SlotCheck = CheckGiveSlot(UID, 3)
	if SlotCheck == false then
		elseif(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 140, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 140, 8144, NPC, 18, 8027);
		else
	Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
			RunQuestExchange(UID,1037)
			--SaveEvent(UID, 8639);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			RunQuestExchange(UID,1038)
			--SaveEvent(UID, 8644);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			RunQuestExchange(UID,1039)
			--SaveEvent(UID, 8649);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			RunQuestExchange(UID,1040)
			--SaveEvent(UID, 8654);
			end
		end
	end
end

if (EVENT == 1602)then
	SelectMsg(UID, 4, 537, 20043, NPC, 22, 1603,23,-1);
end

if (EVENT == 1603)then
	SaveEvent(UID, 11284);
	SaveEvent(UID, 11286);
end

if (EVENT == 1605)then
	SelectMsg(UID, 2, 537, 20043, NPC, 10,-1);
	SaveEvent(UID, 11285);
	SaveEvent(UID, 11296);
end

if (EVENT == 1702)then
	SelectMsg(UID, 4, 538, 20045, NPC, 22, 1703,23,-1);
end

if (EVENT == 1703)then
	SaveEvent(UID, 11296);
end

if (EVENT == 1706)then
	SaveEvent(UID, 11298);
end

if (EVENT == 1705) then
	SelectMsg(UID, 4, 538, 20045, NPC, 22, 1707, 27, -1); 
end

if (EVENT == 1707)then
RunQuestExchange(UID,3025);
	SaveEvent(UID,11297);
	SaveEvent(UID,11308);
end

if (EVENT == 1802)then
	SelectMsg(UID, 4, 541, 20051, NPC, 22, 1803,23,-1);
end

if (EVENT == 1803)then
	QuestStatus = GetQuestStatus(UID, 541)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 11332);
	end
end

if (EVENT == 1808)then
	QuestStatus = GetQuestStatus(UID, 541)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 910227000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 541, 20051, NPC, 18,-1);
		else
			SaveEvent(UID, 11334);
		end
	end
end

if (EVENT == 1805) then
	QuestStatus = GetQuestStatus(UID, 541)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 910227000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 541, 20051, NPC, 18,-1);
		else
			SelectMsg(UID, 4, 541, 20051, NPC, 22, 1806, 27, -1);
		end
	end
end		

if (EVENT == 1806)then
	QuestStatus = GetQuestStatus(UID, 541)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT = HowmuchItem(UID, 910227000);   
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 541, 20051, NPC, 18,-1);
		else
			RunQuestExchange(UID,3028);
			SaveEvent(UID,11333);
			SaveEvent(UID,11344);
			SelectMsg(UID, 2, 541, 20343, NPC, 10,-1);
		end
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=496 status=2 n_index=1789
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 496)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 1174);
		SaveEvent(UID, 1791);
	end
end

-- [AUTO-GEN] quest=401 status=2 n_index=2003
if (EVENT == 190) then
	SearchQuest(UID, 24427);
end

-- [AUTO-GEN] quest=541 status=2 n_index=11333
if (EVENT == 193) then
	QuestStatusCheck = GetQuestStatus(UID, 541)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3028);
		SaveEvent(UID, 11335);
	end
end

-- [AUTO-GEN] quest=499 status=255 n_index=1781
if (EVENT == 400) then
	SaveEvent(UID, 1782);
end

-- [AUTO-GEN] quest=401 status=255 n_index=2000
if (EVENT == 1000) then
	SaveEvent(UID, 2001);
end

-- [AUTO-GEN] quest=405 status=255 n_index=2024
if (EVENT == 1100) then
	SaveEvent(UID, 2025);
end

-- [AUTO-GEN] quest=407 status=255 n_index=2036
if (EVENT == 1300) then
	SaveEvent(UID, 2037);
end

-- [AUTO-GEN] quest=409 status=255 n_index=2048
if (EVENT == 1400) then
	SaveEvent(UID, 2049);
end

-- [AUTO-GEN] quest=411 status=255 n_index=2060
if (EVENT == 1500) then
	SaveEvent(UID, 2061);
end

-- [AUTO-GEN] quest=411 status=1 n_index=2062
if (EVENT == 1530) then
	QuestStatusCheck = GetQuestStatus(UID, 411)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 1194);
		SaveEvent(UID, 2063);
	end
end

-- [AUTO-GEN] quest=537 status=255 n_index=11282
if (EVENT == 1600) then
	SaveEvent(UID, 11283);
end

-- [AUTO-GEN] quest=538 status=255 n_index=11294
if (EVENT == 1700) then
	SaveEvent(UID, 11295);
end

-- [AUTO-GEN] quest=541 status=255 n_index=11330
if (EVENT == 1800) then
	SaveEvent(UID, 11331);
end

-- [AUTO-GEN] quest=567 status=255 n_index=11779
if (EVENT == 1900) then
	SaveEvent(UID, 11672);
end

-- [AUTO-GEN] quest=567 status=0 n_index=11672
if (EVENT == 1902) then
	SelectMsg(UID, 4, 567, 20102, NPC, 3102, 1903, 23, -1);
end

-- [AUTO-GEN] quest=567 status=1 n_index=11673
if (EVENT == 1903) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 567, 20102, NPC, 18, 1905);
	else
		SelectMsg(UID, 4, 567, 20102, NPC, 41, 1904, 27, -1);
	end
end

-- [AUTO-GEN] quest=567 status=1 n_index=11673
if (EVENT == 1904) then
	QuestStatusCheck = GetQuestStatus(UID, 567)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3057);
		SaveEvent(UID, 11674);
	end
end

-- [AUTO-GEN] quest=567 status=3 n_index=11675
if (EVENT == 1905) then
	SelectMsg(UID, 2, 567, 20102, NPC, 10, -1);
end

-- [AUTO-GEN] quest=568 status=255 n_index=11683
if (EVENT == 2000) then
	SaveEvent(UID, 11684);
end

-- [AUTO-GEN] quest=568 status=0 n_index=11684
if (EVENT == 2002) then
	SelectMsg(UID, 4, 568, 20104, NPC, 3104, 2003, 23, -1);
end

-- [AUTO-GEN] quest=568 status=0 n_index=11684
if (EVENT == 2003) then
	SaveEvent(UID, 11685);
end

-- [AUTO-GEN] quest=568 status=1 n_index=11685
if (EVENT == 2005) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 568, 20104, NPC, 22, 2006, 23, -1);
	else
		SelectMsg(UID, 2, 568, 20104, NPC, 18, 2006);
	end
end

-- [AUTO-GEN] quest=568 status=1 n_index=11685
if (EVENT == 2006) then
	QuestStatusCheck = GetQuestStatus(UID, 568)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3058);
		SaveEvent(UID, 11686);
	end
end

-- [AUTO-GEN] quest=569 status=255 n_index=11695
if (EVENT == 2100) then
	SaveEvent(UID, 11696);
end

-- [AUTO-GEN] quest=569 status=0 n_index=11696
if (EVENT == 2102) then
	SelectMsg(UID, 4, 569, 20106, NPC, 3106, 2103, 23, -1);
end

-- [AUTO-GEN] quest=569 status=0 n_index=11696
if (EVENT == 2103) then
	SaveEvent(UID, 11697);
end

-- [AUTO-GEN] quest=569 status=1 n_index=11697
if (EVENT == 2105) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 569, 20106, NPC, 22, 2106, 23, -1);
	else
		SelectMsg(UID, 2, 569, 20106, NPC, 18, 2106);
	end
end

-- [AUTO-GEN] quest=569 status=1 n_index=11697
if (EVENT == 2106) then
	QuestStatusCheck = GetQuestStatus(UID, 569)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3059);
		SaveEvent(UID, 11698);
	end
end

-- [AUTO-GEN] quest=570 status=255 n_index=11707
if (EVENT == 2200) then
	SaveEvent(UID, 11708);
end

-- [AUTO-GEN] quest=570 status=0 n_index=11708
if (EVENT == 2202) then
	SelectMsg(UID, 4, 570, 20108, NPC, 3108, 2203, 23, -1);
end

-- [AUTO-GEN] quest=570 status=0 n_index=11708
if (EVENT == 2203) then
	SaveEvent(UID, 11709);
end

-- [AUTO-GEN] quest=570 status=1 n_index=11709
if (EVENT == 2205) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 570, 20108, NPC, 22, 2206, 23, -1);
	else
		SelectMsg(UID, 2, 570, 20108, NPC, 18, 2206);
	end
end

-- [AUTO-GEN] quest=570 status=1 n_index=11709
if (EVENT == 2206) then
	QuestStatusCheck = GetQuestStatus(UID, 570)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3060);
		SaveEvent(UID, 11710);
	end
end

-- [AUTO-GEN] quest=140 status=255 n_index=8636
if (EVENT == 8020) then
	SaveEvent(UID, 8637);
end

-- [AUTO-GEN] quest=137 status=255 n_index=8594
if (EVENT == 8100) then
	SaveEvent(UID, 8595);
end

-- [AUTO-GEN] quest=134 status=255 n_index=8552
if (EVENT == 8200) then
	SaveEvent(UID, 8553);
end

-- [AUTO-GEN] quest=131 status=255 n_index=8510
if (EVENT == 8300) then
	SaveEvent(UID, 8511);
end

-- [AUTO-GEN] quest=125 status=255 n_index=8396
if (EVENT == 8700) then
	SaveEvent(UID, 8397);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
