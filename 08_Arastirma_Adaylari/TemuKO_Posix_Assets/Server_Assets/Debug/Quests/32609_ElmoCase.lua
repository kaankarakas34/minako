-- =============================================
-- Author:		TheThyke
-- Create date: 29.11.2017
-- Update date: 29.11.2017
-- İsmimi Belgelerden Silseniz Bile Beyninizde Her Daim Olacağım.
-- =============================================
local NPC = 32609;

if (EVENT == 100) then
	NATION = CheckNation(UID);
		if (NATION == 1) then
			SelectMsg(UID, 2, -1, 1032, NPC, 10, 101);
		else
			SelectMsg(UID, 2, -1, 1028, NPC, 10, -1);
		end
end

if (EVENT == 101) then
	Copy_of_Information_Paper = HowmuchItem(UID, 900035000);
		if (Copy_of_Information_Paper > 0) then
			SelectMsg(UID, 2, -1, 1028, NPC, 10, -1);
		else
	SlotCheck = CheckGiveSlot(UID, 1);
		if SlotCheck == false then
			;
		else
			RobItem(UID, 900074000);
			GiveItem(UID, 900035000,1);
		end
	end
end