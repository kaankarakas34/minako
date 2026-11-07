-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [3148]={},
  [3149]={{370004000,10},{168210003,1},{391010000,5000}},
  [13150]={{900005000,666}},
  [13151]={{900005000,668}},
  [13152]={{900005000,670}},
  [13153]={{900005000,672}},
  [13154]={{900005000,674}},
}
local __KO_Completion = {
  [12758]={663,3148},
  [12770]={664,3149},
  [12782]={666,13150},
  [12794]={668,13151},
  [12806]={670,13152},
  [12818]={672,13153},
  [12830]={674,13154},
}
local __KO_Quests = {
  [3148]={663},
  [3149]={664},
  [13150]={666},
  [13151]={668},
  [13152]={670},
  [13153]={672},
  [13154]={674},
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
local NPC = 31561;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 21310, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 21310, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 1001) then
	SelectMsg(UID, 2, 663, 21882, NPC, 10, 1002);
end

if (EVENT == 1002) then
SaveEvent(UID, 12757);
	SelectMsg(UID, 2, 663, 21883, NPC, 3000, 1003,3005,-1);
end

if (EVENT == 1003) then
	SelectMsg(UID, 4, 663, 21883, NPC, 3000, 1004,3005,-1);
	SaveEvent(UID, 12759);
end

if (EVENT == 1004) then
	SaveEvent(UID, 12758);
	SaveEvent(UID, 12769);
end

if (EVENT == 1101) then
	SelectMsg(UID, 4, 664, 21308, NPC, 22, 1102, 27, -1);
end

if (EVENT == 1102) then
	QuestStatus = GetQuestStatus(UID, 664)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
		SaveEvent(UID, 12769);
	end
end

if (EVENT == 1106) then
	QuestStatus = GetQuestStatus(UID, 664)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT1 = HowmuchItem(UID, 370004000);   
	ITEM1_COUNT2 = HowmuchItem(UID, 168210003); 
	ITEM1_COUNT3 = HowmuchItem(UID, 391010000); 
		if (ITEM1_COUNT1 < 10 and ITEM1_COUNT2 < 1 and ITEM1_COUNT3 < 5000) then
			SelectMsg(UID, 2, 664, 21308, NPC, 18,-1);
		else
			SaveEvent(UID, 12771);
		end
	end
end

if (EVENT == 1105) then
	QuestStatus = GetQuestStatus(UID, 664)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT1 = HowmuchItem(UID, 370004000);   
	ITEM1_COUNT2 = HowmuchItem(UID, 168210003); 
	ITEM1_COUNT3 = HowmuchItem(UID, 391010000); 
		if (ITEM1_COUNT1 < 10 and ITEM1_COUNT2 < 1 and ITEM1_COUNT3 < 5000) then
			SelectMsg(UID, 2, 664, 21308, NPC, 18,-1);
		else
			SelectMsg(UID, 4, 664, 21308, NPC, 22, 1107,27, -1);
		end
	end
end	

if (EVENT == 1107)then
	QuestStatus = GetQuestStatus(UID, 664)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM1_COUNT1 = HowmuchItem(UID, 370004000);   
	ITEM1_COUNT2 = HowmuchItem(UID, 168210003); 
	ITEM1_COUNT3 = HowmuchItem(UID, 391010000); 
		if (ITEM1_COUNT1 < 10 and ITEM1_COUNT2 < 1 and ITEM1_COUNT3 < 5000) then
			SelectMsg(UID, 2, 664, 21308, NPC, 18,-1);
		else
			SelectMsg(UID, 2, 664, 21897, NPC, 10,-1);
			RunExchange(UID,3149);
			SaveEvent(UID,12770);
			SaveEvent(UID,12781);
		end
	end
end


if (EVENT == 1201) then
	SelectMsg(UID, 4, 666, 21310, NPC, 22, 1202, 27, -1);
end

if (EVENT == 1202) then
	QuestStatus = GetQuestStatus(UID, 666)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12781);
	end
end

if (EVENT == 1206) then
	QuestStatus = GetQuestStatus(UID, 666)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 666, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 666, 21310, NPC, 18, 1207);
		else
			SaveEvent(UID, 12783);
		end
	end
end
	
if (EVENT == 1205) then
	QuestStatus = GetQuestStatus(UID, 666)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 666, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 666, 21310, NPC, 18, 1207);
		else
			SelectMsg(UID, 4, 666, 21310, NPC, 22, 1208, 23, -1);
		end
	end
end

if (EVENT == 1207) then
	ShowMap(UID, 27);
end

if (EVENT == 1208)then
	QuestStatus = GetQuestStatus(UID, 666)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 666, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 666, 21310, NPC, 18, 1207);
		else
			RunExchange(UID,13150);
			SaveEvent(UID,12782);
			SaveEvent(UID,12793);
		end
	end
end

if (EVENT == 1301) then
	SelectMsg(UID, 4, 668, 21312, NPC, 22, 1302, 27, -1);
end

if (EVENT == 1302) then
	QuestStatus = GetQuestStatus(UID, 668)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12793);
	end
end

if (EVENT == 1306) then
	QuestStatus = GetQuestStatus(UID, 668)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 668, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 668, 21312, NPC, 18, 1307);
		else
			SaveEvent(UID, 12795);
		end
	end
end

if (EVENT == 1305) then
	QuestStatus = GetQuestStatus(UID, 668)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 668, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 668, 21312, NPC, 18, 1307);
		else
			SelectMsg(UID, 4, 668, 21312, NPC, 22, 1308, 23, -1);
		end
	end
end

if (EVENT == 1307) then
	ShowMap(UID, 14);
end

if (EVENT == 1308)then
	QuestStatus = GetQuestStatus(UID, 668)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 668, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 668, 21312, NPC, 18, 1307);
		else
			SelectMsg(UID, 2, 668, 21925, NPC, 10, -1);
			RunExchange(UID,13151);
			SaveEvent(UID,12794);
			SaveEvent(UID,12805);
		end
	end
end

if (EVENT == 1401) then
	SelectMsg(UID, 4, 670, 21314, NPC, 22, 1402, 27, -1);
end

if (EVENT == 1402) then
	QuestStatus = GetQuestStatus(UID, 670)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12805);
	end
end

if (EVENT == 1406) then
	QuestStatus = GetQuestStatus(UID, 670)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 670, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 670, 21314, NPC, 18, 1407);
		else
			SaveEvent(UID, 12807);
		end
	end
end
	
if (EVENT == 1405) then
	QuestStatus = GetQuestStatus(UID, 670)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 670, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 670, 21314, NPC, 18, 1407);
		else
			SelectMsg(UID, 4, 670, 21314, NPC, 22, 1408, 23, -1);
		end
	end
end

if (EVENT == 1407) then
	ShowMap(UID, 828);
end

if (EVENT == 1408)then
	QuestStatus = GetQuestStatus(UID, 670)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 670, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 670, 21314, NPC, 18, 1407);
		else
			SelectMsg(UID, 2, 670, 21939, NPC, 10, -1);
			RunExchange(UID,13152);
			SaveEvent(UID,12806);
			SaveEvent(UID,12817);
		end
	end
end

if (EVENT == 1501) then
	SelectMsg(UID, 4, 672, 21316, NPC, 22, 1502, 27, -1);
end

if (EVENT == 1502) then
	QuestStatus = GetQuestStatus(UID, 672)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12817);
	end
end

if (EVENT == 1506) then
	QuestStatus = GetQuestStatus(UID, 672)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12819);
	end
end
	
if (EVENT == 1505) then
	QuestStatus = GetQuestStatus(UID, 672)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 672, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 672, 21316, NPC, 18, 1507);
		else
			SelectMsg(UID, 4, 672, 21316, NPC, 22, 1508, 23, -1);
		end
	end
end

if (EVENT == 1507) then
	ShowMap(UID, 820);
end

if (EVENT == 1508)then
	QuestStatus = GetQuestStatus(UID, 672)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 672, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 672, 21316, NPC, 18, 1507);
		else
			RunExchange(UID,13153);
			SaveEvent(UID,12818);
			SaveEvent(UID,12829);
		end
	end
end

if (EVENT == 1601) then
	SelectMsg(UID, 4, 674, 21318, NPC, 22, 1602, 27, -1);
end

if (EVENT == 1602) then
	QuestStatus = GetQuestStatus(UID, 674)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12829);
	end
end

if (EVENT == 1606) then
	QuestStatus = GetQuestStatus(UID, 674)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 674, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 674, 21318, NPC, 18, 1607);
		else
			SaveEvent(UID, 12831);
		end
	end
end
	
if (EVENT == 1605) then
	QuestStatus = GetQuestStatus(UID, 674)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 674, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 674, 21318, NPC, 18, 1607);
		else
			SelectMsg(UID, 4, 674, 21318, NPC, 22, 1608, 23, -1);
		end
	end
end

if (EVENT == 1607) then
	ShowMap(UID, 682);
end

if (EVENT == 1608)then
	QuestStatus = GetQuestStatus(UID, 674)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 674, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 674, 21318, NPC, 18, 1607);
		else
			SelectMsg(UID, 2, 674, 21965, NPC, 10, -1);
			RunExchange(UID,13154);
			SaveEvent(UID,12830);
		end
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=663 status=2 n_index=12758
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 663)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3148);
		SaveEvent(UID, 12760);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
