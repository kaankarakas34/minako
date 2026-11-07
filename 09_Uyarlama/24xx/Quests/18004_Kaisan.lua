-- Adapted for bundled GameServer SHA256 19e92a27...; source Orcun
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [460]={{900000000,3000}},
  [3098]={},
  [3099]={{910218000,1},{910242000,1},{910243000,1}},
  [3146]={{900194000,1}},
  [6005]={{810418000,20}},
}
local __KO_Completion = {
  [4063]={71,460},
  [7358]={1208,6005},
  [12167]={609,3098},
  [12179]={610,3099},
  [12734]={661,3146},
}
local __KO_Quests = {
  [460]={71},
  [3098]={609},
  [3099]={610},
  [3146]={661},
  [6005]={1208},
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
local NPC = 18004;

if (EVENT == 100) then
	NpcMsg(UID, 147, NPC)
end

if (EVENT == 403) then
	ITEM_COUNT = HowmuchItem(UID, 900000000);
		if (ITEM_COUNT < 3000) then
			SelectMsg(UID, 2, 71, 4065, NPC, 10, -1);
		else
	QuestStatusCheck = GetQuestStatus(UID, 71) 
		if(QuestStatusCheck == 1) then
			SaveEvent(UID, 4064);
			SelectMsg(UID, 2, 71, 4064, NPC, 4062, 404,4063,-1);
		else
		if(QuestStatusCheck == 3) then
			SelectMsg(UID, 2, 71, 4064, NPC, 4062, 404,4063,-1);
		else
			SaveEvent(UID, 4062);
			SaveEvent(UID, 4064);
			SelectMsg(UID, 2, 71, 4064, NPC, 4062, 404,4063,-1);
			end
		end
	end
end

if (EVENT == 404) then
	PromoteUserNovice(UID);
	GoldLose(UID, 3000);
	SaveEvent(UID, 4063);
end

if (EVENT == 407) then
	SelectMsg(UID, 2, -1, 4070, NPC, 4070, 408,10,-1);
end

if (EVENT == 408) then
	SendStatSkillDistribute(UID);
end

if (EVENT == 10000) then
	SelectMsg(UID, 19, 73, 1549, NPC, 10,10001);
end

if (EVENT == 10001) then
    SaveEvent(UID, 4070);
end

if (EVENT == 410) then
	SelectMsg(UID, 2, -1, 1522, NPC, 7014, 411,73,-1);
end

if (EVENT == 411) then
	SelectMsg(UID, 2, -1, 1533, NPC, 10, 412);
end

if (EVENT == 412) then
	SelectMsg(UID, 2, -1, 1534, NPC, 3000, 413,3005,-1);
end

if (EVENT == 413) then
	NTS = HowmuchItem(UID, 800360000);
		if NTS == 0 then
			SelectMsg(UID, 2, -1, 1532, NPC,10,-1);
		else
			RobItem(UID, 800360000, 1);
			GiveItem(UID, 810096000, 1,1);
   end
end

if (EVENT == 499) then
	SelectMsg(UID, 2, -1, 1546, NPC, 7012, 500,7013,505);
end

if (EVENT == 500) then
	SelectMsg(UID, 2, -1, 1532, NPC, 10, -1);
end

if (EVENT == 505) then
	SelectMsg(UID, 2, -1, 1532, NPC, 10, -1);
end

if (EVENT == 699) then
	NTS2 = HowmuchItem(UID, 810096000);
		if NTS2 == 0 then
			SelectMsg(UID, 2, -1, 1523, NPC, 18,5000);
		else
			SelectMsg(UID, 2, -1, 1524, NPC, 72, 700,73,-1);
	end
end

if (EVENT == 700) then
	NTS2 = HowmuchItem(UID, 810096000);
		if NTS2 == 0 then
			SelectMsg(UID, 2, -1, 1523, NPC,10,-1);
		else
			SendNationChange(UID);
	end
end	  

if (EVENT == 799) then
	SelectMsg(UID, 2, -1, 10745, NPC, 22,800,23,-1);
end

if (EVENT == 800) then
	SendRepurchase(UID);
end

if (EVENT == 200) then
	CLANCONT = HowmuchItem(UID, 810323000);   
		if (CLANCONT == 0) then
			SelectMsg(UID, 2, -1, 11644, NPC, 10,-1);
		else
			SelectMsg(UID, 2, -1, 11644, NPC, 7014, 201, 73, -1);
	end
end	

if (EVENT == 201) then
	SelectMsg(UID, 2, -1, 11644, NPC, 3000, 202, 73, -1);
end

if (EVENT == 202) then
	CLANCONT = HowmuchItem(UID, 810323000);   
		if (CLANCONT == 0) then
			SelectMsg(UID, 2, -1, 11644, NPC, 18,5000);
		else
	SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
			
        else
			RobItem(UID, 810323000, 1);
			GiveItem(UID, 810324000, 1,1);
		end
	end
end

if (EVENT == 302) then
	SelectMsg(UID, 2, 1208, 43642, NPC, 40148, 303);
end

if (EVENT == 303) then
	SelectMsg(UID, 4, 1208, 43643, NPC, 22, 304, 23, -1);
end

if (EVENT == 304) then
	SaveEvent(UID, 7357)
end

if(EVENT == 305) then
	CountA = HowmuchItem(UID, 810418000)
	if( CountA < 20) then
		SelectMsg(UID, 2, 1208, 43643, NPC, 18, 306);
	else
		SelectMsg(UID, 4, 1208, 43643, NPC, 41, 308, 27, -1);
	end
end

if (EVENT == 306 ) then
	ShowMap(UID, 2)
end

if (EVENT == 307) then
	SaveEvent(UID, 7359)
end

if(EVENT == 308) then
	QuestStatusCheck = GetQuestStatus(UID, 1208) 
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 187, NPC, 10, -1);
		else
	CountA = HowmuchItem(UID, 810418000)
		if( CountA < 20) then
			SelectMsg(UID, 2, 1208, 43643, NPC, 18, 306);
		else
			RunExchange(UID, 6005);
			SaveEvent(UID, 7358)
		end
	end
end

if (EVENT == 1201) then
	SelectMsg(UID, 4, 661, 21302, NPC, 22, 1202, 23, -1);
end

if (EVENT == 1202) then
	SaveEvent(UID, 12733);
end

if (EVENT == 1206) then
	SaveEvent(UID, 12735);
end

if (EVENT == 1205) then
	ITEM1_COUNT = HowmuchItem(UID, 900194000);   
	if (ITEM1_COUNT < 1) then
		SelectMsg(UID, 2, 661, 21302, NPC, 18,-1);
	else
		SelectMsg(UID, 4, 661, 21302, NPC, 22, 1207, 27, -1);
	end
end	

if (EVENT == 1207) then
	QuestStatusCheck = GetQuestStatus(UID, 661) 
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 187, NPC, 10, -1);
		else
			SelectMsg(UID, 2, 661, 21851, NPC, 10,-1);
			SaveEvent(UID,12734);
			SaveEvent(UID,12745);
			RunExchange(UID,3146);
	end
end

if (EVENT == 1000) then
	ShowMap(UID, 450);
	SelectMsg(UID, 8, -1, -1, NPC);	
end

if (EVENT == 1010) then
	SelectMsg(UID, 2, -1, 12144, NPC, 40206, 1011);
end

if (EVENT == 1011) then
	SelectMsg(UID, 2, -1, 12145, NPC, 3000, 1012,3005,-1);
end

if (EVENT == 1012) then
MONEY = HowmuchItem(UID, 900000000);
WARPRE = GetPremium(UID);
	if (WARPRE == 12 or WARPRE == 13) then 
		SelectMsg(UID, 52, -1, -1, NPC);
	else
	if (MONEY >= 100000000) then
		SelectMsg(UID, 52, -1, -1, NPC);
	else
		SelectMsg(UID, 2, -1, 12147, NPC, 56,-1);
		end
	end
end

if (EVENT == 5000) then
	ShowMap(UID, 450);
end

-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=609 status=2 n_index=12167
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 609)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3098);
		SaveEvent(UID, 12169);
	end
end

-- [AUTO-GEN] quest=609 status=0 n_index=12165
if (EVENT == 1002) then
	SelectMsg(UID, 4, 609, 20786, NPC, 3184, 1003, 23, -1);
end

-- [AUTO-GEN] quest=609 status=1 n_index=12166
if (EVENT == 1003) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 609, 20786, NPC, 18, 1005);
	else
		SelectMsg(UID, 4, 609, 20786, NPC, 41, 1004, 27, -1);
	end
end

-- [AUTO-GEN] quest=609 status=1 n_index=12166
if (EVENT == 1004) then
	QuestStatusCheck = GetQuestStatus(UID, 609)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3098);
		SaveEvent(UID, 12167);
	end
end

-- [AUTO-GEN] quest=609 status=3 n_index=12168
if (EVENT == 1005) then
	SelectMsg(UID, 2, 609, 20786, NPC, 10, -1);
end

-- [AUTO-GEN] quest=71 status=2 n_index=4063
if (EVENT == 110) then
	QuestStatusCheck = GetQuestStatus(UID, 71)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 460);
		SaveEvent(UID, 4065);
	end
end

-- [AUTO-GEN] quest=71 status=255 n_index=4060
if (EVENT == 400) then
	SaveEvent(UID, 4061);
end

-- [AUTO-GEN] quest=1208 status=2 n_index=7358
if (EVENT == 191) then
	QuestStatusCheck = GetQuestStatus(UID, 1208)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6005);
		SaveEvent(UID, 7360);
	end
end

-- [AUTO-GEN] quest=1208 status=255 n_index=7355
if (EVENT == 300) then
	SaveEvent(UID, 7356);
end

-- [AUTO-GEN] quest=1380 status=0 n_index=4076
if (EVENT == 780) then
	SelectMsg(UID, 4, 1380, 116, NPC, 341, 781, 23, -1);
end

-- [AUTO-GEN] quest=1380 status=0 n_index=4076
if (EVENT == 781) then
	SaveEvent(UID, 4077);
end

-- [AUTO-GEN] quest=1380 status=1 n_index=4077
if (EVENT == 782) then
	ShowMap(UID, 4077);
end

-- [AUTO-GEN] quest=610 status=255 n_index=12176
if (EVENT == 1100) then
	SaveEvent(UID, 12177);
end

-- [AUTO-GEN] quest=610 status=0 n_index=12177
if (EVENT == 1102) then
	SelectMsg(UID, 4, 610, 20788, NPC, 3186, 1103, 23, -1);
end

-- [AUTO-GEN] quest=610 status=0 n_index=12177
if (EVENT == 1103) then
	SaveEvent(UID, 12178);
end

-- [AUTO-GEN] quest=610 status=1 n_index=12178
if (EVENT == 1105) then
	ItemA = HowmuchItem(UID, 910218000);
	if (ItemA < 1) then
		SelectMsg(UID, 2, 610, 20788, NPC, 18, 1106);
	else
		SelectMsg(UID, 4, 610, 20788, NPC, 41, 1106, 27, -1);
	end
end

-- [AUTO-GEN] quest=610 status=1 n_index=12178
if (EVENT == 1106) then
	QuestStatusCheck = GetQuestStatus(UID, 610)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3099);
		SaveEvent(UID, 12179);
	end
end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
