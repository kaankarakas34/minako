local Ret = 0;
local NPC = 31553;

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
	COUNTA = HowmuchItem(UID, 900156000) 
	if(COUNTA < 1) then
		GiveItem(UID, 900156000)
		RobItem(UID, 900201000)
		SelectMsg(UID, 2, -1, 21587, NPC, 22,-1);
	end
end
end

if(EVENT == 102) then
SLOTKONTROL = CheckExchangeSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	COUNTA = HowmuchItem(UID, 900154000) 
	if(COUNTA < 1) then
		GiveItem(UID, 900154000)
		RobItem(UID, 900204000)
		SelectMsg(UID, 2, -1, 21582, NPC, 22,-1);
	end
end
end

if(EVENT == 103) then
SLOTKONTROL = CheckExchangeSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	COUNTA = HowmuchItem(UID, 900155000) 
	if(COUNTA < 1) then
		GiveItem(UID, 900155000)
		RobItem(UID, 900207000)
		SelectMsg(UID, 2, -1, 21582, NPC, 22,-1);
	end
end
end

if(EVENT == 104) then
SLOTKONTROL = CheckExchangeSlot(UID, 3)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	COUNTA = HowmuchItem(UID, 900152000) 
	if(COUNTA < 1) then
		GiveItem(UID, 900152000)
		RobItem(UID, 900210000)
		SelectMsg(UID, 2, -1, 21582, NPC, 22,-1);
	end
end
end