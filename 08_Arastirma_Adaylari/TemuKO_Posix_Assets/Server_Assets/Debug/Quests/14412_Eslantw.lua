-- Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...
-- =============================================
-- Author:		TheThyke
-- Create date: 13.11.2017
-- Update date: 13.11.2017
-- =============================================
local NPC = 14412;


if (EVENT == 222) then
	ITEM_COUNT1 = HowmuchItem(UID, 910087000);  
	if (ITEM_COUNT1 < 1) then
		SelectMsg(UID, 2, 67, 697, NPC, 18, 100);
	else
		SelectMsg(UID, 2, 67, 705, NPC, 4006, 226, 4005, 193);
	end
end

if (EVENT == 100) then
	ShowMap(UID, 42);
end

if (EVENT == 226) then
	ITEM_COUNT1 = HowmuchItem(UID, 910087000);  
	if (ITEM_COUNT1 < 1) then
		SelectMsg(UID, 2, 67, 697, NPC, 18, 100);
	else
	RobItem(UID, 910087000, 1);
	GoldGain(UID , 500000); 
	SaveEvent(UID, 461);
end
end