-- Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...
-- =============================================
-- Author:		TheThyke
-- Create date: 13.11.2017
-- Update date: 13.11.2017
-- =============================================
local NPC = 19001;

if (EVENT == 100) then
	SelectMsg(UID, 2, -1, 8946, NPC, 4424, 101, 27, -1);
end   

if (EVENT == 101) then
	SelectMsg(UID, 2, -1, 8947, NPC, 4446, -1);
end