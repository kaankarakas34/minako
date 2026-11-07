-- =============================================
-- Create date: 01.10.2020
-- Update date: 01.10.2020
-- =============================================
local NPC = 24438;

if (EVENT == 3000) then
	NpcMsg(UID, 810, NPC)
end

if (EVENT == 3010) then
    SelectMsg(UID, 2, -1, 803, NPC, 67, 3011, 68, -1);
end

if (EVENT == 3011) then
	Level = CheckLevel(UID);
	if (Level > 69) then
		SelectMsg(UID, 2, -1, 804, NPC, 2002, 3012);
	else
		SelectMsg(UID, 2, -1, 810, NPC, 10, -1);
	end
end

if (EVENT == 3012) then
	SelectMsg(UID, 2, -1, 805, NPC, 65, 3013);
end

if (EVENT == 3013) then
    CheckJuraidMountainTime(UID)
	JoinEvent(UID);
	SaveEvent(UID, 694);
end


--local NPC = 24438;

--if (EVENT == 3000) then
	--NpcMsg(UID, 810, NPC)
--end

--if (EVENT == 3010) then
    --SelectMsg(UID, 2, -1, 803, NPC, 67, 3011, 68, -1);
--end

--if (EVENT == 3011) then
	--Level = CheckLevel(UID);
	--if (Level > 69) then
	--	SelectMsg(UID, 2, -1, 804, NPC, 2002, 3012);
	--else
		--SelectMsg(UID, 2, -1, 810, NPC, 10, -1);
	--end
--end

--if (EVENT == 3012) then
	--SelectMsg(UID, 2, -1, 805, NPC, 65, 3013);
--end

--if (EVENT == 3013) then
    --JURADTIME = CheckJuraidMountainTime(UID)
		--if (JURADTIME == 23) then
			--JoinEvent(UID);
			--SaveEvent(UID, 694);
		--elseif (JURADTIME == 8) then
			--JoinEvent(UID);
			--SaveEvent(UID, 694);
		--else
			--SelectMsg(UID, 2, -1, 804, NPC, 10, -1);
	--end
--end