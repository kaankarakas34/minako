local NPC = 29235;
local Ret = 0;

if (EVENT == 100) then
	SelectMsg(UID, 3, -1, 11624, NPC, 48013, 792, 8574, 104, 8208, 105, 8534, 106, 4637, 107, 8479, 108, 8465, 111,8239,112, 10, 101);
end

-- Knight Cash Exchange

if (EVENT == 792) then
	SelectMsg(UID, 2, -1, 44662, NPC, 60000, 793, 60001, 794, 60002, 795, 60003, 796, 60004, 797, 60005, 798, 60006, 100);
end

-- 100 cash

if (EVENT == 793) then
	CASH = HowmuchItem(UID, 700081000);
	if (CASH > 0) then
		RobItem(UID, 700081000, 1)
		GiveCash(UID, 100)
	else
		SelectMsg(UID, 2, -1, 44677, NPC, 61000, 101)
	end
end

-- 350 cash

if (EVENT == 794) then
	CASH = HowmuchItem(UID, 810042000);
	if (CASH > 0) then
		RobItem(UID, 810042000, 1)
		GiveCash(UID, 350)
	else
		SelectMsg(UID, 2, -1, 44677, NPC, 61000, 101)
	end
end

-- 700 cash

if (EVENT == 795) then
	CASH = HowmuchItem(UID, 810010000);
	if (CASH > 0) then
		RobItem(UID, 810010000, 1)
		GiveCash(UID, 700)
	else
		SelectMsg(UID, 2, -1, 44677, NPC, 61000, 101)
	end
end

-- 1000 cash

if (EVENT == 796) then
	CASH = HowmuchItem(UID, 810020000);
	if (CASH > 0) then
		RobItem(UID, 810020000, 1)
		GiveCash(UID, 1000)
	else
		SelectMsg(UID, 2, -1, 44677, NPC, 61000, 101)
	end
end

-- 2000 cash

if (EVENT == 797) then
	CASH = HowmuchItem(UID, 810030000);
	if (CASH > 0) then
		RobItem(UID, 810030000, 1)
		GiveCash(UID, 2000)
	else
		SelectMsg(UID, 2, -1, 44677, NPC, 61000, 101)
	end
end

-- 5000 cash

if (EVENT == 798) then
	CASH = HowmuchItem(UID, 810040000);
	if (CASH > 0) then
		RobItem(UID, 810040000, 1)
		GiveCash(UID, 5000)
	else
		SelectMsg(UID, 2, -1, 44677, NPC, 61000, 101)
	end
end

if (EVENT == 101) then
	Ret = 1;
end

if (EVENT == 102) then -- War Emblem Exchange
	WARAMBLEM = HowmuchItem(UID, 914052000);
	if (WARAMBLEM < 1) then
		SelectMsg(UID, 2, -1, 11801, NPC, 10, 101);
	else
		GiveItemLua(UID,914053879,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 914052000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 103) then -- WAR Championship Emblem Exchange
	WARCAMBLEM = HowmuchItem(UID, 914052000);
	if (WARCAMBLEM < 1) then
		SelectMsg(UID, 2, -1, 11802, NPC, 10, 101);
	else
		GiveItemLua(UID,914054880,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 914052000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 104) then -- Use Platinum Premium
	PLAT = HowmuchItem(UID, 900970865); -- KONTROL EDILCEK
	if (PLAT > 0) then -- Menu us -> 7029
		SelectMsg(UID, 2, -1, 9527, NPC, 4478, 300, 4005, 101);
	else
		SelectMsg(UID, 2, -1, 9528, NPC, 10, 101);
	end
end

if (EVENT == 300) then
	Prem = GetPremium(UID);
	if (Prem == 0) then
		RobItem(UID, 900970865, 1)
		GivePremium(UID, 7,720)
	else
		SelectMsg(UID, 2, -1, 9526, NPC, 10, 101);
	end
end

if (EVENT == 105) then -- Jumping Event
	Level = CheckLevel(UID);
	if (Level > 49) then
		SelectMsg(UID, 2, -1, 11050, NPC, 40147, 200, 40146, 101);
	else
		SelectMsg(UID, 2, -1, 11053, NPC, 10, 101);
	end
end

if (EVENT == 200) then
	SelectMsg(UID, 2, -1, 11051, NPC, 10, 201);
end

if (EVENT == 201) then
	SelectMsg(UID, 2, -1, 11052, NPC, 40142, 202, 4005, 101);
end

if (EVENT == 202) then
	Level = CheckLevel(UID);
	if (Level > 49 and Level < 60) then
		EVENT = 203
	elseif (Level > 59 and Level < 65) then
		EVENT = 204
	elseif (Level > 64) then
		EVENT = 205
	end
end

if (EVENT == 203) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		LevelChange(UID, 75)
	else
		LevelChange(UID, 73)
	end
end

if (EVENT == 204) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		LevelChange(UID, 76)
	else
		LevelChange(UID, 74)
	end
end

if (EVENT == 205) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		LevelChange(UID, 77)
	else
		LevelChange(UID, 75)
	end
end

if (EVENT == 106) then -- Under The Castle Event
	SelectMsg(UID, 3, -1, 11972, NPC, 2002, 400, 8535, 401, 8536, 402);
end

if (EVENT == 107) then -- Attendance Check Event
	
end

if (EVENT == 108) then -- Guardian Emblem Exchange
	GUARD = HowmuchItem(UID, 900703000);
	if (GUARD < 1) then
		SelectMsg(UID, 2, -1, 11063, NPC, 10, 101);
	else
		GiveItemLua(UID,900704864,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 900703000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 111) then -- Exchange Wing of Neophyte
	WINGNEO = HowmuchItem(UID, 900700000);
	if (WINGNEO < 1) then
		SelectMsg(UID, 2, -1, 11063, NPC, 10, 101);
	else
		Nation = CheckNation(UID);
		if (Nation == 1) then
			GiveItemLua(UID,900701000,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 900700000,1, 0,0, 0,0, 0,0, 0,0);
		else
			GiveItemLua(UID,900702000,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 900700000,1, 0,0, 0,0, 0,0, 0,0);
		end
	end
end

if (EVENT == 112) then -- BattleHero Wing Exchange
	WINGHERO = HowmuchItem(UID, 900582000);
	if (WINGHERO < 1) then
		SelectMsg(UID, 2, -1, 11063, NPC, 10, 101);
	else
		GiveItemLua(UID,900028683,1,7, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 900582000,1, 0,0, 0,0, 0,0, 0,0);
	end
end
