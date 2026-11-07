local NPC = 32558;

if EVENT == 100 then
   SelectMsg(UID, 3, -1, 1034, NPC, 4574, -1, 4575, -1,4065,-1,7018,200);
end

--if EVENT == 200 then
 --  SelectMsg(UID, 2, -1, 1051, NPC, 4527, 201, 4528, -1);
--end


if EVENT == 201 then
   SelectMsg(UID, 19, -1, 1603, NPC,3000,202);
end

if (EVENT == 202) then
	ITEMA = HowmuchItem(UID, 900000000);
	COPY = HowmuchItem(UID, 900035000);
	if (ITEMA < 1000000) then
		SelectMsg(UID, 2, -1, 9181, NPC, 18, 1000);
	elseif (COPY < 1) then	
	    SelectMsg(UID, 2, -1, 1605, NPC, 10, -1);
		else
		EVENT = 203
		end
	end

if (EVENT == 203) then
GoldLose(UID, 1000000)
GiveItemLua(UID,900067000,1,1, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 0,0, 0,0);
end