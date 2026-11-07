if (EVENT == 100) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		SelectMsg(UID, 2, -1, 1028, NPC, 10, -1);
	else
		SelectMsg(UID, 2, -1, 1032, NPC, 10, 101);
	end
end

if (EVENT == 101) then
SLOTKONTROL = CheckExchangeSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
      RobItem(UID, 900074000)
      GiveItem(UID, 900035000,1)
end
end