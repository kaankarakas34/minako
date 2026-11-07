local Ret = 0;
local NPC = 31552;

if (EVENT == 100) then
	QuestStatus = SearchQuest(UID, 633)	
	if(QuestStatus == 1) then
		EVENT = 101
		else
			QuestStatus = SearchQuest(UID, 635)	
	if(QuestStatus == 1) then
		EVENT = 102
		else
					QuestStatus = SearchQuest(UID, 637)	
	if(QuestStatus == 1) then
	    EVENT = 103
		else
							QuestStatus = SearchQuest(UID, 639)	
	if(QuestStatus == 1) then
	EVENT = 104
	end
end
end
end
end

if(EVENT == 101) then
SLOTKONTROL = CheckGiveSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	COUNTA = HowmuchItem(UID, 900151000) 
	if(COUNTA < 1) then
		GiveItem(UID, 900151000)
		RobItem(UID, 900200000)
		SelectMsg(UID, 2, -1, 21582, NPC, 22,-1);
	end
end
end


if(EVENT == 102) then
SLOTKONTROL = CheckGiveSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	COUNTA = HowmuchItem(UID, 900149000) 
	if(COUNTA < 1) then
		GiveItem(UID, 900149000)
		RobItem(UID, 900203000)
		SelectMsg(UID, 2, -1, 21582, NPC, 22,-1);
	end
end
end

if(EVENT == 103) then
SLOTKONTROL = CheckGiveSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	COUNTA = HowmuchItem(UID, 900150000) 
	if(COUNTA < 1) then
		GiveItem(UID, 900150000)
		RobItem(UID, 900206000)
		SelectMsg(UID, 2, -1, 21582, NPC, 22,-1);
	end
end
end

if(EVENT == 104) then
SLOTKONTROL = CheckGiveSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	COUNTA = HowmuchItem(UID, 900148000) 
	if(COUNTA < 1) then
		GiveItem(UID, 900148000)
		RobItem(UID, 900209000)
		SelectMsg(UID, 2, -1, 21582, NPC, 22,-1);
	end
end
end