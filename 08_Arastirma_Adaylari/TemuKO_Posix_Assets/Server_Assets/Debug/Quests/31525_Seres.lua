-- =============================================
-- Create date: 29.11.2020
-- Update date: 29.11.2020
-- Kontrol Edilecek.
-- =============================================
local NPC = 31525;

if (EVENT == 100) then
	--SelectMsg(UID, 3, -1, 12436, NPC, 8975, 105, 8976, 109, 10,-1);
	SelectMsg(UID, 3, -1, 12436, NPC, 8975, 105, 8976, 109, 7799, 900, 10,-1);
end

if (EVENT == 500) then
	SendGenderChange(UID);
end

if (EVENT == 1000) then
	ShowMap(UID, 450);
end

if (EVENT == 105) then
	SelectMsg(UID, 24, -1, -1, NPC);
end


if (EVENT == 109) then
	ItemGen = HowmuchItem(UID, 810594000);
	Nation = CheckNation(UID);	
	if (ItemGen >= 1) then
		if (Nation == 1) then
			SelectMsg(UID, 3, savenum, 147, NPC, 2002, 250);
		else
			SelectMsg(UID, 3, savenum, 147, NPC, 2002, 251);
		end
	else
		ShowMap(UID, 450);
	end
end

if (EVENT == 250) then
	WarriorC = isWarrior(UID);
	RogueC = isRogue(UID);
	MageC = isMage(UID);
	PriestC = isPriest(UID);
	if (WarriorC) then
		SelectMsg(UID, 3, savenum, 7108, NPC, 10, 101);
	elseif (RogueC) then
		SelectMsg(UID, 3, savenum, 7108, NPC, 10, 101);
	elseif (MageC) then
		SelectMsg(UID, 3, savenum, 147, NPC, 50200, 211, 50204, 212);
	elseif (PriestC) then
		SelectMsg(UID, 3, savenum, 147, NPC, 50203, 210, 50204, 212);
	end
end


if (EVENT == 251) then
	WarriorC = isWarrior(UID);
	RogueC = isRogue(UID);
	MageC = isMage(UID);
	PriestC = isPriest(UID);
	if (WarriorC) then
		SelectMsg(UID, 3, savenum, 147, NPC, 50202, 213, 50203, 214, 50204, 215);
	elseif (RogueC) then
		SelectMsg(UID, 3, savenum, 147, NPC, 50203, 214, 50204, 215);
	elseif (MageC) then
		SelectMsg(UID, 3, savenum, 147, NPC, 50203, 214, 50204, 215);
	elseif (PriestC) then
		SelectMsg(UID, 3, savenum, 147, NPC, 50203, 214, 50204, 215);
	end
end

--Karus Gender Change Effected
if (EVENT == 210) then
	GenderChange(UID, 2)
end

if (EVENT == 211) then
	GenderChange(UID, 3)
end

if (EVENT == 212) then
	GenderChange(UID, 4)
end

--Elmorad Gender Change Effected
if (EVENT == 213) then
	GenderChange(UID, 11)
end

if (EVENT == 214) then
	GenderChange(UID, 12)
end

if (EVENT == 215) then
	GenderChange(UID, 13)
end

--[Knight Chaos Day] job change
if (EVENT == 900) then
	JOBCHANGEITEM = HowmuchItem(UID, 900006000);
	if (JOBCHANGEITEM > 0) then
		Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6) then
			SelectMsg(UID, 3, -1, 44203, NPC, 8651, 302, 8652, 303, 8653, 304);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			SelectMsg(UID, 3, -1, 44203, NPC, 8650, 301, 8652, 303, 8653, 304);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			SelectMsg(UID, 3, -1, 44203, NPC, 8650, 301, 8651, 302, 8653, 304);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			SelectMsg(UID, 3, -1, 44203, NPC, 8650, 301, 8651, 302, 8652, 303);
		end
	else
		SelectMsg(UID, 2, -1, 44217, NPC, 18, 1000);
	end
end