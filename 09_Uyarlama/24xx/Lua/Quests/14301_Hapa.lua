-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [56]={{810418000,2}},
  [60]={{910017000,3},{379076000,3},{900000000,1000}},
  [61]={{910017000,3},{379076000,3},{900000000,1000}},
  [62]={{910017000,3},{379076000,3},{900000000,1000}},
  [63]={{910017000,3},{379076000,3},{900000000,1000}},
  [64]={{810418000,3}},
  [65]={{379071000,7},{379076000,15},{900000000,500000}},
  [66]={{379071000,7},{379076000,15},{900000000,500000}},
  [67]={{379071000,7},{379076000,15},{900000000,500000}},
  [68]={{379071000,7},{379076000,15},{900000000,500000}},
  [69]={{379071000,5},{379076000,12},{900000000,500000}},
  [70]={{379071000,5},{379076000,12},{900000000,500000}},
  [71]={{379071000,5},{379076000,12},{900000000,500000}},
  [72]={{379071000,5},{379076000,12},{900000000,500000}},
  [73]={{379071000,4},{379076000,9},{900000000,500000}},
  [74]={{379071000,4},{379076000,9},{900000000,500000}},
  [75]={{379071000,4},{379076000,9},{900000000,500000}},
  [76]={{379071000,4},{379076000,9},{900000000,500000}},
  [77]={{379071000,3},{379076000,6},{900000000,500000}},
  [78]={{379071000,3},{379076000,6},{900000000,500000}},
  [79]={{379071000,3},{379076000,6},{900000000,500000}},
  [80]={{379071000,3},{379076000,6},{900000000,500000}},
  [81]={{379071000,3},{379076000,3},{900000000,500000}},
  [82]={{379071000,3},{379076000,3},{900000000,500000}},
  [83]={{379071000,3},{379076000,3},{900000000,500000}},
  [84]={{379071000,3},{379076000,3},{900000000,500000}},
  [100]={{203011337,1},{389075000,1},{379072000,5}},
  [102]={{243011338,1},{389075000,1},{379072000,5}},
  [104]={{263011339,1},{389075000,1},{379072000,5}},
  [106]={{283011340,1},{389075000,1},{379072000,5}},
  [108]={{810418000,2}},
  [405]={{110110002,1}},
  [406]={{110110002,1}},
  [407]={{110110002,1}},
  [408]={{110110002,1}},
  [601]={{379049000,5},{900000000,100000}},
  [602]={{379049000,5},{900000000,100000}},
  [603]={{379049000,5},{900000000,100000}},
  [604]={{379049000,5},{900000000,100000}},
  [605]={{379050000,5},{900000000,80000}},
  [606]={{379050000,5},{900000000,80000}},
  [607]={{379050000,5},{900000000,80000}},
  [608]={{379050000,5},{900000000,80000}},
  [609]={{379051000,5},{900000000,50000}},
  [610]={{379051000,5},{900000000,50000}},
  [611]={{379051000,5},{900000000,50000}},
  [612]={{379051000,5},{900000000,50000}},
  [613]={{379052000,5},{900000000,40000}},
  [614]={{379052000,5},{900000000,40000}},
  [615]={{379052000,5},{900000000,40000}},
  [616]={{379052000,5},{900000000,40000}},
  [617]={{379053000,5},{900000000,30000}},
  [618]={{379053000,5},{900000000,30000}},
  [619]={{379053000,5},{900000000,30000}},
  [620]={{379053000,5},{900000000,30000}},
}
local __KO_Completion = {
  [362]={81,56},
  [384]={89,60},
  [389]={89,61},
  [394]={89,62},
  [399]={89,63},
  [406]={94,64},
  [656]={93,108},
  [662]={68,405},
  [667]={68,406},
  [672]={68,407},
  [677]={68,408},
}
local __KO_Quests = {
  [56]={81},
  [60]={89},
  [61]={89},
  [62]={89},
  [63]={89},
  [64]={94},
  [108]={93},
  [405]={68},
  [406]={68},
  [407]={68},
  [408]={68},
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
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 554 or EVENT == 555 or EVENT == 559 or EVENT == 565 or EVENT == 1555 or EVENT == 1565 or EVENT == 1655 or EVENT == 1665 or EVENT == 1755 or EVENT == 1765 then
  SelectMsg(UID, 2, -1, 10526, 14301, 10, -1)
  return
end
local Ret = 0;
local NPC = 14301;

if (EVENT == 240) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 241, NPC, 10, 241);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 242, NPC)
	else
		EVENT = QuestNum
	end
end


if (EVENT == 241) then
	Ret = 1;
end

local savenum01 = 68;
local NATION = 0;

if (EVENT == 4009) then -- 9 Level Dagger +2
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, savenum01, 4018, NPC, 28, 4008);
	else
		SelectMsg(UID, 2, savenum01, 4019, NPC, 14, 4008);
	end
end

if (EVENT == 4008) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		ShowMap(UID, 8);
		SaveEvent(UID, 660);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		ShowMap(UID, 8);
		SaveEvent(UID, 665);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		ShowMap(UID, 8);
		SaveEvent(UID, 670);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		ShowMap(UID, 8);
		SaveEvent(UID, 675);
	end
end

if (EVENT == 4011) then
	SelectMsg(UID, 2, savenum01, 4020, NPC, 10, 4012);
end   

if (EVENT == 4012) then
	SelectMsg(UID, 4, savenum01, 4022, NPC, 22, 4013, 23, 4014);
end   

if (EVENT == 4013) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 661);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 666);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 671);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 676);
	end
end

if (EVENT == 4014) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 664);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 669);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 674);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 679);
	end
end
 
local NATION = 0;

if (EVENT == 4016) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 663);
		EVENT = 4017
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 668);
		EVENT = 4017
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 673);
		EVENT = 4017
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 678);
		EVENT = 4017
	end
end

if (EVENT == 4017) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, savenum01, 4026, NPC, 14, 241);
	else
		SelectMsg(UID, 2, savenum01, 4027, NPC, 14, 241);
	end
end

if (EVENT == 4020) then 
	ItemA = HowmuchItem(UID, 110110002);  
	if (ItemA < 1) then
		SelectMsg(UID, 2, savenum01, 4025, NPC, 18, 4021);
	else
		SelectMsg(UID, 5, savenum01, 4028, NPC, 22, 4025, 22, 4025, 22, 4025);
	end
end

if (EVENT == 4021) then
	ShowMap(UID, 349);
end

if (EVENT == 4025) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID,405)
		SaveEvent(UID, 662);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunExchange(UID,406)
		SaveEvent(UID, 667);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunExchange(UID,407)
		SaveEvent(UID, 672);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunExchange(UID,408)
		SaveEvent(UID, 677);
	end
end

local NATION = 0;

if (EVENT == 301) then -- 11 Level Kekoon Armor
	SaveEvent(UID, 360);
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, 81, 593, NPC, 28, 300);
	else
		SelectMsg(UID, 2, 81, 594, NPC, 14, 300);
	end
end

if (EVENT == 300) then
	ShowMap(UID, 8);
end

if (EVENT == 302) then
	SelectMsg(UID, 2, 81, 595, NPC, 10, 303);
end

if (EVENT == 303) then
	SelectMsg(UID, 4, 81, 596, NPC, 22, 304, 23, 241);
end   

if (EVENT == 304) then
	SaveEvent(UID, 361);
end

if (EVENT == 306) then
	SaveEvent(UID, 363);
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, 81, 597, NPC, 14, 241);
	else
		SelectMsg(UID, 2, 81, 598, NPC, 14, 241);
	end
end

if (EVENT == 308) then 
	ItemB = HowmuchItem(UID, 810418000);  
	if (ItemB < 2) then
		SelectMsg(UID, 2, 81, 600, NPC, 18, 310);
	else
		SelectMsg(UID, 5, 81, 601, NPC, 41, 309, 23, 241);
	end
end

if (EVENT == 310) then
	ShowMap(UID, 326);
end

if (EVENT == 309) then
RunExchange(UID,56)
	SaveEvent(UID, 362);   
end

if (EVENT == 313) then -- 16 Level Bulture Horn & Iron Bar
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, 89, 603, NPC, 28, 314);
	else
		SelectMsg(UID, 2, 89, 604, NPC, 14, 314);
	end
end

if (EVENT == 314) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		ShowMap(UID, 8);
		SaveEvent(UID, 382);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		ShowMap(UID, 8);
		SaveEvent(UID, 387);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		ShowMap(UID, 8);
		SaveEvent(UID, 392);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		ShowMap(UID, 8);
		SaveEvent(UID, 397);
	end
end

if (EVENT == 315) then
	SelectMsg(UID, 2, 89, 605, NPC, 10, 316);
end   

if (EVENT == 316) then
	SelectMsg(UID, 4, 89, 606, NPC, 22, 317, 23, 318);
end   

if (EVENT == 317) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 383);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 388);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 393);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 398);
	end
end

if (EVENT == 318) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 386);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 391);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 396);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 401);
	end
end

if (EVENT == 319) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 385);
		EVENT = 320
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 390);
		EVENT = 320
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 395);
		EVENT = 320
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 400);
		EVENT = 320
	end
end

if (EVENT == 320) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, 89, 607, NPC, 14, 241);
	else
		SelectMsg(UID, 2, 89, 608, NPC, 14, 241);
	end
end

if (EVENT == 321) then 
	ItemA = HowmuchItem(UID, 910017000);  
	ItemB = HowmuchItem(UID, 379076000);  
	ItemC = HowmuchItem(UID, 900000000);  
	if (ItemA < 3) then
		SelectMsg(UID, 2, 89, 609, NPC, 18, 323);
	end
	if (ItemB < 3) then
		SelectMsg(UID, 2, 89, 610, NPC, 18, 324);
	end
	if (ItemC < 1000) then
		SelectMsg(UID, 2, 89, 611, NPC, 18, 325);
	end
	if (ItemA > 2 and ItemB > 2 and ItemC > 999) then
		SelectMsg(UID, 5, 89, 612, NPC, 22, 322, 22, 322, 22, 322);
	end
end

if (EVENT == 323) then
	ShowMap(UID, 38);
end

if (EVENT == 324) then
	ShowMap(UID, 34);
end

if (EVENT == 325) then
	ShowMap(UID, 336);
end

if (EVENT == 322) then
	Class = CheckClass (UID);
	if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID,60)
		SaveEvent(UID, 384);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunExchange(UID,61)
		SaveEvent(UID, 389);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunExchange(UID,62)
		SaveEvent(UID, 394);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunExchange(UID,63)
		SaveEvent(UID, 399);
	end
end

if (EVENT == 470) then -- 17 Level Silan Bone
	SaveEvent(UID, 654);
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 1, 93, 1300, NPC, 56, 241);
	else
		SelectMsg(UID, 1, 93, 1301, NPC, 57, 241);
	end
end

if (EVENT == 471) then
	SelectMsg(UID, 2, 93, 1302, NPC, 6002, 472);
end   

if (EVENT == 472) then
	SelectMsg(UID, 4, 93, 1303, NPC, 22, 473, 23, 241);
end   

if (EVENT == 473) then
	SaveEvent(UID, 655);
end

if (EVENT == 483) then
	SaveEvent(UID, 657);
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, savenum, 1305, NPC, 14, 241);
	else
		SelectMsg(UID, 2, savenum, 1306, NPC, 14, 241);
	end
end

if (EVENT == 474) then 
	ItemA = HowmuchItem(UID, 810418000);  
	if (ItemA < 2) then
		SelectMsg(UID, 2, 93, 1304, NPC, 18, 475);
	else
		SelectMsg(UID, 4, 93, 1307, NPC, 50, 478, 23, 241);
	end
end

if (EVENT == 475) then
	ShowMap(UID, 60);
end
   
if (EVENT == 478) then
RunExchange(UID,108)
	SaveEvent(UID, 656);	 
end

local NATION = 0;

if (EVENT == 327) then -- 18 Level Fang of Wolf Man
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, 94, 614, NPC, 28, 328);
	else
		SelectMsg(UID, 2, 94, 615, NPC, 14, 328);
	end
end

if (EVENT == 328) then
	ShowMap(UID, 8);
	SaveEvent(UID, 404);
end

if (EVENT == 329) then
	SelectMsg(UID, 2, 94, 616, NPC, 10, 330);
end   

if (EVENT == 330) then
	SelectMsg(UID, 4, 94, 617, NPC, 22, 331, 23, 332);
end   

if (EVENT == 331) then
	SaveEvent(UID, 405);
end

if (EVENT == 332) then
	SaveEvent(UID, 408);
end

if (EVENT == 333) then
	SaveEvent(UID, 407);
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, 94, 618, NPC, 32, 241);
	else
		SelectMsg(UID, 2, 94, 619, NPC, 21, 241);
	end
end

if (EVENT == 335) then
	ITEM_COUNT = HowmuchItem(UID, 810418000);
	if (ITEM_COUNT < 3) then
		SelectMsg(UID, 2, 94, 620, NPC, 18, 336);
	else
		SelectMsg(UID, 4, 94, 621, NPC, 41, 337, 27, 241);
	end
end

if (EVENT == 336) then
	ShowMap(UID, 523);
end

if (EVENT == 337) then
    RunExchange(UID,64) 
	SaveEvent(UID, 406);
end

if EVENT == 338 then 
   Class = CheckClass (UID);
       if Class == 1 or Class == 5 or Class == 6 then
      SaveEvent(UID, 411);
       EVENT = 339
       elseif Class == 2 or Class == 7 or Class == 8 then
      SaveEvent(UID, 412);
       EVENT = 339
       elseif Class == 3 or Class == 9 or Class == 10 then
      SaveEvent(UID, 413);
       EVENT = 339
      elseif Class == 4 or Class == 11 or Class == 12 then
      SaveEvent(UID, 414);
       EVENT = 339
      end
end

if EVENT == 339 then
         
   NATION = CheckNation(UID);
   if NATION == 1 then 
   SelectMsg(UID, 1, 192, 623, NPC, 28, 241);
  else
   SelectMsg(UID, 1, 192, 624, NPC, 14, 241);
   end
end

if EVENT == 340 then
   SelectMsg(UID, 3, 192, 651, NPC, 36, 341, 37,  350 , 38, 356, 39, 363, 40, 370);
end

if EVENT == 341 then
   SelectMsg(UID, 4, 192, 651, NPC, 22, 343, 23, 241);
end

if EVENT == 350 then
   SelectMsg(UID, 4, 193, 631, NPC, 22, 351, 23, 241);
end

if EVENT == 356 then
   SelectMsg(UID, 4, 193, 636, NPC, 22, 357, 23, 241);
end

if EVENT == 363 then
   SelectMsg(UID, 4, 194, 641, NPC, 22, 364, 23, 241);
end

if EVENT == 370 then
   SelectMsg(UID, 4, 195, 646, NPC, 22, 371, 23, 241);
end

if EVENT == 343 then 
    ItemA = HowmuchItem(UID, 379071000);  
    ItemB = HowmuchItem(UID, 379076000);  
    ItemC = HowmuchItem(UID, 900000000); 
      if  (ItemA < 7)  then
       SelectMsg(UID, 2, 192, 627, NPC, 10, 241);
      end
      if (ItemB < 15)  then
       SelectMsg(UID, 2, 192, 628, NPC, 10, 241);
      end
      if (ItemC < 500000) then
       SelectMsg(UID, 2, 192, 629, NPC, 10, 241);
      end
      if  (ItemA > 7 and ItemB > 15 and ItemC > 500000)then
       SelectMsg(UID, 2, 192, 630, NPC, 22, 345, 23, 241);
      end
end
if EVENT == 345 then 
   Class = CheckClass (UID);
       if Class == 1 or Class == 5 or Class == 6 then
       RunExchange(UID,65)
       elseif Class == 2 or Class == 7 or Class == 8 then
       RunExchange(UID,66)
       elseif Class == 3 or Class == 9 or Class == 10 then
       RunExchange(UID,67)
      elseif Class == 4 or Class == 11 or Class == 12 then
       RunExchange(UID,68)
      end
end

if EVENT == 351 then 
    ItemA = HowmuchItem(UID, 379071000);  
    ItemB = HowmuchItem(UID, 379076000);  
    ItemC = HowmuchItem(UID, 900000000);  
      if  ItemA < 5  then
       SelectMsg(UID, 2, 193, 632, NPC, 10, 241);
      end
      if ItemB < 12  then
       SelectMsg(UID, 2, 193, 633, NPC, 10, 241);
      end
      if ItemC < 500000 then
       SelectMsg(UID, 2, 193, 634, NPC, 10, 241);
      end
      if  ItemA > 5 and ItemB > 12 and ItemC > 500000 then
       SelectMsg(UID, 2, 193, 635, NPC, 22, 390, 23, 241);
      end
end

if EVENT == 390 then 
   Class = CheckClass (UID);
       if Class == 1 or Class == 5 or Class == 6 then
       RunExchange(UID,69)
       elseif Class == 2 or Class == 7 or Class == 8 then
       RunExchange(UID,70)
       elseif Class == 3 or Class == 9 or Class == 10 then
       RunExchange(UID,71)
      elseif Class == 4 or Class == 11 or Class == 12 then
       RunExchange(UID,72)
      end
end

if EVENT == 357 then 
    ItemA = HowmuchItem(UID, 379071000);  
    ItemB = HowmuchItem(UID, 379076000);  
    ItemC = HowmuchItem(UID, 900000000);  
      if  ItemA < 4  then
       SelectMsg(UID, 2, 194, 637, NPC, 10, 241);
      end
      if ItemB < 9  then
       SelectMsg(UID, 2, 194, 638, NPC, 10, 241);
      end
      if ItemC < 500000 then
       SelectMsg(UID, 2, 194, 639, NPC, 10, 241);
      end
      if  ItemA >= 4 and ItemB >= 9 and ItemC >= 500000 then
       SelectMsg(UID, 2, 194, 640, NPC, 22, 358, 23, 241);
      end
end

if EVENT == 358 then 
   Class = CheckClass (UID);
       if Class == 1 or Class == 5 or Class == 6 then
       RunExchange(UID,73)
       elseif Class == 2 or Class == 7 or Class == 8 then
       RunExchange(UID,74)
       elseif Class == 3 or Class == 9 or Class == 10 then
       RunExchange(UID,75)
      elseif Class == 4 or Class == 11 or Class == 12 then
       RunExchange(UID,76)
      end
end

if EVENT == 364 then 
    ItemA = HowmuchItem(UID, 379071000);  
    ItemB = HowmuchItem(UID, 379076000);  
    ItemC = HowmuchItem(UID, 900000000);  
      if  ItemA < 3  then
       SelectMsg(UID, 2, 195, 642, NPC, 10, 241);
      end
      if ItemB < 6  then
       SelectMsg(UID, 2, 195, 643, NPC, 10, 241);
      end
      if ItemC < 500000 then
       SelectMsg(UID, 2, 195, 644, NPC, 10, 241);
      end
      if  ItemA >= 3 and ItemB >= 6 and ItemC >= 500000 then
       SelectMsg(UID, 2, 195, 645, NPC, 22, 365, 23, 241);
      end
end

if EVENT == 365 then 
   Class = CheckClass (UID);
       if Class == 1 or Class == 5 or Class == 6 then
       RunExchange(UID,77)
       elseif Class == 2 or Class == 7 or Class == 8 then
       RunExchange(UID,78)
       elseif Class == 3 or Class == 9 or Class == 10 then
       RunExchange(UID,79)
      elseif Class == 4 or Class == 11 or Class == 12 then
       RunExchange(UID,80)
      end
end

if EVENT == 371 then 
    ItemA = HowmuchItem(UID, 379071000);  
    ItemB = HowmuchItem(UID, 379076000);  
    ItemC = HowmuchItem(UID, 900000000);  
      if  ItemA < 3  then
       SelectMsg(UID, 2, 196, 647, NPC, 10, 241);
      end
      if ItemB < 3  then
       SelectMsg(UID, 2, 196, 648, NPC, 10, 241);
      end
      if ItemC < 500000 then
       SelectMsg(UID, 2, 196, 649, NPC, 10, 241);
      end
      if  ItemA >= 3 and ItemB >= 3 and ItemC >= 500000 then
       SelectMsg(UID, 2, 196, 650, NPC, 22, 391, 23, 241);
      end
end

if EVENT == 391 then 
   Class = CheckClass (UID);
       if Class == 1 or Class == 5 or Class == 6 then
       RunExchange(UID,81)
       elseif Class == 2 or Class == 7 or Class == 8 then
       RunExchange(UID,82)
       elseif Class == 3 or Class == 9 or Class == 10 then
       RunExchange(UID,83)
      elseif Class == 4 or Class == 11 or Class == 12 then
       RunExchange(UID,84)
      end
end


if EVENT == 400 then 
   Class = CheckClass (UID);
       if Class == 1 or Class == 5 or Class == 6 then
      SaveEvent(UID, 626);
       EVENT = 396
       elseif Class == 2 or Class == 7 or Class == 8 then
      SaveEvent(UID, 627);
       EVENT = 396
       elseif Class == 3 or Class == 9 or Class == 10 then
      SaveEvent(UID, 628);
       EVENT = 396
      elseif Class == 4 or Class == 11 or Class == 12 then
      SaveEvent(UID, 629);
       EVENT = 396
      end
end


if EVENT == 396 then
   NATION = CheckNation(UID);
   if NATION == 1 then 
   SelectMsg(UID, 1, 154, 1200, NPC, 28, 401);
  else 
   SelectMsg(UID, 1, 154, 1201, NPC, 14, 401);
   end
end

if EVENT == 401 then
   ShowMap(UID, 8);
end

if EVENT == 402 then
   SelectMsg(UID, 3, 154, 1202, NPC, 42, 403, 43,  411 , 44, 419, 45, 427, 46, 435);
end

if EVENT == 403 then
   SelectMsg(UID, 4, 154, 1203, NPC, 22, 404, 23, 241);
end

if EVENT == 411 then
   SelectMsg(UID, 4, 155, 1207, NPC, 22, 412, 23, 241);
end

if EVENT == 419 then
   SelectMsg(UID, 4, 156, 1211, NPC, 22, 420, 23, 241);
end

if EVENT == 427 then
   SelectMsg(UID, 4, 157, 1215, NPC, 22, 428, 23, 241);
end

if EVENT == 435 then
   SelectMsg(UID, 4, 158, 1219, NPC, 22, 436, 23, 241);
end

if EVENT == 404 then 
    ItemB = HowmuchItem(UID, 379049000);  
    ItemC = HowmuchItem(UID, 900000000);  
      if ItemB < 5  then
       SelectMsg(UID, 2, 154, 1204, NPC, 10, 241);
      end
      if ItemC < 100000 then
       SelectMsg(UID, 2, 154, 1205, NPC, 10, 241);
      end
      if ItemB >= 5 and ItemC >= 100000 then
       SelectMsg(UID, 2, 154, 1206, NPC, 22, 405, 23, 241);
      end
end

if EVENT == 412 then 

    ItemB = HowmuchItem(UID, 379050000);  
    ItemC = HowmuchItem(UID, 900000000);  
     if ItemB < 5  then
       SelectMsg(UID, 2, 155, 1208, NPC, 10, 241);
      end
      if ItemC < 80000 then
       SelectMsg(UID, 2, 155, 1209, NPC, 10, 241);
      end
      if ItemB >= 5 and ItemC >= 80000 then
       SelectMsg(UID, 2, 155, 1210, NPC, 22, 413, 23, 241);
      end
end

if EVENT == 420 then 
    ItemB = HowmuchItem(UID, 379051000);  
    ItemC = HowmuchItem(UID, 900000000);  
    if ItemB < 5  then
       SelectMsg(UID, 2, 156, 1212, NPC, 10, 241);
      end
      if ItemC < 50000 then
       SelectMsg(UID, 2, 156, 1213, NPC, 10, 241);
      end
      if ItemB >= 5 and ItemC >= 50000 then
       SelectMsg(UID, 2, 156, 1214, NPC, 22, 421, 23, 241);
      end
end

if EVENT == 428 then 
    ItemB = HowmuchItem(UID, 379052000);  
    ItemC = HowmuchItem(UID, 900000000);  
      if ItemB < 5  then
       SelectMsg(UID, 2, 157, 1216, NPC, 10, 241);
      end
      if ItemC < 40000 then
       SelectMsg(UID, 2, 157, 1217, NPC, 10, 241);
      end
      if ItemB >= 5 and ItemC >= 40000 then
       SelectMsg(UID, 2, 157, 1218, NPC, 22, 429, 23, 241);
      end
end

if EVENT == 436 then 
    ItemB = HowmuchItem(UID, 379053000);  
    ItemC = HowmuchItem(UID, 900000000);  
      if ItemB < 5  then
       SelectMsg(UID, 2, 158, 1220, NPC, 10, 241);
      end
      if ItemC < 30000 then
       SelectMsg(UID, 2, 158, 1221, NPC, 10, 241);
      end
      if ItemB >= 5 and ItemC >= 30000 then
       SelectMsg(UID, 2, 158, 1222, NPC, 22, 437, 23, 241);
      end
end

if EVENT == 405 then 
   Class = CheckClass (UID);
       if Class == 1 or Class == 5 or Class == 6 then
       RunExchange(UID,601)
       elseif Class == 2 or Class == 7 or Class == 8 then
       RunExchange(UID,602)
       elseif Class == 3 or Class == 9 or Class == 10 then
       RunExchange(UID,603)
      elseif Class == 4 or Class == 11 or Class == 12 then
       RunExchange(UID,604)
      end
end

if EVENT == 413 then 
   Class = CheckClass (UID);
       if Class == 1 or Class == 5 or Class == 6 then
       RunExchange(UID,605)
       elseif Class == 2 or Class == 7 or Class == 8 then
       RunExchange(UID,606)
       elseif Class == 3 or Class == 9 or Class == 10 then
       RunExchange(UID,607)
      elseif Class == 4 or Class == 11 or Class == 12 then
       RunExchange(UID,608)
      end
end

if EVENT == 421 then 
   Class = CheckClass (UID);
       if Class == 1 or Class == 5 or Class == 6 then
       RunExchange(UID,609)
       elseif Class == 2 or Class == 7 or Class == 8 then
       RunExchange(UID,610)
       elseif Class == 3 or Class == 9 or Class == 10 then
       RunExchange(UID,611)
      elseif Class == 4 or Class == 11 or Class == 12 then
       RunExchange(UID,612)
      end
end

if EVENT == 429 then 
   Class = CheckClass (UID);
       if Class == 1 or Class == 5 or Class == 6 then
       RunExchange(UID,613)
       elseif Class == 2 or Class == 7 or Class == 8 then
       RunExchange(UID,614)
       elseif Class == 3 or Class == 9 or Class == 10 then
       RunExchange(UID,615)
      elseif Class == 4 or Class == 11 or Class == 12 then
       RunExchange(UID,616)
      end
end

if EVENT == 437 then 
   Class = CheckClass (UID);
       if Class == 1 or Class == 5 or Class == 6 then
       RunExchange(UID,617)
       elseif Class == 2 or Class == 7 or Class == 8 then
       RunExchange(UID,618)
       elseif Class == 3 or Class == 9 or Class == 10 then
       RunExchange(UID,619)
      elseif Class == 4 or Class == 11 or Class == 12 then
       RunExchange(UID,620)
      end
end



if EVENT == 450 then
   Class = CheckClass (UID);
       if Class == 1 or Class == 5 or Class == 6 then
      SaveEvent(UID, 648);
       EVENT = 442
       elseif Class == 2 or Class == 7 or Class == 8 then
      SaveEvent(UID, 649);
       EVENT = 442
       elseif Class == 3 or Class == 9 or Class == 10 then
      SaveEvent(UID, 650);
       EVENT = 442
      elseif Class == 4 or Class == 11 or Class == 12 then
      SaveEvent(UID, 651)
       EVENT = 442
      end
end

if EVENT == 442 then
   NATION = CheckNation(UID);
   if NATION == 1 then 
   SelectMsg(UID, 1, 205, 1284, NPC, 56, 241);
  else 
   SelectMsg(UID, 1, 205, 1285, NPC, 57, 241);
   end
end

if EVENT == 451 then
   SelectMsg(UID, 4, 205, 1287, NPC, 22, 461, 23, 241);
end

if EVENT == 461 then
   Class = CheckClass (UID);
       if Class == 1 or Class == 5 or Class == 6 then
       EVENT = 453
       elseif Class == 2 or Class == 7 or Class == 8 then
       EVENT = 458
       elseif Class == 3 or Class == 9 or Class == 10 then
       EVENT = 459
      elseif Class == 4 or Class == 11 or Class == 12 then
       EVENT = 460
      end
end

if EVENT == 453 then 
    ItemA = HowmuchItem(UID, 203011337);  
    ItemB = HowmuchItem(UID, 379072000);  
    ItemC = HowmuchItem(UID, 389075000);  
      if  ItemA < 1  then
       SelectMsg(UID, 2, 205, 1288, NPC, 10, 241);
      end
      if ItemB < 5  then
       SelectMsg(UID, 2, 205, 1289, NPC, 10, 241);
      end
      if ItemC < 1 then
       SelectMsg(UID, 2, 205, 1290, NPC, 10, 241);
      end
      if  ItemA >= 1 and ItemB >= 5 and ItemC >= 1 then
       SelectMsg(UID, 2, 205, 1291, NPC, 50, 454, 23, 241);
      end
end

if EVENT == 454 then 
RunExchange(UID,100)
end

if EVENT == 458 then 
    ItemA = HowmuchItem(UID, 243011338);  
    ItemB = HowmuchItem(UID, 379072000);  
    ItemC = HowmuchItem(UID, 389075000);  
      if  ItemA < 1  then
       SelectMsg(UID, 2, 205, 1288, NPC, 10, 241);
      end
      if ItemB < 5  then
       SelectMsg(UID, 2, 205, 1289, NPC, 10, 241);
      end
      if ItemC < 1 then
       SelectMsg(UID, 2, 205, 1290, NPC, 10, 241);
      end
      if  ItemA >= 1 and ItemB >= 5 and ItemC >= 1 then
       SelectMsg(UID, 2, 205, 1291, NPC, 50, 455, 23, 241);
      end
end

if EVENT == 455 then 
RunExchange(UID,102)
end

if EVENT == 459 then 
    ItemA = HowmuchItem(UID, 263011339);  
    ItemB = HowmuchItem(UID, 379072000);  
    ItemC = HowmuchItem(UID, 389075000);  
      if  ItemA < 1  then
       SelectMsg(UID, 2, 205, 1288, NPC, 10, 241);
      end
      if ItemB < 5  then
       SelectMsg(UID, 2, 205, 1289, NPC, 10, 241);
      end
      if ItemC < 1 then
       SelectMsg(UID, 2, 205, 1290, NPC, 10, 241);
      end
      if  ItemA >= 1 and ItemB >= 5 and ItemC >= 1 then
       SelectMsg(UID, 2, 205, 1291, NPC, 50, 456, 23, 241);
      end
end

if EVENT == 456 then 
RunExchange(UID,104)
end

if EVENT == 460 then 
    ItemA = HowmuchItem(UID, 283011340);  
    ItemB = HowmuchItem(UID, 379072000);  
    ItemC = HowmuchItem(UID, 389075000);  
      if  ItemA < 1  then
       SelectMsg(UID, 2, 205, 1288, NPC, 10, 241);
      end
      if ItemB < 5  then
       SelectMsg(UID, 2, 205, 1289, NPC, 10, 241);
      end
      if ItemC < 0 then
       SelectMsg(UID, 2, 205, 1290, NPC, 10, 241);
      end
      if  ItemA >= 1 and ItemB >= 5 and ItemC >= 1 then
       SelectMsg(UID, 2, 205, 1291, NPC, 50, 457, 23, 241);
      end
end

if EVENT == 457 then 
RunExchange(UID,106)
end

if (EVENT == 2000)then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
SelectMsg(UID, 2, -1, 22274, NPC, 22,-1);
GiveItem(UID, 900292000,1)
end
end
-- SQL completed-state dialog exit; no reward or state mutation.
if EVENT == 563 then return end

end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
