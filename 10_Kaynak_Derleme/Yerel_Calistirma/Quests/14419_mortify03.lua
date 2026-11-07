-- Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...
-- =============================================
-- Author:		TheThyke
-- Create date: 13.11.2017
-- Update date: 13.11.2017
-- =============================================
local NPC = 14419;


local savenum = 40;

if (EVENT == 100) then
	ItemA = HowmuchItem(UID, 910129000);
	if (ItemA == 0) then
		SelectMsg(UID, 2, savenum, 4558, NPC, 10, -1);
	else
		SelectMsg(UID, 4, savenum, 4559, NPC, 22, 101, 23, -1);
	end
end

if (EVENT == 101) then
	SelectMsg(UID, 2, savenum, 4560, NPC, 4216, 102, 4217, 103);
end

if (EVENT == 102) then
	ItemA = HowmuchItem(UID, 910129000);
	if (ItemA == 0) then
		SelectMsg(UID, 2, savenum, 4558, NPC, 10, -1);
	else
	RunQuestExchange(UID, 484);		 
	SaveEvent(UID, 4299);
end
end

if (EVENT == 103) then
	RobItem(UID, 910129000, 1);
	SelectMsg(UID, 2, savenum, 4561, NPC, 10, -1);
end