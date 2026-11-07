-- =============================================
-- Create date: 29.04.2020
-- Update date: 24.05.2020
-- =============================================
local NPC = 29235;

if (EVENT == 100) then
	SelectMsg(UID, 3, -1, 11624, NPC,8365,101,8534,300,8603,500,7582,600,9018,650,40389,800, 7027, 242, 7028, 243, 40815, 251, 40819, 815);
end

if (EVENT == 101) then
	SelectMsg(UID, 3, -1, 11624, NPC,8749,102,9001,106,8473,117,8290,130,8359,170,8360,180,8479,190,8466,200,8467,210);
end

if (EVENT == 102) then
	SelectMsg(UID, 3, -1, 12494, NPC,40613,103,40614,104,40615,105,40745,232);
end

if (EVENT == 103) then
	EMBLEM = HowmuchItem(UID, 914042000);
	if (EMBLEM < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 914042000,1);
		GiveItem(UID, 914041877,1,1);
    	end
    end
end


if (EVENT == 104) then
	EMBLEM = HowmuchItem(UID, 914044000);
	if (EMBLEM < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 914044000,1);
		GiveItem(UID, 914041877,1,7);
    	end
    end
end

if (EVENT == 105) then
	EMBLEM = HowmuchItem(UID, 914046000);
	if (EMBLEM < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 914046000,1);
		GiveItem(UID, 914041877,1,30);
    	end
    end
end

if (EVENT == 232) then
	SelectMsg(UID, 3, -1, 12494, NPC,40746, 230, 40747, 231);
end


if (EVENT == 230) then
	EMBLEM = HowmuchItem(UID, 914052000);
	if (EMBLEM < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 914052000,1);
		GiveItem(UID, 914053879,1,30);
    	end
    end
end

if (EVENT == 231) then
	EMBLEM = HowmuchItem(UID, 914052000);
	if (EMBLEM < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 914052000,1);
		GiveItem(UID, 914054880,1,30);
    	end
    end
end



if (EVENT == 106) then
	SelectMsg(UID, 3, -1, 12446, NPC,9003,107,9004,108,9005,109,9006,110,9007,111,9008,112,9009,113,9010,114,9011,115,9012,116);
end

if (EVENT == 107) then -- Dark Knight Dagger +1
	CHEST = HowmuchItem(UID, 810635000, 1);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 12447, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810635000,1);
		GiveItem(UID, 1111466741,1);
    	end
    end
end

if (EVENT == 108) then -- Dark Knight Axe +1
	CHEST = HowmuchItem(UID, 810635000, 1);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 12447, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810635000,1);
		GiveItem(UID, 1111473741,1);
    	end
    end
end

if (EVENT == 109) then -- Dark Knight Spear +1
	CHEST = HowmuchItem(UID, 810635000, 1);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 12447, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810635000,1);
		GiveItem(UID, 1111468741,1);
    	end
    end
end

if (EVENT == 110) then -- Dark Knight Crossbow +1
	CHEST = HowmuchItem(UID, 810635000, 1);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 12447, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810635000,1);
		GiveItem(UID, 1111469741,1);
    	end
    end
end

if (EVENT == 111) then -- Fire Dark Knight Staff +1
	CHEST = HowmuchItem(UID, 810635000, 1);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 12447, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810635000,1);
		GiveItem(UID, 1111470561,1);
    	end
    end
end

if (EVENT == 112) then -- Ice Dark Knight Staff +1
	CHEST = HowmuchItem(UID, 810635000, 1);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 12447, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810635000,1);
		GiveItem(UID, 1111470571,1);
    	end
    end
end

if (EVENT == 113) then -- Lightning Dark Knight Staff +1
	CHEST = HowmuchItem(UID, 810635000, 1);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 12447, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810635000,1);
		GiveItem(UID, 1111470581,1);
    	end
    end
end

if (EVENT == 114) then -- Dark Knight Mace +1
	CHEST = HowmuchItem(UID, 810635000, 1);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 12447, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810635000,1);
		GiveItem(UID, 1111471741,1);
    	end
    end
end

if (EVENT == 115) then -- Dark Knight Shield +1
	CHEST = HowmuchItem(UID, 810635000, 1);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 12447, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810635000,1);
		GiveItem(UID, 1111472741,1);
    	end
    end
end

if (EVENT == 116) then -- Dark Knight Jamadar +1
	CHEST = HowmuchItem(UID, 810635000, 1);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 12447, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810635000,1);
		GiveItem(UID, 1111467741,1);
    	end
    end
end

if (EVENT == 117) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
        SelectMsg(UID, 3, -1, 11677, NPC, 8474,118,8475,119,8476,120,8477,121);
    	end
end

if (EVENT == 118) then
    SelectMsg(UID, 3, -1, 11677, NPC, 8443,211,8444,212,8445,213,8446,214,8447,215);
end

if (EVENT == 119) then
    SelectMsg(UID, 3, -1, 11677, NPC, 8448,216,8449,217,8450,218,8451,219,8452,220);
end

if (EVENT == 120) then
    SelectMsg(UID, 3, -1, 11677, NPC, 8453,221,8454,222,8455,223,8456,224,8457,225);
end

if (EVENT == 121) then
    SelectMsg(UID, 3, -1, 11677, NPC, 8458,226,8459,227,8460,228,8461,229,8462,230);
end

if (EVENT == 211) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 521511007,1);
    	end
    end
end

if (EVENT == 212) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 521512007,1);
    	end
    end
end

if (EVENT == 213) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 521513007,1);
    	end
    end
end

if (EVENT == 214) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 521514007,1);
    	end
    end
end

if (EVENT == 215) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 521515007,1);
    	end
    end
end

if (EVENT == 216) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 522511007,1);
    	end
    end
end

if (EVENT == 217) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 522512007,1);
    	end
    end
end

if (EVENT == 218) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 522513007,1);
    	end
    end
end

if (EVENT == 219) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 522514007,1);
    	end
    end
end

if (EVENT == 220) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 522515007,1);
    	end
    end
end

if (EVENT == 221) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 523511007,1);
    	end
    end
end

if (EVENT == 222) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 523512007,1);
    	end
    end
end

if (EVENT == 223) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 523513007,1);
    	end
    end
end

if (EVENT == 224) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 523514007,1);
    	end
    end
end

if (EVENT == 225) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 523515007,1);
    	end
    end
end

if (EVENT == 226) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 524511007,1);
    	end
    end
end

if (EVENT == 227) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 524512007,1);
    	end
    end
end

if (EVENT == 228) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 524513007,1);
    	end
    end
end

if (EVENT == 229) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 524514007,1);
    	end
    end
end

if (EVENT == 230) then
	CHEST = HowmuchItem(UID, 900672000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 900672000,1);
		GiveItem(UID, 524515007,1);
    	end
    end
end
	
if (EVENT == 130) then
	SelectMsg(UID, 3, -1, 11624, NPC,8293,131,8465,132,9017,133);
end

if (EVENT == 131) then -- Wing of Hero
	WING = HowmuchItem(UID, 810251000);
	if (WING < 1) then
		SelectMsg(UID, 2, -1, 11739, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810251000,1);
		GiveItem(UID, 900030684,1,30);
    	end
    end
end

if (EVENT == 132) then -- Wing of Neophyte
	WING = HowmuchItem(UID, 900700000);
	if (WING < 1) then
		SelectMsg(UID, 2, -1, 11879, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900700000,1);
		GiveItem(UID, 900702863,1,30);
    	end
    end
end

if (EVENT == 133) then -- Wing of Hellfire
SelectMsg(UID,3,-1,12458,NPC,9021,134,40619,135,40620,136,9022,137,9023,138,9024,139,9025,168)
end

if (EVENT == 134) then
	WING = HowmuchItem(UID, 814062000);
	if (WING > 0) then
		SelectMsg(UID, 3, -1, 12458, NPC, 7786, 140, 7787, 141, 7788, 142, 7789, 143);
	else
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	end
end

if (EVENT == 135) then
	WING = HowmuchItem(UID, 810672000);
	if (WING > 0) then
		SelectMsg(UID, 3, -1, 12458, NPC, 7786, 144, 7787, 145, 7788, 146, 7789, 147);
	else
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	end
end

if (EVENT == 136) then
	WING = HowmuchItem(UID, 910939000);
	if (WING > 0) then
		SelectMsg(UID, 3, -1, 12458, NPC, 7786, 148, 7787, 149, 7788, 150, 7789, 151);
	else
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	end
end

if (EVENT == 137) then
	WING = HowmuchItem(UID, 810640000);
	if (WING > 0) then
		SelectMsg(UID, 3, -1, 12458, NPC, 7786, 152, 7787, 153, 7788, 154, 7789, 155);
	else
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	end
end

if (EVENT == 138) then
	WING = HowmuchItem(UID, 810641000);
	if (WING > 0) then
		SelectMsg(UID, 3, -1, 12458, NPC, 7786, 156, 7787, 157, 7788, 158, 7789, 159);
	else
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	end
end

if (EVENT == 139) then
	WING = HowmuchItem(UID, 810642000);
	if (WING > 0) then
		SelectMsg(UID, 3, -1, 12458, NPC, 7786, 160, 7787, 161, 7788, 162, 7789, 163);
	else
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	end
end

if (EVENT == 168) then
	WING = HowmuchItem(UID, 810643000);
	if (WING > 0) then
		SelectMsg(UID, 3, -1, 12458, NPC, 7786, 164, 7787, 165, 7788, 166, 7789, 167);
	else
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	end
end

if (EVENT == 140) then
	WING = HowmuchItem(UID, 814062000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 814062000, 1);
		GiveItem(UID, 810638711, 1,30);
		end
	end
end

if (EVENT == 141) then
	WING = HowmuchItem(UID, 814062000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 814062000, 1);
		GiveItem(UID, 810638712, 1,30);
		end
	end
end

if (EVENT == 142) then
	WING = HowmuchItem(UID, 814062000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 814062000, 1);
		GiveItem(UID, 810638730, 1,30);
		end
	end
end

if (EVENT == 143) then
	WING = HowmuchItem(UID, 814062000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 814062000, 1);
		GiveItem(UID, 810638731, 1,30);
		end
	end
end

if (EVENT == 144) then
	WING = HowmuchItem(UID, 810672000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810672000, 1);
		GiveItem(UID, 810638711, 1,1);
		end
	end
end

if (EVENT == 145) then
	WING = HowmuchItem(UID, 810672000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810672000, 1);
		GiveItem(UID, 810638712, 1,1);
		end
	end
end

if (EVENT == 146) then
	WING = HowmuchItem(UID, 810672000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810672000, 1);
		GiveItem(UID, 810638730, 1,1);
		end
	end
end

if (EVENT == 147) then
	WING = HowmuchItem(UID, 810672000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810672000, 1);
		GiveItem(UID, 810638731, 1,1);
		end
	end
end

if (EVENT == 148) then
	WING = HowmuchItem(UID, 910939000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 910939000, 1);
		GiveItem(UID, 810638711, 1,7);
		end
	end
end

if (EVENT == 149) then
	WING = HowmuchItem(UID, 910939000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 910939000, 1);
		GiveItem(UID, 810638712, 1,7);
		end
	end
end

if (EVENT == 150) then
	WING = HowmuchItem(UID, 910939000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 910939000, 1);
		GiveItem(UID, 810638730, 1,7);
		end
	end
end

if (EVENT == 151) then
	WING = HowmuchItem(UID, 910939000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 910939000, 1);
		GiveItem(UID, 810638731, 1,7);
		end
	end
end

if (EVENT == 152) then
	WING = HowmuchItem(UID, 810640000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810640000, 1);
		GiveItem(UID, 810638711, 1,15);
		end
	end
end

if (EVENT == 153) then
	WING = HowmuchItem(UID, 810640000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810640000, 1);
		GiveItem(UID, 810638712, 1,15);
		end
	end
end

if (EVENT == 154) then
	WING = HowmuchItem(UID, 810640000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810640000, 1);
		GiveItem(UID, 810638730, 1,15);
		end
	end
end

if (EVENT == 155) then
	WING = HowmuchItem(UID, 810640000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810640000, 1);
		GiveItem(UID, 810638731, 1,15);
		end
	end
end

if (EVENT == 156) then
	WING = HowmuchItem(UID, 810641000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810641000, 1);
		GiveItem(UID, 810638711, 1,30);
		end
	end
end

if (EVENT == 157) then
	WING = HowmuchItem(UID, 810641000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810641000, 1);
		GiveItem(UID, 810638712, 1,30);
		end
	end
end

if (EVENT == 158) then
	WING = HowmuchItem(UID, 810641000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810641000, 1);
		GiveItem(UID, 810638730, 1,30);
		end
	end
end

if (EVENT == 159) then
	WING = HowmuchItem(UID, 810641000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810641000, 1);
		GiveItem(UID, 810638731, 1,30);
		end
	end
end

if (EVENT == 160) then
	WING = HowmuchItem(UID, 810642000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810642000, 1);
		GiveItem(UID, 810638711, 1,90);
		end
	end
end

if (EVENT == 161) then
	WING = HowmuchItem(UID, 810642000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810642000, 1);
		GiveItem(UID, 810638712, 1,90);
		end
	end
end

if (EVENT == 162) then
	WING = HowmuchItem(UID, 810642000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810642000, 1);
		GiveItem(UID, 810638730, 1,90);
		end
	end
end

if (EVENT == 163) then
	WING = HowmuchItem(UID, 810642000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810642000, 1);
		GiveItem(UID, 810638731, 1,90);
		end
	end
end

if (EVENT == 164) then
	WING = HowmuchItem(UID, 810643000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810643000, 1);
		GiveItem(UID, 810638711, 1,180);
		end
	end
end

if (EVENT == 165) then
	WING = HowmuchItem(UID, 810643000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810643000, 1);
		GiveItem(UID, 810638712, 1,180);
		end
	end
end

if (EVENT == 166) then
	WING = HowmuchItem(UID, 810643000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810643000, 1);
		GiveItem(UID, 810638730, 1,180);
		end
	end
end

if (EVENT == 167) then
	WING = HowmuchItem(UID, 810643000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810643000, 1);
		GiveItem(UID, 810638731, 1,180);
		end
	end
end

if (EVENT == 170) then
	EMBLEM = HowmuchItem(UID, 900594000);
	if (EMBLEM < 1) then
		SelectMsg(UID, 2, -1, 11801, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900594000,1);
		GiveItem(UID, 900595860,30);
    	end
    end
end

if (EVENT == 180) then
	EMBLEM = HowmuchItem(UID, 900596000);
	if (EMBLEM < 1) then
		SelectMsg(UID, 2, -1, 11802, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900596000,1);
		GiveItem(UID, 900597861,30);
    	end
    end
end

if (EVENT == 190) then
	EMBLEM = HowmuchItem(UID, 900703000);
	if (EMBLEM < 1) then
		SelectMsg(UID, 2, -1, 11065, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900703000,1);
		GiveItem(UID, 900704864,30);
    	end
    end
end

if (EVENT == 200) then
	POT = HowmuchItem(UID, 889310000);
	if (POT < 1) then
		SelectMsg(UID, 2, -1, 11065, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 889310000,1);
		GiveItem(UID, 389310000,1);
    	end
    end
end

if (EVENT == 210) then
	POT = HowmuchItem(UID, 889340000);
	if (POT < 1) then
		SelectMsg(UID, 2, -1, 11065, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 889340000,1);
		GiveItem(UID, 389340000,1);
    	end
    end
end

if (EVENT == 300) then
SelectMsg(UID,3,-1,11972,NPC,6000,301,8535,302,8536,311)
end

if (EVENT == 301) then
SelectMsg(UID,3,-1,11973,NPC,6000,302,8535,310,8536,311)
end

if (EVENT == 302) then
SelectMsg(UID,3,-1,11974,NPC,3000,303,3005,-1,8536,311)
end

if (EVENT == 303) then
SelectMsg(UID,2,-1,11975,NPC,10,-1)
end

if (EVENT == 311) then
SelectMsg(UID,2,-1,11976,NPC,3000,303,3005,-1)
end

if (EVENT == 242) then -- HARF TOPLAMA ETKİNLİGİ
	HARF = HowmuchItem(UID, 800401000,10);
	HARF = HowmuchItem(UID, 800402000,10);
	HARF = HowmuchItem(UID, 800403000,10);
	HARF = HowmuchItem(UID, 800404000,10);
	HARF = HowmuchItem(UID, 800405000,10);
	HARF = HowmuchItem(UID, 800406000,10);
	
	if (HARF < 10) then
	SelectMsg(UID, 2, -1, 11063, NPC, 10);
		
	else
	RobItem(UID, 800401000,10)
	RobItem(UID, 800402000,10)
	RobItem(UID, 800403000,10)
	RobItem(UID, 800404000,10)
	RobItem(UID, 800405000,10)
	RobItem(UID, 800406000,10)
	GiveKnightCash(UID, 100)  -- 100 KNİGHT CASH
	SelectMsg(UID, 2, -1, 1114, NPC, 27);
	end
end

if (EVENT == 243) then -- Resurrection
SelectMsg(UID, 3, -1, 12448, NPC, 40808, 244, 40809, 245, 40810, 246, 40811, 247, 40812, 248);
end

if (EVENT == 244) then -- Resurrection Pink Wing (New Wing's)
	WING = HowmuchItem(UID, 507016000);
	if (WING < 1) then
	SelectMsg(UID, 2, -1, 11063, NPC, 10);	
	else
	RobItem(UID, 507016000, 1)
	GiveItem(UID, 910258753, 1, 30)
	SelectMsg(UID, 2, -1, 1114, NPC, 27);
	end
end

if (EVENT == 245) then -- Resurrection Ice Wing (New Wing's)
	WING = HowmuchItem(UID, 507016000)
	if (WING < 1) then
	SelectMsg(UID, 2, -1, 11063, NPC, 10);	
	else
	RobItem(UID, 507016000, 1)
	GiveItem(UID, 910268754, 1, 30)
	SelectMsg(UID, 2, -1, 1114, NPC, 27);
	end
end

if (EVENT == 246) then -- Resurrection Red Wing (New Wing's))
	WING = HowmuchItem(UID, 507016000)
	if (WING < 1) then
	SelectMsg(UID, 2, -1, 11063, NPC, 10);	
	else
	RobItem(UID, 507016000, 1)
	GiveItem(UID, 910278755, 1, 30)
	SelectMsg(UID, 2, -1, 1114, NPC, 27);
	end
end

if (EVENT == 247) then -- Resurrection Purple Wing (New Wing's)
	WING = HowmuchItem(UID, 507016000)
	if (WING < 1) then
	SelectMsg(UID, 2, -1, 11063, NPC, 10);	
	else
	RobItem(UID, 507016000, 1)
	GiveItem(UID, 910288756, 1, 30)
	SelectMsg(UID, 2, -1, 1114, NPC, 27);
	end
end

if (EVENT == 248) then
SelectMsg(UID, 3, -1, 12448, NPC, 40813, 249, 40814, 250);
end

if (EVENT == 249) then
	VALARMOR = HowmuchItem(UID, 399142000);
	if (VALARMOR > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4288, 1014, 4289, 1015, 4290, 1016, 4291, 1017);
	else
		SelectMsg(UID, 2, -1, 4921, NPC, 18, 5000);
	end
end

if (EVENT == 250) then
	VALHELMET = HowmuchItem(UID, 399143000);
	if (VALHELMET > 0) then
		SelectMsg(UID, 3, -1, 4902, NPC, 4292, 1018, 4293, 1019, 4294, 1020, 4295, 1021);
	else
		SelectMsg(UID, 2, -1, 4911, NPC, 18, 5000);
	end
end

if (EVENT == 251) then -- Auto Mining&Fishing and Offline Merchant
SelectMsg(UID, 3, -1, 12448, NPC, 40816, 252, 40817, 253, 40818, 254);
end

if (EVENT == 252) then -- AUTO MINING
	ITEM = HowmuchItem(UID, 507017000)
	if (ITEM < 1) then
	SelectMsg(UID, 2, -1, 11063, NPC, 10);	
	else
	RobItem(UID, 507017000, 1)
	GiveItem(UID, 750680000, 1, 30)
	SelectMsg(UID, 2, -1, 1114, NPC, 27);
	end
end

if (EVENT == 253) then -- AUTO Fishing
	ITEM = HowmuchItem(UID, 507017000)
	if (ITEM < 1) then
	SelectMsg(UID, 2, -1, 11063, NPC, 10);	
	else
	RobItem(UID, 507017000, 1)
	GiveItem(UID, 750690000, 1, 30)
	SelectMsg(UID, 2, -1, 1114, NPC, 27);
	end
end

if (EVENT == 254) then -- Offline Merchant
	ITEM = HowmuchItem(UID, 820352000)
	if (ITEM < 1) then
	SelectMsg(UID, 2, -1, 11063, NPC, 10);	
	else
	RobItem(UID, 820352000, 1)
	GiveItem(UID, 900677882, 1, 30)
	SelectMsg(UID, 2, -1, 1114, NPC, 27);
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

if (EVENT == 1038) then
	VALARMOR = HowmuchItem(UID, 399142000);
	if (VALARMOR == 0) then
		SelectMsg(UID, 2, -1, 4921, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 399142000, 1);
			GiveItem(UID, 507011441, 1,30);
		end
	end
end

if (EVENT == 1039) then
	VALARMOR = HowmuchItem(UID, 399142000);
	if (VALARMOR == 0) then
		SelectMsg(UID, 2, -1, 4921, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 399142000, 1);
			GiveItem(UID, 507011442, 1,30);
		end
	end
end

if (EVENT == 1040) then
	VALARMOR = HowmuchItem(UID, 399142000);
	if (VALARMOR == 0) then
		SelectMsg(UID, 2, -1, 4921, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 399142000, 1);
			GiveItem(UID, 507011443, 1,30);
		end
	end
end

if (EVENT == 1041) then
	VALARMOR = HowmuchItem(UID, 399142000);
	if (VALARMOR == 0) then
		SelectMsg(UID, 2, -1, 4921, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 399142000, 1);
			GiveItem(UID, 507011444, 1,30);
		end
	end
end

if (EVENT == 1042) then
	VALHELMET = HowmuchItem(UID, 399143000);
	if (VALHELMET == 0) then
		SelectMsg(UID, 2, -1, 4911, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 399143000, 1);
			GiveItem(UID, 507013318, 1,30);
		end
	end
end

if (EVENT == 1043) then
	VALHELMET = HowmuchItem(UID, 399143000);
	if (VALHELMET == 0) then
		SelectMsg(UID, 2, -1, 4911, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 399143000, 1);
			GiveItem(UID, 507013319, 1,30);
		end
	end
end

if (EVENT == 1044) then
	VALHELMET = HowmuchItem(UID, 399143000);
	if (VALHELMET == 0) then
		SelectMsg(UID, 2, -1, 4911, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 399143000, 1);
			GiveItem(UID, 507013320, 1,30);
		end
	end
end

if (EVENT == 1045) then
	VALHELMET = HowmuchItem(UID, 399143000);
	if (VALHELMET == 0) then
		SelectMsg(UID, 2, -1, 4911, NPC, 18, 5000);
	else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
		else
			RobItem(UID, 399143000, 1);
			GiveItem(UID, 507013321, 1,30);
		end
	end
end

if (EVENT == 500) then
SelectMsg(UID,3,-1,12006,NPC,8604,501,8605,502,8606,503,8607,504)
end

if (EVENT == 501) then
SelectMsg(UID,3,-1,11807,NPC,8564,505,8565,506,8566,507,8567,508,8568,509,8569,510,8570,511,8571,512,8572,513)
end

if (EVENT == 502) then
SelectMsg(UID,3,-1,11807,NPC,8564,514,8565,515,8566,516,8567,517,8568,518,8569,519,8570,520,8571,521,8572,522)
end

if (EVENT == 503) then
SelectMsg(UID,3,-1,11807,NPC,8564,523,8565,524,8566,525,8567,526,8568,527,8569,528,8570,529,8571,530,8572,531)
end

if (EVENT == 504) then
SelectMsg(UID,3,-1,11807,NPC,8564,532,8565,533,8566,534,8567,535,8568,536,8569,537,8570,538,8571,539,8572,540)
end

if (EVENT == 505) then
	GARGES = HowmuchItem(UID, 900764000); 
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900764000,1);
		GiveItem(UID, 1110581734,1); -- Garges Dagger
    	end
    end
end

if (EVENT == 506) then
	GARGES = HowmuchItem(UID, 900764000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900764000,1);
		GiveItem(UID, 1110582734,1);-- Garges Two-Handed Sword
    	end
    end
end

if (EVENT == 507) then
	GARGES = HowmuchItem(UID, 900764000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900764000,1);
		GiveItem(UID, 1110583734,1);-- Garges Scythe
    	end
    end
end

if (EVENT == 508) then
	GARGES = HowmuchItem(UID, 900764000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900764000,1);
		GiveItem(UID, 1110586734,1);
    	end
    end
end

if (EVENT == 509) then
	GARGES = HowmuchItem(UID, 900764000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900764000,1);
		GiveItem(UID, 1110585534,1);
    	end
    end
end

if (EVENT == 510) then
	GARGES = HowmuchItem(UID, 900764000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900764000,1);
		GiveItem(UID, 1110584734,1);
    	end
    end
end

if (EVENT == 511) then
	GARGES = HowmuchItem(UID, 900764000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900764000,1);
		GiveItem(UID, 1110587734,1);
    	end
    end
end

if (EVENT == 512) then
	GARGES = HowmuchItem(UID, 900764000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900764000,1);
		GiveItem(UID, 1110585544,1);
    	end
    end
end

if (EVENT == 513) then
	GARGES = HowmuchItem(UID, 900764000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900764000,1);
		GiveItem(UID, 1110585554,1);
    	end
    end
end

if (EVENT == 514) then
	GARGES = HowmuchItem(UID, 900763000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900763000,1);
		GiveItem(UID, 1110581735,1);
    	end
    end
end

if (EVENT == 515) then
	GARGES = HowmuchItem(UID, 900763000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900763000,1);
		GiveItem(UID, 1110582735,1);
    	end
    end
end

if (EVENT == 516) then
	GARGES = HowmuchItem(UID, 900763000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900763000,1);
		GiveItem(UID, 1110583735,1);
    	end
    end
end

if (EVENT == 517) then
	GARGES = HowmuchItem(UID, 900763000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900763000,1);
		GiveItem(UID, 1110586735,1);
    	end
    end
end

if (EVENT == 518) then
	GARGES = HowmuchItem(UID, 900763000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900763000,1);
		GiveItem(UID, 1110585535,1);
    	end
    end
end

if (EVENT == 519) then
	GARGES = HowmuchItem(UID, 900763000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900763000,1);
		GiveItem(UID, 1110584735,1);
    	end
    end
end

if (EVENT == 520) then
	GARGES = HowmuchItem(UID, 900763000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900763000,1);
		GiveItem(UID, 1110587735,1);
    	end
    end
end

if (EVENT == 521) then
	GARGES = HowmuchItem(UID, 900763000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900763000,1);
		GiveItem(UID, 1110585545,1);
    	end
    end
end

if (EVENT == 522) then
	GARGES = HowmuchItem(UID, 900763000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900763000,1);
		GiveItem(UID, 1110585555,1);
    	end
    end
end

if (EVENT == 523) then
	GARGES = HowmuchItem(UID, 900762000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900762000,1);
		GiveItem(UID, 1110581736,1);
    	end
    end
end

if (EVENT == 524) then
	GARGES = HowmuchItem(UID, 900762000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900762000,1);
		GiveItem(UID, 1110582736,1);
    	end
    end
end

if (EVENT == 525) then
	GARGES = HowmuchItem(UID, 900762000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900762000,1);
		GiveItem(UID, 1110583736,1);
    	end
    end
end

if (EVENT == 526) then
	GARGES = HowmuchItem(UID, 900762000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900762000,1);
		GiveItem(UID, 1110586736,1);
    	end
    end
end

if (EVENT == 527) then
	GARGES = HowmuchItem(UID, 900762000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900762000,1);
		GiveItem(UID, 1110585536,1);
    	end
    end
end

if (EVENT == 528) then
	GARGES = HowmuchItem(UID, 900762000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900762000,1);
		GiveItem(UID, 1110584736,1);
    	end
    end
end

if (EVENT == 529) then
	GARGES = HowmuchItem(UID, 900762000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900762000,1);
		GiveItem(UID, 1110587736,1);
    	end
    end
end

if (EVENT == 530) then
	GARGES = HowmuchItem(UID, 900762000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900762000,1);
		GiveItem(UID, 1110585546,1);
    	end
    end
end

if (EVENT == 531) then
	GARGES = HowmuchItem(UID, 900762000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900762000,1);
		GiveItem(UID, 1110585556,1);
    	end
    end
end

if (EVENT == 532) then
	GARGES = HowmuchItem(UID, 900761000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900761000,1);
		GiveItem(UID, 1110581737,1);
    	end
    end
end

if (EVENT == 533) then
	GARGES = HowmuchItem(UID, 900761000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900761000,1);
		GiveItem(UID, 1110582737,1);
    	end
    end
end

if (EVENT == 534) then
	GARGES = HowmuchItem(UID, 900761000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900761000,1);
		GiveItem(UID, 1110583737,1);
    	end
    end
end

if (EVENT == 535) then
	GARGES = HowmuchItem(UID, 900761000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900761000,1);
		GiveItem(UID, 1110586737,1);
    	end
    end
end

if (EVENT == 536) then
	GARGES = HowmuchItem(UID, 900761000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900761000,1);
		GiveItem(UID, 1110585537,1);
    	end
    end
end

if (EVENT == 537) then
	GARGES = HowmuchItem(UID, 900761000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900761000,1);
		GiveItem(UID, 1110584737,1);
    	end
    end
end

if (EVENT == 538) then
	GARGES = HowmuchItem(UID, 900761000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900761000,1);
		GiveItem(UID, 1110587737,1);
    	end
    end
end

if (EVENT == 539) then
	GARGES = HowmuchItem(UID, 900761000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900761000,1);
		GiveItem(UID, 1110585547,1);
    	end
    end
end

if (EVENT == 540) then
	GARGES = HowmuchItem(UID, 900761000);
	if (GARGES < 1) then
		SelectMsg(UID, 2, -1, 12007, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 900761000,1);
		GiveItem(UID, 1110585557,1);
    	end
    end
end

if (EVENT == 600) then
	TRADE = HowmuchItem(UID, 800149000);
	if (TRADE < 1) then
		SelectMsg(UID, 2, -1, 12378, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
         EVENT = 601
    	end
    end
end

if EVENT == 601 then 
	TRADE = HowmuchItem(UID, 800149000);
		if (TRADE < 1) then
			SelectMsg(UID, 2, -1, 12378, NPC, 27, -1);
		else
		SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
        else
			SelectMsg(UID,2,-1,12377,NPC,10,-1);
	Check = CheckExchange(UID, 2626)
		if  (Check == true) then   
			Roll = RollDice(UID, 25) 
			found = Roll + 2601
			RunQuestExchange(UID, found);
		end  
	end
end
end

if (EVENT == 650) then
SelectMsg(UID, 2, -1, 12467, NPC, 9030, 651);
end

if (EVENT == 651) then
SelectMsg(UID, 2, -1, 12468, NPC, 9031, 652,27,-1);
end

if (EVENT == 652) then
SelectMsg(UID, 3, -1, 12469, NPC, 9032,653,9033,654,9034,655,9035,656);
end

if (EVENT == 653) then
	CHEST = HowmuchItem(UID, 998011000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 12474, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 998011000,1);
		SaveEvent(UID, 00000);
    	end
    end
end

if (EVENT == 654) then
	CHEST = HowmuchItem(UID, 998011000);
	if (CHEST < 5) then
		SelectMsg(UID, 2, -1, 12474, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 998011000,5);
		SaveEvent(UID, 00000);
    	end
    end
end

if (EVENT == 655) then
	CHEST = HowmuchItem(UID, 998011000);
	if (CHEST < 10) then
		SelectMsg(UID, 2, -1, 12474, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 998011000,10);
		SaveEvent(UID, 00000);
    	end
    end
end

if (EVENT == 656) then
	CHEST = HowmuchItem(UID, 998011000);
	if (CHEST < 20) then
		SelectMsg(UID, 2, -1, 12474, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 998011000,20);
		SaveEvent(UID, 00000);
    	end
    end
end

if (EVENT == 800) then
SelectMsg(UID, 3, -1, 12448, NPC, 40671,801,40601,803,40602,805,40591,807,40592,810);
end

if (EVENT == 801) then
SelectMsg(UID, 2, -1, 12448, NPC,40672,802);
end

if (EVENT == 802) then
	TATTO = HowmuchItem(UID, 914009000);
	if (TATTO < 1) then
		SelectMsg(UID, 2, -1, 44268, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 914009000,1);
		GiveItem(UID, 810932954,1,1);
    	end
    end
end

if (EVENT == 803) then
SelectMsg(UID, 2, -1, 12448, NPC,40603,804);
end

if (EVENT == 804) then
	TATTO = HowmuchItem(UID, 910925000);
	if (TATTO < 1) then
		SelectMsg(UID, 2, -1, 44268, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 910925000,1);
		GiveItem(UID, 810941998,1,3);
    	end
    end
end

if (EVENT == 805) then
SelectMsg(UID, 2, -1, 12448, NPC,40604,806);
end

if (EVENT == 806) then
	TATTO = HowmuchItem(UID, 910926000);
	if (TATTO < 1) then
		SelectMsg(UID, 2, -1, 44268, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 910926000,1);
		GiveItem(UID, 810942999,1,7);
    	end
    end
end

if (EVENT == 807) then
SelectMsg(UID, 2, -1, 12448, NPC,40390,808,40535,809);
end

if (EVENT == 808) then
	TATTO = HowmuchItem(UID, 810686000);
	if (TATTO < 1) then
		SelectMsg(UID, 2, -1, 44268, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810686000,1);
		GiveItem(UID, 810932954,1,15);
    	end
    end
end

if (EVENT == 809) then
	TATTO = HowmuchItem(UID, 810713000);
	if (TATTO < 1) then
		SelectMsg(UID, 2, -1, 44268, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810713000,1);
		GiveItem(UID, 810931953,1,15);
    	end
    end
end

if (EVENT == 810) then
SelectMsg(UID, 3, -1, 12448, NPC,40587,811,40588,812,40589,813,40590,814);
end

if (EVENT == 811) then
	TATTO = HowmuchItem(UID, 810926000);
	if (TATTO < 1) then
		SelectMsg(UID, 2, -1, 44268, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810926000,1);
		GiveItem(UID, 810930952,1,30);
    	end
    end
end

if (EVENT == 812) then
	TATTO = HowmuchItem(UID, 810927000);
	if (TATTO < 1) then
		SelectMsg(UID, 2, -1, 44268, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810927000,1);
		GiveItem(UID, 810931953,1,30);
    	end
    end
end

if (EVENT == 813) then
	TATTO = HowmuchItem(UID, 810928000);
	if (TATTO < 1) then
		SelectMsg(UID, 2, -1, 44268, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810928000,1);
		GiveItem(UID, 810932954,1,30);
    	end
    end
end

if (EVENT == 814) then
	TATTO = HowmuchItem(UID, 810929000);
	if (TATTO < 1) then
		SelectMsg(UID, 2, -1, 44268, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810929000,1);
		GiveItem(UID, 810933955,1,30);
    	end
    end
end

if (EVENT == 815) then
	SelectMsg(UID, 3, -1, 11624, NPC,40820, 816, 40821, 817, 40822, 818, 40823, 819, 40824, 820, 40825, 821, 40826, 822);
end

if (EVENT == 816) then -- PK PACKET
	ITEM = HowmuchItem(UID, 379282000);
	if (ITEM < 1) then
		SelectMsg(UID, 2, -1, 44938, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 11)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 379282000,1);
		GiveItem(UID, 399292764, 1); -- war pre
		GiveItem(UID, 800270000, 1); -- bahamut armor
		GiveItem(UID, 800260000, 1); -- bahamut helmet
		GiveItem(UID, 800250000, 1); -- pathos
		GiveItem(UID, 800250000, 1); -- pathos
		GiveItem(UID, 800022000, 1); -- duration
		GiveItem(UID, 800079000, 1); -- hp scrol %60
		GiveItem(UID, 900387000, 1); -- alseids cupon
		GiveItem(UID, 800440000, 1); -- magic bag
		GiveItem(UID, 800440000, 1); -- magic bag
		GiveItem(UID, 810926000, 1); -- solar tatto
    	end
    end
end

if (EVENT == 817) then -- FARM PACKET
	ITEM = HowmuchItem(UID, 379286000);
	if (ITEM < 1) then
		SelectMsg(UID, 2, -1, 44939, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 9)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 379286000,1);
		GiveItem(UID, 399281685 ,1); -- DC Prem
		GiveItem(UID, 900386000 ,1); -- Oreads
		GiveItem(UID, 800450000	,1); -- Auto Loot
		GiveItem(UID, 507018000 ,1); -- Auto Fishing
		GiveItem(UID, 900693000 ,1); -- Hyper Noah
		GiveItem(UID, 800250000 ,1); -- Pathos
		GiveItem(UID, 800250000 ,1); -- Pathos
		GiveItem(UID, 800440000 ,1); -- MAgic Bag
		GiveItem(UID, 800440000 ,1); -- Magic Bag
    	end
    end
end

if (EVENT == 818) then -- VIP PACKET
	ITEM = HowmuchItem(UID, 379284000);
	if (ITEM < 1) then
		SelectMsg(UID, 2, -1, 44940, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 15)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 379284000,1);
		GiveItem(UID, 399295859, 1); -- switch pre
		GiveItem(UID, 399142000, 1); -- resurrection armor
		GiveItem(UID, 399143000, 1); -- resurrection helmet
		GiveItem(UID, 800250000, 1); -- pathos
		GiveItem(UID, 800250000, 1); -- pathos
		GiveItem(UID, 800022000, 1); -- duration
		GiveItem(UID, 800440000, 1); -- magic bag
		GiveItem(UID, 800440000, 1); -- magic bag		
		GiveItem(UID, 900386000, 1); -- oreads
		GiveItem(UID, 900387000, 1); -- alseids cupon
		GiveItem(UID, 800450000	,1); -- Auto Loot
		GiveItem(UID, 507018000 ,1); -- Auto Fishing	
		GiveItem(UID, 900435000, 1); -- master teaching
		GiveItem(UID, 810926000, 1); -- solar tatto	
        GiveItem(UID, 800014000, 1); -- scroll of attack		
    	end
    end
end
--------------------------------------------------------
if (EVENT == 819) then -- Rogue Package
	ITEM = HowmuchItem(UID, 379287000);
	if (ITEM < 1) then
		SelectMsg(UID, 2, -1, 44941, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 15)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 379287000,1);
		GiveItem(UID, 800079000, 1); -- HP Scroll %60
		GiveItem(UID, 800077000, 1); -- Scroll Of Armor 400
		GiveItem(UID, 800014000, 1); -- Attack Scroll
		GiveItem(UID, 800025000, 1); -- Scroll Of Dexterity
		GiveItem(UID, 800022000, 1); -- Duration Item
		GiveItem(UID, 800074000, 1); -- Np Increase Item
		GiveItem(UID, 389390000, 1); -- Premium Potion HP
		GiveItem(UID, 389400000, 1); -- Premium Potion MP
		GiveItem(UID, 800021000, 1); -- Scroll Of Teleport Friend
		GiveItem(UID, 900129000, 10); -- Red Potion	
    	end
    end
end

if (EVENT == 820) then -- Warriorr Package
	ITEM = HowmuchItem(UID, 379288000);
	if (ITEM < 1) then
		SelectMsg(UID, 2, -1, 44940, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 10)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 379288000,1);
		GiveItem(UID, 800079000, 1); -- HP Scroll %60
		GiveItem(UID, 800077000, 1); -- Scroll Of Armor 400
		GiveItem(UID, 800014000, 1); -- Attack Scroll
		GiveItem(UID, 800023000, 1); -- Scroll Of Strength
		GiveItem(UID, 800022000, 1); -- Duration Item
		GiveItem(UID, 800074000, 1); -- Np Increase Item
		GiveItem(UID, 389390000, 1); -- Premium Potion HP
		GiveItem(UID, 389400000, 1); -- Premium Potion MP
		GiveItem(UID, 800021000, 1); -- Scroll Of Teleport Friend
		GiveItem(UID, 900129000, 10); -- Red Potion	
    	end
    end
end

if (EVENT == 821) then -- Mage Package
	ITEM = HowmuchItem(UID, 379289000);
	if (ITEM < 1) then
		SelectMsg(UID, 2, -1, 44941, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 8)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 379289000,1);
		GiveItem(UID, 800079000, 1); -- HP Scroll %60
		GiveItem(UID, 800077000, 1); -- Scroll Of Armor 400
		GiveItem(UID, 800023000, 1); -- Scroll Of HEALT
		GiveItem(UID, 800074000, 1); -- Np Increase Item
		GiveItem(UID, 389390000, 1); -- Premium Potion HP
		GiveItem(UID, 389400000, 1); -- Premium Potion MP
		GiveItem(UID, 800021000, 1); -- Scroll Of Teleport Friend
		GiveItem(UID, 900067000, 10); -- Unidentified Potion
    	end
    end
end

if (EVENT == 822) then -- Priest Package
	ITEM = HowmuchItem(UID, 379291000);
	if (ITEM < 1) then
		SelectMsg(UID, 2, -1, 44942, NPC, 27, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 8)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 379291000,1);
		GiveItem(UID, 800079000, 1); -- HP Scroll %60
		GiveItem(UID, 800077000, 1); -- Scroll Of Armor 400
		GiveItem(UID, 800023000, 1); -- Scroll Of HEALT
		GiveItem(UID, 800074000, 1); -- Np Increase Item
		GiveItem(UID, 389390000, 1); -- Premium Potion HP
		GiveItem(UID, 389400000, 1); -- Premium Potion MP
		GiveItem(UID, 800021000, 1); -- Scroll Of Teleport Friend
		GiveItem(UID, 900128000, 30); -- Blue Potion	
    	end
    end
end

