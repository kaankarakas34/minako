-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-New
local NPC = 25177;

if (EVENT == 100) then
	SelectMsg(UID, 3, -1, 11804, NPC,8354,101,8364,150,7247,180,7248,185);
end

if (EVENT == 101) then
	SelectMsg(UID, 2, -1, 11798, NPC,10,-1);
end

if (EVENT == 150) then
	SelectMsg(UID, 3, -1, 11804, NPC,8378,151,8379,155,8380,160);
end

if (EVENT == 151) then
	SelectMsg(UID, 3, -1, 11806, NPC,10,-1);
end

if (EVENT == 155) then
	SelectMsg(UID, 3, -1, 11806, NPC,10,-1);
end

if (EVENT == 160) then
	SelectMsg(UID, 3, -1, 11806, NPC,10,-1);
end

if (EVENT == 180) then
	PICKAX = HowmuchItem(UID, 508122000);
	if (PICKAX < 1) then
		SelectMsg(UID, 2, -1, 9943, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 9944, NPC, 4297, 181, 4005, -1);
	end
end

if (EVENT == 181) then
	PICKAX = HowmuchItem(UID, 508122000);
	if (PICKAX < 1) then
		SelectMsg(UID, 2, -1, 9943, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 508122000, 1);
	GiveItem(UID, 389135000, 1,30);
	end
end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 185) then
	FISHING = HowmuchItem(UID, 508121000);
	if (FISHING < 1) then
		SelectMsg(UID, 2, -1, 9945, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 9946, NPC, 4297, 186, 4005, -1);

	end
end

if (EVENT == 186) then
	FISHING = HowmuchItem(UID, 508121000);
	if (FISHING < 1) then
		SelectMsg(UID, 2, -1, 9945, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 508121000, 1);
	GiveItem(UID, 191347000, 1,30);
	end
end
end

if (EVENT == 5000) then
	ShowMap(UID, 450);
end