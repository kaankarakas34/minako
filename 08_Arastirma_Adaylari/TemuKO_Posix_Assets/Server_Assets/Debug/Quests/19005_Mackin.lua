-- =============================================
-- Create date: 01.08.2020
-- Update date: 28.08.2020
-- =============================================
local NPC = 19005;

if (EVENT == 100) then
	SelectMsg(UID, 3, 974, 8082, NPC, 8265, 301);
end

if (EVENT == 301) then
	SelectMsg(UID, 3, -1, 11705, NPC, 8258, 375, 8265,400);
end

if(EVENT == 370) then
	QUEST1 = GetQuestStatus(UID,1119);
	QUEST2 = GetQuestStatus(UID,1120);
	QUEST3 = GetQuestStatus(UID,1121);
	if (QUEST1 ~= 2)then
		SelectMsg(UID, 2, -1, 11710, NPC, 10, -1);
	elseif (QUEST2 ~= 2)then
		SelectMsg(UID, 2, -1, 11711, NPC, 10, -1);
	elseif(QUEST3 == 0)then
		SelectMsg(UID, 2, -1, 11699, NPC, 8259, 371);
	elseif(QUEST3 == 1) then
		SelectMsg(UID, 2, -1, 11703, NPC, 8261, 375);
	end	
end

if(EVENT == 371) then
	SelectMsg(UID, 2, -1, 11700, NPC, 8260, 372);
end

if(EVENT == 372) then
	SelectMsg(UID, 2, -1, 11701, NPC, 8256, 373);
end

if(EVENT == 373) then
	SelectMsg(UID, 2, -1, 11702, NPC, 65, 374);
end

if(EVENT == 374) then
	SaveEvent(UID,7283);
end

if(EVENT == 375) then
	LEVEL = GetLevel(UID);
	NP = CheckLoyalty(UID);
	EXP = GetExpPercent(UID);
	bRebLevel = GetRebirthLevel(UID);
	SlotCheck = CheckGiveSlot(UID, 1)
	if SlotCheck == false then
	else
	if(LEVEL == 83 and NP >= 10000 and EXP == 100 and bRebLevel < 10) then 
		RobLoyalty(UID,10000);
		GiveItem(UID,900579000,1);
		SaveEvent(UID,7276);
		SaveEvent(UID,7281);
		SaveEvent(UID,7286);
		SaveEvent(UID,7288);
	else
		SelectMsg(UID, 2, -1, 11708, NPC, 10, -1);
		end
	end
end

if(EVENT == 400) then
QUEST1 = GetQuestStatus(UID,1122);
	if (QUEST1 == 1) then
		SelectMsg(UID, 2, -1, 11704, NPC, 8263, 401, 8264,402);
	else
		SelectMsg(UID, 2, -1, 11706, NPC, 10, -1);
	end
end

if(EVENT == 401) then
	ITEM = HowmuchItem(UID,900579000)
	if(ITEM > 0) then
		SelectMsg(UID, 48, -1, -1, NPC);	
	else
		SelectMsg(UID, 2, 974, 11704, NPC, 27, 402);	
	end
end

if (EVENT == 5000) then
	ShowMap(UID, 336);
end