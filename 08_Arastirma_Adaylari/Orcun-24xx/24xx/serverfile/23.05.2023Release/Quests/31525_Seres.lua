local Ret = 0;
local NPC = 31525;

if (EVENT == 100) then
	--NpcMsg(UID, 12436, NPC);
	SelectMsg(UID, 3, -1, 12436, NPC, 8975, 8976, 8976, 7636, 4062, 300, 10, 7587);
end

--Apparance Change
if (EVENT == 8976) then
	SelectMsg(UID, 24, -1, -1);	
end

--Gender Change
if (EVENT == 7636) then
	SelectMsg(UID, 53, -1, -1);
end

--Confirm
if (EVENT == 10) then
	Ret = 1;
end


if (EVENT == 300) then
	JOBCHANGEITEM = HowmuchItem(UID, 900006000);
	Class = CheckClass(UID);
	if (JOBCHANGEITEM > 0) then
		--if (Class == 1 or Class == 5 or Class == 6) then
		--	SelectMsg(UID, 3, -1, 12436, NPC, 49360, 302, 49362, 303, 49361, 304, 49359, 305);
		--elseif (Class == 2 or Class == 7 or Class == 8) then
		--	SelectMsg(UID, 3, -1, 12436, NPC, 49358, 301, 49362, 303, 49361, 304, 49359, 305);
		--elseif (Class == 3 or Class == 9 or Class == 10) then
		--	SelectMsg(UID, 3, -1, 12436, NPC, 49358, 301, 49360, 302, 49361, 304, 49359, 305);
		--elseif (Class == 4 or Class == 11 or Class == 12) then
		--	SelectMsg(UID, 3, -1, 12436, NPC, 49358, 301, 49360, 302, 49362, 303, 49359, 305);
		--elseif (Class == 13 or Class == 14 or Class == 15) then
		--	SelectMsg(UID, 3, -1, 12436, NPC, 49358, 301, 49360, 302, 49362, 303, 49361, 304);
	--	end
		SendJobChange(UID);
	else
		SelectMsg(UID, 2, -1, 9546, NPC, 18, 1000);
	end
end

if (EVENT == 1000) then
	ShowMap(UID, 450);
end

if (EVENT == 301) then
	JobChange(UID,1);
end

if (EVENT == 302) then
	JobChange(UID,2);
end

if (EVENT == 303) then
	JobChange(UID,3);
end

if (EVENT == 304) then
	JobChange(UID,4);
end

if (EVENT == 305) then
	JobChange(UID,5);
end

