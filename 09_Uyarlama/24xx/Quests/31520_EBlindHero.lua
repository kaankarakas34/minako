-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [3034]={},
  [3035]={{508108000,5}},
  [3036]={{508108000,5}},
  [3037]={{508108000,5}},
  [3038]={{508108000,5}},
  [3039]={{910228000,1}},
  [3044]={},
}
local __KO_Completion = {
  [11411]={547,3034},
  [11438]={548,3035},
  [11443]={548,3036},
  [11448]={548,3037},
  [11453]={548,3038},
  [11465]={549,3039},
  [11525]={554,3044},
}
local __KO_Quests = {
  [3034]={547},
  [3035]={548},
  [3036]={548},
  [3037]={548},
  [3038]={548},
  [3039]={549},
  [3044]={554},
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
local NPC = 31520;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 9148, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 9148, NPC)
	else
		EVENT = QuestNum
	end
end

if(EVENT == 1000)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11409);
end
end

if(EVENT == 1005)then
	SelectMsg(UID, 4, 547, 10144, NPC, 10, 1002,27,-1);
	SaveEvent(UID, 11412);
end

if(EVENT == 1003)then
NATION = CheckNation(UID);
if(NATION == 2)then
SelectMsg(UID, 2, 547, 10144, NPC, 10, 1005);
end
ItemCount0 = HowmuchItem(UID,900012000);
if(NATION == 2)then
if(ItemCount0 < 0)then
SelectMsg(UID, 2, 547, 10146, NPC, 10, -1);
else
SelectMsg(UID, 2, 547, 10144, NPC, 10, 1005);
end
end
end

if(EVENT == 1002)then
NATION = CheckNation(UID);
if(NATION == 2)then
	SaveEvent(UID, 11411);
	SaveEvent(UID, 11437);
end
end
if(EVENT == 1100)then
NATION = CheckNation(UID);
ClassCheck = CheckClass(UID)
if(NATION == 2 and ClassCheck == 1 or ClassCheck == 5 or ClassCheck == 6 or ClassCheck == 13 or ClassCheck == 14 or ClassCheck == 15)then
SaveEvent(UID, 11436);
end
ClassCheck = CheckClass(UID)
if(NATION == 2 and ClassCheck == 2 or ClassCheck == 7 or ClassCheck == 8)then
SaveEvent(UID, 11441);
end
ClassCheck = CheckClass(UID)
if(NATION == 2 and ClassCheck == 3 or ClassCheck == 9 or ClassCheck == 10)then
SaveEvent(UID, 11446);
end
ClassCheck = CheckClass(UID)
if(NATION == 2 and ClassCheck == 4 or ClassCheck == 11 or ClassCheck == 12)then
SaveEvent(UID, 11451);
end
end
if(EVENT == 1102)then
NATION = CheckNation(UID);
ClassCheck = CheckClass (UID);
if(NATION == 2 and ClassCheck == 1 or ClassCheck == 5 or ClassCheck == 6 or ClassCheck == 13 or ClassCheck == 14 or ClassCheck == 15)then
SaveEvent(UID, 11437);
end
ClassCheck = CheckClass (UID);
if(NATION == 2 and ClassCheck == 2 or ClassCheck == 7 or ClassCheck == 8)then
SaveEvent(UID, 11442);
end
ClassCheck = CheckClass (UID);
if(NATION == 2 and ClassCheck == 3 or ClassCheck == 9 or ClassCheck == 10)then
SaveEvent(UID, 11447);
end
ClassCheck = CheckClass (UID);
if(NATION == 2 and ClassCheck == 4 or ClassCheck == 11 or ClassCheck == 12)then
SaveEvent(UID, 11452);
end
end
if(EVENT == 1101)then
NATION = CheckNation(UID);
ClassCheck = CheckClass (UID);
if (NATION == 2 and ClassCheck == 1 or ClassCheck == 5 or ClassCheck == 6 or ClassCheck == 13 or ClassCheck == 14 or ClassCheck == 15) then
SelectMsg(UID, 4, 548, 10146, NPC, 22, 1102, 23, -1);
end
ClassCheck = CheckClass (UID);
if(NATION == 2 and ClassCheck == 2 or ClassCheck == 7 or ClassCheck == 8)then
SelectMsg(UID, 4, 548, 10146, NPC, 22, 1102, 23, -1);
end
ClassCheck = CheckClass (UID);
if(NATION == 2 and ClassCheck == 3 or ClassCheck == 9 or ClassCheck == 10)then
SelectMsg(UID, 4, 548, 10146, NPC, 22, 1102, 23, -1);
end
ClassCheck = CheckClass (UID);
if(NATION == 2 and ClassCheck == 4 or ClassCheck == 11 or ClassCheck == 12)then
SelectMsg(UID, 4, 548, 10146, NPC, 22, 1102, 23, -1);
end
end

if (EVENT == 1105) then
	RELICHERO = HowmuchItem(UID, 508108000);
	if (RELICHERO < 5 ) then
	SelectMsg(UID, 2, -1, 10147, NPC, 10, -1)
	else
		Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SelectMsg(UID, 5, 548, 10148, NPC, 4006, 880, 4005, -1);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SelectMsg(UID, 5, 548, 10148, NPC, 4006, 881, 4005, -1);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SelectMsg(UID, 5, 548, 10148, NPC, 4006, 882, 4005, -1);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SelectMsg(UID, 5, 548, 10148, NPC, 4006, 883, 4005, -1);
    end
end
end

if (EVENT == 880) then
	RELICHERO = HowmuchItem(UID, 508108000);
	SlotCheck = CheckGiveSlot(UID, 3)
	if SlotCheck == false then
	elseif (RELICHERO < 5) then
		SelectMsg(UID, 2, 548, 10189, NPC, 10, -1);
	else
	RunExchange(UID,3035); 
	RobItem(UID, 508108000, 5);
	SaveEvent(UID, 11438);
	SaveEvent(UID, 11464);
    end
end


if (EVENT == 881) then
	RELICHERO = HowmuchItem(UID, 508108000);
	SlotCheck = CheckGiveSlot(UID, 3)
	if SlotCheck == false then
	elseif (RELICHERO < 5) then
		SelectMsg(UID, 2, 548, 10189, NPC, 10, -1);
	else
	RunExchange(UID,3036);
	RobItem(UID, 508108000, 5);
	SaveEvent(UID, 11443);
	SaveEvent(UID, 11464);
    end
end


if (EVENT == 882) then
	RELICHERO = HowmuchItem(UID, 508108000);
	SlotCheck = CheckGiveSlot(UID, 3)
	if SlotCheck == false then
	elseif (RELICHERO < 5) then
		SelectMsg(UID, 2, 548, 10189, NPC, 10, -1);
	else
		RunExchange(UID,3037);
		RobItem(UID, 508108000, 5);
		SaveEvent(UID, 11448);
		SaveEvent(UID, 11464);
    end
end


if (EVENT == 883) then
	RELICHERO = HowmuchItem(UID, 508108000);
	SlotCheck = CheckGiveSlot(UID, 3)
	if SlotCheck == false then
	elseif (RELICHERO < 5) then
		SelectMsg(UID, 2, 548, 10189, NPC, 10, -1);
	else
	RunExchange(UID,3038);
	RobItem(UID, 508108000, 5);
	SaveEvent(UID, 11453);
	SaveEvent(UID, 11464);
    end
end


if(EVENT == 1104)then
NATION = CheckNation(UID);
ClassCheck = CheckClass (UID);
if(NATION == 2 and ClassCheck == 1 or ClassCheck == 5 or ClassCheck == 6 or ClassCheck == 13 or ClassCheck == 14 or ClassCheck == 15)then
SaveEvent(UID, 11439);
end
ClassCheck = CheckClass (UID);
if(NATION == 2 and ClassCheck == 2 or ClassCheck == 7 or ClassCheck == 8)then
SaveEvent(UID, 11444);
end
ClassCheck = CheckClass (UID);
if(NATION == 2 and ClassCheck == 3 or ClassCheck == 9 or ClassCheck == 10)then
SaveEvent(UID, 11449);
end
ClassCheck = CheckClass (UID);
if(NATION == 2 and ClassCheck == 4 or ClassCheck == 11 or ClassCheck == 12)then
SaveEvent(UID, 11454);
end
end
if(EVENT == 1200)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11463);
end
end
if(EVENT == 1202)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11464);
end
end
if(EVENT == 1201)then
NATION = CheckNation(UID);
if(NATION == 2)then
SelectMsg(UID, 4, 549, 10145, NPC, 22, 1202, 23, -1);
end
end

if (EVENT == 1205) then
	EXHALSPRIT = HowmuchItem(UID, 910228000);
	if (EXHALSPRIT < 1 ) then
		SelectMsg(UID, 2, 549, 10147, NPC, 10, -1);
	else
		SelectMsg(UID, 5, 549, 10189, NPC, 10, 1208, 27,-1);
	end
end

if (EVENT == 1208) then
	EXHALSPRIT = HowmuchItem(UID, 910228000);
	SlotCheck = CheckGiveSlot(UID, 1)
	if SlotCheck == false then
		SelectMsg(UID, 2, 549, 10189, NPC, 10, -1);
	else
	RunExchange(UID,3039);
	RobItem(UID, 910228000, 1);
	SaveEvent(UID, 11465);
	SaveEvent(UID, 11476);
	SaveEvent(UID, 11478);
    end
end

if(EVENT == 1204)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11466);
	end
end
if(EVENT == 1300)then
	NATION = CheckNation(UID);
if(NATION == 2)then
	SaveEvent(UID, 11523);
	end
end

if(EVENT == 1303)then
NATION = CheckNation(UID);
if(NATION == 2)then
SelectMsg(UID, 2, -1, 10150, NPC, 10, 1304);
	end
end

if(EVENT == 1304)then
NATION = CheckNation(UID);
if(NATION == 2)then
SelectMsg(UID, 4, 554, 10152, NPC, 10, 1002,27,-1);
SaveEvent(UID, 11526);
	end
end

if(EVENT == 1305)then
NATION = CheckNation(UID);
if(NATION == 2)then
	SlotCheck = CheckGiveSlot(UID, 1)
	if SlotCheck then
		GiveItem(UID, 910230000,1);
	end
	SelectMsg(UID, 4, 554, 10143, NPC, 10, -1);
SaveEvent(UID, 11525);
SaveEvent(UID, 11536);
SaveEvent(UID, 11538);
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=548 status=2 n_index=11438
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 548)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3035);
		SaveEvent(UID, 11440);
	end
end

-- [AUTO-GEN] quest=547 status=2 n_index=11411
if (EVENT == 193) then
	QuestStatusCheck = GetQuestStatus(UID, 547)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3034);
		SaveEvent(UID, 11413);
	end
end

-- [AUTO-GEN] quest=554 status=0 n_index=11523
if (EVENT == 1302) then
	SelectMsg(UID, 4, 554, 20077, NPC, 3077, 1303, 23, -1);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
