local NPC = 29056;
------------------
if (EVENT == 100) then             --ALTTAN SİLİNDİ : 7242,440,7679,205
	SelectMsg(UID, 3, -1, 3018, NPC,8931,101,8229,350,7796,210,7496,550,40102,110,7202,400,7214,420,7219,430,7228,460,49034,556);
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 101) then
	FORTUNEPOCKET = HowmuchItem(UID, 810449000);
	if (FORTUNEPOCKET < 1) then
		SelectMsg(UID, 2, -1, 44415, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 12367, NPC, 4302, 102, 4303, -1);

	end
end

if EVENT == 102 then 
SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
        else
Check = CheckExchangeSlot(UID, 000)
   if  Check == true then   
   Roll = RollDice(UID, 00) 
   found = Roll + 000
   RunQuestExchange(UID, found);
      end
         end
		 end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 110) then --- aşagıdan silindi : 7251,195,7250,190,8491,135,8723,129,8210,200,
	SelectMsg(UID, 3, -1, 3018, NPC,7685,116,7247,181,7248,186,7258,500);
end


----------------------------------------------------------------------------------------------------------------------
if (EVENT == 116) then -- Official List
	LIST = HowmuchItem(UID, 810163000);
	if (LIST > 0) then
		SelectMsg(UID, 2, -1, 10597, NPC, 10,117);
	else
		SelectMsg(UID, 2, -1, 10596, NPC, 18, 5000);
	end
end

if (EVENT == 117) then
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810163000, 1);
	GiveItem(UID, 810166000, 1,30);
    end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 129) then
	TOUR = HowmuchItem(UID, 810391000);
	TOUR2 = HowmuchItem(UID, 810392000);
	if (TOUR < 1) then
		SelectMsg(UID, 2, -1, 12168, NPC, 10,-1);
	elseif (TOUR2 < 1) then
	    SelectMsg(UID, 2, -1, 12168, NPC, 10,-1);
	else
		SelectMsg(UID, 2, -1, 12167, NPC,4297,130,27,-1);
	end
end

if (EVENT == 130) then
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 00000, 1);
	GiveItem(UID, 0000, 1);
    end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 135) then
	SelectMsg(UID, 3, -1, 11899, NPC, 8710,136,8711,137,8712,138,8713,139);
end

if (EVENT == 136) then
  BLOODY = HowmuchItem(UID, 810381000); --+4
   if (BLOODY < 1) then
    SelectMsg(UID, 2, -1, 11901, NPC, 10,-1);
       else
	SelectMsg(UID, 3, -1, 11899, NPC,8492,140,8493,141,8494,142,8495,143,8496,144,8497,145,8498,146,8499,147,8500,148);
   end
end
if (EVENT == 137) then
  BLOODY = HowmuchItem(UID, 810382000); --+5
   if (BLOODY < 1) then
    SelectMsg(UID, 2, -1, 11901, NPC, 10,-1);
       else
	SelectMsg(UID, 3, -1, 11899, NPC,8492,149,8493,150,8494,151,8495,152,8496,153,8497,154,8498,155,8499,156,8500,157);
end
end

if (EVENT == 138) then
  BLOODY = HowmuchItem(UID, 810383000); --+6
   if (BLOODY < 1) then
    SelectMsg(UID, 2, -1, 11901, NPC, 10,-1);
       else
	SelectMsg(UID, 3, -1, 11899, NPC,8492,158,8493,159,8494,160,8495,161,8496,162,8497,163,8498,164,8499,165,8500,166);
end
end

if (EVENT == 139) then
  BLOODY = HowmuchItem(UID, 810384000); --+7
   if (BLOODY < 1) then
    SelectMsg(UID, 2, -1, 11901, NPC, 10,-1);
       else
	SelectMsg(UID, 3, -1, 11899, NPC,8492,167,8493,168,8494,169,8495,170,8496,171,8497,172,8498,173,8499,174,8500,175);
end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 140) then
	BLOODY = HowmuchItem(UID, 810381000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810381000,1);
		GiveItem(UID, 1111452714,1);
    	end
    end
end

if (EVENT == 141) then
	BLOODY = HowmuchItem(UID, 810381000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810381000,1);
		GiveItem(UID, 1111453714,1);
    	end
    end
end

if (EVENT == 142) then
	BLOODY = HowmuchItem(UID, 810381000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810381000,1);
		GiveItem(UID, 1111454714,1);
    	end
    end
end

if (EVENT == 143) then
	BLOODY = HowmuchItem(UID, 810381000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810381000,1);
		GiveItem(UID, 1111455714,1);
    	end
    end
end

if (EVENT == 144) then
	BLOODY = HowmuchItem(UID, 810381000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then

	    else
		RobItem(UID, 810381000,1);
		GiveItem(UID, 1111456864,1);
    	end
    end
end

if (EVENT == 145) then
	BLOODY = HowmuchItem(UID, 810381000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810381000,1);
		GiveItem(UID, 1111456874,1);
    	end
    end
end

if (EVENT == 146) then
	BLOODY = HowmuchItem(UID, 810381000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810381000,1);
		GiveItem(UID, 1111456884,1);
    	end
    end
end

if (EVENT == 147) then
	BLOODY = HowmuchItem(UID, 810381000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810381000,1);
		GiveItem(UID, 1111457714,1);
    	end
    end
end

if (EVENT == 148) then
	BLOODY = HowmuchItem(UID, 810381000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810381000,1);
		GiveItem(UID, 1111458714,1);
    	end
    end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 149) then
	BLOODY = HowmuchItem(UID, 810382000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810382000,1);
		GiveItem(UID, 1111452715,1);
    	end
    end
end

if (EVENT == 150) then
	BLOODY = HowmuchItem(UID, 810382000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810382000,1);
		GiveItem(UID, 1111453715,1);
    	end
    end
end

if (EVENT == 151) then
	BLOODY = HowmuchItem(UID, 810382000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810382000,1);
		GiveItem(UID, 1111454715,1);
    	end
    end
end

if (EVENT == 152) then
	BLOODY = HowmuchItem(UID, 810382000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810382000,1);
		GiveItem(UID, 1111455715,1);
    	end
    end
end

if (EVENT == 153) then
	BLOODY = HowmuchItem(UID, 810382000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810382000,1);
		GiveItem(UID, 1111456865,1);
    	end
    end
end

if (EVENT == 154) then
	BLOODY = HowmuchItem(UID, 810382000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810382000,1);
		GiveItem(UID, 1111456875,1);
    	end
    end
end

if (EVENT == 155) then
	BLOODY = HowmuchItem(UID, 810382000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810382000,1);
		GiveItem(UID, 1111456885,1);
    	end
    end
end

if (EVENT == 156) then
	BLOODY = HowmuchItem(UID, 810382000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810382000,1);
		GiveItem(UID, 1111457715,1);
    	end
    end
end

if (EVENT == 157) then
	BLOODY = HowmuchItem(UID, 810382000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810382000,1);
		GiveItem(UID, 1111458715,1);
    	end
    end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 158) then
	BLOODY = HowmuchItem(UID, 810383000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810383000,1);
		GiveItem(UID, 1111452716,1);
    	end
    end
end

if (EVENT == 159) then
	BLOODY = HowmuchItem(UID, 810383000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810383000,1);
		GiveItem(UID, 1111453716,1);
    	end
    end
end

if (EVENT == 160) then
	BLOODY = HowmuchItem(UID, 810383000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810383000,1);
		GiveItem(UID, 1111454716,1);
    	end
    end
end

if (EVENT == 161) then
	BLOODY = HowmuchItem(UID, 810383000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810383000,1);
		GiveItem(UID, 1111455716,1);
    	end
    end
end

if (EVENT == 162) then
	BLOODY = HowmuchItem(UID, 810383000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810383000,1);
		GiveItem(UID, 1111456866,1);
    	end
    end
end

if (EVENT == 163) then
	BLOODY = HowmuchItem(UID, 810383000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810383000,1);
		GiveItem(UID, 1111456876,1);
    	end
    end
end

if (EVENT == 164) then
	BLOODY = HowmuchItem(UID, 810383000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810383000,1);
		GiveItem(UID, 1111456886,1);
    	end
    end
end

if (EVENT == 165) then
	BLOODY = HowmuchItem(UID, 810383000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810383000,1);
		GiveItem(UID, 1111457716,1);
    	end
    end
end

if (EVENT == 166) then
	BLOODY = HowmuchItem(UID, 810383000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810383000,1);
		GiveItem(UID, 1111458716,1);
    	end
    end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 167) then
	BLOODY = HowmuchItem(UID, 810384000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810384000,1);
		GiveItem(UID, 1111452717,1);
    	end
    end
end

if (EVENT == 168) then
	BLOODY = HowmuchItem(UID, 810384000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810384000,1);
		GiveItem(UID, 1111453717,1);
    	end
    end
end

if (EVENT == 169) then
	BLOODY = HowmuchItem(UID, 810384000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810384000,1);
		GiveItem(UID, 1111454717,1);
    	end
    end
end

if (EVENT == 170) then
	BLOODY = HowmuchItem(UID, 810384000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810384000,1);
		GiveItem(UID, 1111455717,1);
    	end
    end
end

if (EVENT == 171) then
	BLOODY = HowmuchItem(UID, 810384000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810384000,1);
		GiveItem(UID, 1111456867,1);
    	end
    end
end

if (EVENT == 172) then
	BLOODY = HowmuchItem(UID, 810384000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810384000,1);
		GiveItem(UID, 1111456877,1);
    	end
    end
end

if (EVENT == 173) then
	BLOODY = HowmuchItem(UID, 810384000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810384000,1);
		GiveItem(UID, 1111456887,1);
    	end
    end
end

if (EVENT == 174) then
	BLOODY = HowmuchItem(UID, 810384000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810384000,1);
		GiveItem(UID, 1111457717,1);
    	end
    end
end

if (EVENT == 175) then
	BLOODY = HowmuchItem(UID, 810384000);
	if (BLOODY < 1) then
		SelectMsg(UID, 2, -1, 12494, NPC, 7477, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
	    else
		RobItem(UID, 810384000,1);
		GiveItem(UID, 1111458717,1);
    	end
    end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 180) then
	
	if (DCPRE == 10) then
	    EVENT = 181
	else
		SelectMsg(UID, 2, -1, 9530, NPC, 18, 5000);
	end
end

if (EVENT == 181) then
	PICKAX = HowmuchItem(UID, 508122000);
	if (PICKAX < 1) then
		SelectMsg(UID, 2, -1, 9943, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 9944, NPC, 4297, 182, 4005, -1);
	end
end

if (EVENT == 182) then
	PICKAX = HowmuchItem(UID, 508122000);
	if (PICKAX < 1) then
		SelectMsg(UID, 2, -1, 9943, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 508122000, 1);
	GiveItem(UID, 389135000, 1,30);
	end
end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 185) then
	EXP = GetPremium(UID);
	if (EXP == 11) then
	    EVENT = 186
	else
		SelectMsg(UID, 2, -1, 9531, NPC, 18, 5000);
	end
end

if (EVENT == 186) then
	FISHING = HowmuchItem(UID, 508121000);
	if (FISHING < 1) then
		SelectMsg(UID, 2, -1, 9945, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 9946, NPC, 4297, 187, 4005, -1);

	end
end

if (EVENT == 187) then
	FISHING = HowmuchItem(UID, 508121000);
	if (FISHING < 1) then
		SelectMsg(UID, 2, -1, 9945, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 508121000, 1);
	GiveItem(UID, 191347000, 1,30);
	end
end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 190) then
	WARPRE = GetPremium(UID);
	if (WARPRE == 12) then
	SelectMsg(UID, 2, -1, 9949, NPC, 4297, 191, 4005, -1);
	else
		SelectMsg(UID, 2, -1, 9951, NPC, 18, 5000);
	end
end

if (EVENT == 191) then
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	GiveItem(UID, 910246000, 1,1);
end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 195) then
	WARPRE = GetPremium(UID);
	if (WARPRE == 12) then
	SelectMsg(UID, 2, -1, 9953, NPC, 4297, 196, 4005, -1);
	else
    SelectMsg(UID, 2, -1, 9951, NPC, 18, 5000);
	end
end

if (EVENT == 196) then
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	GiveItem(UID, 810161000, 1,1);
end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 200) then
	UTC = HowmuchItem(UID, 810319000);
	if (UTC < 1) then
		SelectMsg(UID, 2, -1, 11061, NPC, 10, -1);
	else
		EVENT = 201
	end
end

if (EVENT == 201) then
	UTC = HowmuchItem(UID, 810319000);
	if (UTC < 1) then
	SelectMsg(UID, 2, -1, 11061, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       SelectMsg(UID, 2,-1,8898,NPC,10,-1)
         else
	Roll = RollDice(UID, 7) 
	if Roll == 0 then
	SelectMsg(UID, 2, -1, 11062, NPC, 7538, -1);
	RobItem(UID, 810319000,1);
    GiveItem(UID,1110432508,1);--azagai
    end
		if Roll == 1 then
	SelectMsg(UID, 2, -1, 11062, NPC, 7538, -1);
	RobItem(UID, 810319000,1);
    GiveItem(UID,1110429508,1);--Khanjar
    end
		if Roll == 2 then
	SelectMsg(UID, 2, -1, 11062, NPC, 7538, -1);
	RobItem(UID, 810319000,1);
    GiveItem(UID,1110435558,1);--adaga
    end
		if Roll == 3 then
	SelectMsg(UID, 2, -1, 11062, NPC, 7538, -1);
	RobItem(UID, 810319000,1);
    GiveItem(UID,1110433648,1);--Fire Codex
    end
		if Roll == 4 then
	SelectMsg(UID, 2, -1, 11062, NPC, 7538, -1);
	RobItem(UID, 810319000,1);
    GiveItem(UID,1110433668,1);--Ice Codex
    end
		if Roll == 5 then
	SelectMsg(UID, 2, -1, 11062, NPC, 7538, -1);
	RobItem(UID, 810319000,1);
    GiveItem(UID,1110433688,1);--Lightning Codex
    end
		if Roll == 6 then
	SelectMsg(UID, 2, -1, 11062, NPC, 7538, -1);
	RobItem(UID, 810319000,1);
    GiveItem(UID,1110431508,1);--Buju
    end
		if Roll == 7 then
	SelectMsg(UID, 2, -1, 11062, NPC, 7538, -1);
	RobItem(UID, 810319000,1);
    GiveItem(UID,1110434508,1);--Ruahue
		if Roll == 8 then
	SelectMsg(UID, 2, -1, 11062, NPC, 7538, -1);
	RobItem(UID, 810319000,1);
    GiveItem(UID,1110430508,1);--Moonlight
	end
	   end
	      end
		     end
		        end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 205) then -- Dragon Wings
	ITEMDRGN = HowmuchItem(UID, 810164000);
	if (ITEMDRGN > 0) then
		SelectMsg(UID, 3, -1, 10592, NPC, 7680, 206, 7681, 207, 7682, 208, 7683, 209);
	else
		SelectMsg(UID, 2, -1, 10593, NPC, 18, 5000);
	end
end

if (EVENT == 206) then
	ITEMDRGN = HowmuchItem(UID, 810164000);
	if (ITEMDRGN < 0) then
	SelectMsg(UID, 2, -1, 10593, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	NATION = CheckNation(UID);
	if (NATION == 1) then
			RobItem(UID, 810164000, 1);
			GiveItem(UID, 810178835, 1,30);
	    else
         	RobItem(UID, 810164000, 1);
			GiveItem(UID, 810179839, 1,30);
		end
	end
end
end

if (EVENT == 207) then
	ITEMDRGN = HowmuchItem(UID, 810164000);
	if (ITEMDRGN < 0) then
	SelectMsg(UID, 2, -1, 10593, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	NATION = CheckNation(UID);
	if (NATION == 1) then
			RobItem(UID, 810164000, 1);
			GiveItem(UID, 810178836, 1,30);
	else
			RobItem(UID, 810164000, 1);
			GiveItem(UID, 810179840, 1,30);
		end
	end
end
end

if (EVENT == 208) then
	ITEMDRGN = HowmuchItem(UID, 810164000);
	if (ITEMDRGN < 0) then
	SelectMsg(UID, 2, -1, 10593, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	NATION = CheckNation(UID);
	if (NATION == 1) then
			RobItem(UID, 810164000, 1);
			GiveItem(UID, 810178837, 1,30);
	else
			RobItem(UID, 810164000, 1);
			GiveItem(UID, 810179841, 1,30);
		end
	end
end
end

if (EVENT == 209) then
	ITEMDRGN = HowmuchItem(UID, 810164000);
	if (ITEMDRGN < 0) then
	SelectMsg(UID, 2, -1, 10593, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	NATION = CheckNation(UID);
	if (NATION == 1) then
			RobItem(UID, 810164000, 1);
			GiveItem(UID, 810178838, 1,30);
	else
			RobItem(UID, 810164000, 1);
			GiveItem(UID, 810179842, 1,30);
		end
	end
end
end
--607.ts3.center
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 210) then
	SelectMsg(UID, 3, -1, 3018, NPC,8664,211,8576,215,7790,250,7791,255,7792,260,7793,265,7794,270,7795,275,7797,280,7992,290);
end

if (EVENT == 211) then
	SPECIAL = HowmuchItem(UID, 810536000);
	if (SPECIAL > 0) then
	EVENT = 212
	else
	SelectMsg(UID, 2, -1, 10853, NPC, 10, -1);
	end
	end

if EVENT == 212 then 
	SPECIAL = HowmuchItem(UID, 810536000);
	if (SPECIAL < 1 or SPECIAL == 0) then
	SelectMsg(UID, 2, -1, 10853, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
        else
Check = CheckExchangeSlot(UID, 6188)
   if  Check == true then   
   Roll = RollDice(UID, 22) 
   found = Roll + 6166
   RunQuestExchange(UID, found);
   SelectMsg(UID, 2, -1, 10852, NPC, 7538, -1);
         end
		    end
			   end
			   end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 215) then
	ROSSETTA = HowmuchItem(UID, 810207000);
	if (ROSSETTA < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
        SelectMsg(UID, 3, -1, 11677, NPC, 8577,216,8578,217,8579,218,8580,219);
    	end
end

if (EVENT == 216) then
	ROSSETTA = HowmuchItem(UID, 810207000);
	if (ROSSETTA < 1) then
	SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
    SelectMsg(UID, 3, -1, 11677, NPC, 8581,220,8582,221,8583,222,8584,223,8585,224);
end
end

if (EVENT == 217) then
	ROSSETTA = HowmuchItem(UID, 810207000);
	if (ROSSETTA < 1) then
	SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
    SelectMsg(UID, 3, -1, 11677, NPC, 8586,225,8587,226,8588,227,8589,228,8590,229);
end
end

if (EVENT == 218) then
	ROSSETTA = HowmuchItem(UID, 810207000);
	if (ROSSETTA < 1) then
	SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
    SelectMsg(UID, 3, -1, 11677, NPC, 8591,230,8592,231,8593,232,8594,233,8595,234);
end
end

if (EVENT == 219) then
	ROSSETTA = HowmuchItem(UID, 810207000);
	if (ROSSETTA < 1) then
	SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
    SelectMsg(UID, 3, -1, 11677, NPC, 8596,235,8597,236,8598,237,8599,238,8600,239);
end
end

if (EVENT == 220) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 521511004,1);
    	end
    end
end

if (EVENT == 221) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 521512004,1);
    	end
    end
end

if (EVENT == 222) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 521513004,1);
    	end
    end
end

if (EVENT == 223) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 521514004,1);
    	end
    end
end

if (EVENT == 224) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 521515004,1);
    	end
    end
end


if (EVENT == 225) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 522511004,1);
    	end
    end
end

if (EVENT == 226) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 522512004,1);
    	end
    end
end

if (EVENT == 227) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 522513004,1);
    	end
    end
end

if (EVENT == 228) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 522514004,1);
    	end
    end
end

if (EVENT == 229) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 522515004,1);
    	end
    end
end

if (EVENT == 230) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 523511004,1);
    	end
    end
end

if (EVENT == 231) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 523512004,1);
    	end
    end
end

if (EVENT == 232) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 523513004,1);
    	end
    end
end

if (EVENT == 233) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 523514004,1);
    	end
    end
end

if (EVENT == 234) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 523515004,1);
    	end
    end
end

if (EVENT == 235) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 524511004,1);
    	end
    end
end

if (EVENT == 236) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 524512004,1);
    	end
    end
end

if (EVENT == 237) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 524513004,1);
    	end
    end
end

if (EVENT == 238) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 524514004,1);
    	end
    end
end

if (EVENT == 239) then
	CHEST = HowmuchItem(UID, 810207000);
	if (CHEST < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		RobItem(UID, 810207000,1);
		GiveItem(UID, 524515004,1);
    	end
    end
end
----------------------------------------------------------------------------------------------------------------------
if EVENT == 250 then 
	LEVEL = HowmuchItem(UID, 810235000);
	if (LEVEL > 0) then
	EVENT = 251
	else
	SelectMsg(UID, 2, -1, 10853, NPC, 10, -1);
   end
end

if (EVENT == 251) then
	LEVEL = HowmuchItem(UID, 810235000);
	if (LEVEL < 1) then
	SelectMsg(UID, 2, -1, 10851, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       SelectMsg(UID, 2,-1,8898,NPC,10,-1)
         else
	Roll = RollDice(UID,17) 
	if Roll == 0 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389196000,1);
    end
	if Roll == 1 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389197000,1);
    end
	if Roll == 2 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389198000,1);
    end
	if Roll == 3 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389199000,1);
    end
	if Roll == 4 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389201000,1);
    end
	if Roll == 5 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389205000,1);
    end
	--
	if Roll == 6 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389196000,2);
    end
	if Roll == 7 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389197000,2);
    end
	if Roll == 8 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389198000,2);
    end
	if Roll == 9 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389199000,2);
    end
	if Roll == 10 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389201000,2);
    end
	if Roll == 11 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389205000,2);
    end
	--	
	if Roll == 12 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389196000,3);
    end
	if Roll == 13 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389197000,3);
    end
	if Roll == 14 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389198000,3);
    end
	if Roll == 15 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389199000,3);
    end
	if Roll == 16 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389201000,3);
    end
	if Roll == 17 then
	SelectMsg(UID, 2, -1, 10850, NPC, 7538, -1);
	RobItem(UID, 810235000,1);
    GiveItem(UID,389205000,3);
    end
	end
	end
	end
----------------------------------------------------------------------------------------------------------------------
if EVENT == 255 then 
	ACCEESS = HowmuchItem(UID, 810228000);
	if (ACCEESS > 0) then
	EVENT = 256
	else
	SelectMsg(UID, 2, -1, 10853, NPC, 10, -1);
   end
end

if EVENT == 256 then 
	ACCEESS = HowmuchItem(UID, 810228000);
	if (ACCEESS < 1) then
	SelectMsg(UID, 2, -1, 10853, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
        else
Check = CheckExchangeSlot(UID, 4051)
   if  Check == true then   
   Roll = RollDice(UID, 22) 
   found = Roll + 4029
		RunQuestExchange(UID, found);	
		SelectMsg(UID, 2, -1, 10852, NPC, 7538, -1);
      end
         end
		    end
			end
----------------------------------------------------------------------------------------------------------------------
if EVENT == 260 then 
	BIFROST = HowmuchItem(UID, 810229000);
	if (BIFROST > 0) then
	EVENT = 261
	else
	SelectMsg(UID, 2, -1, 10855, NPC, 10, -1);
   end
end

if (EVENT == 261) then
	LEVEL = HowmuchItem(UID, 810229000);
	if (LEVEL < 1) then
	SelectMsg(UID, 2, -1, 10855, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       SelectMsg(UID, 2,-1,8898,NPC,10,-1)
         else
	Roll = RollDice(UID,20) 
	if Roll == 0 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389160000,1);
    end
		if Roll == 1 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389163000,1);
    end
		if Roll == 2 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389161000,1);
    end
		if Roll == 3 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389165000,1);
    end
		if Roll == 4 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389162000,1);
    end
		if Roll == 5 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389166000,1);
    end
		if Roll == 6 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389164000,1);
    end
	--
		if Roll == 7 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389160000,2);
    end
		if Roll == 8 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389163000,2);
    end
		if Roll == 9 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389161000,2);
    end
		if Roll == 10 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389165000,2);
    end
		if Roll == 11 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389162000,2);
    end
		if Roll == 12 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389166000,2);
    end
		if Roll == 13 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389164000,2);
    end
	--
		if Roll == 14 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389160000,3);
    end
		if Roll == 15 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389163000,3);
    end
		if Roll == 16 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389161000,3);
    end
		if Roll == 17 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389165000,3);
    end
		if Roll == 18 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389162000,3);
    end
		if Roll == 19 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389166000,3);
    end
		if Roll == 20 then
	SelectMsg(UID, 2, -1, 10854, NPC, 7538, -1);
	RobItem(UID, 810229000,1);
    GiveItem(UID,389164000,3);
    end
	end
	end
	end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 265) then
	TH = HowmuchItem(UID, 810231000);
	if (TH > 0) then
	EVENT = 266
	else
	SelectMsg(UID, 2, -1, 10857, NPC, 10, -1);
	end
	end

if EVENT == 266 then 
	TH = HowmuchItem(UID, 810231000);
	if (TH < 1 or TH == 0) then
	SelectMsg(UID, 2, -1, 10857, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
         else
Check = CheckExchangeSlot(UID, 4028)
   if  Check == true then   
   Roll = RollDice(UID, 4) 
   found = Roll + 4024
   RunQuestExchange(UID, found);
   SelectMsg(UID, 2, -1, 10856, NPC, 7538, -1);
      end
         end
		    end
			   end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 270) then
	GUARDIAN = HowmuchItem(UID, 810232000);
	if (GUARDIAN > 0) then
	EVENT = 271
	else
	SelectMsg(UID, 2, -1, 10859, NPC, 10, -1);
    end
	end
	
if (EVENT == 275) then
	MAGIPIE = HowmuchItem(UID, 810233000);
	if (MAGIPIE > 0) then
	EVENT = 276
	else
	SelectMsg(UID, 2, -1, 10861, NPC, 10, -1);
    end
	end
	
if (EVENT == 280) then
	MAGIPIE = HowmuchItem(UID, 900582000);
	if (MAGIPIE > 0) then
	EVENT = 281
	else
	SelectMsg(UID, 2, -1, 10865, NPC, 10, -1);
	end
	end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 290) then
	SelectMsg(UID, 3, -1, 10865, NPC,8557,291,8558,292,8559,293,8560,294,8561,295);
end

if (EVENT == 291) then
	SelectMsg(UID, 3, -1, 11990, NPC,8548,296,8549,297,8550,298,8551,299,8552,300,8553,301,8554,302,8555,303,8556,304);
end

if (EVENT == 292) then
	SelectMsg(UID, 3, -1, 11990, NPC,8548,305,8549,306,8550,307,8551,308,8552,309,8553,310,8554,311,8555,312,8556,313);
end

if (EVENT == 293) then
	SelectMsg(UID, 3, -1, 11990, NPC,8548,314,8549,315,8550,316,8551,317,8552,318,8553,319,8554,320,8555,321,8556,322);
end

if (EVENT == 294) then
	SelectMsg(UID, 3, -1, 11990, NPC,8548,323,8549,324,8550,325,8551,326,8552,327,8553,328,8554,329,8555,330,8556,331);
end

if (EVENT == 295) then
	SelectMsg(UID, 3, -1, 11990, NPC,8548,332,8549,333,8550,334,8551,335,8552,336,8553,337,8554,338,8555,339,8556,340);
end

if (EVENT == 296) then
	WINGBOX = HowmuchItem(UID, 900736000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900736000,1);
		GiveItem(UID, 1110561724,1);
    	end
    end
end

if (EVENT == 297) then
	WINGBOX = HowmuchItem(UID, 900736000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900736000,1);
		GiveItem(UID, 1110562724,1);
    	end
    end
end

if (EVENT == 298) then
	WINGBOX = HowmuchItem(UID, 900736000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900736000,1);
		GiveItem(UID, 1110563724,1);
    	end
    end
end

if (EVENT == 299) then
	WINGBOX = HowmuchItem(UID, 900736000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900736000,1);
		GiveItem(UID, 1110564724,1);
    	end
    end
end

if (EVENT == 300) then
	WINGBOX = HowmuchItem(UID, 900736000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900736000,1);
		GiveItem(UID, 1110565894,1);
    	end
    end
end

if (EVENT == 301) then
	WINGBOX = HowmuchItem(UID, 900736000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900736000,1);
		GiveItem(UID, 1110565904,1);
    	end
    end
end

if (EVENT == 302) then
	WINGBOX = HowmuchItem(UID, 900736000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900736000,1);
		GiveItem(UID, 1110565914,1);
    	end
    end
end

if (EVENT == 303) then
	WINGBOX = HowmuchItem(UID, 900736000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900736000,1);
		GiveItem(UID, 1110566724,1);
    	end
    end
end

if (EVENT == 304) then
	WINGBOX = HowmuchItem(UID, 900736000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900736000,1);
		GiveItem(UID, 1110567724,1);
    	end
    end
end
--
if (EVENT == 305) then
	WINGBOX = HowmuchItem(UID, 900735000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900735000,1);
		GiveItem(UID, 1110561725,1);
    	end
    end
end

if (EVENT == 306) then
	WINGBOX = HowmuchItem(UID, 900735000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900735000,1);
		GiveItem(UID, 1110562725,1);
    	end
    end
end

if (EVENT == 307) then
	WINGBOX = HowmuchItem(UID, 900735000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900735000,1);
		GiveItem(UID, 1110563725,1);
    	end
    end
end

if (EVENT == 308) then
	WINGBOX = HowmuchItem(UID, 900735000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900735000,1);
		GiveItem(UID, 1110564725,1);
    	end
    end
end

if (EVENT == 309) then
	WINGBOX = HowmuchItem(UID, 900735000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900735000,1);
		GiveItem(UID, 1110565895,1);
    	end
    end
end

if (EVENT == 310) then
	WINGBOX = HowmuchItem(UID, 900735000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900735000,1);
		GiveItem(UID, 1110565905,1);
    	end
    end
end

if (EVENT == 311) then
	WINGBOX = HowmuchItem(UID, 900735000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900735000,1);
		GiveItem(UID, 1110565915,1);
    	end
    end
end

if (EVENT == 312) then
	WINGBOX = HowmuchItem(UID, 900735000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900735000,1);
		GiveItem(UID, 1110566725,1);
    	end
    end
end

if (EVENT == 313) then
	WINGBOX = HowmuchItem(UID, 900735000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900735000,1);
		GiveItem(UID, 1110567725,1);
    	end
    end
end
--
if (EVENT == 314) then
	WINGBOX = HowmuchItem(UID, 900734000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900734000,1);
		GiveItem(UID, 1110561726,1);
    	end
    end
end

if (EVENT == 315) then
	WINGBOX = HowmuchItem(UID, 900734000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900734000,1);
		GiveItem(UID, 1110562726,1);
    	end
    end
end

if (EVENT == 316) then
	WINGBOX = HowmuchItem(UID, 900734000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900734000,1);
		GiveItem(UID, 1110563726,1);
    	end
    end
end

if (EVENT == 317) then
	WINGBOX = HowmuchItem(UID, 900734000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900734000,1);
		GiveItem(UID, 1110564726,1);
    	end
    end
end

if (EVENT == 318) then
	WINGBOX = HowmuchItem(UID, 900734000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900734000,1);
		GiveItem(UID, 1110565896,1);
    	end
    end
end

if (EVENT == 319) then
	WINGBOX = HowmuchItem(UID, 900734000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900734000,1);
		GiveItem(UID, 1110565906,1);
    	end
    end
end

if (EVENT == 320) then
	WINGBOX = HowmuchItem(UID, 900734000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900734000,1);
		GiveItem(UID, 1110565916,1);
    	end
    end
end

if (EVENT == 321) then
	WINGBOX = HowmuchItem(UID, 900734000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900734000,1);
		GiveItem(UID, 1110566726,1);
    	end
    end
end

if (EVENT == 322) then
	WINGBOX = HowmuchItem(UID, 900734000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900734000,1);
		GiveItem(UID, 1110567726,1);
    	end
    end
end
--
if (EVENT == 323) then
	WINGBOX = HowmuchItem(UID, 900733000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900733000,1);
		GiveItem(UID, 1110561727,1);
    	end
    end
end

if (EVENT == 324) then
	WINGBOX = HowmuchItem(UID, 900733000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900733000,1);
		GiveItem(UID, 1110562727,1);
    	end
    end
end

if (EVENT == 325) then
	WINGBOX = HowmuchItem(UID, 900733000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900733000,1);
		GiveItem(UID, 1110563727,1);
    	end
    end
end

if (EVENT == 326) then
	WINGBOX = HowmuchItem(UID, 900733000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900733000,1);
		GiveItem(UID, 1110564727,1);
    	end
    end
end

if (EVENT == 327) then
	WINGBOX = HowmuchItem(UID, 900733000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900733000,1);
		GiveItem(UID, 1110565897,1);
    	end
    end
end

if (EVENT == 328) then
	WINGBOX = HowmuchItem(UID, 900733000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900733000,1);
		GiveItem(UID, 1110565907,1);
    	end
    end
end

if (EVENT == 329) then
	WINGBOX = HowmuchItem(UID, 900733000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900733000,1);
		GiveItem(UID, 1110565917,1);
    	end
    end
end

if (EVENT == 330) then
	WINGBOX = HowmuchItem(UID, 900733000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900733000,1);
		GiveItem(UID, 1110566727,1);
    	end
    end
end

if (EVENT == 331) then
	WINGBOX = HowmuchItem(UID, 900733000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 900733000,1);
		GiveItem(UID, 1110567727,1);
    	end
    end
end
--
if (EVENT == 332) then
	WINGBOX = HowmuchItem(UID, 810284000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 810284000,1);
		GiveItem(UID, 000000,1);
    	end
    end
end

if (EVENT == 333) then
	WINGBOX = HowmuchItem(UID, 810284000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 810284000,1);
		GiveItem(UID, 000000,1);
    	end
    end
end

if (EVENT == 334) then
	WINGBOX = HowmuchItem(UID, 810284000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 810284000,1);
		GiveItem(UID, 000000,1);
    	end
    end
end

if (EVENT == 335) then
	WINGBOX = HowmuchItem(UID, 810284000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 810284000,1);
		GiveItem(UID, 000000,1);
    	end
    end
end

if (EVENT == 336) then
	WINGBOX = HowmuchItem(UID, 810284000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 810284000,1);
		GiveItem(UID, 000000,1);
    	end
    end
end

if (EVENT == 337) then
	WINGBOX = HowmuchItem(UID, 810284000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 810284000,1);
		GiveItem(UID, 000000,1);
    	end
    end
end

if (EVENT == 338) then
	WINGBOX = HowmuchItem(UID, 810284000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 810284000,1);
		GiveItem(UID, 000000,1);
    	end
    end
end

if (EVENT == 339) then
	WINGBOX = HowmuchItem(UID, 810284000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 810284000,1);
		GiveItem(UID, 000000,1);
    	end
    end
end

if (EVENT == 340) then
	WINGBOX = HowmuchItem(UID, 810284000);
	if (WINGBOX < 1 or WINGBOX == 0) then
		SelectMsg(UID, 2, -1, 11037, NPC, 10, -1);
	else
	SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
		SelectMsg(UID,2,-1,11036,NPC,7538,-1);
		RobItem(UID, 810284000,1);
		GiveItem(UID, 000000,1);
    	end
    end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 350) then
SelectMsg(UID,3,-1,11672,NPC,8229,351,8230,355,8231,360,8232,365,8233,370,8234,375,8235,380,8236,385,8239,390);
end

if (EVENT == 351) then
	DRAGONBOX = HowmuchItem(UID, 810377000);
	if (DRAGONBOX < 1 or DRAGONBOX == 0) then
		SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	else
		SlotCheck = CheckGiveSlot(UID, 2);
     if SlotCheck == false then
       ;
	    else
	Roll = RollDice(UID,10) 
	if Roll == 0 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810377000,1);
    GiveItem(UID,810192000,1);
	GiveItem(UID,810192000,1);
    end
	if Roll == 1 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810377000,1);
    GiveItem(UID,810342000,1);
    end
	if Roll == 2 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810377000,1);
    GiveItem(UID,810343000,1);
    end
	if Roll == 3 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810377000,1);
    GiveItem(UID,810344000,1);
    end
	if Roll == 4 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810377000,1);
    GiveItem(UID,810192000,1);
	GiveItem(UID,810192000,1);
    end
	if Roll == 5 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810377000,1);
    GiveItem(UID,810345000,1);
    end
	if Roll == 6 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810377000,1);
    GiveItem(UID,810346000,1);
    end
	if Roll == 7 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810377000,1);
    GiveItem(UID,810347000,1);
    end
	if Roll == 8 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810377000,1);
    GiveItem(UID,810348000,1);
    end
	if Roll == 9 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810377000,1);
    GiveItem(UID,810349000,1);
    end
	if Roll == 10 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810377000,1);
    GiveItem(UID,810192000,1);
	GiveItem(UID,810192000,1);
    end
		end
     end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 355) then
	AC2 = HowmuchItem(UID, 810342000);
	if (AC2 < 1 or AC2 == 0) then
		SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	else
	EVENT = 356
	end
	end
	
if (EVENT == 356) then
	AC2 = HowmuchItem(UID, 810342000);
	     if (AC2 < 1 or AC2 == 0) then
    SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	     else
		 SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
        else
	Check = CheckExchangeSlot(UID, 1490)
      if (Check == true) then
    Roll = RollDice(UID, 2) 
    found = Roll + 1488
    RunQuestExchange(UID, found);	
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
end
end
end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 360) then
	AC2 = HowmuchItem(UID, 810343000);
	if (AC2 < 1 or AC2 == 0) then
		SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	else
	EVENT = 361
	end
	end
	
if (EVENT == 361) then
	 AC2 = HowmuchItem(UID, 810343000);
	     if (AC2 < 1 or AC2 == 0) then
    SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	     else
		 SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
        else
	Check = CheckExchangeSlot(UID, 1487)
       if  Check == true then   
    Roll = RollDice(UID, 3) 
    found = Roll + 1484
    RunQuestExchange(UID, found);	
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
end
end
end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 365) then
	UNKNOWN = HowmuchItem(UID, 810345000);
	if (UNKNOWN < 1 or UNKNOWN == 0) then
		SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	else
	EVENT = 366
	end
	end
	
if (EVENT == 366) then
	UNKNOWN = HowmuchItem(UID, 810345000);
	if (UNKNOWN < 1 or UNKNOWN == 0) then
		SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	else
		SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
	Roll = RollDice(UID,10) 
	if Roll == 0 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810345000,1);
    GiveItem(UID,900177663,1,30);
    end
	if Roll == 1 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810345000,1);
    GiveItem(UID,900177664,1,30);
    end
	if Roll == 2 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810345000,1);
    GiveItem(UID,900178665,1,30);
    end
	if Roll == 3 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810345000,1);
    GiveItem(UID,900178666,1,30);
    end
	if Roll == 4 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810345000,1);
    GiveItem(UID,900178667,1,30);
    end
	if Roll == 5 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810345000,1);
    GiveItem(UID,900179670,1,30);
    end
	if Roll == 6 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810345000,1);
    GiveItem(UID,900180669,1,30);
    end
	if Roll == 7 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810345000,1);
    GiveItem(UID,900181671,1,30);
    end
	if Roll == 8 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810345000,1);
    GiveItem(UID,900182674,1,30);
    end
	if Roll == 9 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810345000,1);
    GiveItem(UID,900182675,1,30);
    end
	if Roll == 10 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810345000,1);
    GiveItem(UID,900182675,1,30);
    end
	end
	end
	end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 370) then
	ACC3 = HowmuchItem(UID, 810346000);
	if (ACC3 < 1 or ACC3 == 0) then
		SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	else
	EVENT = 371
	end
	end
	
if (EVENT == 371) then
	 ACC3 = HowmuchItem(UID, 810346000);
	     if (ACC3 < 1 or ACC3 == 0) then
    SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	     else
		 SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
        else
	Check = CheckExchangeSlot(UID, 1495)
       if  Check == true then   
    Roll = RollDice(UID, 4) 
    found = Roll + 1491
    RunQuestExchange(UID, found);	
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
end
end
end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 375) then
	ACC3 = HowmuchItem(UID, 810347000);
	if (ACC3 < 1 or ACC3 == 0) then
		SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	else
	EVENT = 376
	end
	end
	
if (EVENT == 376) then
	 ACC3 = HowmuchItem(UID, 810347000);
	     if (ACC3 < 1 or ACC3 == 0) then
    SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	     else
	SlotCheck = CheckGiveSlot(UID, 1);
         if SlotCheck == false then
	    else
	Check = CheckExchangeSlot(UID, 1727)
       if  Check == true then   
    Roll = RollDice(UID, 4) 
    found = Roll + 1705
    RunQuestExchange(UID, found);	
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
end
end
end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 380) then
	BIFF = HowmuchItem(UID, 810348000);
	if (BIFF < 1 or BIFF == 0) then
		SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	else
	EVENT = 381
	end
	end
	
if (EVENT == 381) then
	BIFF = HowmuchItem(UID, 810348000);
	if (BIFF < 1 or BIFF == 0) then
		SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	else
		SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
	Roll = RollDice(UID,6) 
	if Roll == 0 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810348000,1);
    GiveItem(UID,389160000,3);
    end
	if Roll == 1 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810348000,1);
    GiveItem(UID,389161000,3);
    end
	if Roll == 2 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810348000,1);
    GiveItem(UID,389162000,3);
    end
	if Roll == 3 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810348000,1);
    GiveItem(UID,389163000,3);
    end
	if Roll == 4 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810348000,1);
    GiveItem(UID,389164000,3);
    end
	if Roll == 5 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810348000,1);
    GiveItem(UID,389165000,3);
    end
	if Roll == 6 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810348000,1);
    GiveItem(UID,389166000,3);
    end
	end
	end
	end
	
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 385) then
	JURAD = HowmuchItem(UID, 810349000);
	if (JURAD < 1 or JURAD == 0) then
		SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	else
	EVENT = 386
	end
	end
	
if (EVENT == 386) then
	JURAD = HowmuchItem(UID, 810349000);
	if (JURAD < 1 or JURAD == 0) then
		SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	else
		SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
	Roll = RollDice(UID,5) 
	if Roll == 0 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810349000,1);
    GiveItem(UID,389196000,3);
    end
	if Roll == 1 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810349000,1);
    GiveItem(UID,389197000,3);
    end
	if Roll == 2 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810349000,1);
    GiveItem(UID,389198000,3);
    end
	if Roll == 3 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810349000,1);
    GiveItem(UID,389199000,3);
    end
	if Roll == 4 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810349000,1);
    GiveItem(UID,389201000,3);
    end
	if Roll == 5 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810349000,1);
    GiveItem(UID,389205000,3);
    end
	end
	end
	end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 390) then
	BATTLE = HowmuchItem(UID, 810344000);
	if (BATTLE < 1 or BATTLE == 0) then
		SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	else
	EVENT = 391
	end
	end
	
if (EVENT == 391) then
	BATTLE = HowmuchItem(UID, 810344000);
	if (BATTLE < 1 or BATTLE == 0) then
		SelectMsg(UID, 2, -1, 11673, NPC, 10, -1);
	else
		SlotCheck = CheckGiveSlot(UID, 1);
     if SlotCheck == false then
       ;
	    else
	Roll = RollDice(UID,3) 
	if Roll == 0 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810344000,1);
    GiveItem(UID,910248763,1,30);
    end
	if Roll == 1 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810344000,1);
    GiveItem(UID,910248854,1,30);
    end
	if Roll == 2 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810344000,1);
    GiveItem(UID,900028683,1,30);
    end
	if Roll == 3 then
	SelectMsg(UID,2,-1,11674,NPC,8238,-1);
	RobItem(UID, 810344000,1);
    GiveItem(UID,900030684,1,30);
    end
	end
	end
	end
	
----------------------------------------------------------------------------------------------------------------------
-- PREMİUM MENÜSÜ

--if (EVENT == 400) then
	--PREMIUM = GetPremium(UID);
	--if (PREMIUM == 0) then
		--SelectMsg(UID, 3, -1, 9527, NPC, 7197, 401, 7198, 402, 7252, 403,7803,404,10005,405,8574,406);
	--else
		--SelectMsg(UID, 2, -1, 9526, NPC, 10, -1);
	--end
--end

if (EVENT == 400) then--7803,404,10005,405,8574,406,
	SelectMsg(UID, 3, -1, 9527, NPC, 7197, 401, 7198, 402, 7252, 403,8390,600, 50543,750);   --,7803,404,10005,405,8574,406
end

if (EVENT == 401) then -- DISC Premium
	SelectMsg(UID, 2, -1, 9529, NPC, 3000, 407, 3005, -1);
end

if (EVENT == 402) then -- EXP Premium
	SelectMsg(UID, 2, -1, 9544, NPC, 3000, 409, 3005, -1);
end

if (EVENT == 403) then -- WAR Premium
	SelectMsg(UID, 2, -1, 9954, NPC, 3000, 411, 3005, -1);
end

if (EVENT == 404) then -- Gold Premium
	SelectMsg(UID, 2, -1, 10881, NPC, 3000, 413, 3005, -1);
end

if (EVENT == 405) then -- Bronze Premium
	SelectMsg(UID, 2, -1, 12068, NPC, 3000, 415, 3005, -1);
end

if (EVENT == 406) then -- Platinum Premium
	SelectMsg(UID, 2, -1, 9532, NPC, 3000, 417, 3005, -1);
end

if (EVENT == 600) then -- Switch Premium
	SelectMsg(UID, 2, -1, 9532, NPC, 3000, 601, 3005, -1);
end

----------------------------------------------------------------------------------------------------------------------
-- DC PREMİUM

if (EVENT == 407) then -- DISC Premium
	DCPREM = HowmuchItem(UID, 399281685);
	if (DCPREM < 1 or DCPREM == 0) then
		SelectMsg(UID, 2, -1, 9530, NPC, 18, 5000);
	else
		EVENT = 408
	end
end

if (EVENT == 408) then
	DCPREM = HowmuchItem(UID, 399281685);
	if (DCPREM < 1 or DCPREM == 0) then
		SelectMsg(UID, 2, -1, 9530, NPC, 18, 5000);
		else
		RobItem(UID, 399281685, 1);
		GivePremiumItem(UID,10)
		GivePremium(UID, 10, 30);
end	
end

----------------------------------------------------------------------------------------------------------------------
-- EXP PREMİUM

if (EVENT == 409) then -- EXP Premium Menüsü
	EXPPREM = HowmuchItem(UID, 399282686);
	if (EXPPREM < 1 or EXPPREM == 0) then
		SelectMsg(UID, 2, -1, 9531, NPC, 18, 5000);
	else
    EVENT = 410
	end
end

if (EVENT == 410) then
	EXPPREM = HowmuchItem(UID, 399282686);
	if (EXPPREM < 1 or EXPPREM == 0) then
		SelectMsg(UID, 2, -1, 9531, NPC, 18, 5000);
	else
	RobItem(UID, 399282686, 1);
	GivePremiumItem(UID,11);
	GivePremium(UID, 11, 30);
end
end

----------------------------------------------------------------------------------------------------------------------
-- WAR PREMİUM

if (EVENT == 411) then -- WAR Premium Menüsü
	WARPREM = HowmuchItem(UID, 399292764);
	if (WARPREM < 1 or WARPREM == 0) then
		SelectMsg(UID, 2, -1, 9955, NPC, 18, 5000);
	else
    EVENT = 412
	end
end

if (EVENT == 412) then
	WARPREM = HowmuchItem(UID, 399292764);
	if (WARPREM < 1 or WARPREM == 0) then
		SelectMsg(UID, 2, -1, 9955, NPC, 18, 5000);
	else
	RobItem(UID, 399292764, 1);
	GivePremiumItem(UID,12);		
	GivePremium(UID, 12, 30);
end
end

----------------------------------------------------------------------------------------------------------------------
-- GOLD PREMİUM

if (EVENT == 413) then -- Gold Premium Menüsü
	GOLDPRE = HowmuchItem(UID, 0);
	if (GOLDPRE < 1 or GOLDPRE == 0) then
		SelectMsg(UID, 2, -1, 10882, NPC, 18, 5000);
	else
    EVENT = 414
	end
end
	
if (EVENT == 414) then
	GOLDPRE = HowmuchItem(UID, 0);
	if (GOLDPRE < 1 or GOLDPRE == 0) then
		SelectMsg(UID, 2, -1, 10882, NPC, 18, 5000);
	else
	RobItem(UID, 0, 1);
	GivePremiumItem(UID,5);
	GivePremium(UID, 5, 30);
end
end

----------------------------------------------------------------------------------------------------------------------
-- BRONZE PREMİUM

if (EVENT == 415) then -- Bronze Premium Menüsü
	BRONZEPRE = HowmuchItem(UID, 814042000);
	if (BRONZEPRE < 1 or BRONZEPRE == 0) then
		SelectMsg(UID, 2, -1, 12069, NPC, 18, 5000);
	else
    EVENT = 416
	end
end

if (EVENT == 416) then
	BRONZEPRE = HowmuchItem(UID, 814042000);
	if (BRONZEPRE < 1 or BRONZEPRE == 0) then
		SelectMsg(UID, 2, -1, 12069, NPC, 18, 5000);
	else	
	RobItem(UID, 814042000, 1);
	GivePremium(UID, 3, 30);
end
end

----------------------------------------------------------------------------------------------------------------------
-- PLATİNİUM PREMİUM

if (EVENT == 417) then  -- Platinium Menüsü
	PLATPRE = HowmuchItem(UID, 800880000);
	if (PLATPRE < 1 or PLATPRE == 0) then
		SelectMsg(UID, 2, -1, 9533, NPC, 18, 5000);
	else
    EVENT = 418
	end
end

if (EVENT == 418) then
	PLATPRE = HowmuchItem(UID, 800880000);
	if (PLATPRE < 1 or PLATPRE == 0) then
		SelectMsg(UID, 2, -1, 9533, NPC, 18, 5000);
	else
		RobItem(UID, 800880000, 1);
		GivePremiumItem(UID,7);
		GivePremium(UID, 7, 30);
	end
end

------------------------------------------------------------------------------------------------------------------------------
-- SWİTCH PREMİUM

if (EVENT == 601) then -- Stiwch Premium Menüsü
	SWITCH = HowmuchItem(UID, 399295859);
	if (SWITCH < 1 or SWITCH == 0) then
		SelectMsg(UID, 2, -1, 9533, NPC, 18, 5000);
	else
    EVENT = 602
	end
end

if (EVENT == 602) then
	SWITCH = HowmuchItem(UID, 399295859);
	if (SWITCH < 1 or SWITCH == 0) then
		SelectMsg(UID, 2, -1, 9533, NPC, 18, 5000);
	else
		RobItem(UID, 399295859, 1);
		GivePremium(UID, 13, 30);
	end
end

------------------------------------------------------------------------------------------------------------------------------
-- CLAN PREMİUM

if (EVENT == 750) then
	CheckLeader = isClanLeader(UID) -- Bu fonksiyon Clan başkanı olup olmadığını kontrol eder.
	if (CheckLeader == false) then
		SelectMsg(UID, 3, -1, 45035, NPC, 10, -1);
	else
		CLANPREM = HowmuchItem(UID, 399300000);
		if (CLANPREM < 1) then
			SelectMsg(UID, 3, -1, 45033, NPC, 18, -1);
		else
			GivePremium(UID, 15, 30);
		end
	end
end

------------------------------------------------------------------------------------------------------------------------------
if (EVENT == 420) then
	MINEVRAPACK = HowmuchItem(UID, 508112000);
	if (MINEVRAPACK < 1 or MINEVRAPACK == 0) then
		SelectMsg(UID, 2, -1, 9622, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 9621, NPC, 4006, 421, 4005, -1);
	end
end

if (EVENT == 421) then
	MINEVRAPACK = HowmuchItem(UID, 508112000);
	if (MINEVRAPACK < 1 or MINEVRAPACK == 0) then
		SelectMsg(UID, 2, -1, 9622, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 3)
     if SlotCheck == false then
       
         else
	RobItem(UID, 508112000, 1);
	GiveItem(UID, 508056000, 1);
	GiveItem(UID, 508057000, 1);
    end
end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 430) then
	PATHOSPACK = HowmuchItem(UID, 508074000);
	if (PATHOSPACK < 1 or PATHOSPACK == 0) then
		SelectMsg(UID, 2, -1, 9629, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 9628, NPC, 4006, 431, 4005, -1);
    end
end

if (EVENT == 431) then
	PATHOSPACK = HowmuchItem(UID, 508074000);
	if (PATHOSPACK < 1 or PATHOSPACK == 0) then
		SelectMsg(UID, 2, -1, 9629, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 3)
     if SlotCheck == false then
       
         else
	RobItem(UID, 508074000, 1);
	GiveItem(UID, 800250000, 1);
	GiveItem(UID, 800250000, 1);
    end
end
end
----------------------------------------------------------------------------------------------------------------------
if (EVENT == 440) then
	SelectMsg(UID, 2, -1, 9938, NPC, 7244, 441, 7243, 442);
end

if (EVENT == 441) then
	ITEMYENIA = HowmuchItem(UID, 508117000);
	if (ITEMYENIA < 1 or ITEMYENIA == 0) then
	SelectMsg(UID, 2, -1, 9942, NPC, 18, 5000);
	else
	SelectMsg(UID, 3, -1, 9941, NPC, 4288, 443, 4289, 444, 4290, 445, 4291, 446);
	end
end

if (EVENT == 442) then
	ITEMYENIH = HowmuchItem(UID, 508116000);
	if (ITEMYENIH < 1 or ITEMYENIH == 0) then
	SelectMsg(UID, 2, -1, 9940, NPC, 18, 5000);
	else
	SelectMsg(UID, 3, -1, 9941, NPC, 4292, 447, 4293, 448, 4294, 449, 4295, 450);
	end
end
----------------------------------------------------------------------------------------
if (EVENT == 443) then
	ITEMYENIA = HowmuchItem(UID, 508117000);
	if (ITEMYENIA < 1 or ITEMYENIA == 0) then
	SelectMsg(UID, 2, -1, 9942, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 508117000, 1);
		GiveItem(UID, 518001636, 1,30);
	end
end
end

if (EVENT == 444) then
	ITEMYENIA = HowmuchItem(UID, 508117000);
	if (ITEMYENIA < 1 or ITEMYENIA == 0) then
	SelectMsg(UID, 2, -1, 9942, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 508117000, 1);
		GiveItem(UID, 518001637,1,30);
	end
end
end

if (EVENT == 445) then
	ITEMYENIA = HowmuchItem(UID, 508117000);
	if (ITEMYENIA < 1 or ITEMYENIA == 0) then
	SelectMsg(UID, 2, -1, 9942, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 508117000, 1);
		GiveItem(UID, 518001638, 1,30);
	end
end
end

if (EVENT == 446) then
	ITEMYENIA = HowmuchItem(UID, 508117000);
	if (ITEMYENIA < 1 or ITEMYENIA == 0) then
	SelectMsg(UID, 2, -1, 9942, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 508117000, 1);
		GiveItem(UID, 518001639, 1,30);
	end
end
end
----------------------------------------------------------------------------------------
if (EVENT == 447) then
	ITEMYENIH = HowmuchItem(UID, 508116000);
	if (ITEMYENIH < 1 or ITEMYENIH == 0) then
	SelectMsg(UID, 2, -1, 9940, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 508116000, 1);
		GiveItem(UID, 518003636, 1,30);
	end
end
end

if (EVENT == 448) then
	ITEMYENIH = HowmuchItem(UID, 508116000);
	if (ITEMYENIH < 1 or ITEMYENIH == 0) then
	SelectMsg(UID, 2, -1, 9940, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 508116000, 1);
		GiveItem(UID, 518003637, 1,30);
	end
end
end

if (EVENT == 449) then
	ITEMYENIH = HowmuchItem(UID, 508116000);
	if (ITEMYENIH < 1 or ITEMYENIH == 0) then
	SelectMsg(UID, 2, -1, 9940, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 508116000, 1);
		GiveItem(UID, 518003638, 1,30);
	end
end
end

if (EVENT == 450) then
	ITEMYENIH = HowmuchItem(UID, 508116000);
	if (ITEMYENIH < 1 or ITEMYENIH == 0) then
	SelectMsg(UID, 2, -1, 9940, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 508116000, 1);
		GiveItem(UID, 518003639, 1,30);
	end
end
end
----------------------------------------------------------------------------------------
if (EVENT == 460) then
SelectMsg(UID,2,-1,9706,NPC,7229,461,7230,462)
end

if (EVENT == 461) then
SelectMsg(UID,2,-1,9708,NPC,3000,463,3005,-1)
end

if (EVENT == 462) then
SelectMsg(UID,2,-1,9709,NPC,3000,464,3005,-1)
end

if (EVENT == 463) then
	SEAL10 = HowmuchItem(UID, 810520000);
	if (SEAL10 < 1 or SEAL10 == 0) then
	SelectMsg(UID, 2, -1, 9706, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		 SelectMsg(UID,2,-1,9706,NPC,10,-1)
		RobItem(UID, 810520000, 1);
		GiveItem(UID, 810890000,10);
	end
end
end

if (EVENT == 464) then
	SEAL50 = HowmuchItem(UID, 810700000);
	if (SEAL50 < 1 or SEAL50 == 0) then
	SelectMsg(UID, 2, -1, 9707, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		 SelectMsg(UID,2,-1,9707,NPC,10,-1)
		RobItem(UID, 810700000, 1);
		GiveItem(UID, 810890000,50);
	end
end
end
------------------------------------------------------------------------------------------------------------------------------
-- PERİLER (OREADS - DYARDS - ALSEIDS)
if (EVENT == 500) then ----------- PERİ MENU
	SelectMsg(UID, 3, -1, 9989, NPC, 7259, 501, 7260, 502, 7314, 503);
end

if (EVENT == 501) then
	SelectMsg(UID, 2, -1, 45062, NPC, 3000, 504, 3005, -1);
end

if (EVENT == 502) then
	SelectMsg(UID, 2, -1, 45062, NPC, 3000, 506, 3005, -1);
end

if (EVENT == 503) then
	SelectMsg(UID, 2, -1, 45062, NPC, 3000, 508, 3005, -1);
end

if (EVENT == 504) then  -- DYARDS PERİ VOUCHER
	DRYADS = HowmuchItem(UID, 900385000);
	if (DRYADS < 1 or DRYADS == 0) then
		SelectMsg(UID, 2, -1, 45065, NPC, 18, 5000);
	else
    EVENT =505
	end
end
---------------
if (EVENT == 505) then -- DYARDS PERİ VOUCHER
	DRYADS = HowmuchItem(UID, 900385000);
	if (DRYADS < 1 or DRYADS == 0) then
		SelectMsg(UID, 2, -1, 45065, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 900385000, 1);
	GiveItem(UID, 700038767, 1,30);
end
end
end
---------------
if (EVENT == 506) then -- OREADS PERİ VOUCHER
	OREADS = HowmuchItem(UID, 900386000);
	if (OREADS < 1 or OREADS == 0) then
		SelectMsg(UID, 2, -1, 45065, NPC, 18, 5000);
	else
    EVENT = 507
	end
end
---------------
if (EVENT == 507) then -- OREADS PERİ VOUCHER
	OREADS = HowmuchItem(UID, 900386000);
	if (OREADS < 1 or OREADS == 0) then
		SelectMsg(UID, 2, -1, 9991, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 900386000, 1);
	GiveItem(UID, 700039768, 1,30);
end
end
end
---------------
if (EVENT == 508) then -- ALSEIDS PERİ VOUCHER
	ALSEIDS = HowmuchItem(UID, 800387000);
	if (ALSEIDS < 1 or ALSEIDS == 0) then
		SelectMsg(UID, 2, -1, 45065, NPC, 18, 5000);
	else
    EVENT = 509
	end
end
---------------
if (EVENT == 509) then -- ALSEIDS PERİ VOUCHER
	ALSEIDS = HowmuchItem(UID, 800387000);
	if (ALSEIDS < 1 or ALSEIDS == 0) then
		SelectMsg(UID, 2, -1, 9992, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 800387000, 1);
	GiveItem(UID, 700042769, 1,30);
end
end
end

----------------------------------------------------------------------------------------
if (EVENT == 550) then
	HELWRATH = HowmuchItem(UID, 800451000);
	if (HELWRATH < 1 or HELWRATH == 0) then
		SelectMsg(UID, 2, -1, 43604, NPC, 18, 5000);
	else
		SelectMsg(UID, 2, -1, 43605, NPC, 4006, 551, 4005, -1);
	end
end

if (EVENT == 551) then
	HELWRATH = HowmuchItem(UID, 800451000);
	if (HELWRATH < 1 or HELWRATH == 0) then
		SelectMsg(UID, 2, -1, 43604, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 800451000, 1);
	GiveItem(UID, 518006774,1,30);
end
end
end
------------------------------------------------
if (EVENT == 556) then 
	SelectMsg(UID, 3, -1, 3018, NPC,7679,205,49032,552,49033,35264, 40536,111,8611,118,9017,133);
end


if (EVENT ==  118) then
	SelectMsg(UID, 2, -1, 12056, NPC, 8629,8000,8628,8001);
end

if (EVENT ==  8000) then --Alecia Wing Blue Menüsü
	SelectMsg(UID, 2, -1, 12056, NPC, 50587,119);  --,50588,8003, 50589,8008,50590,8013
end

if (EVENT == 119) then --Alencia Wing Blue 30 günlük
	BLUEWING = HowmuchItem(UID, 810502000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
		SelectMsg(UID, 3, -1, 12060, NPC, 7786,121,7787,122,7788,123,7789,124);
	end
end

if (EVENT == 121) then
	BLUEWING = HowmuchItem(UID, 810502000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810502000, 1);
	GiveItem(UID, 810510902, 1,30);
	end
    end
end

if (EVENT == 122) then
	BLUEWING = HowmuchItem(UID, 810502000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810502000, 1);
	GiveItem(UID, 810510903, 1,30);
	end
    end
end

if (EVENT == 123) then
	BLUEWING = HowmuchItem(UID, 810502000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810502000, 1);
	GiveItem(UID, 810510905, 1,30);
	end
    end
end

if (EVENT == 124) then
	BLUEWING = HowmuchItem(UID, 810502000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810502000, 1);
	GiveItem(UID, 810510904, 1,30);
	end
    end
end


--Alecia Wing Blue 15 Günlük

if (EVENT == 8003) then --Alencia Wing Blue 15 günlük
	BLUEWING = HowmuchItem(UID, 810503000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
		SelectMsg(UID, 3, -1, 12060, NPC, 7786,8004,7787,8005,7788,8006,7789,8007);
	end
end

if (EVENT == 8004) then
	BLUEWING = HowmuchItem(UID, 810503000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810503000, 1);
	GiveItem(UID, 810510902, 1,15);
	end
    end
end

if (EVENT == 8005) then
	BLUEWING = HowmuchItem(UID, 810503000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810503000, 1);
	GiveItem(UID, 810510903, 1,15);
	end
    end
end

if (EVENT == 8006) then
	BLUEWING = HowmuchItem(UID, 810503000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810503000, 1);
	GiveItem(UID, 810510905, 1,15);
	end
    end
end

if (EVENT == 8007) then
	BLUEWING = HowmuchItem(UID, 810503000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810503000, 1);
	GiveItem(UID, 810510904, 1,15);
	end
    end
end


--Alecia Wing Blue 7 Günlük

if (EVENT == 8008) then --Alencia Wing Blue 7 günlük
	BLUEWING = HowmuchItem(UID, 810504000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
		SelectMsg(UID, 3, -1, 12060, NPC, 7786,8009,7787,8010,7788,8011,7789,8012);
	end
end

if (EVENT == 8009) then
	BLUEWING = HowmuchItem(UID, 810504000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810504000, 1);
	GiveItem(UID, 810510902, 1,7);
	end
    end
end

if (EVENT == 8010) then
	BLUEWING = HowmuchItem(UID, 810504000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810504000, 1);
	GiveItem(UID, 810510903, 1,7);
	end
    end
end

if (EVENT == 8011) then
	BLUEWING = HowmuchItem(UID, 810504000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810504000, 1);
	GiveItem(UID, 810510905, 1,7);
	end
    end
end

if (EVENT == 8012) then
	BLUEWING = HowmuchItem(UID, 810504000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810504000, 1);
	GiveItem(UID, 810510904, 1,7);
	end
    end
end

--Alecia Wing Blue 1 Günlük

if (EVENT == 8013) then --Alencia Wing Blue 1 günlük
	BLUEWING = HowmuchItem(UID, 810505000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
		SelectMsg(UID, 3, -1, 12060, NPC, 7786,8014,7787,8015,7788,8016,7789,8017);
	end
end

if (EVENT == 8014) then
	BLUEWING = HowmuchItem(UID, 810505000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810505000, 1);
	GiveItem(UID, 810510902, 1,1);
	end
    end
end

if (EVENT == 8015) then
	BLUEWING = HowmuchItem(UID, 810505000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810505000, 1);
	GiveItem(UID, 810510903, 1,1);
	end
    end
end

if (EVENT == 8016) then
	BLUEWING = HowmuchItem(UID, 810505000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810505000, 1);
	GiveItem(UID, 810510905, 1,1);
	end
    end
end

if (EVENT == 8017) then
	BLUEWING = HowmuchItem(UID, 810505000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810505000, 1);
	GiveItem(UID, 810510904, 1,1);
	end
    end
end

if (EVENT ==  8001) then --Alecia Wing Red Menüsü
	SelectMsg(UID, 2, -1, 12056, NPC, 50591,120); --,50592,8018,50593,8023,50594,8028
end

if (EVENT == 120) then --Alencia Wing Red 30 günlük
	REDWING = HowmuchItem(UID, 810507000);
	if (REDWING < 1) then
		SelectMsg(UID, 2, -1, 12058, NPC, 18,5000);
	else
		SelectMsg(UID, 3, -1, 12057, NPC, 7786,125,7787,126,7788,127,7789,128);
	end
end

if (EVENT == 125) then
	REDWING = HowmuchItem(UID, 810507000);
	if (REDWING < 1) then
		SelectMsg(UID, 2, -1, 12058, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810507000, 1);
	GiveItem(UID, 810509906, 1,30);
	end
    end
end

if (EVENT == 126) then
	REDWING = HowmuchItem(UID, 810507000);
	if (REDWING < 1) then
		SelectMsg(UID, 2, -1, 12058, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810507000, 1);
	GiveItem(UID, 810509907, 1,30);
	end
    end
end

if (EVENT == 127) then
	REDWING = HowmuchItem(UID, 810507000);
	if (REDWING < 1) then
		SelectMsg(UID, 2, -1, 12058, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810507000, 1);
	GiveItem(UID, 810509909, 1,30);
	end
    end
end

if (EVENT == 128) then
	REDWING = HowmuchItem(UID, 810507000);
	if (REDWING < 1) then
		SelectMsg(UID, 2, -1, 12058, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810507000, 1);
	GiveItem(UID, 810509908, 1,30);
	end
    end
end


--Alecia Wing Red 15 Günlük

if (EVENT == 8018) then --Alencia Wing Red 15 günlük
	BLUEWING = HowmuchItem(UID, 810503000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
		SelectMsg(UID, 3, -1, 12060, NPC, 7786,8019,7787,8020,7788,8021,7789,8022);
	end
end

if (EVENT == 8019) then
	BLUEWING = HowmuchItem(UID, 810503000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810503000, 1);
	GiveItem(UID, 810509906, 1,15);
	end
    end
end

if (EVENT == 8020) then
	BLUEWING = HowmuchItem(UID, 810503000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810503000, 1);
	GiveItem(UID, 810509907, 1,15);
	end
    end
end

if (EVENT == 8021) then
	BLUEWING = HowmuchItem(UID, 810503000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810503000, 1);
	GiveItem(UID, 810509909, 1,15);
	end
    end
end

if (EVENT == 8022) then
	BLUEWING = HowmuchItem(UID, 810503000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810503000, 1);
	GiveItem(UID, 810509908, 1,15);
	end
    end
end


--Alecia Wing Red 7 Günlük

if (EVENT == 8023) then --Alencia Wing Red 7 günlük
	BLUEWING = HowmuchItem(UID, 810504000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
		SelectMsg(UID, 3, -1, 12060, NPC, 7786,8024,7787,8025,7788,8026,7789,8027);
	end
end

if (EVENT == 8024) then
	BLUEWING = HowmuchItem(UID, 810504000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810504000, 1);
	GiveItem(UID, 810509906, 1,7);
	end
    end
end

if (EVENT == 8025) then
	BLUEWING = HowmuchItem(UID, 810504000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810504000, 1);
	GiveItem(UID, 810509907, 1,7);
	end
    end
end

if (EVENT == 8026) then
	BLUEWING = HowmuchItem(UID, 810504000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810504000, 1);
	GiveItem(UID, 810509909, 1,7);
	end
    end
end

if (EVENT == 8027) then
	BLUEWING = HowmuchItem(UID, 810504000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810504000, 1);
	GiveItem(UID, 810509908, 1,7);
	end
    end
end

--Alecia Wing Red 1 Günlük

if (EVENT == 8028) then --Alencia Wing Red 1 günlük
	BLUEWING = HowmuchItem(UID, 810505000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
		SelectMsg(UID, 3, -1, 12060, NPC, 7786,8029,7787,8030,7788,8031,7789,8032);
	end
end

if (EVENT == 8029) then
	BLUEWING = HowmuchItem(UID, 810505000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810505000, 1);
	GiveItem(UID, 810509906, 1,1);
	end
    end
end

if (EVENT == 8030) then
	BLUEWING = HowmuchItem(UID, 810505000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810505000, 1);
	GiveItem(UID, 810509907, 1,1);
	end
    end
end

if (EVENT == 8031) then
	BLUEWING = HowmuchItem(UID, 810505000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810505000, 1);
	GiveItem(UID, 810509909, 1,1);
	end
    end
end

if (EVENT == 8032) then
	BLUEWING = HowmuchItem(UID, 810505000);
	if (BLUEWING < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18,5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 810505000, 1);
	GiveItem(UID, 810509908, 1,1);
	end
    end
end

if (EVENT == 133) then -- Wing of Hellfire
SelectMsg(UID,3,-1,12458,NPC,9023,138) -- 40619,135,40620,136,9022,137,
end


--hellfire 30 günlük
if (EVENT == 138) then
	WING = HowmuchItem(UID, 810672000);
	if (WING > 0) then
		SelectMsg(UID, 3, -1, 12458, NPC, 7786, 156, 7787, 157, 7788, 158, 7789, 159);
	else
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	end
end
if (EVENT == 156) then
	WING = HowmuchItem(UID, 810672000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810672000, 1);
		GiveItem(UID, 810638711, 1,30);
		end
	end
end

if (EVENT == 157) then
	WING = HowmuchItem(UID, 810672000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810672000, 1);
		GiveItem(UID, 810638712, 1,30);
		end
	end
end

if (EVENT == 158) then
	WING = HowmuchItem(UID, 810672000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810672000, 1);
		GiveItem(UID, 810638730, 1,30);
		end
	end
end

if (EVENT == 159) then
	WING = HowmuchItem(UID, 810672000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810672000, 1);
		GiveItem(UID, 810638731, 1,30);
		end
	end
end



--hellfire 1 günlük
if (EVENT == 135) then
	WING = HowmuchItem(UID, 910936000);
	if (WING > 0) then
		SelectMsg(UID, 3, -1, 12458, NPC, 7786, 144, 7787, 145, 7788, 146, 7789, 147);
	else
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	end
end

if (EVENT == 144) then
	WING = HowmuchItem(UID, 910936000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 910936000, 1);
		GiveItem(UID, 810638711, 1,1);
		end
	end
end

if (EVENT == 145) then
	WING = HowmuchItem(UID, 910936000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 910936000, 1);
		GiveItem(UID, 810638712, 1,1);
		end
	end
end

if (EVENT == 146) then
	WING = HowmuchItem(UID, 910936000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 910936000, 1);
		GiveItem(UID, 810638730, 1,1);
		end
	end
end

if (EVENT == 147) then
	WING = HowmuchItem(UID, 910936000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 910936000, 1);
		GiveItem(UID, 810638731, 1,1);
		end
	end
end
--hellfire 7 günlük
if (EVENT == 136) then
	WING = HowmuchItem(UID, 910939000);
	if (WING > 0) then
		SelectMsg(UID, 3, -1, 12458, NPC, 7786, 148, 7787, 149, 7788, 150, 7789, 151);
	else
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
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

--helfire 15 günlük
if (EVENT == 137) then
	WING = HowmuchItem(UID, 910938000);
	if (WING > 0) then
		SelectMsg(UID, 3, -1, 12458, NPC, 7786, 152, 7787, 153, 7788, 154, 7789, 155);
	else
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	end
end

if (EVENT == 152) then
	WING = HowmuchItem(UID, 910938000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 910938000, 1);
		GiveItem(UID, 810638711, 1,15);
		end
	end
end

if (EVENT == 153) then
	WING = HowmuchItem(UID, 910938000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810640000, 1);
		GiveItem(UID, 910938000, 1,15);
		end
	end
end

if (EVENT == 154) then
	WING = HowmuchItem(UID, 910938000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 910938000, 1);
		GiveItem(UID, 810638730, 1,15);
		end
	end
end

if (EVENT == 155) then
	WING = HowmuchItem(UID, 910938000);
	if (WING == 0) then
		SelectMsg(UID, 2, -1, 12461, NPC, 10, -1);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 910938000, 1);
		GiveItem(UID, 810638731, 1,15);
		end
	end
end


------------------------------------------------------------------------------------------------------------------
if (EVENT == 111) then --Cupid Wing
	CUPIDWING = HowmuchItem(UID, 810715000);
	if (CUPIDWING < 1) then
		SelectMsg(UID, 2, -1, 44440, NPC, 18, 5000);
	else
		SelectMsg(UID, 3, -1, 44439, NPC, 7680,112,7681,113,7682,114,7683,115);
	end
end

if (EVENT == 112) then
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810715000, 1);
		GiveItem(UID, 810714946,1,30);
	end
end

if (EVENT == 113) then
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810715000, 1);
		GiveItem(UID, 810714947,1,30);
	end
end

if (EVENT == 114) then
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810715000, 1);
		GiveItem(UID, 810714948,1,30);
	end
end

if (EVENT == 115) then
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
		RobItem(UID, 810715000, 1);
		GiveItem(UID, 810714949,1,30);
	end
end

if (EVENT == 552) then -- War Wing 30 DAY
	WarWing = HowmuchItem(UID, 950248000);
	if (WarWing < 1 or WarWing == 0) then
		SelectMsg(UID, 2, -1, 91002, NPC, 18, 5000);
	else
    EVENT = 553
	end
end

if (EVENT == 553) then
	WarWing = HowmuchItem(UID, 950248000);
	if (WarWing < 1 or WarWing == 0) then
		SelectMsg(UID, 2, -1, 91004, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	RobItem(UID, 950248000, 1);
	GiveItem(UID, 910248763, 1,30);
end
end
end
----------------------------------------------------------------------------------------
if (EVENT == 35264) then 
	SelectMsg(UID, 3, -1, 3018, NPC,50504,554,50505,3500,50506,3502,50507,3504,50508,3506);
end

if (EVENT == 554) then -- Battle Hero Wing 30 DAY
	WarWing = HowmuchItem(UID, 810251000);
	if (WarWing < 1 or WarWing == 0) then
		SelectMsg(UID, 2, -1, 91002, NPC, 18, 5000);
	else
    EVENT = 555
	end
end

if (EVENT == 555) then
	WarWing = HowmuchItem(UID, 810251000);
	if (WarWing < 1 or WarWing == 0) then
		SelectMsg(UID, 2, -1, 91004, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	NATION = CheckNation(UID);
	if (NATION == 1) then
	RobItem(UID, 810251000, 1);
	GiveItem(UID, 900030684, 1,30);
	else
	RobItem(UID, 810251000, 1);
	GiveItem(UID, 900028683, 1,30);
	end
	
end
end
end
----------------------------------------------------------------------------------------
if (EVENT == 3500) then -- Battle Hero Wing 15 DAY
	WarWing = HowmuchItem(UID, 910651000);
	if (WarWing < 1 or WarWing == 0) then
		SelectMsg(UID, 2, -1, 91002, NPC, 18, 5000);
	else
    EVENT = 3501
	end
end

if (EVENT == 3501) then
	WarWing = HowmuchItem(UID, 910651000);
	if (WarWing < 1 or WarWing == 0) then
		SelectMsg(UID, 2, -1, 91004, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	NATION = CheckNation(UID);
	if (NATION == 1) then
	RobItem(UID, 910651000, 1);
	GiveItem(UID, 900030684, 1,15);
	else
	RobItem(UID, 910651000, 1);
	GiveItem(UID, 900028683, 1,15);
	end
	
end
end
end
----------------------------------------------------------------------------------------
if (EVENT == 3502) then -- Battle Hero Wing 7 DAY
	WarWing = HowmuchItem(UID, 910551000);
	if (WarWing < 1 or WarWing == 0) then
		SelectMsg(UID, 2, -1, 91002, NPC, 18, 5000);
	else
    EVENT = 3503
	end
end

if (EVENT == 3503) then
	WarWing = HowmuchItem(UID, 910551000);
	if (WarWing < 1 or WarWing == 0) then
		SelectMsg(UID, 2, -1, 91004, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	NATION = CheckNation(UID);
	if (NATION == 1) then
	RobItem(UID, 910551000, 1);
	GiveItem(UID, 900030684, 1,7);
	else
	RobItem(UID, 910551000, 1);
	GiveItem(UID, 900028683, 1,7);
	end
	
end
end
end
----------------------------------------------------------------------------------------
if (EVENT == 3504) then -- Battle Hero Wing 3 DAY
	WarWing = HowmuchItem(UID, 910451000);
	if (WarWing < 1 or WarWing == 0) then
		SelectMsg(UID, 2, -1, 91002, NPC, 18, 5000);
	else
    EVENT = 3505
	end
end

if (EVENT == 3505) then
	WarWing = HowmuchItem(UID, 910451000);
	if (WarWing < 1 or WarWing == 0) then
		SelectMsg(UID, 2, -1, 91004, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	NATION = CheckNation(UID);
	if (NATION == 1) then
	RobItem(UID, 910451000, 1);
	GiveItem(UID, 900030684, 1,3);
	else
	RobItem(UID, 910451000, 1);
	GiveItem(UID, 900028683, 1,3);
	end
	
end
end
end

----------------------------------------------------------------------------------------
if (EVENT == 3506) then -- Battle Hero Wing 1 DAY
	WarWing = HowmuchItem(UID, 910351000);
	if (WarWing < 1 or WarWing == 0) then
		SelectMsg(UID, 2, -1, 91002, NPC, 18, 5000);
	else
    EVENT = 3507
	end
end

if (EVENT == 3507) then
	WarWing = HowmuchItem(UID, 910351000);
	if (WarWing < 1 or WarWing == 0) then
		SelectMsg(UID, 2, -1, 91004, NPC, 18, 5000);
	else
SlotCheck = CheckGiveSlot(UID, 1)
     if SlotCheck == false then
       
         else
	NATION = CheckNation(UID);
	if (NATION == 1) then
	RobItem(UID, 910351000, 1);
	GiveItem(UID, 900030684, 1,1);
	else
	RobItem(UID, 910351000, 1);
	GiveItem(UID, 900028683, 1,1);
	end
	
end
end
end

----------------------------------------------------------------------------------------
if (EVENT == 5000) then
	ShowMap(UID, 450);
end