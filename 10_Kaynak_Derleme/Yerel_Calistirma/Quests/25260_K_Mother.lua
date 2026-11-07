-- =============================================
-- Author:		TheThyke
-- Create date: 10.07.2018
-- Update date: 10.07.2018
-- İsmimi Belgelerden Silseniz Bile Beyninizde Her Daim Olacağım.
-- =============================================

local NPC = 25260;

if (EVENT == 100) then;
	SelectMsg(UID, 2, -1, 44352, NPC, 65, 101, 13, -1);
end

if(EVENT == 101)then
	ZoneChange(UID, 95, 299, 441);
	DrakiRiftChange(UID, 3, 1);
	DrakiTowerNpcOut(UID);
end
