
local NPC = 31719;

if (EVENT == 100) then
	SelectMsg(UID, 3, -1, 44619, NPC, 40660, 101,40661,104,40662,110,40666,117,40667,125);
end

if (EVENT == 101) then
	SelectMsg(UID, 2, -1, 44620, NPC, 67, 102, 68,-1);
end

if (EVENT == 102) then
	NOAH = HowmuchItem(UID, 900000000)	
	if (NOAH < 10000000) then
		SelectMsg(UID, 2, -1, 44628, NPC, 27, -1);
	else
		EVENT = 103
	end
end

if (EVENT == 103) then
	--BattleOfBarrackRegisterNpc(UID)
	Check = CswDeathMatchRegisterNpc(UID)
	if (Check == 2) then
		SelectMsg(UID, 2, -1, 44623, NPC, 10, -1);	-- no es lider
	elseif (Check == 3) then
		SelectMsg(UID, 2, -1, 44625, NPC, 10, -1);	-- no esta en rango de clan
	elseif (Check == 4) then
		SelectMsg(UID, 2, -1, 44626, NPC, 10, -1);	-- ya esta registrado
	elseif (Check == 5) then
		SelectMsg(UID, 2, -1, 44627, NPC, 10, -1);	-- ya esta lleno
	elseif (Check == 6) then
		SelectMsg(UID, 2, -1, 44624, NPC, 10, -1);	-- ya se cerro el registro
	elseif (Check == 1) then
		SelectMsg(UID, 2, -1, 44621, NPC, 10, -1);	-- me registre
	end
end

if (EVENT == 104) then
	SelectMsg(UID, 2, -1, 44629, NPC, 67, 105, 68,-1);
end

if (EVENT == 105) then
	Check = CswDeathMatchRegisterCancelNpc(UID)
	if (Check == 2) then
		SelectMsg(UID, 2, -1, 44623, NPC, 10, -1);	-- no es lider
	elseif (Check == 3) then
		SelectMsg(UID, 2, -1, 44630, NPC, 10, -1);	-- tu clan no esta participando
	elseif (Check == 6) then
		SelectMsg(UID, 2, -1, 44624, NPC, 10, -1); 	-- ya se cerro el registro
	elseif (Check == 1) then
		SelectMsg(UID, 2, -1, 44631, NPC, 10, -1);	-- se cancelo el registro
	end
end

if (EVENT == 110) then
	CswDeathMatchRegisterClanList(UID)
	SelectMsg(UID, 55, -1, -1, NPC);
end

if (EVENT == 125) then
	CswBarrackScoreListNpc(UID)
	SelectMsg(UID, 56, -1, -1, NPC);
end