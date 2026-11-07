-- Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...
-- =============================================
-- Author:		TheThyke
-- Create date: 13.11.2017
-- Update date: 13.11.2017
-- =============================================
local NPC = 16094;

if (EVENT == 500) then
	SelectMsg(UID, 2, -1, 959, NPC, 4071, 501, 4072, -1);
end

if (EVENT == 501) then
	Level = CheckLevel(UID);
	NATION = CheckNation(UID);
	if (Level < 30) then
		if (NATION == 1) then
			ZoneChange(UID, 1, 441, 1625)
		else
			ZoneChange(UID, 2, 1595, 412)
		end
	else
		if (NATION == 1) then
			ZoneChange(UID, 71, 1014, 1020)
		else
			ZoneChange(UID, 71, 1026, 984)
		end
	end
end