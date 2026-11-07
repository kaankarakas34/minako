local NPC = 29056;
local Ret = 0;

if (EVENT == 100) then
	SelectMsg(UID, 3, -1, 3018, NPC, 8611, 115, 40102, 106, 49032, 107, 8229, 108, 7202, 110, 7214, 104, 7219, 105, 7242, 547, 2002, 103);
end

if (EVENT == 101) then
	Ret = 1;
end

if (EVENT == 115) then -- Alencia Wing
	SelectMsg(UID, 2, -1, 12056, NPC, 8629, 116);
end

if (EVENT == 116) then -- Alencia Wing Blue
	ALENCIA = HowmuchItem(UID, 900387000); 
	if (ALENCIA < 1) then
		SelectMsg(UID, 2, -1, 12061, NPC, 18, 1000); 
	else
		SelectMsg(UID, 2, -1, 12060, NPC, 4006, 117, 4005, 101);
	end
end

if (EVENT == 1000) then
	ShowMap(UID, 450);
end

if (EVENT == 117) then
	ALENCIA = HowmuchItem(UID, 900387000); 
	if (ALENCIA > 0) then
	GiveItemLua(UID,800032000,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 900767000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 106) then -- Exchanging Items
	SelectMsg(UID, 3, -1, 3018, NPC, 7247, 118, 7248, 119, 7250, 120, 7251, 121, 8210, 122, 7258, 123);
end

if (EVENT == 118) then -- Golden Pickax
	DCPRE = HowmuchItem(UID, 508122000);
	if (DCPRE < 1) then
		SelectMsg(UID, 2, -1, 9943, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 9944, NPC, 4006, 124, 4005, 101);
	end
end

if (EVENT == 124) then
	DCPRE = HowmuchItem(UID, 508122000);
	if (DCPRE > 0) then
	GiveItemLua(UID,389135000,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 508122000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 119) then -- Golden Fishing
	EXPPRE = HowmuchItem(UID, 508121000);
	if (EXPPRE < 1) then
		SelectMsg(UID, 2, -1, 9945, NPC, 18, 1000);
	elseif (EXPPRE > 0) then
		SelectMsg(UID, 2, -1, 9946, NPC, 4006, 125, 4005, 101);
	end
end

if (EVENT == 125) then
	EXPPRE = HowmuchItem(UID, 508121000);
	if (EXPPRE > 0) then
	GiveItemLua(UID,191347000,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 508121000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 120) then -- War Pre Map of Chaos
	WARPRE = HowmuchItem(UID, 399292764);
	if (WARPRE < 1) then
		SelectMsg(UID, 2, -1, 9951, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 9949, NPC, 4006, 128, 4005, 101);
	end
end

if (EVENT == 128) then
	GiveItemLua(UID,910247000,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 399292764,1, 0,0, 0,0, 0,0, 0,0);
end

if (EVENT == 121) then -- War Pre Ancient Text
	WARPRE = HowmuchItem(UID, 399292764);
	if (WARPRE < 1) then
		SelectMsg(UID, 2, -1, 9951, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 9953, NPC, 4006, 129, 4005, 101);
	end
end

if (EVENT == 129) then
	WARPRE = HowmuchItem(UID, 399292764);
	if (WARPRE > 0) then
	GiveItemLua(UID,810161000,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 399292764,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 122) then -- Under Castle Weapons Box
	UNDER = HowmuchItem(UID, 399292764); -- ITEM KONTROL EDILMELI
	if (UNDER < 1) then
		SelectMsg(UID, 2, -1, 11061, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 11062, NPC, 4006, 130, 4005, 101);
	end
end

if (EVENT == 130) then
	UNDER = HowmuchItem(UID, 399292764); -- ITEM KONTROL EDILMELI
	if (UNDER > 0) then
	GiveItemLua(UID,810161000,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 399292764,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 123) then -- Spirit's Help
	SelectMsg(UID, 3, -1, 9989, NPC, 7259, 131, 7260, 132, 7314, 133);
end

if (EVENT == 131) then -- Spirit Dryads
	SelectMsg(UID, 2, -1, 9990, NPC, 3000, 134, 3005, 101);
end

if (EVENT == 134) then
	DRYADS = HowmuchItem(UID, 900385000); -- ITEM KONTROL EDILMELI
	if (DRYADS < 1) then
		SelectMsg(UID, 2, -1, 9991, NPC, 18, 1000);
	else
		GiveItemLua(UID,700038767,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 900385000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 132) then -- Spirit Oreads
	SelectMsg(UID, 2, -1, 9990, NPC, 3000, 135, 3005, 101);
end

if (EVENT == 135) then
	OREADS = HowmuchItem(UID, 900386000); -- ITEM KONTROL EDILMELI
	if (OREADS < 1) then
		SelectMsg(UID, 2, -1, 9991, NPC, 18, 1000);
	else
		GiveItemLua(UID,700039768,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 900386000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 133) then -- Spirit Alseids
	SelectMsg(UID, 2, -1, 9990, NPC, 3000, 136, 3005, 101);
end

if (EVENT == 136) then
	ALSEIDS = HowmuchItem(UID, 900386000); -- ITEM KONTROL EDILMELI
	if (ALSEIDS < 1) then
		SelectMsg(UID, 2, -1, 9992, NPC, 18, 1000);
	else
		GiveItemLua(UID,700042769,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 900386000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 107) then -- Monster Staff Exchanging Items
	SelectMsg(UID, 3, -1, 10849, NPC, 49033, 137, 49024, 138, 7791, 139, 49026, 140, 7793, 141, 49025, 142, 49022, 143, 49027, 144, 49023, 145);
end

if (EVENT == 137) then -- +4 Rosetta Armor
	SelectMsg(UID, 3, -1, 11677, NPC, 49028, 146, 49029, 147, 49030, 148, 49031, 149);
end

if (EVENT == 146) then
	ROSWAR = HowmuchItem(UID, 810346000); -- ITEM KONTROL EDILMELI
	if (ROSWAR < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 18, 1000);
	else
		GiveItemLua(UID,235511005,1,0, 235512005,1,0, 235513005,1,0, 235514005,1,0, 235515005,1,0, 810346000,1, 0,0, 0,0, 0,0, 0,0);

	end
end

if (EVENT == 147) then
	ROSROG = HowmuchItem(UID, 810346000); -- ITEM KONTROL EDILMELI
	if (ROSROG < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 18, 1000);
	else
		GiveItemLua(UID,236511065,1,0, 236512065,1,0, 236513065,1,0, 236514065,1,0, 236515065,1,0, 810346000,1, 0,0, 0,0, 0,0, 0,0);

	end
end

if (EVENT == 148) then
	ROSMAGE = HowmuchItem(UID, 810346000); -- ITEM KONTROL EDILMELI
	if (ROSMAGE < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 18, 1000);
	else
		GiveItemLua(UID,237511035,1,0, 237512035,1,0, 237513035,1,0, 237514035,1,0, 237515035,1,0, 810346000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 149) then
	ROSPRI = HowmuchItem(UID, 810346000); -- ITEM KONTROL EDILMELI
	if (ROSPRI < 1) then
		SelectMsg(UID, 2, -1, 11678, NPC, 18, 1000);
	else
		GiveItemLua(UID,238511035,1,0, 238512035,1,0, 238513035,1,0, 238514035,1,0, 238515035,1,0, 810346000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 138) then -- Juriad Jewel Box
	MONJUR = HowmuchItem(UID, 810163000); -- ITEM KONTROL EDILMELI
	if (MONJUR < 1) then
		SelectMsg(UID, 2, -1, 10851, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 10850, NPC, 4006, 150, 4005, 101);
	end
end

if (EVENT == 150) then
	GiveItemLua(UID,810166000,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810163000,1, 0,0, 0,0, 0,0, 0,0);
end

if EVENT == 400 then
	LOTTO = HowmuchItem(UID, 810347000);
	if (LOTTO < 1) then 
	SelectMsg(UID, 2, 14, 10853, NPC, 18, -1);
	else
    SelectMsg(UID, 4, 14, 10852, NPC, 4006, 151, 4005, -1);
	end
end

if EVENT == 401 then 
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
	   else
Check = CheckGiveSlot(UID, 1727)
   if  Check == true then   
   Roll = RollDice(UID, 23) 
   found = Roll + 1705
   RunExchange(UID, found);
   end  
      end
	     end

if (EVENT == 140) then -- Bifrost Box
	MONBEEF = HowmuchItem(UID, 931682000); -- ITEM KONTROL EDILMELI
	if (MONBEEF < 1) then
		SelectMsg(UID, 2, -1, 10855, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 10854, NPC, 4006, 152, 4005, 101);
	end
end

if (EVENT == 152) then
	GiveItemLua(UID,914041877,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 931682000,1, 0,0, 0,0, 0,0, 0,0);
end

if (EVENT == 141) then -- 7 Armor Package
	-- TODO :P
end

if (EVENT == 153) then
	-- 7 Armor Package
end

if (EVENT == 142) then -- Guardian Exchange Coupon
	Guardian = HowmuchItem(UID, 931692000); -- ITEM KONTROL EDILMELI
	if (Guardian < 1) then
		SelectMsg(UID, 2, -1, 10859, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 10858, NPC, 4006, 154, 4005, 101);
	end
end

if (EVENT == 154) then
	GiveItemLua(UID,900000000,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 931692000,1, 0,0, 0,0, 0,0, 0,0);
end

if (EVENT == 143) then -- Magpie Mama Transformation vouchers
	Magpie = HowmuchItem(UID, 810926000); -- ITEM KONTROL EDILMELI
	if (Magpie < 1) then
		SelectMsg(UID, 2, -1, 10861, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 10860, NPC, 4006, 155, 4005, 101);
	end
end

if (EVENT == 155) then
	GiveItemLua(UID,810930952,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810926000,1, 0,0, 0,0, 0,0, 0,0);
end

if (EVENT == 144) then -- Battlefield Hero Wing Coupon
	Hero = HowmuchItem(UID, 900056000); -- ITEM KONTROL EDILMELI
	if (Hero < 1) then
		SelectMsg(UID, 2, -1, 10865, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 10864, NPC, 4006, 156, 4005, 101);
	end
end

if (EVENT == 156) then
	GiveItemLua(UID,900396772,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 900056000,1, 0,0, 0,0, 0,0, 0,0);
end

if (EVENT == 145) then -- Wing Weapon Box
	Wing = HowmuchItem(UID, 814663000); -- ITEM KONTROL EDILMELI
	if (Wing < 1) then
		SelectMsg(UID, 2, -1, 11037, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 11036, NPC, 4006, 157, 4005, 101);
	end
end

if (EVENT == 157) then
	GiveItemLua(UID,814664796,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 814663000,1, 0,0, 0,0, 0,0, 0,0);
end


if (EVENT == 108) then -- Dragon Box Exchanging Items
	SelectMsg(UID, 3, -1, 11672, NPC, 8229, 158, 8230, 159, 8231, 160, 8232, 161, 8233, 162, 8234, 163, 8235, 164, 8236, 165, 8239, 166);
end


--Dragon Box  Exchange Coupon-----------------------------------------------
if (EVENT == 158) then -- Dragon Box
	Dragon = HowmuchItem(UID, 810209000); -- ITEM KONTROL EDILMELI
	if (Dragon < 1) then
		SelectMsg(UID, 2, -1, 11673, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 11674, NPC, 4006, 167, 4005, 101);
	end
end

if (EVENT == 168) then
    RobItem(UID, 810209000, 1)
   Check = CheckGiveSlot(UID, 6822)
   if  Check == true then   
   Roll = RollDice(UID, 20) 
   found = Roll + 6803
   RunExchange(UID, found);		 
   else
   Ret = 1; 
   end  
end

----------------------------------------------------------------------------
if (EVENT == 159) then -- Dragon Box
	Dragon = HowmuchItem(UID, 810341000); -- ITEM KONTROL EDILMELI
	if (Dragon < 1) then
		SelectMsg(UID, 2, -1, 11673, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 11674, NPC, 4006, 168, 4005, 101);
	end
end

if (EVENT == 168) then
	GiveItemLua(UID,810342000,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810341000,1, 0,0, 0,0, 0,0, 0,0);
end

--Dragon Box 8th Armor Pack-------------------------------------------------
if (EVENT == 160) then -- Dragon Box
	Dragon = HowmuchItem(UID, 810341000); -- ITEM KONTROL EDILMELI
	if (Dragon < 1) then
		SelectMsg(UID, 2, -1, 11673, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 11674, NPC, 4006, 169, 4005, 101);
	end
end

if (EVENT == 169) then
	GiveItemLua(UID,810343000,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810341000,1, 0,0, 0,0, 0,0, 0,0);
end

--Dragon Box Unknown Feather------------------------------------------------
if (EVENT == 161) then -- Dragon Box
	Dragon = HowmuchItem(UID, 810341000); -- ITEM KONTROL EDILMELI
	if (Dragon < 1) then
		SelectMsg(UID, 2, -1, 11673, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 11674, NPC, 4006, 170, 4005, 101);
	end
end

if (EVENT == 170) then
	GiveItemLua(UID,810345000,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810341000,1, 0,0, 0,0, 0,0, 0,0);
end

--Dragon Box 7th Armor Pack-------------------------------------------------
if (EVENT == 162) then -- Dragon Box
	Dragon = HowmuchItem(UID, 810341000); -- ITEM KONTROL EDILMELI
	if (Dragon < 1) then
		SelectMsg(UID, 2, -1, 11673, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 11674, NPC, 4006, 171, 4005, 101);
	end
end

if (EVENT == 171) then
	GiveItemLua(UID,810341000,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810346000,1, 0,0, 0,0, 0,0, 0,0);
end

--Dragon Box Accessory Box--------------------------------------------------
if (EVENT == 163) then -- Dragon Box
	Dragon = HowmuchItem(UID, 810341000); -- ITEM KONTROL EDILMELI
	if (Dragon < 1) then
		SelectMsg(UID, 2, -1, 11673, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 11674, NPC, 4006, 172, 4005, 101);
	end
end

if (EVENT == 172) then
	GiveItemLua(UID,810341000,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810347000,1, 0,0, 0,0, 0,0, 0,0);
end

----------------------------------------------------------------------------
--Dragon Box Beefroast Box--------------------------------------------------
if (EVENT == 164) then -- Dragon Box
	Dragon = HowmuchItem(UID, 810341000); -- ITEM KONTROL EDILMELI
	if (Dragon < 1) then
		SelectMsg(UID, 2, -1, 11673, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 11674, NPC, 4006, 173, 4005, 101);
	end
end

if (EVENT == 173) then
	GiveItemLua(UID,810348000,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810341000,1, 0,0, 0,0, 0,0, 0,0);	
end

--Dragon Box Juriad Jewel Box-----------------------------------------------

if (EVENT == 165) then -- Dragon Box
	Dragon = HowmuchItem(UID, 810341000); -- ITEM KONTROL EDILMELI
	if (Dragon < 1) then
		SelectMsg(UID, 2, -1, 11673, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 11674, NPC, 4006, 174, 4005, 101);
	end
end

if (EVENT == 174) then
	GiveItemLua(UID,810349000,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810341000,1, 0,0, 0,0, 0,0, 0,0);
end

--Dragon Box Battlefield Hero's Wing Exchange Coupon-------------------------

if (EVENT == 166) then -- Dragon Box
	Dragon = HowmuchItem(UID, 810344000); -- ITEM KONTROL EDILMELI
	if (Dragon < 1) then
		SelectMsg(UID, 2, -1, 11673, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 11674, NPC, 4006, 175, 4005, 101);
	end
end

if (EVENT == 175) then
	GiveItemLua(UID,900030684,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810344000,1, 0,0, 0,0, 0,0, 0,0);
end

if (EVENT == 110) then -- Premium Item Use
	SelectMsg(UID, 3, -1, 9527, NPC, 7197, 176, 7198, 181, 7252, 182,8635,975);
end

if (EVENT == 975) then -- switch Premium 
SelectMsg(UID, 2, -1, 9527, NPC, 4006, 976, 4005, 101); 
end

if (EVENT == 976) then 
SlotControl = CheckGiveSlot(UID,1);
if (SlotControl == true) then -- slotta yer var 
EXPPREM = HowmuchItem(UID, 399295000); 
if (EXPPREM < 1) then 

SelectMsg(UID, 2, -1, 9528, NPC, 18, 101);
else
GiveItemLua(UID,0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 399295000,1, 0,0, 0,0, 0,0, 0,0);
GivePremium(UID, 10, 720) 
GivePremium(UID, 11, 720)
GivePremium(UID, 12, 720)

end 
end
end

if (EVENT == 1100) then -- Cash Item Use
	SelectMsg(UID, 3, -1, 9527, NPC, 17201, 1101, 17202, 1102, 17203, 1103, 17204, 1104, 17205, 1105, 17206, 1106, 17207, 1107);
end

if (EVENT == 1101) then -- 10 KC
	KC = HowmuchItem(UID, 389168000);
	if (KC < 1) then
		SelectMsg(UID, 2, -1, 45001, NPC, 18, 1000);
	else
	GiveItemLua(UID,0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 389168000,1, 0,0, 0,0, 0,0, 0,0);
	GiveKnightCash(UID, 10)
	end
end

if (EVENT == 1102) then -- 50 KC
	KC = HowmuchItem(UID, 389169000);
	if (KC < 1) then
		SelectMsg(UID, 2, -1, 45002, NPC, 18, 1000);
	else
	GiveItemLua(UID,0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 389169000,1, 0,0, 0,0, 0,0, 0,0);
	GiveKnightCash(UID, 50)
	end
end

if (EVENT == 1103) then -- 100 KC
	KC = HowmuchItem(UID, 389170000);
	if (KC < 1) then
		SelectMsg(UID, 2, -1, 45003, NPC, 18, 1000);
	else
	GiveItemLua(UID,0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 389170000,1, 0,0, 0,0, 0,0, 0,0);
	GiveKnightCash(UID, 100)
	end
end

if (EVENT == 1104) then -- 250 KC
	KC = HowmuchItem(UID, 389171000);
	if (KC < 1) then
		SelectMsg(UID, 2, -1, 45004, NPC, 18, 1000);
	else
		GiveItemLua(UID,0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 389171000,1, 0,0, 0,0, 0,0, 0,0);
		GiveKnightCash(UID, 250)
	end
end

if (EVENT == 1105) then -- 500 KC
	KC = HowmuchItem(UID, 389172000);
	if (KC < 1) then
		SelectMsg(UID, 2, -1, 45005, NPC, 18, 1000);
	else
	GiveItemLua(UID,0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 389172000,1, 0,0, 0,0, 0,0, 0,0);
	GiveKnightCash(UID, 500)
	end
end

if (EVENT == 1106) then -- 1000 KC
	KC = HowmuchItem(UID, 389173000);
	if (KC < 1) then
		SelectMsg(UID, 2, -1, 45006, NPC, 18, 1000);
	else
	GiveItemLua(UID,0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 389173000,1, 0,0, 0,0, 0,0, 0,0);
	GiveKnightCash(UID, 1000)
	end
end

if (EVENT == 1107) then -- 2000 KC
	KC = HowmuchItem(UID, 389174000);
	if (KC < 1) then
		SelectMsg(UID, 2, -1, 45007, NPC, 18, 1000);
	else
	GiveItemLua(UID,0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 389174000,1, 0,0, 0,0, 0,0, 0,0);
	GiveKnightCash(UID, 2000)
	end
end


if (EVENT == 176) then -- DISC Premium
	SelectMsg(UID, 2, -1, 9527, NPC, 4006, 183, 4005, 101);
end

if (EVENT == 183) then
	DCPREM = HowmuchItem(UID, 399281685);
	if (DCPREM < 1) then
		SelectMsg(UID, 2, -1, 9528, NPC, 18, 1000);
	else
		GiveItemLua(UID,508122000,1,0, 700002000,1,0, 0,0,0, 0,0,0, 0,0,0, 399281685,1, 0,0, 0,0, 0,0, 0,0);
		GivePremium(UID, 10, 30)
		GivePremium(UID, 10, 720)
	end
end

if (EVENT == 181) then -- EXP Premium
	SelectMsg(UID, 2, -1, 9527, NPC, 4006, 184, 4005, 101);
end

if (EVENT == 184) then
	EXPPREM = HowmuchItem(UID, 399282686);
	if (EXPPREM < 1) then
		SelectMsg(UID, 2, -1, 9528, NPC, 18, 1000);
	else
		GiveItemLua(UID,389330000,1,0, 389360000,1,0, 700002000,1,0, 508121000,1,0, 0,0,0, 399282686,1, 0,0, 0,0, 0,0, 0,0);
		GivePremium(UID, 11, 720)
	end
end


if (EVENT == 182) then -- WAR Premium
	SelectMsg(UID, 2, -1, 9527, NPC, 4006, 185, 4005, 101);
end

if (EVENT == 185) then
	WARPREM = HowmuchItem(UID, 399292764);
	if (WARPREM < 1) then
		SelectMsg(UID, 2, -1, 9528, NPC, 18, 1000);
	else	
		GiveItemLua(UID,0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 399292764,1, 0,0, 0,0, 0,0, 0,0);
		GivePremium(UID, 12, 720)
		GivePremium(UID, 10, 720)
		GivePremium(UID, 11, 720)
		GivePremium(UID, 12, 720)	
		end
end

if (EVENT == 186) then -- Switching Premium
	SelectMsg(UID, 2, -1, 9527, NPC, 4006, 187, 4005, 101);
end

if (EVENT == 187) then
	SWTPREM = HowmuchItem(UID, 399295000);
	if (SWTPREM < 1) then
		SelectMsg(UID, 2, -1, 9528, NPC, 18, 1000);
	else
		GiveItemLua(UID,389070000,1000,0, 389130000,1000,0, 810638730,1,30, 0,0,0, 0,0,0, 399295000,1, 0,0, 0,0, 0,0, 0,0);
		GivePremium(UID, 10, 720)
		GivePremium(UID, 11, 720)
		GivePremium(UID, 12, 720)	
	end
end

if (EVENT == 111) then -- Seal Coupon
	SelectMsg(UID, 2, -1, 9706, NPC, 7229, 177, 7230, 178);
end

if (EVENT == 177) then -- Seal 10x
	SelectMsg(UID, 2, -1, 9708, NPC, 4161, 179, 4162, 101);
end

if (EVENT == 179) then -- Seal 10x Yes
	
end

if (EVENT == 178) then -- Seal 50x
	SelectMsg(UID, 2, -1, 9709, NPC, 4161, 180, 4162, 101);
end

if (EVENT == 180) then -- Seal 50x Yes
	
end

if (EVENT == 104) then --Minevra Package
	MINEVRA = HowmuchItem(UID, 508073000);
	if (MINEVRA < 1) then
		SelectMsg(UID, 2, -1, 9622, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 9621, NPC, 4006, 114, 4005, 101);
	end
end

if (EVENT == 114) then
	GiveItemLua(UID,508075000,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 508073000,1, 0,0, 0,0, 0,0, 0,0);
end

if (EVENT == 105) then -- Pathos Glove Package
	PATHOS = HowmuchItem(UID, 508070000);
	if (PATHOS < 1) then
		SelectMsg(UID, 2, -1, 9629, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 9628, NPC, 4006, 113, 4005, 101);
	end
end

if (EVENT == 113) then
	GiveItemLua(UID,800250000,1,0, 800250000,1,0, 0,0,0, 0,0,0, 0,0,0, 508070000,1, 0,0, 0,0, 0,0, 0,0);
end

if (EVENT == 102) then -- Helmet of Wrath Use
	KURU = HowmuchItem(UID, 800451000);
	if (KURU < 1) then
		SelectMsg(UID, 2, -1, 43604, NPC, 18, 1000);
	else
		SelectMsg(UID, 2, -1, 43605, NPC, 4006, 112, 4005, 101);
	end
end

if (EVENT == 112) then
	GiveItemLua(UID,518006000,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 800451000,1, 0,0, 0,0, 0,0, 0,0);
end

if (EVENT == 103) then -- 2.Sayfa
	SelectMsg(UID, 3, -1, 3018, NPC, 2003, 100, 7228, 111, 7496, 102, 7679, 542);
end

if (EVENT == 542) then -- Dragon Wings
	ITEMDRGN = HowmuchItem(UID, 810164000);
	if (ITEMDRGN > 0) then
		SelectMsg(UID, 3, -1, 10592, NPC, 7680, 543, 7681, 544, 7682, 545, 7683, 546);
	else
		SelectMsg(UID, 2, -1, 10593, NPC, 18, 1000);
	end
end

if (EVENT == 543) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		Check = isRoomForItem(UID, 810178835);
		if (Check == -1) then
			SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
		else
			GiveItemLua(UID,810178835,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810164000,1, 0,0, 0,0, 0,0, 0,0);
		end
	else
		Check = isRoomForItem(UID, 810179839);
		if (Check == -1) then
			SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
		else
			GiveItemLua(UID,810179839,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810164000,1, 0,0, 0,0, 0,0, 0,0);
		end
	end
end

if (EVENT == 544) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		Check = isRoomForItem(UID, 810178836);
		if (Check == -1) then
			SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
		else
			GiveItemLua(UID,810178836,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810164000,1, 0,0, 0,0, 0,0, 0,0);
		end
	else
		Check = isRoomForItem(UID, 810179840);
		if (Check == -1) then
			SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
		else
			GiveItemLua(UID,810179840,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810164000,1, 0,0, 0,0, 0,0, 0,0);
		end
	end
end

if (EVENT == 545) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		Check = isRoomForItem(UID, 810178837);
		if (Check == -1) then
			SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
		else
			GiveItemLua(UID,810178837,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810164000,1, 0,0, 0,0, 0,0, 0,0);
		end
	else
		Check = isRoomForItem(UID, 810179841);
		if (Check == -1) then
			SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
		else
			GiveItemLua(UID,810179841,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810164000,1, 0,0, 0,0, 0,0, 0,0);
		end
	end
end

if (EVENT == 546) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		Check = isRoomForItem(UID, 810178838);
		if (Check == -1) then
			SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
		else
			GiveItemLua(UID,810178838,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810164000,1, 0,0, 0,0, 0,0, 0,0);
		end
	else
		Check = isRoomForItem(UID, 810179842);
		if (Check == -1) then
			SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
		else
			GiveItemLua(UID,810179842,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 810164000,1, 0,0, 0,0, 0,0, 0,0);
		end
	end
end

if (EVENT == 547) then -- Yeniceri Minevra
	SelectMsg(UID, 2, -1, 9938, NPC, 7244, 548, 7243, 549);
end

if (EVENT == 548) then
	ITEMYENIA = HowmuchItem(UID, 508117000);
	if (ITEMYENIA > 0) then
		SelectMsg(UID, 3, -1, 9941, NPC, 4288, 550, 4289, 551, 4290, 552, 4291, 553);
	else
		SelectMsg(UID, 2, -1, 9942, NPC, 18, 1000);
	end
end

if (EVENT == 550) then
	Check = isRoomForItem(UID, 518001636);
	if (Check == -1) then
		SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
	else
		GiveItemLua(UID,518001637,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 508116000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 551) then
	Check = isRoomForItem(UID, 518001637);
	if (Check == -1) then
		SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
	else
		GiveItemLua(UID,518001637,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 508116000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 552) then
	Check = isRoomForItem(UID, 518001638);
	if (Check == -1) then
		SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
	else
		GiveItemLua(UID,518001638,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 508116000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 553) then
	Check = isRoomForItem(UID, 518001639);
	if (Check == -1) then
		SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
	else
		GiveItemLua(UID,518001639,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 508116000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 549) then
	ITEMYENIH = HowmuchItem(UID, 508116000);
	if (ITEMYENIH > 0) then
		SelectMsg(UID, 3, -1, 9941, NPC, 4292, 554, 4293, 555, 4294, 556, 4295, 557);
	else
		SelectMsg(UID, 2, -1, 9940, NPC, 18, 1000);
	end
end

if (EVENT == 554) then
	Check = isRoomForItem(UID, 518003636,30);
	if (Check == -1) then
		SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
	else
		GiveItemLua(UID,518003636,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 508116000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 555) then
	Check = isRoomForItem(UID, 518003637);
	if (Check == -1) then
		SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
	else
		GiveItemLua(UID,518003637,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 508116000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 556) then
	Check = isRoomForItem(UID, 518003638);
	if (Check == -1) then
		SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
	else
		GiveItemLua(UID,518003638,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 508116000,1, 0,0, 0,0, 0,0, 0,0);
	end
end

if (EVENT == 557) then
	Check = isRoomForItem(UID, 518003639);
	if (Check == -1) then
		SelectMsg(UID, 2, -1, 832, NPC, 27, 101);
	else
		GiveItemLua(UID,518003639,1,30, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 508116000,1, 0,0, 0,0, 0,0, 0,0);
	end
end