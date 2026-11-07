local Ret = 0;
local NPC = 18004;
local savenum = -1;

if (EVENT == 101) then
 Ret = 1;
end

if (EVENT == 100) then   
	Level = CheckLevel(UID)
	if (Level > 9) then 
		Class = CheckClass(UID);
		if (Class == 1 or Class == 2 or Class == 3 or Class == 4 or Class == 13) then
			ITEM_COUNT = HowmuchItem(UID, 900000000);
			if (ITEM_COUNT < 3000) then
				SelectMsg(UID, 2, savenum, 4065, NPC, 10, 101);
			else
				SelectMsg(UID, 2, savenum, 4064, NPC, 4062, 404, 4063, 101);
			end
		else
			NpcMsg(UID, 147, NPC);
		end
	else
		SelectMsg(UID, 2, savenum, 4069, NPC, 10, 101);
	end
end

if (EVENT == 404) then
	SaveEvent(UID, 4063);
	PromoteUserNovice(UID)
	GoldLose(UID, 3000)
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, savenum, 4066, NPC, 4064, 101);
	else
		SelectMsg(UID, 2, savenum, 4067, NPC, 4064, 101);
	end
end

if (EVENT == 699) then
	SelectMsg(UID, 2, -1, 1548, NPC, 3000, 107, 3005, 101);
end

if (EVENT == 107) then
	SelectMsg(UID, 2, -1, 1532, NPC, 10, 108);
end

if (EVENT == 108) then
	nItem = HowmuchItem(UID, 800360000);
	if(nItem > 0) then
		SendNationTransfer(UID)
	end
end

if (EVENT == 10000) then
	SelectMsg(UID, 2, 60, 1549, NPC, 10, 101);
end

if (EVENT == 407) then
	SelectMsg(UID, 2, savenum, 4070, NPC, 4070, 408, 10, 101);
end

if (EVENT == 408) then
	SendStatSkillDistribute(UID)
end

-- Repurchase Item
if (EVENT == 799) then
  SelectMsg(UID, 2, 60, 10745, NPC, 22, 171, 23, 101);
end

if (EVENT == 171) then
	SendRepurchaseMsg(UID)
end

if (EVENT == 499) then
  SelectMsg(UID, 2, 60, 1546, NPC, 7012, 801, 7013, 805);
end

if (EVENT == 801) then -- Need investigate
	SelectMsg(UID, 2, -1, 1532, NPC, 10, 108);
end

if (EVENT == 805) then -- Need investigate
	LEADER = isClanLeader(UID)
	SelectMsg(UID, 2, 60, 1536, NPC, 10, 806);
end

if (EVENT == 806) then -- Need investigate
	SelectMsg(UID, 2, 60, 1538, NPC, 3000, 807, 3005, 101);
end

if (EVENT == 807) then -- Need investigate
	SelectMsg(UID, 2, 60, 1542, NPC, 3000, 808, 3005, 101);
end

if (EVENT == 808) then -- Need investigate
	SelectMsg(UID, 2, 60, 1544, NPC, 10, 101);
end

if (EVENT == 410) then
	SelectMsg(UID, 2, 60, 1522, NPC, 7014, 901, 73, 903);
end

if (EVENT == 901) then
	SelectMsg(UID, 2, 60, 1532, NPC, 10, 902);
end

if (EVENT == 902) then
-- Usko sending nothing
end
if (EVENT == 903) then
-- Usko sending nothing
end

if (EVENT == 1010) then
	SelectMsg(UID, 2, 60, 12144, NPC, 4160, 1011);
end

if (EVENT == 1011) then
	SelectMsg(UID, 2, 60, 12145, NPC, 3000, 1012, 3005, 101);
end

if (EVENT == 1012) then
	ITEM_COUNT = HowmuchItem(UID, 900000000);
	bRebLevel = GetRebLevel(UID);
	if(bRebLevel > 0) then
		if (ITEM_COUNT > 100000000) then
			SelectMsg(UID, 52, -1, -1);
		else
			SelectMsg(UID, 2, 60, 12147, NPC, 27, 101);
		end
	else
		SelectMsg(UID, 2, 60, 12149, NPC, 27, 101);
	end
end

if (EVENT == 600) then
	SelectMsg(UID, 2, 60, 11640, NPC, 7014, 601, 73, 101);
end

if (EVENT == 601) then
	SelectMsg(UID, 2, 60, 11641, NPC, 10, 602);
end

if (EVENT == 602) then
-- Usko sending nothing
end

if (EVENT == 700) then
-- Usko sending nothing
end