local Ret = 0;
local NPC = 14410;

if (EVENT == 190) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 680, NPC, 10, 193);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 681, NPC)
	else 
		EVENT = QuestNum
	end
end

if (EVENT == 193) then
	Ret = 1;
end

if (EVENT == 195) then
	SelectMsg(UID, 2, 202, 1260, NPC, 28, 196);
end

if (EVENT == 196) then
	ShowMap(UID, 41);
	SaveEvent(UID, 449);
end

if (EVENT == 200) then
	SelectMsg(UID, 4, 202, 684, NPC, 22, 202, 23, 203);
end

if (EVENT == 202) then
	SaveEvent(UID, 450);
end

if (EVENT == 203) then
	SaveEvent(UID, 453);
end

if (EVENT == 205) then
	SaveEvent(UID, 452);
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, 202, 1263, NPC, 32, 193);
	else
		SelectMsg(UID, 2, 202, 685, NPC, 21, 193);
	end
end

if (EVENT == 210) then
	ITEM_COUNT = HowmuchItem(UID, 379204000);   
	if (ITEM_COUNT < 2) then
		SelectMsg(UID, 2, 202, 686, NPC, 18, 213);
	else
		SelectMsg(UID, 4, 202, 687, NPC, 41, 214, 27, 193); 
	end
end

if (EVENT == 213) then
	ShowMap(UID, 14);
end

if (EVENT == 214) then
	Check = isRoomForItem(UID, 389620000);
	if (Check == -1) then
		SelectMsg(UID, 2, -1, 832, NPC, 27, 193);
	else
RunExchange(UID,90)
		SaveEvent(UID, 451);
	end
end

if (EVENT == 1001) then
SelectMsg(UID, 4, 519, 20143, NPC, 22, 1002, 23, -1); 
end

if (EVENT == 1002) then
 SaveEvent(UID, 11068);
end

if (EVENT == 1006) then
 SaveEvent(UID, 11070);
end

if (EVENT == 1003) then
	ITEM_COUNT = HowmuchItem(UID, 910209000);   
	if (ITEM_COUNT < 1) then
		SelectMsg(UID, 2, 519, 20143, NPC, 18, -1);
	else
		SelectMsg(UID, 4, 519, 20143, NPC, 22, 1005, 27, -1); 
	end
end

if (EVENT == 1005) then
SLOTKONTROL = CheckGiveSlot(UID,3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
RunExchange(UID,3006)
 SaveEvent(UID, 11069);
  SaveEvent(UID, 11086);
end
end
