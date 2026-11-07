local Ret = 0;
local NPC = 25174;

if (EVENT == 100) then
	SelectMsg(UID, 3, -1, 12009, NPC, 8707, 3100);
end

if (EVENT == 101) then
	Ret = 1;
end

-- Returnee Knight
if (EVENT == 3100) then
	SelectMsg(UID, 2, -1, 12131, NPC, 8708, 3101)
end

if (EVENT == 3101) then
	ITEM = HowmuchItem(UID, 810552000);
	if (ITEM > 0) then
		GiveItemLua(UID,810552000,1,1, 810554924,1,1, 810512000,1,1, 0,0,0, 0,0,0, 810552000,1, 0,0, 0,0, 0,0, 0,0);
	else
	SelectMsg(UID, 2, -1, 12133, NPC, 8708, 101)
	end
end