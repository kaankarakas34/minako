-- =============================================
-- Author:		TheThyke
-- Create date: 11.02.2018
-- Update date: 11.02.2018
-- İsmimi Belgelerden Silseniz Bile Beyninizde Her Daim Olacağım.
-- =============================================
local NPC = 30334;

if (EVENT == 100) then
	Cast = CastSkill(UID, 610096);
		if (Cast) then
			Cast = CastSkill(UID, 610096);
		else
			SelectMsg(UID, 2, -1, 8970, NPC, 10, -1);
	end	
end
