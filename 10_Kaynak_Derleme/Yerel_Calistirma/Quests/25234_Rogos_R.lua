-- =============================================
-- Author:		TheThyke
-- Create date: 04.04.2018
-- Update date: 04.04.2018
-- İsmimi Belgelerden Silseniz Bile Beyninizde Her Daim Olacağım.
-- =============================================
local NPC = 25234;

if (EVENT == 100) then
	SelectMsg(UID, 3, -1, 12181, NPC,8737,101,8738,102,8739,103,8740,104);
end

if (EVENT == 101) then
Cast = CastSkill(UID, 492017);
	if (Cast) then
		CastSkill(UID, 492017);
		KillNpcEvent(UID);
	end
end

if (EVENT == 102) then
Cast = CastSkill(UID, 492018);
	if (Cast) then
		CastSkill(UID, 492018);
		KillNpcEvent(UID);
	end
end

if (EVENT == 103) then
Cast = CastSkill(UID, 492019);
	if (Cast) then
		CastSkill(UID, 492019);
		KillNpcEvent(UID);
	end
end

if (EVENT == 104) then
Cast = CastSkill(UID, 492020);
	if (Cast) then
		CastSkill(UID, 492020);
		KillNpcEvent(UID);
	end
end