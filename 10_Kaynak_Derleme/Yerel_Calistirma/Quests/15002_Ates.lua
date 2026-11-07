-- Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...
-- =============================================
-- Author:		TheThyke
-- Create date: 13.11.2017
-- Update date: 13.11.2017
-- =============================================
local NPC = 15002;

if (EVENT == 165) then
	SelectMsg(UID, 2, -1, 4132, NPC, 4073, 169, 4074, -1);
end

if (EVENT == 169) then
	ZoneChange(UID, 48, 133, 118)
end
