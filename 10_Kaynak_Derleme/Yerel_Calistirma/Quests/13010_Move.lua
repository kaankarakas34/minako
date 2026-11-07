-- =============================================
-- Author:		TheThyke
-- Create date: 04.12.2017
-- Update date: 04.12.2017
-- İsmimi Belgelerden Silseniz Bile Beyninizde Her Daim Olacağım.
-- =============================================
local NPC = 13010;

if (EVENT == 500) then
	SelectMsg(UID, 2, -1, 4072, NPC, 4071, 501, 4072, -1);
end

if (EVENT == 501) then
	ZoneChange(UID, 21, 817, 451)
end