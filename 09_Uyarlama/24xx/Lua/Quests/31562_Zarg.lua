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
  [3150]={{900005000,665}},
  [3151]={{900005000,667}},
  [3152]={{900005000,669}},
  [3153]={{900005000,671}},
  [3154]={{900005000,673}},
  [13150]={{900005000,666}},
  [13151]={{900005000,668}},
  [13152]={{900005000,670}},
  [13153]={{900005000,672}},
  [13154]={{900005000,674}},
}
local __KO_Completion = {
  [12752]={663,3148},
  [12764]={664,3149},
  [12776]={665,3150},
  [12788]={667,3151},
  [12800]={669,3152},
  [12812]={671,3153},
  [12824]={673,3154},
}
local __KO_Quests = {
  [3148]={663},
  [3149]={664},
  [3150]={665},
  [3151]={667},
  [3152]={669},
  [3153]={671},
  [3154]={673},
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
local NPC = 31562;

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
	SelectMsg(UID, 2, 663, 21877, NPC, 10, 1002);
end

if (EVENT == 1002) then
SaveEvent(UID, 12751);
	SelectMsg(UID, 2, 663, 21878, NPC, 3000, 1003,3005,-1);
end

if (EVENT == 1003) then
	SelectMsg(UID, 4, 663, 21878, NPC, 3000, 1004,3005,-1);
	SaveEvent(UID, 12753);
end

if (EVENT == 1004) then
	SaveEvent(UID, 12752);
	SaveEvent(UID, 12763);
end

if (EVENT == 1101) then
	SelectMsg(UID, 4, 664, 21308, NPC, 22, 1102, 27, -1);
end

if (EVENT == 1102) then
	QuestStatus = GetQuestStatus(UID, 664)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
		SaveEvent(UID, 12763);
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
			SaveEvent(UID, 12765);
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
			SelectMsg(UID, 2, 664, 21891, NPC, 10,-1);
			RunExchange(UID,3149);
			SaveEvent(UID,12764);
			SaveEvent(UID,12781);
		end
	end
end


if (EVENT == 1201) then
	SelectMsg(UID, 4, 665, 21310, NPC, 22, 1202, 27, -1);
end


if (EVENT == 1202) then
	QuestStatus = GetQuestStatus(UID, 665)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12775);
	end
end

if (EVENT == 1206) then
	QuestStatus = GetQuestStatus(UID, 665)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 665, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 665, 21310, NPC, 18, 1207);
		else
			SaveEvent(UID, 12777);
		end
	end
end
	
if (EVENT == 1205) then
	QuestStatus = GetQuestStatus(UID, 665)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 665, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 665, 21310, NPC, 18, 1207);
		else
			SelectMsg(UID, 4, 665, 21310, NPC, 22, 1208, 23, -1);
		end
	end
end

if (EVENT == 1207) then
	ShowMap(UID, 545);
end

if (EVENT == 1208)then
	QuestStatus = GetQuestStatus(UID, 665)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 665, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 665, 21310, NPC, 18, 1207);
		else
			RunExchange(UID,13150);
			SaveEvent(UID,12776);
			SaveEvent(UID,12793);
		end
	end
end

if (EVENT == 1301) then
	SelectMsg(UID, 4, 667, 21312, NPC, 22, 1302, 27, -1);
end

if (EVENT == 1302) then
	QuestStatus = GetQuestStatus(UID, 667)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12787);
	end
end

if (EVENT == 1306) then
	QuestStatus = GetQuestStatus(UID, 667)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 667, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 667, 21312, NPC, 18, 1307);
		else
			SaveEvent(UID, 12789);
		end
	end
end

if (EVENT == 1305) then
	QuestStatus = GetQuestStatus(UID, 667)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 667, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 667, 21312, NPC, 18, 1307);
		else
			SelectMsg(UID, 4, 667, 21312, NPC, 22, 1308, 23, -1);
		end
	end
end

if (EVENT == 1307) then
	ShowMap(UID, 344);
end

if (EVENT == 1308)then
	QuestStatus = GetQuestStatus(UID, 667)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 667, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 667, 21312, NPC, 18, 1307);
		else
			SelectMsg(UID, 2, 667, 21918, NPC, 10, -1);
			RunExchange(UID,13151);
			SaveEvent(UID,12788);
			SaveEvent(UID,12799);
		end
	end
end

if (EVENT == 1401) then
	SelectMsg(UID, 4, 669, 21314, NPC, 22, 1402, 27, -1);
end

if (EVENT == 1402) then
	QuestStatus = GetQuestStatus(UID, 669)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12799);
	end
end

if (EVENT == 1406) then
	QuestStatus = GetQuestStatus(UID, 669)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 669, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 669, 21314, NPC, 18, 1407);
		else
			SaveEvent(UID, 12801);
		end
	end
end
	
if (EVENT == 1405) then
	QuestStatus = GetQuestStatus(UID, 669)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 669, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 669, 21314, NPC, 18, 1407);
		else
			SelectMsg(UID, 4, 669, 21314, NPC, 22, 1408, 23, -1);
		end
	end
end

if (EVENT == 1407) then
	ShowMap(UID, 827);
end

if (EVENT == 1408)then
	QuestStatus = GetQuestStatus(UID, 669)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 669, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 669, 21314, NPC, 18, 1407);
		else
			SelectMsg(UID, 2, 669, 21932, NPC, 10, -1);
			RunExchange(UID,13152);
			SaveEvent(UID,12800);
			SaveEvent(UID,12811);
		end
	end
end

if (EVENT == 1501) then
	SelectMsg(UID, 4, 671, 21316, NPC, 22, 1502, 27, -1);
end

if (EVENT == 1502) then
	QuestStatus = GetQuestStatus(UID, 671)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12811);
	end
end

if (EVENT == 1506) then
	QuestStatus = GetQuestStatus(UID, 671)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 671, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 671, 21316, NPC, 18, 1507);
		else
			SaveEvent(UID, 12813);
		end
	end
end
	
if (EVENT == 1505) then
	QuestStatus = GetQuestStatus(UID, 671)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 671, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 671, 21316, NPC, 18, 1507);
		else
			SelectMsg(UID, 4, 671, 21316, NPC, 22, 1508, 23, -1);
		end
	end
end

if (EVENT == 1507) then
	ShowMap(UID, 819);
end

if (EVENT == 1508)then
	QuestStatus = GetQuestStatus(UID, 671)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 671, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 671, 21316, NPC, 18, 1507);
		else
			RunExchange(UID,13153);
			SaveEvent(UID,12812);
			SaveEvent(UID,12823);
		end
	end
end

if (EVENT == 1601) then
	SelectMsg(UID, 4, 673, 21318, NPC, 22, 1602, 27, -1);
end

if (EVENT == 1602) then
	QuestStatus = GetQuestStatus(UID, 673)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 12823);
	end
end

if (EVENT == 1606) then
	QuestStatus = GetQuestStatus(UID, 673)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 673, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 673, 21318, NPC, 18, 1607);
		else
			SaveEvent(UID, 12825);
		end
	end
end
	
if (EVENT == 1605) then
	QuestStatus = GetQuestStatus(UID, 673)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 673, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 673, 21318, NPC, 18, 1607);
		else
			SelectMsg(UID, 4, 673, 21318, NPC, 22, 1608, 23, -1);
		end
	end
end

if (EVENT == 1607) then
	ShowMap(UID, 681);
end

if (EVENT == 1608)then
	QuestStatus = GetQuestStatus(UID, 673)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	MonsterCount = CountMonsterQuestSub(UID, 673, 1);
		if (MonsterCount < 50) then
			SelectMsg(UID, 2, 673, 21318, NPC, 18, 1607);
		else
			SelectMsg(UID, 2, 673, 21959, NPC, 10, -1);
			RunExchange(UID,13154);
			SaveEvent(UID,12824);
		end
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=663 status=2 n_index=12752
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 663)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3148);
		SaveEvent(UID, 12754);
	end
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
