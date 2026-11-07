local NPC = 16047;
----------------------------------
if (EVENT == 240) then
		NpcMsg(UID, 4031, NPC)
end
---------------------------------------------------------
--Mavi Ye?il ve Black Kutu K©¥rd©¥rma--
if EVENT == 280 then 
BLUEBOX    = HowmuchItem(UID, 379156000);
GREENBOX   = HowmuchItem(UID, 379155000);
--BLACKBOX   = HowmuchItem(UID, 810636000);--Hat©¥rlatma..Event Yap©¥lacak.
if(BLUEBOX > 0 and GREENBOX > 0) then
          SelectMsg(UID, 3, -1, 4035, NPC, 4007, 285, 4008, 286);
 elseif(BLUEBOX  > 0) then
          EVENT = 285
 elseif(GREENBOX > 0) then
          EVENT = 286
 else
        SelectMsg(UID, 2, -1, 4032, NPC, 10, -1);
end
   end
--------------------------------------------------------- 
--MAV? KUTU SORU.
if EVENT == 285 then 
   SelectMsg(UID, 4, 11, 4034, NPC, 4006, 289, 27, -1);
end
--------------------------------------------------------- 
--MAV? KUTU KIRDIRMA
if EVENT == 289 then 
	SLOTKONTROL = CheckGiveSlot(UID, 1)
    if SLOTKONTROL == false then
		SelectMsg(UID,2,-1,8898,NPC,10)
    else
	   Roll = RollDice(UID, 19) 
	   found = Roll + 410
	   RunExchange(UID, found);
	end
end
---------------------------------------------------------
--YE??L KUTU SORU.
if EVENT == 286 then 
   SelectMsg(UID, 2, -1, 4033, NPC, 4006, 290, 27, -1);
end
---------------------------------------------------------
--YE??L KUTU KIRDIRMA
if EVENT == 290 then
	SLOTKONTROL = CheckGiveSlot(UID, 1)
	if SLOTKONTROL == false then
		SelectMsg(UID,2,-1,8898,NPC,10)
	else
		Roll = RollDice(UID, 19) 
		found = Roll + 430
		RunExchange(UID, found);
	end
end
---------------------------------------------------------
--BLACK KUTU SORU.
if EVENT == 287 then 
   SelectMsg(UID, 2, -1, 4035, NPC, 4006, 291, 27, -1);
end
---------------------------------------------------------
--BLACK KUTU KIRDIRMA
if EVENT == 291 then 
	SLOTKONTROL = CheckGiveSlot(UID, 1)
	if SLOTKONTROL == false then
		SelectMsg(UID,2,-1,8898,NPC,10)
	else
		Roll = RollDice(UID, 19) 
		found = Roll + 410
		RunExchange(UID, found);		 
	end
end
---------------------------------------------------------
--ABYS GEM KIRDIRMA
if EVENT == 300 then
	ItemA = HowmuchItem(UID, 810347000);
	if  ItemA < 1 then
	SelectMsg(UID, 2, 13, 4142, NPC, 10, -1);
	else
	SelectMsg(UID, 4, 13, 4141, NPC, 4006, 301,27, -1);
	end
end

---------------------------------------------------------
if EVENT == 301 then
--ABYS GEM KIRDIRMA
	SLOTKONTROL = CheckGiveSlot(UID, 1)
	if SLOTKONTROL == false then
		SelectMsg(UID,2,-1,8898,NPC,10)
	else
		Roll = RollDice(UID, 23) 
		found = Roll + 6746
		RunExchange(UID, found);	
	end
end
-----------------------------------------------------------
--LOTTO KIRDIRMA--Soru
if EVENT == 400 then
	LOTTO = HowmuchItem(UID, 800149000);
	if (LOTTO < 1) then 
	SelectMsg(UID, 2, 14, 4664, NPC, 10, -1);
	else
    SelectMsg(UID, 4, 14, 4665, NPC, 4006, 401, 27, -1);
	end
end
-----------------------------------------------------------
--LOTTO KIRDIRMA
if EVENT == 401 then 
	SLOTKONTROL = CheckGiveSlot(UID, 1)
	if SLOTKONTROL == false then
		SelectMsg(UID,2,-1,8898,NPC,10)
	else
		Roll = RollDice(UID, 53) 
		found = Roll + 6862
		RunExchange(UID, found);
	end  
end
-----------------------------------------------------------
--K©¥rm©¥z©¥ Kutu K©¥rd©¥rma--Soru
if EVENT == 500 then
	  REDBOX = HowmuchItem(UID, 379154000);
	  if (REDBOX < 1) then
	       SelectMsg(UID, 2, 15, 4912, NPC, 10, -1);
	  else
		   SelectMsg(UID, 4, 15, 4920, NPC, 4006, 584, 27, -1);
	  end
end

if EVENT == 584 then 
	SLOTKONTROL = CheckGiveSlot(UID, 1)
	if SLOTKONTROL == false then
		SelectMsg(UID,2,-1,8898,NPC,10)
	else
		Roll = RollDice(UID, 19) 
		found = Roll + 2200
		RunExchange(UID, found);
	end  
end
-----------------------------------------------------------
--Premium Lotto K©¥rd©¥rma--Soru
if EVENT == 450 then
	PRELOTTO = HowmuchItem(UID, 900369000);
	if (PRELOTTO < 1) then
	SelectMsg(UID, 2, 18, 4664, NPC, 10, -1);
	else
    SelectMsg(UID, 4, 18, 4665, NPC, 4006, 451, 27, -1);
	end
end
-----------------------------------------------------------
--Premium Lotto K©¥rd©¥rma
if EVENT == 451 then 
	SLOTKONTROL = CheckGiveSlot(UID, 1)
	if SLOTKONTROL == false then
		SelectMsg(UID,2,-1,8898,NPC,10)
	else
		Roll = RollDice(UID, 53) 
		found = Roll + 6809
		RunExchange(UID, found);
	end
end
-----------------------------------------------------------
if (EVENT == 1000) then
	ShowMap(UID, 450);
end
-----------------------------------------------------------
--ACCESORY BOX KIRDIRMA--SORU
if (EVENT == 700) then
SelectMsg(UID, 3, -1, 4031, NPC, 8805, 701,8806,702,8807,703);
end
-----------------------------------------------------------
if (EVENT == 701) then 
	ABOX = HowmuchItem(UID, 508194000);
	if (ABOX < 1) then
		SelectMsg(UID, 2, 17, 9462, NPC, 10, -1);
	else
	    SelectMsg(UID, 4, 17, 9463, NPC, 4006, 704,27,-1);
	end
end
-----------------------------------------------------------
--FORGETTEN ACCESSORY BOX.
if (EVENT == 702) then 
	FBOX = HowmuchItem(UID, 900823000);
	if (FBOX < 1) then
		SelectMsg(UID, 2, -1, 9462, NPC, 10, -1);
	else
	    SelectMsg(UID, 2, -1, 9463, NPC, 4006, 705,27,-1);
	end
end
-----------------------------------------------------------
--FORGETTEN ADVANCED ACCESSORY BOX.
if (EVENT == 703) then 
	FABOX = HowmuchItem(UID, 900824000);
	if (FABOX < 1) then
		SelectMsg(UID, 2, -1, 9462, NPC, 10, -1);
	else
	    SelectMsg(UID, 2, -1, 9463, NPC, 4006, 706,27,-1);
	end
end
-----------------------------------------------------------
--ACCESORY BOX KIRDIRMA
if EVENT == 704 then 
	SLOTKONTROL = CheckGiveSlot(UID, 1)
	if SLOTKONTROL == false then
		SelectMsg(UID,2,-1,8898,NPC,10)
	else
		Roll = RollDice(UID, 13) 
		found = Roll + 22031
		RunExchange(UID, found);  
	end
end
-----------------------------------------------------------
--FORGETTEN BOX KIRDIRMA
if EVENT == 705 then 
	SLOTKONTROL = CheckGiveSlot(UID, 1)
	if SLOTKONTROL == false then
		SelectMsg(UID,2,-1,8898,NPC,10)
	else
		Roll = RollDice(UID, 0) 
		found = Roll + 0
		RunExchange(UID, found);
	end  
end
-----------------------------------------------------------
--FORGETTEN ADVANCED BOX KIRDIRMA
if EVENT == 706 then 
	SLOTKONTROL = CheckGiveSlot(UID, 1)
	if SLOTKONTROL == false then
		SelectMsg(UID,2,-1,8898,NPC,10)
	else
		Roll = RollDice(UID, 0) 
		found = Roll + 0
		RunExchange(UID, found);
   end
end
-----------------------------------------------------------
---TROPHY BOX KIRDIRMA.--SORU
if (EVENT == 600) then 
	TROPHYMAVI = HowmuchItem(UID, 810342000);
	if (TROPHYMAVI < 1) then
		SelectMsg(UID, 2, 16, 8917, NPC, 10, -1);
	else
	    SelectMsg(UID, 4, 16, 8968, NPC, 4006, 610,27,-1);
	end
end
-----------------------------------------------------------
---TROPHY BOX KIRDIRMA.
if EVENT == 610 then 
	SLOTKONTROL = CheckGiveSlot(UID, 1)
	if SLOTKONTROL == false then
		SelectMsg(UID,2,-1,8898,NPC,10)
	else
		Roll = RollDice(UID, 37) 
		found = Roll + 6969
		RunExchange(UID, found);
	end
end
-----------------------------------------------------------
--CH?T?N ARMOR KIRDIRMA.-- SORU--Hat©¥rlatma...Ozel Event Planlanacak.QUEST_GU?DE 794 Numara.
if (EVENT == 800) then 
SelectMsg(UID, 2, -1, 12267, NPC, 3000, -1,27,-1);
end
-----------------------------------------------------------
--FORGETTEN TEMPLE CO?N.--SORU
if (EVENT == 2000) then 
SelectMsg(UID, 2, -1, 12391, NPC, 8939, 2001,8940,2010);
end
-----------------------------------------------------------
--FORGETTEN TEMPLE LOW COIN SORU
if (EVENT == 2010) then 
SelectMsg(UID, 2, -1, 12393, NPC, 8943, 2011,8941,2013);
end
-----------------------------------------------------------
--FORGETTEN TEMPLE LOW KIRMIZI KONTROL
if (EVENT == 2011) then 
TEMPLELOWCOIN = HowmuchItem(UID, 810445000);
if (TEMPLELOWCOIN < 2) then
SelectMsg(UID, 2, -1, 12396, NPC, 10, -1);
else
EVENT = 2012
	  end
	    end
-----------------------------------------------------------
--FORGETTEN TEMPLE LOW KIRMIZI KIRDIRMA
if (EVENT == 2012) then 
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else	
	  RobItem(UID, 810445000, 2)
      GiveItem(UID, 379154000, 1)
	  SelectMsg(UID, 2, -1, 12390, NPC, 10, -1);
	  end
	  end
-----------------------------------------------------------
--FORGETTEN TEMPLE LOW YESIL KONTROL
if (EVENT == 2013) then 
TEMPLELOWCOIN = HowmuchItem(UID, 810445000);
if (TEMPLELOWCOIN < 3) then
SelectMsg(UID, 2, -1, 12397, NPC, 10, -1);
else
EVENT = 2014
	  end
	    end
-----------------------------------------------------------
--FORGETTEN TEMPLE LOW YESIL KIRDIRMA
if (EVENT == 2014) then 
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else	
	  RobItem(UID, 810445000, 3)
      GiveItem(UID, 379155000, 1)
	  SelectMsg(UID, 2, -1, 12390, NPC, 10, -1);
	  end
	  end
-----------------------------------------------------------
--FORGETTEN TEMPLE COIN MAVI & YESIL SORU.
if (EVENT == 2001) then 
SelectMsg(UID, 2, -1, 12392, NPC, 8941, 2002,8942,2004);
end
-----------------------------------------------------------
--FORGETTEN TEMPLE YESIL KONTROL
if (EVENT == 2002) then 
TEMPLECOIN = HowmuchItem(UID, 810446000);
if (TEMPLECOIN < 2) then
SelectMsg(UID, 2, -1, 12394, NPC, 10, -1);
else
EVENT = 2003
	  end
	    end
-----------------------------------------------------------	
--FORGETTEN TEMPLE YESIL KIRDIRMA
if (EVENT == 2003) then 
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else	
	  RobItem(UID, 810446000, 2)
      GiveItem(UID, 379155000, 1)
	  SelectMsg(UID, 2, -1, 12390, NPC, 10, -1);
	  end
	  end
-----------------------------------------------------------	  
--FORGETTEN TEMPLE MAVI KONTROL
if (EVENT == 2004) then 
TEMPLECOIN = HowmuchItem(UID, 810446000);
if (TEMPLECOIN < 3) then
SelectMsg(UID, 2, -1, 12395, NPC, 10, -1);
else
EVENT = 2005
	  end
	    end
-----------------------------------------------------------		
--FORGETTEN TEMPLE MAVI KIRDIRMA
if (EVENT == 2005) then 
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else	
	  RobItem(UID, 810446000, 3)
      GiveItem(UID, 379156000, 1)
	  SelectMsg(UID, 2, -1, 12390, NPC, 10, -1);
	  end
	  end		
-----------------------------------------------------------	
if (EVENT == 2500) then 
	  REDBOX = HowmuchItem(UID, 810596000);
	  if (REDBOX < 1) then
	       SelectMsg(UID, 2, 15, 4912, NPC, 10, -1);
	  else
		    SelectMsg(UID, 2, savenum, 4035, NPC, 40501, 5841, 27, -1);
	  end
end

if EVENT == 5841 then 
	SLOTKONTROL = CheckGiveSlot(UID, 1)
	if SLOTKONTROL == false then
		SelectMsg(UID,2,-1,8898,NPC,10)
	else
		Roll = RollDice(UID, 26) 
		found = Roll + 6789
		RunExchange(UID, found);
	end
end