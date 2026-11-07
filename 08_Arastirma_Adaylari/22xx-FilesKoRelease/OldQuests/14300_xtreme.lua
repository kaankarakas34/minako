local UserClass;
local QuestNum;
local Ret = 0;
local NPC =14300;
local NATION = 0;

if EVENT == 300 then --Ana menu
 SelectMsg(UID, 3, -1, 90100, NPC, 27500,2300,27501,2301,27502,2302,27503,2303,27504,2304,27505,2305,27506,2306,27507,2307,27508,2308);--,27509,2309 ); 
end

--Hera scroll 10 k np
if EVENT == 2300 then
	NATION = CheckNation(UID); --Irk kontrol
	if (NATION == 1) then
	
 SelectMsg(UID, 3, -1, 90101, NPC, 37500,980); 
 else
  SelectMsg(UID, 3, -1, 90101, NPC, 37500,981); 
 end
end


--------------------------------------------------------
--[Hera Scroll ]

if (EVENT == 980) then --Karus
SLOTKONTROL = CheckGiveSlot(UID, 1)--bos yer varmi komtrol
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SelectMsg(UID, 3, -1, 90101, NPC, 20000,8444)
end
end

if (EVENT == 8444) then
	Loyalty = CheckLoyalty(UID)
	if (Loyalty > 9999)  then
	GiveItem(UID, 800220000, 1)
	RobLoyalty(UID, 10000)
	else
	SelectMsg(UID, 3, -1, 9919, NPC, 20001,144)
end
end


if (EVENT == 981) then--Human
SLOTKONTROL = CheckGiveSlot(UID, 1)--bos yer varmi komtrol
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SelectMsg(UID, 3, -1, 90101, NPC, 20000,8445)
end
end

if (EVENT == 8445) then
	Loyalty = CheckLoyalty(UID)
	if (Loyalty > 9999)  then
	GiveItem(UID, 800130000, 1)
	RobLoyalty(UID, 10000)
	else
	SelectMsg(UID, 3, -1, 9919, NPC, 20001,144)
end
end



--###############################################################################

--Counger scroll 10 k np
if EVENT == 2301 then
	NATION = CheckNation(UID); --Irk kontrol
	if (NATION == 1) then
	
 SelectMsg(UID, 3, -1, 90101, NPC, 37500,1000); 
 else
  SelectMsg(UID, 3, -1, 90101, NPC, 37500,2000); 
 end
end


--------------------------------------------------------
--[Counger Scroll ]

if (EVENT == 1000) then --Karus
SLOTKONTROL = CheckGiveSlot(UID, 1)--bos yer varmi komtrol
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SelectMsg(UID, 3, -1, 90101, NPC, 20000,1400)
end
end

if (EVENT == 1400) then
	Loyalty = CheckLoyalty(UID)
	if (Loyalty > 9999)  then
	GiveItem(UID, 800210000, 1)
	RobLoyalty(UID, 10000)
	else
	SelectMsg(UID, 3, -1, 9919, NPC, 20001,144)
end
end


if (EVENT == 2000) then--Human
SLOTKONTROL = CheckGiveSlot(UID, 1)--bos yer varmi komtrol
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SelectMsg(UID, 3, -1, 90101, NPC, 20000,2400)
end
end

if (EVENT == 2400) then
	Loyalty = CheckLoyalty(UID)
	if (Loyalty > 9999)  then
	GiveItem(UID, 800120000, 1)
	RobLoyalty(UID, 10000)
	else
	SelectMsg(UID, 3, -1, 9919, NPC, 20001,144)
end
end

--###############################################################################

--[Cougar Scroll 10 Piece / 10.000 NP]
if EVENT == 2302 then
	NATION = CheckNation(UID); --Irk kontrol
	if (NATION == 1) then
	
 SelectMsg(UID, 3, -1, 90101, NPC, 37500,1001); 
 else
  SelectMsg(UID, 3, -1, 90101, NPC, 37500,2001); 
 end
end


--------------------------------------------------------


if (EVENT == 1001) then --Karus
SLOTKONTROL = CheckGiveSlot(UID, 1)--bos yer varmi komtrol
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SelectMsg(UID, 3, -1, 90101, NPC, 20000,1401)
end
end

if (EVENT == 1401) then
	Loyalty = CheckLoyalty(UID)
	if (Loyalty > 9999)  then
	GiveItem(UID, 800190000, 1)
	RobLoyalty(UID, 10000)
	else
	SelectMsg(UID, 3, -1, 9919, NPC, 20001,144)
end
end


if (EVENT == 2001) then--Human
SLOTKONTROL = CheckGiveSlot(UID, 1)--bos yer varmi komtrol
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SelectMsg(UID, 3, -1, 90101, NPC, 20000,2401)
end
end

if (EVENT == 2401) then
	Loyalty = CheckLoyalty(UID)
	if (Loyalty > 9999)  then
	GiveItem(UID, 800100000, 1)
	RobLoyalty(UID, 10000)
	else
	SelectMsg(UID, 3, -1, 9919, NPC, 20001,144)
end
end



--###############################################################################

--[Menissiah Scroll 10 Piece / 10.000 NP]
if EVENT == 2303 then
	NATION = CheckNation(UID); --Irk kontrol
	if (NATION == 1) then
	
 SelectMsg(UID, 3, -1, 90101, NPC, 37500,1002); 
 else
  SelectMsg(UID, 3, -1, 90101, NPC, 37500,2002); 
 end
end


--------------------------------------------------------


if (EVENT == 1002) then --Karus
SLOTKONTROL = CheckGiveSlot(UID, 1)--bos yer varmi komtrol
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SelectMsg(UID, 3, -1, 90101, NPC, 20000,1402)
end
end

if (EVENT == 1402) then
	Loyalty = CheckLoyalty(UID)
	if (Loyalty > 9999)  then
	GiveItem(UID, 800200000, 1)
	RobLoyalty(UID, 10000)
	else
	SelectMsg(UID, 3, -1, 9919, NPC, 20001,144)
end
end


if (EVENT == 2002) then--Human
SLOTKONTROL = CheckGiveSlot(UID, 1)--bos yer varmi komtrol
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SelectMsg(UID, 3, -1, 90101, NPC, 20000,2402)
end
end

if (EVENT == 2402) then
	Loyalty = CheckLoyalty(UID)
	if (Loyalty > 9999)  then
	GiveItem(UID, 800110000, 1)
	RobLoyalty(UID, 10000)
	else
	SelectMsg(UID, 3, -1, 9919, NPC, 20001,144)
end
end



--###############################################################################

--[HP Scroll 2000 30 Piece / 15.000 NP]
if EVENT == 2304 then
 SelectMsg(UID, 3, -1, 90101, NPC, 37500,1003); 
end


--------------------------------------------------------


if (EVENT == 1003) then 
SLOTKONTROL = CheckGiveSlot(UID, 1)--bos yer varmi komtrol
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SelectMsg(UID, 3, -1, 90101, NPC, 20000,1403)
end
end

if (EVENT == 1403) then
	Loyalty = CheckLoyalty(UID)
	if (Loyalty > 14999)  then
	GiveItem(UID, 810081000, 1)
	RobLoyalty(UID, 14000)
	else
	SelectMsg(UID, 3, -1, 9919, NPC, 20001,144)
end
end


--###############################################################################

--[350 Armor Scroll 30 Piece / 15.000 NP]
if EVENT == 2305 then
 SelectMsg(UID, 3, -1, 90101, NPC, 37500,1004); 
end


--------------------------------------------------------


if (EVENT == 1004) then 
SLOTKONTROL = CheckGiveSlot(UID, 1)--bos yer varmi komtrol
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SelectMsg(UID, 3, -1, 90101, NPC, 20000,1404)
end
end

if (EVENT == 1404) then
	Loyalty = CheckLoyalty(UID)
	if (Loyalty > 14999)  then
	GiveItem(UID, 810080000, 1)
	RobLoyalty(UID, 14000)
	else
	SelectMsg(UID, 3, -1, 9919, NPC, 20001,144)
end
end


--###############################################################################

--[Rebirth Scroll / 5.000 NP]
if EVENT == 2306 then
 SelectMsg(UID, 3, -1, 90101, NPC, 37500,1005); 
end


--------------------------------------------------------


if (EVENT == 1005) then 
SLOTKONTROL = CheckGiveSlot(UID, 1)--bos yer varmi komtrol
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SelectMsg(UID, 3, -1, 90101, NPC, 20000,1405)
end
end

if (EVENT == 1405) then
	Loyalty = CheckLoyalty(UID)
	if (Loyalty > 4999)  then
	GiveItem(UID, 379256000, 1)
	RobLoyalty(UID, 5000)
	else
	SelectMsg(UID, 3, -1, 9919, NPC, 20001,144)
end
end




--###############################################################################

--[Bezoar 100 Piece / 5.000 NP]
if EVENT == 2307 then
 SelectMsg(UID, 3, -1, 90101, NPC, 37500,1006); 
end


--------------------------------------------------------


if (EVENT == 1006) then 
SLOTKONTROL = CheckGiveSlot(UID, 1)--bos yer varmi komtrol
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SelectMsg(UID, 3, -1, 90101, NPC, 20000,1406)
end
end

if (EVENT == 1406) then
	Loyalty = CheckLoyalty(UID)
	if (Loyalty > 4999)  then
	GiveItem(UID, 389034000, 100)
	RobLoyalty(UID, 5000)
	else
	SelectMsg(UID, 3, -1, 9919, NPC, 20001,144)
end
end



--###############################################################################

--[Glutinous Rice Cake 100 Piece / 5.000 NP]
if EVENT == 2308 then
 SelectMsg(UID, 3, -1, 90101, NPC, 37500,1007); 
end


--------------------------------------------------------


if (EVENT == 1007) then 
SLOTKONTROL = CheckGiveSlot(UID, 1)--bos yer varmi komtrol
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SelectMsg(UID, 3, -1, 90101, NPC, 20000,1407)
end
end

if (EVENT == 1407) then
	Loyalty = CheckLoyalty(UID)
	if (Loyalty > 4999)  then
	GiveItem(UID, 389035000, 100)
	RobLoyalty(UID, 5000)
	else
	SelectMsg(UID, 3, -1, 9919, NPC, 20001,144)
end
end



--###############################################################################

--[1000 KnightCash Voucher / 10.000 NP]
if EVENT == 2309 then
 SelectMsg(UID, 3, -1, 90101, NPC, 37500,1008); 
end


--------------------------------------------------------


if (EVENT == 1008) then 
SLOTKONTROL = CheckGiveSlot(UID, 1)--bos yer varmi komtrol
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	SelectMsg(UID, 3, -1, 90101, NPC, 20000,1408)
end
end

if (EVENT == 1408) then
	Loyalty = CheckLoyalty(UID)
	if (Loyalty > 9999)  then
	GiveItem(UID, 700084000, 1)
	RobLoyalty(UID, 10000)
	else
	SelectMsg(UID, 3, -1, 9919, NPC, 20001,144)
end
end
