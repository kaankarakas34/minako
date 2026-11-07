local Ret = 0;
local NPC = 31554;

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
SLOTKONTROL = CheckExchangeSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	ITEM1_COUNT1 = HowmuchItem(UID, 900165000);   
	if(ITEM1_COUNT1 < 1) then
		GiveItem(UID, 900165000)
		RobItem(UID, 900202000)
		SelectMsg(UID, 2, -1, 21592, NPC, 22,-1);
	end
end
end

if(EVENT == 102) then
SLOTKONTROL = CheckExchangeSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	COUNTA = HowmuchItem(UID, 900163000) 
	if(COUNTA < 1) then
		GiveItem(UID, 900163000)
		RobItem(UID, 900205000)
		SelectMsg(UID, 2, -1, 21582, NPC, 22,-1);
	end
end
end

if(EVENT == 103) then
SLOTKONTROL = CheckExchangeSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	COUNTA = HowmuchItem(UID, 900164000) 
	if(COUNTA < 1) then
		GiveItem(UID, 900164000)
		RobItem(UID, 900208000)
		SelectMsg(UID, 2, -1, 21582, NPC, 22,-1);
	end
end
end

if(EVENT == 104) then
SLOTKONTROL = CheckExchangeSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	COUNTA = HowmuchItem(UID, 900159000) 
	if(COUNTA < 1) then
		GiveItem(UID, 900159000)
		RobItem(UID, 900211000)
		SelectMsg(UID, 2, -1, 21582, NPC, 22,-1);
	end
end
end