-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6000]={{810418000,2}},
  [6001]={{810418000,2}},
  [6002]={{900005000,1202}},
  [6003]={{900600000,1},{900601000,1},{900603000,1},{900604000,1}},
}
local __KO_Completion = {
  [7311]={1200,6000},
  [7318]={1201,6001},
  [7325]={1202,6002},
  [7331]={1203,6003},
  [7364]={1209,0},
}
local __KO_Quests = {
  [6000]={1200},
  [6001]={1201},
  [6002]={1202},
  [6003]={1203},
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
local NPC = 25000;

if (EVENT == 200) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 43647, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 43647, NPC)
	else
		EVENT = QuestNum
	end
end

if(EVENT == 102) then 
	SelectMsg(UID, 4, 1200, 43611, NPC, 22, 106, 23, -1);
end

if(EVENT == 106) then
	QuestStatus = GetQuestStatus(UID, 1200)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43612, NPC, 10, -1);
		else
			SaveEvent(UID, 7310);
	end
end

if(EVENT == 107) then
	QuestStatus = GetQuestStatus(UID, 1200)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43612, NPC, 10, -1);
		else
	CountA = HowmuchItem(UID, 810418000)
		if( CountA < 2) then
			SelectMsg(UID, 2, 1200, 43623, NPC, 18, 108);
		else
			SaveEvent(UID, 7312);
		end
	end
end

if(EVENT == 105) then
	QuestStatus = GetQuestStatus(UID, 1200)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43612, NPC, 10, -1);
		else
	CountA = HowmuchItem(UID, 810418000)
		if( CountA < 2) then
			SelectMsg(UID, 2, 1200, 43623, NPC, 18, 108);
		else
			SelectMsg(UID, 4, 1200, 43624, NPC, 41, 110, 27, -1);
		end
	end
end

if(EVENT == 108) then
	ShowMap(UID, 1);
end

if(EVENT == 110) then
	QuestStatus = GetQuestStatus(UID, 1200)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43612, NPC, 10, -1);
		else
	CountA = HowmuchItem(UID, 810418000)
		if( CountA < 2) then
			SelectMsg(UID, 2, 1200, 43623, NPC, 18, 108);
		else
			RunExchange(UID,6000);
			SaveEvent(UID, 7311);
		end
	end
end

if(EVENT == 112) then
	SelectMsg(UID, 4, 1201, 43611, NPC, 22, 114, 23, -1);
end

if(EVENT == 114) then
	QuestStatus = GetQuestStatus(UID, 1201)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43612, NPC, 10, -1);
		else
			SaveEvent(UID, 7317);
	end
end

if(EVENT == 117) then
	QuestStatus = GetQuestStatus(UID, 1201)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43612, NPC, 10, -1);
		else
	CountA = HowmuchItem(UID, 810418000)
		if( CountA < 2) then
			SelectMsg(UID, 2, 1201, 43623, NPC, 18, 118);
		else
			SaveEvent(UID, 7319);
		end
	end
end

if(EVENT == 115) then
	QuestStatus = GetQuestStatus(UID, 1201)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43612, NPC, 10, -1);
		else
	CountA = HowmuchItem(UID, 810418000)
		if( CountA < 2) then
			SelectMsg(UID, 2, 1201, 43623, NPC, 18, 118);
		else
			SelectMsg(UID, 4, 1201, 43624, NPC, 41, 120, 27, -1);
		end
	end
end

if (EVENT == 118 ) then
	ShowMap(UID, 2)
end

if(EVENT == 120) then
	QuestStatus = GetQuestStatus(UID, 1201)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43612, NPC, 10, -1);
		else
	CountA = HowmuchItem(UID, 810418000)
		if( CountA < 2) then
			SelectMsg(UID, 2, 1201, 43623, NPC, 18, 118);
		else
			RunExchange(UID, 6001);
			SaveEvent(UID, 7318);
		end
	end
end

if(EVENT == 122) then
	SelectMsg(UID, 4, 1202, 43611, NPC, 22, 124, 23, -1);
end

if(EVENT == 124) then
	QuestStatus = GetQuestStatus(UID, 1202)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43612, NPC, 10, -1);
		else
			SaveEvent(UID, 7324);
	end
end

if(EVENT == 128) then
	QuestStatus = GetQuestStatus(UID, 1202)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43612, NPC, 10, -1);
		else
	MonsterCount  = CountMonsterQuestSub(UID, 1202, 1);
		if (MonsterCount < 5) then
			SelectMsg(UID, 2, 1202, 43623, NPC, 18, 129);
		else
			SaveEvent(UID, 7326);
		end
	end
end

if(EVENT == 125) then
	MonsterCount  = CountMonsterQuestSub(UID, 1202, 1);
		if (MonsterCount < 5) then
			SelectMsg(UID, 2, 1202, 43623, NPC, 18, 129);
		else
			SelectMsg(UID, 4, 1202, 43624, NPC, 41, 130, 27, -1);
	end
end

if(EVENT == 129) then
	ShowMap(UID, 2)
end

if(EVENT == 130) then
	QuestStatus = GetQuestStatus(UID, 1202)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 43612, NPC, 10, -1);
		else
			RunExchange(UID, 6002);
			SaveEvent(UID, 7325);
	end
end

if(EVENT == 132) then
SelectMsg(UID, 2, 1203, 43627, NPC, 40147, 133);
end

if(EVENT == 133) then
	SelectMsg(UID, 4, 1203, 43627, NPC, 22, 134, 23, -1);
end

if(EVENT == 134) then	
SaveEvent(UID, 7330);
SaveEvent(UID, 7335);
SaveEvent(UID, 7340);
end

if(EVENT == 137) then
SaveEvent(UID, 7332)
end

if (EVENT == 135) then
	ITEM1_COUNT = HowmuchItem(UID, 900600000);
    ITEM2_COUNT = HowmuchItem(UID, 900601000);
    ITEM3_COUNT = HowmuchItem(UID, 900603000);
    ITEM4_COUNT = HowmuchItem(UID, 900604000);
	if (ITEM1_COUNT > 0 and ITEM2_COUNT > 0 and ITEM3_COUNT > 0 and ITEM4_COUNT > 0) then
	SelectMsg(UID, 4, 1203, 43627, NPC, 41, 141, 27, -1);
	else
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 1203, 43627, NPC, 18, 136);
		elseif (ITEM2_COUNT < 1) then
			SelectMsg(UID, 2, 1203, 43627, NPC, 18, 138);
		elseif (ITEM3_COUNT < 1) then
			SelectMsg(UID, 2, 1203, 43627, NPC, 18, 139);
		elseif (ITEM4_COUNT < 1) then
			SelectMsg(UID, 2, 1203, 43627, NPC, 18, 140);
		end
	end
end

if (EVENT == 136) then
	ShowMap(UID, 4);
end
if (EVENT == 138) then
	ShowMap(UID, 5);
end
if (EVENT == 139) then
	ShowMap(UID, 2);
end
if (EVENT == 140) then
	ShowMap(UID, 3);
end

if(EVENT == 141) then
	ITEM1_COUNT = HowmuchItem(UID, 900600000);
    ITEM2_COUNT = HowmuchItem(UID, 900601000);
    ITEM3_COUNT = HowmuchItem(UID, 900603000);
    ITEM4_COUNT = HowmuchItem(UID, 900604000);
		if (ITEM1_COUNT < 1) then
			SelectMsg(UID, 2, 1203, 43627, NPC, 18, 136);
		elseif (ITEM2_COUNT < 1) then
			SelectMsg(UID, 2, 1203, 43627, NPC, 18, 138);
		elseif (ITEM3_COUNT < 1) then
			SelectMsg(UID, 2, 1203, 43627, NPC, 18, 139);
		elseif (ITEM4_COUNT < 1) then
			SelectMsg(UID, 2, 1203, 43627, NPC, 18, 140);
		else
			RunExchange(UID, 6003);
			SaveEvent(UID, 7331);
	end
end

if(EVENT == 142) then
	SelectMsg(UID, 2, 1209, 43647, NPC, 40150, 143);
end

if(EVENT == 143) then
	SelectMsg(UID, 2, 1209, 43648, NPC, 22, 144,23,-1);
end

if(EVENT == 144) then
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
			GiveItem(UID, 900599000, 1);
		    SaveEvent(UID, 7364);
		 	SaveEvent(UID, 7368);
			SelectMsg(UID, 2, 1209, 43675, NPC, 10, -1);
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=1200 status=255 n_index=7307
if (EVENT == 100) then
	SearchQuest(UID, 25000);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
