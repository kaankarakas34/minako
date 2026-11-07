-- =============================================
-- Author:		TheThyke
-- Create date: 10.07.2018
-- Update date: 10.07.2018
-- İsmimi Belgelerden Silseniz Bile Beyninizde Her Daim Olacağım.
-- =============================================
local NPC = 25266;

if (EVENT == 100) then;
	SelectMsg(UID, 2, -1, 44398, NPC, 40497, 101);
end

if(EVENT == 101)then
	DrakiOutZone(UID);
end