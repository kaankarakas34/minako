-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [541]={{379273000,3}},
  [542]={{379274000,3}},
  [543]={{379272000,3}},
  [544]={{810418000,3}},
  [545]={{379275000,3}},
  [546]={{810418000,10}},
  [547]={{379277000,7}},
  [548]={{379276000,3}},
  [549]={{379272000,7}},
  [3000]={},
  [3007]={{910210000,1}},
  [3008]={{910211000,1},{910212000,1},{910213000,1}},
  [6161]={{810494000,5}},
  [6162]={{810495000,20}},
  [6163]={{810496000,15}},
  [6164]={{810497000,3}},
}
local __KO_Completion = {
  [3960]={1373,6161},
  [3970]={1374,6162},
  [3980]={1375,6163},
  [3990]={1376,6164},
  [9862]={133,543},
  [9874]={136,544},
  [9886]={139,545},
  [9898]={142,546},
  [9910]={145,547},
  [9922]={148,548},
  [9934]={151,549},
  [10008]={127,541},
  [10020]={130,542},
  [11003]={516,3000},
  [11081]={520,3007},
  [11093]={521,3008},
}
local __KO_Quests = {
  [541]={127},
  [542]={130},
  [543]={133},
  [544]={136},
  [545]={139},
  [546]={142},
  [547]={145},
  [548]={148},
  [549]={151},
  [3000]={516},
  [3007]={520},
  [3008]={521},
  [6161]={1373},
  [6162]={1374},
  [6163]={1375},
  [6164]={1376},
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
local NPC = 24435;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 217, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 8258, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 232) then
	SelectMsg(UID, 4, 127, 4931, NPC, 22, 233, 23, -1);
end

if (EVENT == 233) then
	QuestStatus = GetQuestStatus(UID, 127)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 10007);
	end
end

if (EVENT == 235) then
	QuestStatus = GetQuestStatus(UID, 127)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ANIMAL = HowmuchItem(UID, 379273000);
		if (ANIMAL < 3) then
			SelectMsg(UID, 2, 127, 4991, NPC, 19, 238);
		else
			SaveEvent(UID, 10009);
		end
	end
end

if (EVENT == 236) then
	QuestStatus = GetQuestStatus(UID, 127)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ANIMAL = HowmuchItem(UID, 379273000);
		if (ANIMAL < 3) then
			SelectMsg(UID, 2, 127, 4991, NPC, 19, 238);
		else
			SelectMsg(UID, 4, 127, 4998, NPC, 22, 237, 23, -1);
		end
	end
end

if (EVENT == 238) then
	ShowMap(UID, 95);
end

if (EVENT == 237) then
	QuestStatus = GetQuestStatus(UID, 127)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ANIMAL = HowmuchItem(UID, 379273000);
		if (ANIMAL < 3) then
			SelectMsg(UID, 2, 127, 4991, NPC, 19, 238);
		else
			RunExchange(UID,541);
			SaveEvent(UID, 10008);
		end
	end
end

if (EVENT == 242) then
	SelectMsg(UID, 4, 130, 575, NPC, 22, 243, 23, -1);
end

if (EVENT == 243) then
	QuestStatus = GetQuestStatus(UID, 130)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 10019);
	end
end

if (EVENT == 245) then
	QuestStatus = GetQuestStatus(UID, 130)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ROTTEN = HowmuchItem(UID, 379274000);
		if (ROTTEN < 3) then
			SelectMsg(UID, 2, 130, 788, NPC, 19, 248);
		else
			SaveEvent(UID, 10021);
		end
	end
end

if (EVENT == 246) then
	QuestStatus = GetQuestStatus(UID, 130)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ROTTEN = HowmuchItem(UID, 379274000);
		if (ROTTEN < 3) then
			SelectMsg(UID, 2, 130, 788, NPC, 19, 248);
		else
			SelectMsg(UID, 4, 130, 6106, NPC, 22, 247, 23, -1);
		end
	end
end

if (EVENT == 248) then
	ShowMap(UID, 97);
end

if (EVENT == 247) then
	QuestStatus = GetQuestStatus(UID, 130)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ROTTEN = HowmuchItem(UID, 379274000);
		if (ROTTEN < 3) then
			SelectMsg(UID, 2, 130, 788, NPC, 19, 248);
		else
			RunExchange(UID,542);
			SaveEvent(UID, 10020);
		end
	end
end

if (EVENT == 252) then
	SelectMsg(UID, 4, 133, 576, NPC, 22, 253, 23, -1);
end

if (EVENT == 253) then
	QuestStatus = GetQuestStatus(UID, 133)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 9861);
	end
end

if (EVENT == 255) then
	QuestStatus = GetQuestStatus(UID, 133)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	FEATHER = HowmuchItem(UID, 379272000);
		if (FEATHER < 3) then
			SelectMsg(UID, 2, 133, 6187, NPC, 19, 258);
		else
			SaveEvent(UID, 9863);
		end
	end
end

if (EVENT == 256) then
	QuestStatus = GetQuestStatus(UID, 133)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	FEATHER = HowmuchItem(UID, 379272000);
		if (FEATHER < 3) then
			SelectMsg(UID, 2, 133, 6187, NPC, 19, 258);
		else
			SelectMsg(UID, 4, 133, 6190, NPC, 22, 257, 23, -1);
		end
	end
end

if (EVENT == 258) then
	ShowMap(UID, 99);
end

if (EVENT == 257) then
	QuestStatus = GetQuestStatus(UID, 133)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	FEATHER = HowmuchItem(UID, 379272000);
		if (FEATHER < 3) then
			SelectMsg(UID, 2, 133, 6187, NPC, 19, 258);
		else
			RunExchange(UID,543);
			SaveEvent(UID, 9862);
		end
	end
end

if (EVENT == 262) then
	SelectMsg(UID, 4, 136, 586, NPC, 22, 263, 23, -1);
end

if (EVENT == 263) then
	QuestStatus = GetQuestStatus(UID, 136)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 9873);
	end
end

if (EVENT == 265) then
	QuestStatus = GetQuestStatus(UID, 136)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	SKULL = HowmuchItem(UID, 810418000);
		if (SKULL < 3) then
			SelectMsg(UID, 2, 136, 6127, NPC, 19, 268);
		else
			SaveEvent(UID, 9875);
		end
	end
end

if (EVENT == 266) then
	QuestStatus = GetQuestStatus(UID, 136)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	SKULL = HowmuchItem(UID, 810418000);
		if (SKULL < 3) then
			SelectMsg(UID, 2, 136, 6127, NPC, 19, 268);
		else
			SelectMsg(UID, 4, 136, 6128, NPC, 22, 267, 23, -1);
		end
	end
end

if (EVENT == 268) then
	ShowMap(UID, 101);
end

if (EVENT == 267) then
	QuestStatus = GetQuestStatus(UID, 136)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	SKULL = HowmuchItem(UID, 810418000);
		if (SKULL < 3) then
			SelectMsg(UID, 2, 136, 6127, NPC, 19, 268);
		else
			RunExchange(UID,544);
			SaveEvent(UID, 9874);
		end
	end
end

if (EVENT == 272) then
	SelectMsg(UID, 4, 139, 6139, NPC, 22, 273, 23, -1);
end

if (EVENT == 273) then
	QuestStatus = GetQuestStatus(UID, 139)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 9885);
	end
end

if (EVENT == 275) then
	QuestStatus = GetQuestStatus(UID, 139)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	COARSE = HowmuchItem(UID, 379275000);
		if (COARSE < 3) then
			SelectMsg(UID, 2, 139, 6141, NPC, 19, 278);
		else
			SaveEvent(UID, 9887);
		end
	end
end

if (EVENT == 276) then
	QuestStatus = GetQuestStatus(UID, 139)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	COARSE = HowmuchItem(UID, 379275000);
		if (COARSE < 3) then
			SelectMsg(UID, 2, 139, 6141, NPC, 19, 278);
		else
			SelectMsg(UID, 4, 139, 6142, NPC, 22, 277, 23, -1);
		end
	end
end

if (EVENT == 278) then
	ShowMap(UID, 103);
end

if (EVENT == 277) then
	QuestStatus = GetQuestStatus(UID, 139)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	COARSE = HowmuchItem(UID, 379275000);
		if (COARSE < 3) then
			SelectMsg(UID, 2, 139, 6141, NPC, 19, 278);
		else
			RunExchange(UID,545);
			SaveEvent(UID, 9886);
		end
	end
end

if (EVENT == 282) then
	SelectMsg(UID, 4, 142, 590, NPC, 22, 283, 23, -1);
end

if (EVENT == 283) then
	QuestStatus = GetQuestStatus(UID, 142)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 9897);
	end
end

if (EVENT == 285) then
	QuestStatus = GetQuestStatus(UID, 142)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	APPLE = HowmuchItem(UID, 810418000);
		if (APPLE < 10 ) then
			SelectMsg(UID, 2, 142, 6141, NPC, 19, 288);
		else
			SaveEvent(UID, 9899);
		end
	end
end

if (EVENT == 286) then
	QuestStatus = GetQuestStatus(UID, 142)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	APPLE = HowmuchItem(UID, 810418000);
		if (APPLE < 10 ) then
			SelectMsg(UID, 2, 142, 6141, NPC, 19, 288);
		else
			SelectMsg(UID, 4, 142, 6142, NPC, 22, 287, 23, -1);
		end
	end
end

if (EVENT == 288) then
	ShowMap(UID, 105);
end

if (EVENT == 287) then
	QuestStatus = GetQuestStatus(UID, 142)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	APPLE = HowmuchItem(UID, 810418000);
		if (APPLE < 10 ) then
			SelectMsg(UID, 2, 142, 6141, NPC, 19, 288);
		else
			RunExchange(UID,546);
			SaveEvent(UID, 9898);
		end
	end
end

if (EVENT == 292) then
	SelectMsg(UID, 4, 145, 6163, NPC, 22, 293, 23, -1);
end

if (EVENT == 293) then
	QuestStatus = GetQuestStatus(UID, 145)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 9909);
	end
end

if (EVENT == 295) then
	QuestStatus = GetQuestStatus(UID, 145)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ORK = HowmuchItem(UID, 379277000);
		if (ORK < 7) then
			SelectMsg(UID, 2, 145, 6163, NPC, 19, 298);
		else
			SaveEvent(UID, 9911);
		end
	end
end

if (EVENT == 296) then
	QuestStatus = GetQuestStatus(UID, 145)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ORK = HowmuchItem(UID, 379277000);
		if (ORK < 7) then
			SelectMsg(UID, 2, 145, 6163, NPC, 19, 298);
		else
			SelectMsg(UID, 4, 145, 6142, NPC, 22, 297, 23, -1);
		end
	end
end

if (EVENT == 298) then
	ShowMap(UID, 107);
end

if (EVENT == 297) then
	QuestStatus = GetQuestStatus(UID, 145)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ORK = HowmuchItem(UID, 379277000);
		if (ORK < 7) then
			SelectMsg(UID, 2, 145, 6163, NPC, 19, 298);
		else
			RunExchange(UID,547);
			SaveEvent(UID, 9910);
		end
	end
end

if (EVENT == 302) then
	SelectMsg(UID, 4, 148, 4932, NPC, 22, 303, 23, -1);
end

if (EVENT == 303) then
	QuestStatus = GetQuestStatus(UID, 148)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 9921);
	end
end

if (EVENT == 305) then
	QuestStatus = GetQuestStatus(UID, 148)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	OATH = HowmuchItem(UID, 379276000);
		if (OATH < 3) then
			SelectMsg(UID, 2, 148, 4932, NPC, 19, 308);
		else
			SaveEvent(UID, 9923);
		end
	end
end

if (EVENT == 306) then
	QuestStatus = GetQuestStatus(UID, 148)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	OATH = HowmuchItem(UID, 379276000);
		if (OATH < 3) then
			SelectMsg(UID, 2, 148, 4932, NPC, 19, 308);
		else
			SelectMsg(UID, 4, 148, 4934, NPC, 22, 307, 23, -1);
		end
	end
end

if (EVENT == 308) then
	ShowMap(UID, 109);
end

if (EVENT == 307) then
	QuestStatus = GetQuestStatus(UID, 148)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	OATH = HowmuchItem(UID, 379276000);
		if (OATH < 3) then
			SelectMsg(UID, 2, 148, 4932, NPC, 19, 308);
		else
			RunExchange(UID,548);
			SaveEvent(UID, 9922);
		end
	end
end

if (EVENT == 312) then
	SelectMsg(UID, 4, 151, 576, NPC, 22, 313, 23, -1);
end

if (EVENT == 313) then
	QuestStatus = GetQuestStatus(UID, 151)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 9933);
	end
end

if (EVENT == 315) then
	QuestStatus = GetQuestStatus(UID, 151)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	FEATHER = HowmuchItem(UID, 379272000);
		if (FEATHER < 7) then
			SelectMsg(UID, 2, 151, 6187, NPC, 19, 318);
		else
			SaveEvent(UID, 9935);
		end
	end
end

if (EVENT == 316) then
	QuestStatus = GetQuestStatus(UID, 151)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	FEATHER = HowmuchItem(UID, 379272000);
		if (FEATHER < 7) then
			SelectMsg(UID, 2, 151, 6187, NPC, 19, 318);
		else
			SelectMsg(UID, 4, 151, 6190, NPC, 22, 317, 23, -1);
		end
	end
end

if (EVENT == 318) then
	ShowMap(UID, 111);
end

if (EVENT == 317) then
	QuestStatus = GetQuestStatus(UID, 151)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	FEATHER = HowmuchItem(UID, 379272000);
		if (FEATHER < 7) then
			SelectMsg(UID, 2, 151, 6187, NPC, 19, 318);
		else
			RunExchange(UID,549);
			SaveEvent(UID, 9934);
		end
	end
end

if (EVENT == 500) then
	SelectMsg(UID, 4, 1373, 44200, NPC, 22, 501, 23, -1);
end

if (EVENT == 501) then
	QuestStatus = GetQuestStatus(UID, 1373)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
		SaveEvent(UID, 3959);
	end
end

if (EVENT == 506) then
	QuestStatus = GetQuestStatus(UID, 1373)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEMA  = HowmuchItem(UID, 810494000);
		if(ITEMA < 5) then
			SelectMsg(UID, 2, 1373, 44200, NPC, 10, 504);
		else
			SaveEvent(UID, 3961);
		end
	end
end

if (EVENT == 503) then
	QuestStatus = GetQuestStatus(UID, 1373)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEMA  = HowmuchItem(UID, 810494000);
		if(ITEMA > 4) then
			SelectMsg(UID, 4, 1373, 44200, NPC, 41, 505, 27, -1);
		else
			SelectMsg(UID, 2, 1373, 44200, NPC, 10, 504);
		end
	end
end

if (EVENT == 504) then
	ShowMap(UID, 587);
end

if (EVENT == 505) then
	QuestStatus = GetQuestStatus(UID, 1373)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEMA  = HowmuchItem(UID, 810494000);
		if(ITEMA < 5) then
			SelectMsg(UID, 2, 1373, 44200, NPC, 10, 504);
		else
			RunExchange(UID, 6161);
			SaveEvent(UID, 3960);
		end
	end
end

if (EVENT == 510) then
	SelectMsg(UID, 4, 1374, 44204, NPC, 22, 511, 23, -1);
end
	
if (EVENT == 511) then
	QuestStatus = GetQuestStatus(UID, 1374)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 3969);
	end
end

if (EVENT == 516) then
	QuestStatus = GetQuestStatus(UID, 1374)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEMA  = HowmuchItem(UID, 810495000);
		if(ITEMA < 20) then
			SelectMsg(UID, 2, 1374, 44204, NPC, 10, -1);
		else
			SaveEvent(UID, 3971);
		end
	end
end

if (EVENT == 513) then
	QuestStatus = GetQuestStatus(UID, 1374)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEMA  = HowmuchItem(UID, 810495000);
		if(ITEMA < 20) then
			SelectMsg(UID, 2, 1374, 44204, NPC, 10, -1);
		else
			SelectMsg(UID, 4, 1374, 44204, NPC, 41, 514, 27, -1);
		end
	end
end

if (EVENT == 514)then
	QuestStatus = GetQuestStatus(UID, 1374)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEMA  = HowmuchItem(UID, 810495000);
		if(ITEMA < 20) then
			SelectMsg(UID, 2, 1374, 44204, NPC, 10, -1);
		else
			RunExchange(UID, 6162);
			SaveEvent(UID,3970);
		end
	end
end



if (EVENT == 530) then
	SelectMsg(UID, 4, 1376, 44212, NPC, 22, 531, 23, -1);
end

if (EVENT == 531) then
	QuestStatus = GetQuestStatus(UID, 1376)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID, 3989);
	end
end

if (EVENT == 536) then
	QuestStatus = GetQuestStatus(UID, 1376)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEMA = HowmuchItem(UID, 810497000);
		if (ITEMA < 3) then
			SelectMsg(UID, 2, 1376, 44212, NPC, 19, -1);
		else
			SaveEvent(UID, 3991);
		end
	end
end

if (EVENT == 533) then
	QuestStatus = GetQuestStatus(UID, 1376)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEMA = HowmuchItem(UID, 810497000);
		if (ITEMA < 3) then
			SelectMsg(UID, 2, 1376, 44212, NPC, 19, -1);
		else
			SelectMsg(UID, 4, 1376, 44212, NPC, 22, 535, 23, -1);
		end
	end
end

if (EVENT == 535) then
	QuestStatus = GetQuestStatus(UID, 1376)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEMA = HowmuchItem(UID, 810497000);
		if (ITEMA < 3) then
			SelectMsg(UID, 2, 1376, 44212, NPC, 19, -1);
		else
			RunExchange(UID, 6164);
			SaveEvent(UID, 3990);
		end
	end
end

if (EVENT == 1002)then
	SelectMsg(UID, 2, 516, 20122, NPC, 4161, 1003);
end

if (EVENT == 1003)then
	SelectMsg(UID, 2, 516, 20123, NPC, 4552, 1004,6004,-1);
	SaveEvent(UID,11002);
end

if (EVENT == 1004)then
	SelectMsg(UID, 4, 516, 20124, NPC, 4161, 1005,3005,-1);
	SaveEvent(UID,11004);
end

if (EVENT == 1005) then 
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
	    SaveEvent(UID, 11003);
		SaveEvent(UID, 11035);
		SelectMsg(UID, 2, 516, 20207, NPC,6002, -1);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 11003);
		SaveEvent(UID, 11040);
		SelectMsg(UID, 2, 516, 20207, NPC,6002, -1);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 11003);
		SaveEvent(UID, 11045);
		SelectMsg(UID, 2, 516, 20207, NPC,6002, -1);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 11003);
		SaveEvent(UID, 11050);
		SelectMsg(UID, 2, 516, 20207, NPC,6002, -1);
	end
end

if (EVENT == 1101)then
	SelectMsg(UID, 4, 520, 20008, NPC, 22, 1102,23,-1);
end

if (EVENT == 1102)then
	QuestStatus = GetQuestStatus(UID, 520)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
			SaveEvent(UID,11080);
	end
end

if (EVENT == 1106)then
	QuestStatus = GetQuestStatus(UID, 520)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 910210000);   
		if (ITEM_COUNT < 1) then
			SelectMsg(UID, 2, 520, 20008, NPC, 18, -1);
		else
			SaveEvent(UID,11082);
		end
	end
end

if (EVENT == 1103) then
	QuestStatus = GetQuestStatus(UID, 520)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 910210000);   
		if (ITEM_COUNT < 1) then
			SelectMsg(UID, 2, 520, 20008, NPC, 18, -1);
		else
			SelectMsg(UID, 4, 520, 20008, NPC, 22, 1105, 27, -1); 
		end
	end
end

if (EVENT == 1105)then
	QuestStatus = GetQuestStatus(UID, 520)	
		if(QuestStatus == 2) then
			SelectMsg(UID, 2, -1, 44614, NPC, 10, -1);
		else
	ITEM_COUNT = HowmuchItem(UID, 910210000);   
		if (ITEM_COUNT < 1) then
			SelectMsg(UID, 2, 520, 20008, NPC, 18, -1);
		else
			RunExchange(UID,3007);
			SaveEvent(UID,11081);
			SaveEvent(UID,11092);
		end
	end
end

if (EVENT == 1201)then
	SelectMsg(UID, 4, 521, 20011, NPC, 22, 1202,23,-1);
end

if (EVENT == 1202)then
	SaveEvent(UID,11092);
end

if (EVENT == 1206)then
	SaveEvent(UID,11094);
end

if (EVENT == 1203) then
	SelectMsg(UID, 4, 521, 20011, NPC, 22, 1205, 27, -1); 
end

if (EVENT == 1205)then
RunExchange(UID,3008);
	SaveEvent(UID,11093);
	SaveEvent(UID,11104);
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=516 status=2 n_index=11003
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 516)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3000);
		SaveEvent(UID, 11005);
	end
end

-- [AUTO-GEN] quest=127 status=2 n_index=10008
if (EVENT == 165) then
	QuestStatusCheck = GetQuestStatus(UID, 127)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 541);
		SaveEvent(UID, 10010);
	end
end

-- [AUTO-GEN] quest=520 status=2 n_index=11081
if (EVENT == 196) then
	QuestStatusCheck = GetQuestStatus(UID, 520)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 3007);
		SaveEvent(UID, 11083);
	end
end

-- [AUTO-GEN] quest=127 status=255 n_index=10005
if (EVENT == 230) then
	SaveEvent(UID, 10006);
end

-- [AUTO-GEN] quest=130 status=255 n_index=10017
if (EVENT == 240) then
	SaveEvent(UID, 10018);
end

-- [AUTO-GEN] quest=133 status=255 n_index=9859
if (EVENT == 250) then
	SaveEvent(UID, 9860);
end

-- [AUTO-GEN] quest=136 status=255 n_index=9871
if (EVENT == 260) then
	SaveEvent(UID, 9872);
end

-- [AUTO-GEN] quest=139 status=255 n_index=9883
if (EVENT == 270) then
	SaveEvent(UID, 9884);
end

-- [AUTO-GEN] quest=142 status=255 n_index=9895
if (EVENT == 280) then
	SaveEvent(UID, 9896);
end

-- [AUTO-GEN] quest=145 status=255 n_index=9907
if (EVENT == 290) then
	SaveEvent(UID, 9908);
end

-- [AUTO-GEN] quest=148 status=255 n_index=9919
if (EVENT == 300) then
	SaveEvent(UID, 9920);
end

-- [AUTO-GEN] quest=151 status=255 n_index=9931
if (EVENT == 310) then
	SaveEvent(UID, 9932);
end

-- [AUTO-GEN] quest=1375 status=0 n_index=3978
if (EVENT == 520) then
	SelectMsg(UID, 4, 1375, 44208, NPC, 789, 521, 23, -1);
end

-- [AUTO-GEN] quest=1375 status=0 n_index=3978
if (EVENT == 521) then
	SaveEvent(UID, 3979);
end

-- [AUTO-GEN] quest=1375 status=1 n_index=3979
if (EVENT == 523) then
	ItemA = HowmuchItem(UID, 810496000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1375, 44208, NPC, 18, 524);
	else
		SelectMsg(UID, 4, 1375, 44208, NPC, 41, 526, 27, -1);
	end
end

-- [AUTO-GEN] quest=1375 status=1 n_index=3979
if (EVENT == 524) then
	ShowMap(UID, 1);
end

-- [AUTO-GEN] quest=1375 status=1 n_index=3979
if (EVENT == 526) then
	QuestStatusCheck = GetQuestStatus(UID, 1375)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6163);
		SaveEvent(UID, 3980);
	end
end

-- [AUTO-GEN] quest=516 status=255 n_index=11000
if (EVENT == 1000) then
	SaveEvent(UID, 11001);
end

-- [AUTO-GEN] quest=520 status=255 n_index=11078
if (EVENT == 1100) then
	SaveEvent(UID, 11079);
end

-- [AUTO-GEN] quest=521 status=255 n_index=11090
if (EVENT == 1200) then
	SaveEvent(UID, 11091);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
