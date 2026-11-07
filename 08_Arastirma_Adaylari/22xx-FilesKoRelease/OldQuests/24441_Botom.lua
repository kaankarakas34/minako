local Ret = 0;
local NPC = 24441;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 3003, NPC, 10, 193);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 3200, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 193) then
	Ret = 1;
end

local savenum = 403;

if (EVENT == 1000) then -- 36 Level Rotten Eyes Premium
	SelectMsg(UID, 2, savenum, 799, NPC, 10, 1001);
end

if (EVENT == 1001) then
	SaveEvent(UID, 2013);
end

if (EVENT == 1002) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 799, NPC, 22, 1003, 23, 1004);
	else
		SelectMsg(UID, 2, savenum, 799, NPC, 10, 193);
	end
end

if (EVENT == 1003) then
	SaveEvent(UID, 2014);
end

if (EVENT == 1004) then
	SaveEvent(UID, 2017);
end

if (EVENT == 1010) then
	SaveEvent(UID, 2016);
end

if (EVENT == 1006) then
	MonsterCount = QuestMonsterCount(UID, 403, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum, 732, NPC, 18, 1007);
	else
		SelectMsg(UID, 4, savenum, 8461, NPC, 41, 1008, 23, 193);
	end
end

if (EVENT == 1007) then
	ShowMap(UID, 97);
end

if (EVENT == 1008) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID, 1190)
		SaveEvent(UID, 2015);   
	else
		RunExchange(UID, 1190)
		SaveEvent(UID, 2015);
	end
end

local savenum = 128;

if (EVENT == 8400) then -- 36 Level Rotten Eyes
	SelectMsg(UID, 2, savenum, 8363, NPC, 10, 8401);
end

if (EVENT == 8401) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8469);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8474);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8479);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8484);
	end
end

if (EVENT == 8402) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 8363, NPC, 22, 8403, 23, 8404);
	else
		SelectMsg(UID, 2, savenum, 8363, NPC, 10, 193);
	end
end   

if (EVENT == 8403) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8470);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8475);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8480);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8485);
	end
end

if (EVENT == 8404) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8473);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8478);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8483);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8488);
	end
end

if (EVENT == 8410) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8472);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8477);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8482);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8487);
	end
end

if (EVENT == 8406) then
	MonsterCount = QuestMonsterCount(UID, 128, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum, 8363, NPC, 18, 8407);
	else
		SelectMsg(UID, 4, savenum, 8363, NPC, 41, 8408, 23, 193);
	end
end

if (EVENT == 8407) then
	ShowMap(UID, 97);
end

if (EVENT == 8408) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID, 904)
		SaveEvent(UID, 8471);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunExchange(UID, 905)
		SaveEvent(UID, 8476);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunExchange(UID, 906)
		SaveEvent(UID, 8481);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunExchange(UID, 907)
		SaveEvent(UID, 8486);
	end
end
end

local savenum = 415;

if (EVENT == 1100) then -- 42 Level Battalion Premium
	SelectMsg(UID, 2, savenum, 799, NPC, 10, 1101);
end

if (EVENT == 1101) then
	SaveEvent(UID, 2085);
end

if (EVENT == 1102) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 799, NPC, 22, 1103, 23, 1104);
	else
		SelectMsg(UID, 2, savenum, 799, NPC, 10, 193);
	end
end

if (EVENT == 1103) then
	SaveEvent(UID, 2086);
end

if (EVENT == 1104) then
	SaveEvent(UID, 2089);
end

if (EVENT == 1110) then
	SaveEvent(UID, 2088);
end

if (EVENT == 1106) then
	MonsterCount = QuestMonsterCount(UID, 415, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum, 732, NPC, 18, 1107);
	else
		SelectMsg(UID, 4, savenum, 8461, NPC, 41, 1108, 23, 193);
	end
end

if (EVENT == 1107) then
	ShowMap(UID, 109);
end

if (EVENT == 1108) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID, 1196)
		SaveEvent(UID, 2087);   
	else
		RunExchange(UID, 1196)
		SaveEvent(UID, 2087);
	end
end

local savenum1 = 146;

if (EVENT == 8850) then -- 42 Level Battalion
	SelectMsg(UID, 2, savenum1, 799, NPC, 10, 8851);
end

if (EVENT == 8851) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8721);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8726);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8731);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8736);
	end
end

if (EVENT == 8852) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum1, 799, NPC, 22, 8853, 23, 8854);
	else
		SelectMsg(UID, 2, savenum1, 8461, NPC, 10, 193);
	end
end   

if (EVENT == 8853) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8722);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8727);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8732);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8737);
	end
end

if (EVENT == 8854) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8725);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8730);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8735);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8740);
	end
end

if (EVENT == 8860) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8724);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8729);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8734);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8739);
	end
end

if (EVENT == 8856) then
	MonsterCount = QuestMonsterCount(UID, 146, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum1, 732, NPC, 18, 8857);
	else
		SelectMsg(UID, 4, savenum1, 8461, NPC, 41, 8858, 23, 193);
	end
end

if (EVENT == 8857) then
	ShowMap(UID, 109);
end

if (EVENT == 8858) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID, 961)
		SaveEvent(UID, 8723);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		GiveItemLua(UID,245004005,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 0,0, 0,0);
RunExchange(UID, 962)
		SaveEvent(UID, 8728);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunExchange(UID, 963)
		SaveEvent(UID, 8733);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunExchange(UID, 964)
		SaveEvent(UID, 8738);
	end
end
end