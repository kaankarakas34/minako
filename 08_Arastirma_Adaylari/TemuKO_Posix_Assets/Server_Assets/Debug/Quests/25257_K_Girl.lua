-- =============================================
-- Author:		TheThyke
-- Create date: 10.07.2018
-- Update date: 10.07.2018
-- İsmimi Belgelerden Silseniz Bile Beyninizde Her Daim Olacağım.
-- =============================================
local NPC = 25257;

if (EVENT == 100) then;
	SelectMsg(UID, 2, -1, 12401, NPC, 65, 101);
end

if(EVENT == 101)then
	DrakiRiftChange(UID, 1, 4);
	DrakiTowerNpcOut(UID);
end