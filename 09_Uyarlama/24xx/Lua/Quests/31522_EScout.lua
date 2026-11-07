-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [3048]={},
  [3049]={{900005000,559}},
  [3050]={{900005000,560}},
  [3051]={{900005000,561}},
}
local __KO_Completion = {
  [11573]={558,3048},
  [11585]={559,3049},
  [11597]={560,3050},
  [11609]={561,3051},
}
local __KO_Quests = {
  [3048]={558},
  [3049]={559},
  [3050]={560},
  [3051]={561},
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
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 100 or EVENT == 1105 or EVENT == 1205 or EVENT == 1305 then
  SelectMsg(UID, 2, -1, 10526, 31522, 10, -1)
  return
end
local NPC = 31522;
if(EVENT == 1000)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11571);
end
end
if(EVENT == 1003)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11572);
end
ItemCount0 = HowmuchItem(UID,900012000);
if(NATION == 2)then
if(ItemCount0 < 0)then
SelectMsg(UID, 2, 558, 192, 31522, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
else
SelectMsg(UID, 4, 558, 20085, 31522, 10, 4, 27, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end
end
if(EVENT == 1002)then
NATION = CheckNation(UID);
if(NATION == 2)then
SelectMsg(UID, 4, 558, 20085, 31522, 22, 1003, 23, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end
if(EVENT == 1100)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11583);
end
end
if(EVENT == 1103)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11584);
end
end
if(EVENT == 1102)then
NATION = CheckNation(UID);
if(NATION == 2)then
SelectMsg(UID, 4, 559, 20087, 31522, 22, 1103, 23, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end
-- Unsupported EVENT branch is retained in the review copy.

if(EVENT == 1110)then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
NATION = CheckNation(UID);
if(NATION == 2)then
Check = CheckGiveSlot(UID, 3049);
if(Check == 1)then
RunExchange(UID, 3049);
SaveEvent(UID, 11585);
end
end
end
end
if(EVENT == 1106)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11586);
end
end
if(EVENT == 1200)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11595);
end
end
if(EVENT == 1203)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11596);
end
end
if(EVENT == 1202)then
NATION = CheckNation(UID);
if(NATION == 2)then
SelectMsg(UID, 4, 560, 20089, 31522, 22, 1203, 23, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end
-- Unsupported EVENT branch is retained in the review copy.

if(EVENT == 1210)then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
NATION = CheckNation(UID);
if(NATION == 2)then
Check = CheckGiveSlot(UID, 3050);
if(Check == 1)then
RunExchange(UID, 3050);
SaveEvent(UID, 11597);
end
end
end
end
if(EVENT == 1206)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11598);
end
end
if(EVENT == 1300)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11607);
end
end
if(EVENT == 1303)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11608);
end
end
if(EVENT == 1302)then
NATION = CheckNation(UID);
if(NATION == 2)then
SelectMsg(UID, 4, 561, 20091, 31522, 22, 1303, 23, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end
-- Unsupported EVENT branch is retained in the review copy.

if(EVENT == 1310)then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
NATION = CheckNation(UID);
if(NATION == 2)then
Check = CheckGiveSlot(UID, 3051);
if(Check == 1)then
RunExchange(UID, 3051);
SaveEvent(UID, 11609);
end
end
end
end
if(EVENT == 1306)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11610);
end
end


-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=558 status=2 n_index=11573
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 558)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3048);
		SaveEvent(UID, 11575);
	end
end

-- [AUTO-GEN] quest=558 status=1 n_index=11572
if (EVENT == 1004) then
	QuestStatusCheck = GetQuestStatus(UID, 558)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3048);
		SaveEvent(UID, 11573);
	end
end

-- [AUTO-GEN] quest=558 status=3 n_index=11574
if (EVENT == 1005) then
	SelectMsg(UID, 2, 558, 20085, NPC, 10, -1);
end

-- [AUTO-GEN] quest=559 status=1 n_index=11584
if (EVENT == 1105) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 559, 20087, NPC, 22, 1106, 23, -1);
	else
		SelectMsg(UID, 2, 559, 20087, NPC, 18, 1106);
	end
end

-- [AUTO-GEN] quest=560 status=1 n_index=11596
if (EVENT == 1205) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 560, 20089, NPC, 22, 1206, 23, -1);
	else
		SelectMsg(UID, 2, 560, 20089, NPC, 18, 1206);
	end
end

-- [AUTO-GEN] quest=561 status=1 n_index=11608
if (EVENT == 1305) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 561, 20091, NPC, 22, 1306, 23, -1);
	else
		SelectMsg(UID, 2, 561, 20091, NPC, 18, 1306);
	end
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
