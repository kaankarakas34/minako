local NPC = 31520;
if(EVENT == 1000)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11409);
end
end
if(EVENT == 1003)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11410);
end
ItemCount0 = HowmuchItem(UID,900012000);
if(NATION == 2)then
if(ItemCount0 < 0)then
SelectMsg(UID, 2, 547, 192, 31520, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
else
SelectMsg(UID, 4, 547, 20063, 31520, 10, 4, 27, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end
end
if(EVENT == 1002)then
NATION = CheckNation(UID);
if(NATION == 2)then
SelectMsg(UID, 4, 547, 20063, 31520, 22, 1003, 23, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end
-- Unsupported EVENT branch is retained in the review copy.

-- Unsupported EVENT branch is retained in the review copy.

-- Unsupported EVENT branch is retained in the review copy.

if(EVENT == 1105)then
ItemCount0 = HowmuchItem(UID,508108000);
NATION = CheckNation(UID);
if(NATION == 2)then
if(ItemCount0 < 5)then
SelectMsg(UID, 2, 548, 192, 31520, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
else
SelectMsg(UID, 4, 548, 20065, 31520, 10, 1108, 27, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end
end
-- Unsupported EVENT branch is retained in the review copy.

-- Unsupported EVENT branch is retained in the review copy.

if(EVENT == 1200)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11463);
end
end
if(EVENT == 1202)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11464);
end
end
if(EVENT == 1201)then
NATION = CheckNation(UID);
if(NATION == 2)then
SelectMsg(UID, 4, 549, 20067, 31520, 22, 1202, 23, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end
if(EVENT == 1205)then
ItemCount0 = HowmuchItem(UID,910228000);
NATION = CheckNation(UID);
if(NATION == 2)then
if(ItemCount0 < 1)then
SelectMsg(UID, 2, 549, 192, 31520, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
else
SelectMsg(UID, 4, 549, 20067, 31520, 10, 1208, 27, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end
end
if(EVENT == 1208)then
ItemCount0 = HowmuchItem(UID,910228000);
if(ItemCount0 < 1)then
else
NATION = CheckNation(UID);
if(NATION == 2)then
Check = CheckGiveSlot(UID, 3039);
if(Check == 1)then
RunExchange(UID, 3039);
SaveEvent(UID, 11465);
end
end
end
end
if(EVENT == 1204)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11466);
end
end
if(EVENT == 1300)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11523);
end
end
if(EVENT == 1303)then
NATION = CheckNation(UID);
if(NATION == 2)then
SaveEvent(UID, 11524);
end
ItemCount0 = HowmuchItem(UID,900012000);
if(NATION == 2)then
if(ItemCount0 < 0)then
SelectMsg(UID, 2, 554, 192, 31520, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
else
SelectMsg(UID, 4, 554, 20077, 31520, 10, 4, 27, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end
end
if(EVENT == 1302)then
NATION = CheckNation(UID);
if(NATION == 2)then
SelectMsg(UID, 4, 554, 20077, 31520, 22, 1303, 23, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end


-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=548 status=2 n_index=11438
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 548)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3035);
		SaveEvent(UID, 11440);
	end
end

-- [AUTO-GEN] quest=547 status=2 n_index=11411
if (EVENT == 193) then
	QuestStatusCheck = GetQuestStatus(UID, 547)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunQuestExchange(UID, 3034);
		SaveEvent(UID, 11413);
	end
end
