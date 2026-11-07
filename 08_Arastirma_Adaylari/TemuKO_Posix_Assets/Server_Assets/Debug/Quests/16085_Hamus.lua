-- Eyyy Forum Kullanıcıları... Artık Toplamak Yerine Oturun Biraz Mantığınızı Yürütün.Çalanlardan Kopyala Yapıştır Yapmayı Bırakın...
-- =============================================
-- Author:		TheThyke
-- Create date: 13.11.2017
-- Update date: 13.11.2017
-- =============================================
local NPC = 16085;

if (EVENT == 165) then
	NpcMsg(UID, 4131, NPC)
end

if (EVENT ==  520) then
	SelectMsg(UID, 3, -1, 1111, NPC, 4583, 521, 4584, 522, 4585, 523, 4586, 524, 7162, 525, 7163, 526, 4296, 165);
end

if (EVENT == 521) then
	ITEMA = HowmuchItem(UID, 889310000);
	if (ITEMA < 1) then
		SelectMsg(UID, 2, -1, 1113, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 1112, NPC, 4297, 527, 4296, 520);
	end
end

if (EVENT == 522) then  
	ITEMB = HowmuchItem(UID, 889320000);
	if (ITEMB < 1) then
		SelectMsg(UID, 2, -1, 1116, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 1115, NPC, 4297, 528, 4296, 520);
	end
end

if (EVENT == 523) then
	ITEMC = HowmuchItem(UID, 889340000);
	if (ITEMC < 1) then
		SelectMsg(UID, 2, -1, 1118, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 1117, NPC, 4297, 529, 4296, 520);
	end
end

if (EVENT == 524) then
	ITEMD = HowmuchItem(UID, 889350000);
	if (ITEMD < 1) then
		SelectMsg(UID, 2, -1, 1120, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 1119, NPC, 4297, 530, 4296, 520);
	end
end

if (EVENT == 525) then  
	ITEME = HowmuchItem(UID, 889330000);
	if (ITEME < 1) then
		SelectMsg(UID, 2, -1, 1669, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 1668, NPC, 4297, 531, 4296, 520);
	end
end

if (EVENT == 526) then
	ITEMF = HowmuchItem(UID, 889360000);
	if (ITEMF < 1) then
		SelectMsg(UID, 2, -1, 1671, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 1670, NPC, 4297, 532, 4296, 520);
	end
end

if (EVENT == 527) then
	ITEMA = HowmuchItem(UID, 889310000);
	if (ITEMA < 1) then
		SelectMsg(UID, 2, -1, 1113, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
			
		else
			RobItem(UID, 889310000, 1);
			GiveItem(UID, 389310000, 1);
			SelectMsg(UID, 2, -1, 1114, NPC, 27, -1);
		end
	end
end

if (EVENT == 528) then
	ITEMB = HowmuchItem(UID, 889320000);
	if (ITEMB < 1) then
		SelectMsg(UID, 2, -1, 1116, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 889320000, 1);
			GiveItem(UID, 389320000, 1);
			SelectMsg(UID, 2, -1, 1114, NPC, 27, -1);
		end
	end
end

if (EVENT == 529) then
	ITEMC = HowmuchItem(UID, 889340000);
	if (ITEMC < 1) then
		SelectMsg(UID, 2, -1, 1118, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 889340000, 1);
			GiveItem(UID, 389340000, 1);
			SelectMsg(UID, 2, -1, 1114, NPC, 27, -1);
		end
	end
end

if (EVENT == 530) then
	ITEMD = HowmuchItem(UID, 889350000);
	if (ITEMD < 1) then
		SelectMsg(UID, 2, -1, 1120, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 889350000, 1);
			GiveItem(UID, 389350000, 1);
			SelectMsg(UID, 2, -1, 1114, NPC, 27, -1);
		end
	end
end

if (EVENT == 531) then
	ITEME = HowmuchItem(UID, 889330000);
	if (ITEME < 1) then
		SelectMsg(UID, 2, -1, 1669, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then 
		else
			RobItem(UID, 889330000, 1);
			GiveItem(UID, 389330000, 1);
			SelectMsg(UID, 2, -1, 1114, NPC, 27, -1);
		end
	end
end

if (EVENT == 532) then
	ITEMF = HowmuchItem(UID, 889360000);
	if (ITEMF < 1) then
		SelectMsg(UID, 2, -1, 1671, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 889360000, 1);
			GiveItem(UID, 389360000, 1);
			SelectMsg(UID, 2, -1, 1114, NPC, 27, -1);
		end
	end
end

if (EVENT == 200) then
	NCS = HowmuchItem(UID, 800032000);
	if (NCS < 1) then
		SelectMsg(UID, 2, -1, 4454, NPC, 18, 5000);
	else
		SendNameChange(UID);
	end
end

if (EVENT == 300) then
	REDIST = HowmuchItem(UID, 700001000);
	if (REDIST > 0) then
		SelectMsg(UID, 2, -1, 4456, NPC, 4189, 301, 4190, 302);
	else
		SelectMsg(UID, 2, -1, 4455, NPC, 18, 5000);
	end
end

if (EVENT == 301) then
	REDIST = HowmuchItem(UID, 700001000);
	if (REDIST < 1) then 
		SelectMsg(UID, 2, -1, 4455, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 4456, NPC, 3000, 303, 3005, -1);
	end
end

if (EVENT == 302) then
	REDIST = HowmuchItem(UID, 700001000);
	if (REDIST < 1) then 
		SelectMsg(UID, 2, -1, 4455, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 4456, NPC, 3000, 304, 3005, -1);
	end
end


if (EVENT == 303) then
	REDIST = HowmuchItem(UID, 700001000);
	if (REDIST < 1) then 
		SelectMsg(UID, 2, -1, 4455, NPC, 18, 5000);
	else
		ResetSkillPoints(UID);
	end
end

if (EVENT == 304) then
	REDIST = HowmuchItem(UID, 700001000);
	if (REDIST < 1) then 
		SelectMsg(UID, 2, -1, 4455, NPC, 18, 5000);
	else
		ResetStatPoints(UID);
	end
end

if (EVENT == 400) then
	SelectMsg(UID, 2,-1, 4457, NPC, 10, -1);
end

if (EVENT == 500) then
	SelectMsg(UID, 2, -1, 4462, NPC, 10, -1);
end

if (EVENT == 600) then
	CLANNCS = HowmuchItem(UID, 800086000);
	if (CLANNCS < 1) then
		SelectMsg(UID, 2, -1, 4670, NPC, 18, 5000);
	else
		Check = isClanLeader(UID)
		if (Check) then 
			SendClanNameChange(UID);
		else
			SelectMsg(UID, 2, -1, 4671, NPC, 10, -1);
		end
	end
end

if (EVENT == 700) then
	SelectMsg(UID, 2, -1, 4456, NPC, 10, -1);
end

if (EVENT == 701) then
	REDIST = HowmuchItem(UID, 700008000);
	if (REDIST < 1) then 
		SelectMsg(UID, 2, -1, 4455, NPC, 18, 5000);
	else
		ResetSkillPoints(UID);
		RobItem(UID, 700008000, 1);
	end
end

if (EVENT == 702) then
	REDIST = HowmuchItem(UID, 700008000);
	if (REDIST < 1) then 
		SelectMsg(UID, 2, -1, 4455, NPC, 18, 5000);
	else
		ResetStatPoints(UID);
		RobItem(UID, 700008000, 1);
	end
end

if (EVENT == 850) then
	SelectMsg(UID, 3, -1, 8973, NPC, 7040, 1007, 7055, 720,4504,794);
end

if (EVENT == 721) then
	SelectMsg(UID, 11, -1, 4432, NPC);
end

if (EVENT == 720) then
	SelectMsg(UID, 3, -1, 4914, NPC, 4285, 721, 4286, 722, 4287, 723, 4420, 724, 4421, 725, 4589, 726, 4588, 727,7065,728,7064,729,27, -1);
end

if (EVENT == 722) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4288, 730, 4289, 731, 4290, 732, 4291, 733,4296,720);
	else
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
	end
end

if (EVENT == 723) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4292, 734, 4293, 735, 4294, 736, 4295, 737,4296,720);
	else
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
	end
end

if (EVENT == 724) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4288, 738, 4289, 739, 4290, 740, 4291, 741,4296,720);
	else
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
	end
end

if (EVENT == 725) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4292, 742, 4293, 743, 4294, 744, 4295, 745,4296,720);
	else
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
	end
end

if (EVENT == 726) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4288, 746, 4289, 747, 4290, 748, 4291, 749,4296,720);
	else
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
	end
end

if (EVENT == 727) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4292, 750, 4293, 751, 4294, 752, 4295, 753,4296,720);
	else
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
	end
end

if (EVENT == 728) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4288, 754, 4289, 755, 4290, 756, 4291, 757,4296,720);
	else
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
	end
end

if (EVENT == 729) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4292, 758, 4293, 759, 4294, 760, 4295, 761,4296,720);
	else
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
	end
end

if (EVENT == 730) then
	SelectMsg(UID, 2, -1, 4903, NPC, 4297, 762,4296,722);
end

if (EVENT == 731) then
	SelectMsg(UID, 2, -1, 4904, NPC, 4297, 763,4296,722);
end

if (EVENT == 732) then
	SelectMsg(UID, 2, -1, 4905, NPC, 4297, 764,4296,722);
end

if (EVENT == 733) then
	SelectMsg(UID, 2, -1, 4906, NPC, 4297, 765,4296,722);
end

if (EVENT == 734) then
	SelectMsg(UID, 2, -1, 4907, NPC, 4297, 766,4296,723);
end

if (EVENT == 735) then
	SelectMsg(UID, 2, -1, 4908, NPC, 4297, 767,4296,723);
end

if (EVENT == 736) then
	SelectMsg(UID, 2, -1, 4909, NPC, 4297, 768,4296,723);
end

if (EVENT == 737) then
	SelectMsg(UID, 2, -1, 4910, NPC, 4297, 769,4296,723);
end

if (EVENT == 738) then
	SelectMsg(UID, 2, -1, 6489, NPC, 4297, 770,4296,724);
end

if (EVENT == 739) then
	SelectMsg(UID, 2, -1, 6490, NPC, 4297, 771,4296,724);
end

if (EVENT == 740) then
	SelectMsg(UID, 2, -1, 6491, NPC, 4297, 772,4296,724);
end

if (EVENT == 741) then
	SelectMsg(UID, 2, -1, 6492, NPC, 4297, 773,4296,724);
end

if (EVENT == 742) then
	SelectMsg(UID, 2, -1, 6493, NPC, 4297, 774,4296,725);
end

if (EVENT == 743) then
	SelectMsg(UID, 2, -1, 6494, NPC, 4297, 775,4296,725);
end

if (EVENT == 744) then
	SelectMsg(UID, 2, -1, 6495, NPC, 4297, 776,4296,725);
end

if (EVENT == 745) then
	SelectMsg(UID, 2, -1, 6496, NPC, 4297, 777,4296,725);
end

if (EVENT == 746) then
	SelectMsg(UID, 2, -1, 1127, NPC, 4297, 778,4296,726);
end

if (EVENT == 747) then
	SelectMsg(UID, 2, -1, 1128, NPC, 4297, 779,4296,726);
end

if (EVENT == 748) then
	SelectMsg(UID, 2, -1, 1129, NPC, 4297, 780,4296,726);
end

if (EVENT == 749) then
	SelectMsg(UID, 2, -1, 1130, NPC, 4297, 781,4296,726);
end

if (EVENT == 750) then
	SelectMsg(UID, 2, -1, 1131, NPC, 4297, 782,4296,727);
end

if (EVENT == 751) then
	SelectMsg(UID, 2, -1, 1132, NPC, 4297, 783,4296,727);
end

if (EVENT == 752) then
	SelectMsg(UID, 2, -1, 1133, NPC, 4297, 784,4296,727);
end

if (EVENT == 753) then
	SelectMsg(UID, 2, -1, 1134, NPC, 4297, 785,4296,727);
end

if (EVENT == 754) then
	SelectMsg(UID, 2, -1, 9058, NPC, 4297, 786,4296,728);
end

if (EVENT == 755) then
	SelectMsg(UID, 2, -1, 9059, NPC, 4297, 787,4296,728);
end

if (EVENT == 756) then
	SelectMsg(UID, 2, -1, 9060, NPC, 4297, 788,4296,728);
end

if (EVENT == 757) then
	SelectMsg(UID, 2, -1, 9061, NPC, 4297, 789,4296,728);
end

if (EVENT == 758) then
	SelectMsg(UID, 2, -1, 9062, NPC, 4297, 790,4296,729);
end

if (EVENT == 759) then
	SelectMsg(UID, 2, -1, 9063, NPC, 4297, 791,4296,729);
end

if (EVENT == 760) then
	SelectMsg(UID, 2, -1, 9064, NPC, 4297, 792,4296,729);
end

if (EVENT == 761) then
	SelectMsg(UID, 2, -1, 9065, NPC, 4297, 793,4296,729);
end

if (EVENT == 762) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then		
        else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508011441, 1,30);
		end
	end
end

if (EVENT == 763) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
			
        else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508011442, 1,30);
		end
	end
end

if (EVENT == 764) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508011443, 1,30);
		end
	end
end

if (EVENT == 765) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508011444, 1,30);
		end
	end
end

if (EVENT == 766) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508013318, 1,30);
		end
	end
end

if (EVENT == 767) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508013319, 1,30);
		end
	end
end

if (EVENT == 768) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508013320, 1,30);
		end
	end
end

if (EVENT == 769) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508013321, 1,30);
		end
	end
end

if (EVENT == 770) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508471453, 1,30);
		end
	end
end

if (EVENT == 771) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508471454, 1,30);
		end
	end
end

if (EVENT == 772) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508471455, 1,30);
		end
	end
end

if (EVENT == 773) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508471456, 1,30);
		end
	end
end
--MINERVAHELMET
if (EVENT == 774) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508473453, 1,30);
		end
	end
end

if (EVENT == 775) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508473454, 1,30);
		end
	end
end

if (EVENT == 776) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508473455, 1,30);
		end
	end
end

if (EVENT == 777) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508473456, 1,30);
		end
	end
end

if (EVENT == 778) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508051466, 1,30);
		end
	end
end

if (EVENT == 779) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508051467, 1,30);
		end
	end
end

if (EVENT == 780) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508051468, 1,30);
		end
	end
end

if (EVENT == 781) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508051469, 1,30);
		end
	end
end

if (EVENT == 782) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508053466, 1,30);
		end
	end
end

if (EVENT == 783) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508053467, 1,30);
		end
	end
end

if (EVENT == 784) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508053468, 1,30);
		end
	end
end

if (EVENT == 785) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508053469, 1,30);
		end
	end
end

if (EVENT == 786) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508066591, 1,30);
		end
	end
end

if (EVENT == 787) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508066592, 1,30);
		end
	end
end

if (EVENT == 788) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508066593, 1,30);
		end
	end
end

if (EVENT == 789) then
	MINERVAARMOR = HowmuchItem(UID, 508057000);
	if (MINERVAARMOR == 0) then
		SelectMsg(UID, 2, -1, 8984, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508057000, 1);
			GiveItem(UID, 508066594, 1,30);
		end
	end
end

if (EVENT == 790) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508065591, 1,30);
		end
	end
end

if (EVENT == 791) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508065592, 1,30);
		end
	end
end

if (EVENT == 792) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508065593, 1,30);
		end
	end
end

if (EVENT == 793) then
	MINERVAHELMET = HowmuchItem(UID, 508056000);
	if (MINERVAHELMET == 0) then
		SelectMsg(UID, 2, -1, 8985, NPC, 4080, -1);
    else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 508056000, 1);
			GiveItem(UID, 508065594, 1,30);
		end
	end
end

if (EVENT == 794) then
	PATHOSGLOVE = HowmuchItem(UID, 800250000);
	if (PATHOSGLOVE > 0) then
		SelectMsg(UID, 3, -1, 748, NPC, 4509, 795, 4510, 796,4296,700);
	else
		SelectMsg(UID, 2, -1, 749, NPC, 18, 5000);
	end
end

if (EVENT == 795) then
	SelectMsg(UID, 3, -1, 750, NPC, 4505, 797, 4506, 798, 4507, 799, 4508, 800,4296,794);
end

if (EVENT == 796) then
	SelectMsg(UID, 3, -1, 751, NPC, 4514, 801, 4515, 802, 4516, 803, 4517, 804,4296,794);
end

if (EVENT == 797) then
	SelectMsg(UID, 2, -1, 750, NPC, 4297, 805,4296,795);
end

if (EVENT == 798) then
	SelectMsg(UID, 2, -1, 750, NPC, 4297, 806,4296,795);
end

if (EVENT == 799) then
	SelectMsg(UID, 2, -1, 750, NPC, 4297, 807,4296,795);
end

if (EVENT == 800) then
	SelectMsg(UID, 2, -1, 750, NPC, 4297, 808,4296,795);
end

if (EVENT == 801) then
	SelectMsg(UID, 2, -1, 751, NPC, 4297, 809,4296,796);
end

if (EVENT == 802) then
	SelectMsg(UID, 2, -1, 751, NPC, 4297, 810,4296,796);
end

if (EVENT == 803) then
	SelectMsg(UID, 2, -1, 751, NPC, 4297, 811,4296,796);
end

if (EVENT == 804) then
	SelectMsg(UID, 2, -1, 751, NPC, 4297, 812,4296,796);
end

if (EVENT == 805) then
	PATHOSGLOVE = HowmuchItem(UID, 800250000);
	if (PATHOSGLOVE == 0) then
		SelectMsg(UID, 2, -1, 749, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800250000, 1);
			GiveItem(UID, 502573462, 1,30);
			SelectMsg(UID, 2, -1, 752, NPC, 27, -1);
		end
	end
end

if (EVENT == 806) then
	PATHOSGLOVE = HowmuchItem(UID, 800250000);
	if (PATHOSGLOVE == 0) then
		SelectMsg(UID, 2, -1, 749, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800250000, 1);
			GiveItem(UID, 503573463, 1,30);
			SelectMsg(UID, 2, -1, 752, NPC, 27, -1);
		end
	end
end

if (EVENT == 807) then
	PATHOSGLOVE = HowmuchItem(UID, 800250000);
	if (PATHOSGLOVE == 0) then
		SelectMsg(UID, 2, -1, 749, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800250000, 1);
			GiveItem(UID , 504573464, 1,30);
			SelectMsg(UID, 2, -1, 752, NPC, 27, -1);
		end
	end
end

if (EVENT == 808) then
	PATHOSGLOVE = HowmuchItem(UID, 800250000);
	if (PATHOSGLOVE == 0) then
		SelectMsg(UID, 2, -1, 749, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800250000, 1);
			GiveItem(UID, 505573465, 1,30);
			SelectMsg(UID, 2, -1, 752, NPC, 27, -1);
		end
	end
end

if (EVENT == 809) then
	PATHOSGLOVE = HowmuchItem(UID, 800250000);
	if (PATHOSGLOVE == 0) then
		SelectMsg(UID, 2, -1, 749, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800250000, 1);
			GiveItem(UID, 511573471, 1,30);
			SelectMsg(UID, 2, -1, 752, NPC, 27, -1);
		end
	end
end

if (EVENT == 810) then
	PATHOSGLOVE = HowmuchItem(UID, 800250000);
	if (PATHOSGLOVE == 0) then
		SelectMsg(UID, 2, -1, 749, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800250000, 1);
			GiveItem(UID, 512573472, 1,30);
			SelectMsg(UID, 2, -1, 752, NPC, 27, -1);
		end
	end
end

if (EVENT == 811) then
	PATHOSGLOVE = HowmuchItem(UID, 800250000);
	if (PATHOSGLOVE == 0) then
		SelectMsg(UID, 2, -1, 749, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800250000, 1);
			GiveItem(UID , 513573473, 1,30);
			SelectMsg(UID, 2, -1, 752, NPC, 27, -1);
		end
	end
end

if (EVENT == 812) then
	PATHOSGLOVE = HowmuchItem(UID, 800250000);
	if (PATHOSGLOVE == 0) then
		SelectMsg(UID, 2, -1, 749, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800250000, 1);
			GiveItem(UID, 514573474, 1,30);
			SelectMsg(UID, 2, -1, 752, NPC, 27, -1);
		end
	end
end

if (EVENT == 1007) then
	SelectMsg(UID, 3, -1, 4901, NPC,4286, 1008, 4287, 1009, 4420, 1010, 4421, 1011, 4589, 1012, 4588, 1013);
end

if (EVENT == 1008) then
	VALARMOR = HowmuchItem(UID, 800180000);
	if (VALARMOR > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4288, 1014, 4289, 1015, 4290, 1016, 4291, 1017);
	else
		SelectMsg(UID, 2, -1, 4921, NPC, 18, 5000);
	end
end

if (EVENT == 1009) then
	VALHELMET = HowmuchItem(UID, 800170000);
	if (VALHELMET > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4292, 1018, 4293, 1019, 4294, 1020, 4295, 1021);
	else
		SelectMsg(UID, 2, -1, 4911, NPC, 18, 5000);
	end
end

if (EVENT == 1010) then
	GRYPARMOR = HowmuchItem(UID, 800240000);
	if (GRYPARMOR > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4288, 1022, 4289, 1023, 4290, 1024, 4291, 1025);
	else
		SelectMsg(UID, 2, -1, 6488, NPC, 18, 5000);
	end
end

if (EVENT == 1011) then
	GRYPHELMET = HowmuchItem(UID, 800230000);
	if (GRYPHELMET > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4292, 1026, 4293, 1027, 4294, 1028, 4295, 1029);
	else
		SelectMsg(UID, 2, -1, 6497, NPC, 18, 5000);
	end
end

if (EVENT == 1012) then
	BAHAMUTARMOR = HowmuchItem(UID, 800270000);
	if (BAHAMUTARMOR > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4288, 1030, 4289, 1031, 4290, 1032, 4291, 1033);
	else
		SelectMsg(UID, 2, -1, 1126, NPC, 18, 5000);
	end
end

if (EVENT == 1013) then
	BAHAMUTHELMET = HowmuchItem(UID, 800260000);
	if (BAHAMUTHELMET > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4292, 1034, 4293, 1035, 4294, 1036, 4295, 1037);
	else
		SelectMsg(UID, 2, -1, 1126, NPC, 18, 5000);
	end
end

if (EVENT == 1014) then
	SelectMsg(UID, 2, -1, 4903, NPC, 4297, 1038,4296,1008);
end

if (EVENT == 1015) then
	SelectMsg(UID, 2, -1, 4904, NPC, 4297, 1039,4296,1008);
end

if (EVENT == 1016) then
	SelectMsg(UID, 2, -1, 4905, NPC, 4297, 1040,4296,1008);
end

if (EVENT == 1017) then
	SelectMsg(UID, 2, -1, 4906, NPC, 4297, 1041,4296,1008);
end

if (EVENT == 1018) then
	SelectMsg(UID, 2, -1, 4907, NPC, 4297, 1042,4296,1009);
end

if (EVENT == 1019) then
	SelectMsg(UID, 2, -1, 4908, NPC, 4297, 1043,4296,1009);
end

if (EVENT == 1020) then
	SelectMsg(UID, 2, -1, 4909, NPC, 4297, 1044,4296,1009);
end

if (EVENT == 1021) then
	SelectMsg(UID, 2, -1, 4910, NPC, 4297, 1045,4296,1009);
end

if (EVENT == 1022) then
	SelectMsg(UID, 2, -1, 6489, NPC, 4297, 1046,4296,1010);
end

if (EVENT == 1023) then
	SelectMsg(UID, 2, -1, 6490, NPC, 4297, 1047,4296,1010);
end

if (EVENT == 1024) then
	SelectMsg(UID, 2, -1, 6491, NPC, 4297, 1048,4296,1010);
end

if (EVENT == 1025) then
	SelectMsg(UID, 2, -1, 6492, NPC, 4297, 1049,4296,1010);
end

if (EVENT == 1026) then
	SelectMsg(UID, 2, -1, 6493, NPC, 4297, 1050,4296,1011);
end

if (EVENT == 1027) then
	SelectMsg(UID, 2, -1, 6494, NPC, 4297, 1051,4296,1011);
end

if (EVENT == 1028) then
	SelectMsg(UID, 2, -1, 6495, NPC, 4297, 1052,4296,1011);
end

if (EVENT == 1029) then
	SelectMsg(UID, 2, -1, 6496, NPC, 4297, 1053,4296,1011);
end

if (EVENT == 1030) then
	SelectMsg(UID, 2, -1, 1127, NPC, 4297, 1054,4296,1012);
end

if (EVENT == 1031) then
	SelectMsg(UID, 2, -1, 1128, NPC, 4297, 1055,4296,1012);
end

if (EVENT == 1032) then
	SelectMsg(UID, 2, -1, 1129, NPC, 4297, 1056,4296,1012);
end

if (EVENT == 1033) then
	SelectMsg(UID, 2, -1, 1130, NPC, 4297, 1057,4296,1012);
end

if (EVENT == 1034) then
	SelectMsg(UID, 2, -1, 1131, NPC, 4297, 1058,4296,1013);
end

if (EVENT == 1035) then
	SelectMsg(UID, 2, -1, 1132, NPC, 4297, 1059,4296,1013);
end

if (EVENT == 1036) then
	SelectMsg(UID, 2, -1, 1133, NPC, 4297, 1060,4296,1013);
end

if (EVENT == 1037) then
	SelectMsg(UID, 2, -1, 1134, NPC, 4297, 1061,4296,1013);
end

if (EVENT == 1038) then
	VALARMOR = HowmuchItem(UID, 800180000);
	if (VALARMOR == 0) then
		SelectMsg(UID, 2, -1, 4921, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800180000, 1);
			GiveItem(UID, 508011441, 1,30);
		end
	end
end

if (EVENT == 1039) then
	VALARMOR = HowmuchItem(UID, 800180000);
	if (VALARMOR == 0) then
		SelectMsg(UID, 2, -1, 4921, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800180000, 1);
			GiveItem(UID, 508011442, 1,30);
		end
	end
end

if (EVENT == 1040) then
	VALARMOR = HowmuchItem(UID, 800180000);
	if (VALARMOR == 0) then
		SelectMsg(UID, 2, -1, 4921, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800180000, 1);
			GiveItem(UID, 508011443, 1,30);
		end
	end
end

if (EVENT == 1041) then
	VALARMOR = HowmuchItem(UID, 800180000);
	if (VALARMOR == 0) then
		SelectMsg(UID, 2, -1, 4921, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800180000, 1);
			GiveItem(UID, 508011444, 1,30);
		end
	end
end

if (EVENT == 1042) then
	VALHELMET = HowmuchItem(UID, 800170000);
	if (VALHELMET == 0) then
		SelectMsg(UID, 2, -1, 4911, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800170000, 1);
			GiveItem(UID, 508013318, 1,30);
		end
	end
end

if (EVENT == 1043) then
	VALHELMET = HowmuchItem(UID, 800170000);
	if (VALHELMET == 0) then
		SelectMsg(UID, 2, -1, 4911, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800170000, 1);
			GiveItem(UID, 508013319, 1,30);
		end
	end
end

if (EVENT == 1044) then
	VALHELMET = HowmuchItem(UID, 800170000);
	if (VALHELMET == 0) then
		SelectMsg(UID, 2, -1, 4911, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800170000, 1);
			GiveItem(UID, 508013320, 1,30);
		end
	end
end

if (EVENT == 1045) then
	VALHELMET = HowmuchItem(UID, 800170000);
	if (VALHELMET == 0) then
		SelectMsg(UID, 2, -1, 4911, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800170000, 1);
			GiveItem(UID, 508013321, 1,30);
		end
	end
end

if (EVENT == 1046) then
	GRYPARMOR = HowmuchItem(UID, 800240000);
	if (GRYPARMOR == 0) then
		SelectMsg(UID, 2, -1, 6488, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800240000, 1);
			GiveItem(UID, 508471453, 1,30);
		end
	end
end

if (EVENT == 1047) then
	GRYPARMOR = HowmuchItem(UID, 800240000);
	if (GRYPARMOR == 0) then
		SelectMsg(UID, 2, -1, 6488, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800240000, 1);
			GiveItem(UID, 508471454, 1,30);
		end
	end
end

if (EVENT == 1048) then
	GRYPARMOR = HowmuchItem(UID, 800240000);
	if (GRYPARMOR == 0) then
		SelectMsg(UID, 2, -1, 6488, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800240000, 1);
			GiveItem(UID, 508471455, 1,30);
		end
	end
end

if (EVENT == 1049) then
	GRYPARMOR = HowmuchItem(UID, 800240000);
	if (GRYPARMOR == 0) then
		SelectMsg(UID, 2, -1, 6488, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800240000, 1);
			GiveItem(UID, 508471456, 1,30);
		end
	end
end

if (EVENT == 1050) then
	GRYPHELMET = HowmuchItem(UID, 800230000);
	if (GRYPHELMET == 0) then
		SelectMsg(UID, 2, -1, 6497, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800230000, 1);
			GiveItem(UID, 508473453, 1,30);
		end
	end
end

if (EVENT == 1051) then
	GRYPHELMET = HowmuchItem(UID, 800230000);
	if (GRYPHELMET == 0) then
		SelectMsg(UID, 2, -1, 6497, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800230000, 1);
			GiveItem(UID, 508473454, 1,30);
		end
	end
end

if (EVENT == 1052) then
	GRYPHELMET = HowmuchItem(UID, 800230000);
	if (GRYPHELMET == 0) then
		SelectMsg(UID, 2, -1, 6497, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800230000, 1);
			GiveItem(UID, 508473455, 1,30);
		end
	end
end

if (EVENT == 1053) then
	GRYPHELMET = HowmuchItem(UID, 800230000);
	if (GRYPHELMET == 0) then
		SelectMsg(UID, 2, -1, 6497, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800230000, 1);
			GiveItem(UID, 508473456, 1,30);
		end
	end
end

if (EVENT == 1054) then
	BAHAMUTARMOR = HowmuchItem(UID, 800270000);
	if (BAHAMUTARMOR == 0) then
		SelectMsg(UID, 2, -1, 1126, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800270000, 1);
			GiveItem(UID, 508051466, 1,30);
		end
	end
end

if (EVENT == 1055) then
	BAHAMUTARMOR = HowmuchItem(UID, 800270000);
	if (BAHAMUTARMOR == 0) then
		SelectMsg(UID, 2, -1, 1126, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800270000, 1);
			GiveItem(UID, 508051467, 1,30);
		end
	end
end

if (EVENT == 1056) then
	BAHAMUTARMOR = HowmuchItem(UID, 800270000);
	if (BAHAMUTARMOR == 0) then
		SelectMsg(UID, 2, -1, 1126, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800270000, 1);
			GiveItem(UID, 508051468, 1,30);
		end
	end
end

if (EVENT == 1057) then
	BAHAMUTARMOR = HowmuchItem(UID, 800270000);
	if (BAHAMUTARMOR == 0) then
		SelectMsg(UID, 2, -1, 1126, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800270000, 1);
			GiveItem(UID, 508051469, 1,30);
		end
	end
end

if (EVENT == 1058) then
	BAHAMUTHELMET = HowmuchItem(UID, 800260000);
	if (BAHAMUTHELMET == 0) then
		SelectMsg(UID, 2, -1, 1126, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then 
		else
			RobItem(UID, 800260000, 1);
			GiveItem(UID, 508053466, 1,30);
		end
	end
end

if (EVENT == 1059) then
	BAHAMUTHELMET = HowmuchItem(UID, 800260000);
	if (BAHAMUTHELMET == 0) then
		SelectMsg(UID, 2, -1, 1126, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800260000, 1);
			GiveItem(UID, 508053467, 1,30);
		end
	end
end

if (EVENT == 1060) then
	BAHAMUTHELMET = HowmuchItem(UID, 800260000);
	if (BAHAMUTHELMET == 0) then
		SelectMsg(UID, 2, -1, 1126, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800260000, 1);
			GiveItem(UID, 508053468, 1,30);
		end
	end
end

if (EVENT == 1061) then
	BAHAMUTHELMET = HowmuchItem(UID, 800260000);
	if (BAHAMUTHELMET == 0) then
		SelectMsg(UID, 2, -1, 1126, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 800260000, 1);
			GiveItem(UID, 508053469, 1,30);
		end
	end
end

if (EVENT == 650) then
	EVENTKARIBEDIS = HowmuchItem(UID, 810191000);
	if (EVENTKARIBEDIS > 0) then
		SelectMsg(UID, 3, -1, 106, NPC, 4403, 651, 4404, 652, 4479, 653);
	else
		SelectMsg(UID, 2, -1, 8092, NPC, 10, -1);
	end
end

if (EVENT == 651) then
	SelectMsg(UID, 2, -1, 8093, NPC, 4230, 654, 3005, -1);
end

if (EVENT == 652) then
	SelectMsg(UID, 2, -1, 8095, NPC, 4230, 655, 3005, -1);
end

if (EVENT == 653) then
	SelectMsg(UID, 2, -1, 8102, NPC, 4230, 656, 3005, -1);
end

if (EVENT == 654) then
	EVENTKARIBEDIS = HowmuchItem(UID, 810191000);
	if (EVENTKARIBEDIS < 1) then
		SelectMsg(UID, 2, -1, 8092, NPC, 10, -1);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
			
        else
			RobItem(UID, 810191000, 1);
			GiveItem(UID, 700002000, 1);
			SelectMsg(UID, 2, -1 , 8094, NPC, 27, -1);
		end
	end
end
if (EVENT == 655) then
	EVENTKARIBEDIS = HowmuchItem(UID, 810191000);
	if (EVENTKARIBEDIS == 0) then
		SelectMsg(UID, 2, -1, 8092, NPC, 10, -1);
	else
		SlotCheck = CheckGiveSlot(UID, 4)
		if SlotCheck == false then
			
        else
			RobItem(UID, 810191000,1);
			GiveItem(UID, 379258000,1);
			GiveItem(UID, 379258000,1);
			GiveItem(UID, 379258000,1);
			GiveItem(UID, 379258000,1);
			SelectMsg(UID, 2, -1 , 8094, NPC, 27, -1);
		end
	end
end

if (EVENT == 656) then
	EVENTKARIBEDIS = HowmuchItem(UID, 810191000);
	if (EVENTKARIBEDIS == 0) then
		SelectMsg(UID, 2, -1, 8092, NPC, 10, -1);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
			
        else
			RobItem(UID, 810191000,1);
			GiveItem(UID, 700001000,1);
			SelectMsg(UID, 2, -1 , 8094, NPC, 27, -1);
		end
	end
end

if (EVENT == 1500) then
	SelectMsg(UID, 3, -1, 50000, NPC, 49000, 1501, 49001, 1502, 49002, 1503, 49003, 1504, 49004, 1505,49005,1506);
end

if (EVENT == 1501) then
	ITEMA = HowmuchItem(UID, 700082000);
	if (ITEMA == 0) then
		SelectMsg(UID, 2, -1, 44302, NPC, 40326, -1);
	else
		SelectMsg(UID, 2, -1, 44303, NPC, 40326, -1);
		RobItem(UID,700082000,1);
		GiveCash(UID,100);
	end
end

if (EVENT == 1502) then
	ITEMA = HowmuchItem(UID, 700083000);
	if (ITEMA == 0) then
		SelectMsg(UID, 2, -1, 44302, NPC, 40326, -1);
	else
		SelectMsg(UID, 2, -1, 44303, NPC, 40326, -1);
		RobItem(UID,700083000,1);
		GiveCash(UID,250);
	end
end

if (EVENT == 1503) then
	ITEMA = HowmuchItem(UID, 700084000);
	if (ITEMA == 0) then
		SelectMsg(UID, 2, -1, 44302, NPC, 40326, -1);
	else
		SelectMsg(UID, 2, -1, 44303, NPC, 40326, -1);
		RobItem(UID,700084000,1);
		GiveCash(UID,500);
	end
end

if (EVENT == 1504) then
	ITEMA = HowmuchItem(UID, 700085000);
	if (ITEMA == 0) then
		SelectMsg(UID, 2, -1, 44302, NPC, 40326, -1);
	else
		SelectMsg(UID, 2, -1, 44303, NPC, 40326, -1);
		RobItem(UID,700085000,1);
		GiveCash(UID,1000);
	end
end

if (EVENT == 1505) then
	ITEMA = HowmuchItem(UID, 700086000);
	if (ITEMA == 0) then
		SelectMsg(UID, 2, -1, 44302, NPC, 40326, -1);
	else
		SelectMsg(UID, 2, -1, 44303, NPC, 40326, -1);
		RobItem(UID,700086000,1);
		GiveCash(UID,2500);
	end
end

if (EVENT == 1506) then
	ITEMA = HowmuchItem(UID, 900086000);
	if (ITEMA == 0) then
		SelectMsg(UID, 2, -1, 44302, NPC, 40326, -1);
	else
		SelectMsg(UID, 2, -1, 44303, NPC, 40326, -1);
		RobItem(UID,900086000,1);
		GiveCash(UID,2500);
	end
end

if (EVENT == 5000) then
	ShowMap(UID, 450);
end