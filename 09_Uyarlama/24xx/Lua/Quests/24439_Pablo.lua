-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [3]={{900005000,274}},
  [4]={{900005000,275}},
  [9]={{900005000,276}},
  [10]={{900005000,277}},
  [109]={{900005000,278}},
  [3010]={},
  [3011]={{900005000,524}},
  [3016]={{910215000,1}},
  [3017]={{508105000,5}},
  [3020]={{910216000,1}},
  [3021]={{900005000,534}},
  [3041]={{910229000,1}},
  [3062]={},
}
local __KO_Completion = {
  [23]={274,3},
  [34]={275,4},
  [44]={276,9},
  [85]={277,10},
  [7737]={278,109},
  [11117]={523,3010},
  [11129]={524,3011},
  [11189]={529,3016},
  [11201]={530,3017},
  [11237]={533,3020},
  [11249]={534,3021},
  [11483]={551,3041},
  [11734]={572,3062},
}
local __KO_Quests = {
  [3]={274},
  [4]={275},
  [9]={276},
  [10]={277},
  [109]={278},
  [3010]={523},
  [3011]={524},
  [3016]={529},
  [3017]={530},
  [3020]={533},
  [3021]={534},
  [3041]={551},
  [3062]={572},
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
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 151 or EVENT == 154 or EVENT == 157 or EVENT == 171 or EVENT == 174 or EVENT == 177 then
  SelectMsg(UID, 2, -1, 10526, 24439, 10, -1)
  return
end
local NPC = 24439;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 973, NPC, 10, -1);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 973, NPC);
	else
		EVENT = QuestNum
	end
end

if (EVENT == 111) then
	SelectMsg(UID, 4, 274, 120, NPC, 22, 112, 23, -1);
end

if (EVENT == 112) then
	QuestStatus = GetQuestStatus(UID, 274)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
			SaveEvent(UID, 19);
	end
end

if (EVENT == 115) then
	QuestStatus = GetQuestStatus(UID, 274)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 274, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 274, 120, NPC, 21, 117);
		else
			SaveEvent(UID, 24);
		end
	end
end

if (EVENT == 116) then
	QuestStatus = GetQuestStatus(UID, 274)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 274, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 274, 120, NPC, 21, 117);
		else
			SelectMsg(UID, 4, 274, 120, NPC, 41, 118, 23, -1);
		end
	end
end

if (EVENT == 117) then
	ShowMap(UID, 78);
end

if (EVENT == 118) then
	QuestStatus = GetQuestStatus(UID, 274)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 274, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 274, 120, NPC, 21, 117);
		else
			RunQuestExchange(UID, 3);
			SaveEvent(UID, 23);
		end
	end
end

if (EVENT == 120) then
	SelectMsg(UID, 4, 275, 142, NPC, 22, 121, 23, -1);
end

if (EVENT == 121) then
	QuestStatus = GetQuestStatus(UID, 275)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
			SaveEvent(UID, 33);
	end
end

if (EVENT == 124) then
	QuestStatus = GetQuestStatus(UID, 275)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 275, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 275, 142, NPC, 21, 126);
		else
			SaveEvent(UID, 35);
		end
	end
end

if (EVENT == 125) then
	QuestStatus = GetQuestStatus(UID, 275)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 275, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 275, 142, NPC, 21, 126);
		else
			SelectMsg(UID, 4, 275, 142, NPC, 41, 127, 23, -1);
		end
	end
end

if (EVENT == 126) then
	ShowMap(UID, 607);
end

if (EVENT == 127) then
	QuestStatus = GetQuestStatus(UID, 275)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 275, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 275, 142, NPC, 21, 126);
		else
			RunQuestExchange(UID, 4);
			SaveEvent(UID, 34);
		end
	end
end

if (EVENT == 130) then
	SelectMsg(UID, 4, 276, 152, NPC, 22, 131, 23, -1);
end

if (EVENT == 131) then
	QuestStatus = GetQuestStatus(UID, 276)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
			SaveEvent(UID, 43);
	end
end

if (EVENT == 134) then
	QuestStatus = GetQuestStatus(UID, 276)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 276, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 276, 152, NPC, 21, 136);
		else
			SaveEvent(UID, 69);
		end
	end
end

if (EVENT == 135) then
	QuestStatus = GetQuestStatus(UID, 276)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 276, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 276, 152, NPC, 21, 136);
		else
			SelectMsg(UID, 4, 276, 152, NPC, 41, 137, 23, -1);
		end
	end
end

if (EVENT == 136) then
	ShowMap(UID, 84);
end

if (EVENT == 137) then
	QuestStatus = GetQuestStatus(UID, 276)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 276, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 276, 152, NPC, 21, 136);
		else
			RunQuestExchange(UID, 9);
			SaveEvent(UID, 44);
		end
	end
end

if (EVENT == 140) then
	SelectMsg(UID, 4, 277, 171, NPC, 22, 141, 23, -1);
end

if (EVENT == 141) then
	QuestStatus = GetQuestStatus(UID, 277)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
			SaveEvent(UID, 84);
	end
end

if (EVENT == 144) then
	QuestStatus = GetQuestStatus(UID, 277)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 277, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 277, 171, NPC, 21, 146);
		else
			SaveEvent(UID, 86);
		end
	end
end

if (EVENT == 145) then
	QuestStatus = GetQuestStatus(UID, 277)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 277, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 277, 171, NPC, 21, 146);
		else
			SelectMsg(UID, 4, 277, 171, NPC, 41, 147, 23, -1);
		end
	end
end

if (EVENT == 146) then
	ShowMap(UID, 616);
end

if (EVENT == 147) then
	QuestStatus = GetQuestStatus(UID, 277)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 277, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 277, 171, NPC, 21, 146);
		else
			RunQuestExchange(UID, 10);
			SaveEvent(UID, 85);
		end
	end
end

if (EVENT == 150) then
	SelectMsg(UID, 4, 985, 194, NPC, 22, 151, 23, -1);
end

-- Unsupported EVENT branch is retained in the review copy.


-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 155) then
	QuestStatus = GetQuestStatus(UID, 985)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 985, 1);
		if (MonsterCount < 120) then
			SelectMsg(UID, 2, 985, 142, NPC, 21, 156);
		else
			SelectMsg(UID, 4, 985, 142, NPC, 41, 157, 23, -1);
		end
	end
end

if (EVENT == 156) then
	ShowMap(UID, 618);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 170) then
	SelectMsg(UID, 4, 1015, 971, NPC, 22, 171, 23, -1);
end

-- Unsupported EVENT branch is retained in the review copy.


-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 175) then
	QuestStatus = GetQuestStatus(UID, 1015)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 1015, 1);
		if (MonsterCount < 100) then
			SelectMsg(UID, 2, 1015, 142, NPC, 21, 176);
		else
			SelectMsg(UID, 4, 1015, 142, NPC, 41, 177, 23, -1);
		end
	end
end

if (EVENT == 176) then
	ShowMap(UID, 130);
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 160) then
	SelectMsg(UID, 4, 278, 964, NPC, 22, 161, 23, -1);
end

if (EVENT == 161) then
	QuestStatus = GetQuestStatus(UID, 278)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
			SaveEvent(UID, 9992);
	end
end

if (EVENT == 164) then
	QuestStatus = GetQuestStatus(UID, 278)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 278, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 278, 964, NPC, 21, 166);
		else
			SaveEvent(UID, 7738);
		end
	end
end

if (EVENT == 165) then
	QuestStatus = GetQuestStatus(UID, 278)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 278, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 278, 964, NPC, 21, 166);
		else
			SelectMsg(UID, 4, 278, 964, NPC, 41, 167, 23, -1);
		end
	end
end

if (EVENT == 166) then
	ShowMap(UID, 128);
end

if (EVENT == 167) then
	QuestStatus = GetQuestStatus(UID, 278)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 278, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 278, 964, NPC, 21, 166);
		else
			RunQuestExchange(UID, 109);
			SaveEvent(UID, 7737);
		end
	end
end

if (EVENT == 1102) then
	SelectMsg(UID, 4, 523, 20015, NPC, 22, 1103, 27, -1);
end

if (EVENT == 1103) then
	SaveEvent(UID, 11116);
end

if (EVENT == 1104) then
	SelectMsg(UID, 4, 523, 20177, NPC, 22, 1105, 27, -1);
	SaveEvent(UID, 11118);
end

if (EVENT == 1105) then
	SaveEvent(UID, 11117);
	SaveEvent(UID, 11128);
end

if (EVENT == 1202) then
	SelectMsg(UID, 4, 524, 20017, NPC, 22, 1203, 27, -1);
end

if (EVENT == 1203) then
	QuestStatus = GetQuestStatus(UID, 524)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
			SaveEvent(UID, 11128);
	end
end

if (EVENT == 1206) then
	QuestStatus = GetQuestStatus(UID, 524)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 524, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 524, 20017, NPC, 18, 1208);
		else
			SaveEvent(UID, 11130);
		end
	end
end

if (EVENT == 1205) then
	QuestStatus = GetQuestStatus(UID, 524)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 524, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 524, 20017, NPC, 18, 1208);
		else
			SelectMsg(UID, 5, 524, 20017, NPC, 41, 1207,23, -1);
		end
	end
end

if (EVENT == 1208) then
	ShowMap(UID, 1181);
end

if (EVENT == 1207)then
	QuestStatus = GetQuestStatus(UID, 524)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 524, 1);
		if (MonsterCount < 20) then
			SelectMsg(UID, 2, 524, 20017, NPC, 18, 1208);
		else
			RunQuestExchange(UID,3011,STEP,1);
			SaveEvent(UID, 11129);
			SaveEvent(UID, 11140);
		end
	end
end

if (EVENT == 1302) then
	SelectMsg(UID, 4, 529, 20027, NPC, 22, 1303, 27, -1);
end

if (EVENT == 1303) then
	QuestStatus = GetQuestStatus(UID, 529)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
			SaveEvent(UID, 11188);
	end
end

if (EVENT == 1308) then
	QuestStatus = GetQuestStatus(UID, 529)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 910215000);   
		if (ITEM_COUNT < 1) then
			SelectMsg(UID, 2, 529, 20027, NPC, 18,-1);
		else
			SaveEvent(UID, 11190);
		end
	end
end

if (EVENT == 1305) then
	QuestStatus = GetQuestStatus(UID, 529)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 910215000);   
		if (ITEM_COUNT < 1) then
			SelectMsg(UID, 2, 529, 20027, NPC, 18,-1);
		else
			SelectMsg(UID, 4, 529, 20027, NPC, 22, 1307,27, -1);
		end
	end
end

if (EVENT == 1307)then
	RunQuestExchange(UID,3016);
	SaveEvent(UID,11189);
	SaveEvent(UID,11200);
end

if (EVENT == 1402) then
	SelectMsg(UID, 4, 530, 20029, NPC, 22, 1403, 27, -1);
end

if (EVENT == 1403) then
	QuestStatus = GetQuestStatus(UID, 530)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
			SaveEvent(UID, 11200);
	end
end

if (EVENT == 1408) then
	QuestStatus = GetQuestStatus(UID, 530)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 508105000);   
		if (ITEM_COUNT < 5) then
			SelectMsg(UID, 2, 530, 20029, NPC, 18,1406);
		else
			SaveEvent(UID, 11202);
		end
	end
end

if (EVENT == 1405) then
	QuestStatus = GetQuestStatus(UID, 530)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 508105000);   
		if (ITEM_COUNT < 5) then
			SelectMsg(UID, 2, 530, 20029, NPC, 18,1406);
		else
			SelectMsg(UID, 4, 530, 20029, NPC, 22, 1407,27, -1);
		end
	end
end

if (EVENT == 1406) then
	ShowMap(UID, 1177);
end

if (EVENT == 1407)then
	QuestStatus = GetQuestStatus(UID, 530)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 508105000);   
		if (ITEM_COUNT < 5) then
			SelectMsg(UID, 2, 530, 20029, NPC, 18,1406);
		else
			SelectMsg(UID, 2, 530, 20241, NPC, 10,-1);
			RunQuestExchange(UID,3017);
			SaveEvent(UID,11201);
			SaveEvent(UID,11218);
		end
	end
end

if (EVENT == 1502) then
	SelectMsg(UID, 4, 533, 20032, NPC, 22, 1503, 27, -1);
end

if (EVENT == 1503) then
	QuestStatus = GetQuestStatus(UID, 533)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
			SaveEvent(UID, 11236);
	end
end

if (EVENT == 1508) then
	QuestStatus = GetQuestStatus(UID, 533)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 910216000);   
		if (ITEM_COUNT < 1) then
			SelectMsg(UID, 2, 533, 20032, NPC, 18,-1);
		else
			SaveEvent(UID, 11238);
		end
	end
end

if (EVENT == 1505) then
	QuestStatus = GetQuestStatus(UID, 533)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 910216000);   
		if (ITEM_COUNT < 1) then
			SelectMsg(UID, 2, 533, 20032, NPC, 18,-1);
		else
			SelectMsg(UID, 4, 533, 20032, NPC, 22, 1507,27, -1);
		end
	end
end

if (EVENT == 1507)then
	QuestStatus = GetQuestStatus(UID, 533)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 910216000);   
		if (ITEM_COUNT < 1) then
			SelectMsg(UID, 2, 533, 20032, NPC, 18,-1);
		else
			RunQuestExchange(UID,3020);
			SaveEvent(UID,11237);
			SaveEvent(UID,11248);
		end
	end
end

if (EVENT == 1602) then
	SelectMsg(UID, 4, 534, 20037, NPC, 22, 1603, 27, -1);
end

if (EVENT == 1603) then
	QuestStatus = GetQuestStatus(UID, 534)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
			SaveEvent(UID, 11248);
	end
end

if (EVENT == 1606) then
	QuestStatus = GetQuestStatus(UID, 534)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 534, 1);
		if (MonsterCount < 30) then
			SelectMsg(UID, 2, 534, 20037, NPC, 18, -1);
		else
			SaveEvent(UID, 11250);
		end
	end
end

if (EVENT == 1605) then
	QuestStatus = GetQuestStatus(UID, 534)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 534, 1);
		if (MonsterCount < 30) then
			SelectMsg(UID, 2, 534, 20037, NPC, 18, -1);
		else
			SelectMsg(UID, 5, 534, 20037, NPC, 41, 1608,23, -1);
		end
	end
end

if (EVENT == 1608)then
	QuestStatus = GetQuestStatus(UID, 534)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 165, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 534, 1);
		if (MonsterCount < 30) then
			SelectMsg(UID, 2, 534, 20037, NPC, 18, -1);
		else
			RunQuestExchange(UID,3021,STEP,1);
			SaveEvent(UID, 11249);
			SaveEvent(UID, 11260);
		end
	end
end

if (EVENT == 1705) then
	CHERICHERO = HowmuchItem(UID, 910229000);
	if (CHERICHERO < 1) then
		SelectMsg(UID, 2, 551, 21624, NPC, 10, -1);
	else
		SelectMsg(UID, 4, 551, 20066, NPC, 10, 1709, 27, -1);
	end
end

if (EVENT == 1709) then
	RELICHERO = HowmuchItem(UID, 910229000);
	if (RELICHERO < 1) then
		SelectMsg(UID, 2, 551, 21624, NPC, 10, -1);
	else
	RunQuestExchange(UID,3041);
	SaveEvent(UID, 11483);
	SaveEvent(UID, 11494);
    end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=274 status=2 n_index=23
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 274)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3);
		SaveEvent(UID, 25);
	end
end

-- [AUTO-GEN] quest=274 status=255 n_index=17
if (EVENT == 110) then
	SaveEvent(UID, 18);
end

-- [AUTO-GEN] quest=523 status=2 n_index=11117
if (EVENT == 193) then
	QuestStatusCheck = GetQuestStatus(UID, 523)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3010);
		SaveEvent(UID, 11119);
	end
end

-- [AUTO-GEN] quest=523 status=255 n_index=11114
if (EVENT == 1100) then
	SaveEvent(UID, 11115);
end

-- [AUTO-GEN] quest=524 status=255 n_index=11126
if (EVENT == 1200) then
	SaveEvent(UID, 11127);
end

-- [AUTO-GEN] quest=529 status=255 n_index=11186
if (EVENT == 1300) then
	SaveEvent(UID, 11187);
end

-- [AUTO-GEN] quest=530 status=255 n_index=11198
if (EVENT == 1400) then
	SaveEvent(UID, 11199);
end

-- [AUTO-GEN] quest=533 status=255 n_index=11234
if (EVENT == 1500) then
	SaveEvent(UID, 11235);
end

-- [AUTO-GEN] quest=534 status=255 n_index=11246
if (EVENT == 1600) then
	SaveEvent(UID, 11247);
end

-- [AUTO-GEN] quest=551 status=255 n_index=11480
if (EVENT == 1700) then
	SaveEvent(UID, 11481);
end

-- [AUTO-GEN] quest=551 status=0 n_index=11481
if (EVENT == 1702) then
	SelectMsg(UID, 4, 551, 20070, NPC, 3070, 1703, 23, -1);
end

-- [AUTO-GEN] quest=551 status=0 n_index=11481
if (EVENT == 1703) then
	SaveEvent(UID, 11482);
end

-- [AUTO-GEN] quest=551 status=1 n_index=11482
if (EVENT == 1708) then
	QuestStatusCheck = GetQuestStatus(UID, 551)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3041);
		SaveEvent(UID, 11483);
	end
end

-- [AUTO-GEN] quest=572 status=255 n_index=11731
if (EVENT == 1800) then
	SaveEvent(UID, 11732);
end

-- [AUTO-GEN] quest=572 status=0 n_index=11732
if (EVENT == 1802) then
	SelectMsg(UID, 4, 572, 20112, NPC, 3112, 1803, 23, -1);
end

-- [AUTO-GEN] quest=572 status=1 n_index=11733
if (EVENT == 1803) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 572, 20112, NPC, 18, 1805);
	else
		SelectMsg(UID, 4, 572, 20112, NPC, 41, 1804, 27, -1);
	end
end

-- [AUTO-GEN] quest=572 status=1 n_index=11733
if (EVENT == 1804) then
	QuestStatusCheck = GetQuestStatus(UID, 572)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3062);
		SaveEvent(UID, 11734);
	end
end

-- [AUTO-GEN] quest=572 status=3 n_index=11735
if (EVENT == 1805) then
	SelectMsg(UID, 2, 572, 20112, NPC, 10, -1);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
