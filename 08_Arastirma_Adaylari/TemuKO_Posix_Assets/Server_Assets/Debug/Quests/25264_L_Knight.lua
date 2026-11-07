-- =============================================
-- Author:		TheThyke
-- Create date: 10.07.2018
-- Update date: 10.07.2018
-- İsmimi Belgelerden Silseniz Bile Beyninizde Her Daim Olacağım.
-- =============================================
local NPC = 25264;

if (EVENT == 100) then;
	SelectMsg(UID, 2, -1, 44366, NPC, 3000, 101,13,-1);
end

if(EVENT == 101)then
	DrakiRiftChange(UID, 4, 4);
	DrakiTowerNpcOut(UID);
end