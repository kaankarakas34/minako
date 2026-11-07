if EVENT == 100 then
	QuestStatus = SearchQuest(UID, 182)	
	if(QuestStatus == 3) then
		EVENT = 107
		else
   SelectMsg(UID, 2, -1, 4174, NPC, 7015, 101, 7017, 300);
end
end

--if EVENT == 101 then 
--   SelectMsg(UID, 19, -1, 9185, NPC, 10,102);
--end

if EVENT == 102 then 
   SelectMsg(UID, 19, -1, 1642, NPC, 10,103);
end

if EVENT == 103 then 
   SelectMsg(UID, 2, -1, 1564, NPC, 3000,104,3005,-1);
end

if EVENT == 104 then 
   SelectMsg(UID, 4, 182, 1565, NPC, 3000,105,3005,-1);
end

if(EVENT == 105) then
--IsTakeToday = GetUserDailyOp(UID,1);
--if (IsTakeToday == 1) then
SelectMsg(UID, 19, -1, 1566, NPC, 10,106);
SaveEvent(UID, 1206)
--	else
	--SelectMsg(UID, 2, -1, 11584, NPC, 10, -1);
--end
end

if(EVENT == 106) then
SelectMsg(UID, 2, -1, 1571, NPC, 10,-1);
--SaveEvent(UID, 1209)
	  GiveItem(UID, 900074000, 1)
	  GiveItem(UID, 900075000, 1)
end

if EVENT == 107 then 
   SelectMsg(UID, 4, 182, 1565, NPC, 3000,108,3005,-1);
end

if EVENT == 108 then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
		 SaveEvent(UID, 1209);
RunExchange(UID, 188);
end
end

if(EVENT == 216) then
SaveEvent(UID, 1208)
end

	  