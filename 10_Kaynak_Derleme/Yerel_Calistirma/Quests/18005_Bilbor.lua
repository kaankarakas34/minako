local Ret = 0;
local NPC = 18005;

if (EVENT == 100) then
	--SelectMsg(UID, 3, savenum, 101, NPC, 4262, 200, 4554, 300, 8209, 500, 7591, 600, 7746, 700, 7785, 800, 7799);
	SelectMsg(UID, 3, savenum, 101, NPC, 4262, 200, 4554, 300, 8209, 500, 7591, 600, 7746, 700, 7785, 800, 7799, 900);
end

--Licence List
if (EVENT == 200) then
	KC = HowmuchItem(UID, 700086000);
	if (KC < 1) then
		SelectMsg(UID, 2, -1, 45001, NPC, 18, 1000);
	else
	RobItem(UID, 700086000, 1)
	GiveKnightCash(UID, 5000)
	SelectMsg(UID, 2, -1, 1114, NPC, 27, 168);
	end
end	


-- Information of King's inspector
if (EVENT == 300) then
	KC = HowmuchItem(UID, 700085000);
	if (KC < 1) then
		SelectMsg(UID, 2, -1, 45002, NPC, 18, 1000);
	else
	RobItem(UID, 700085000, 1)
	GiveKnightCash(UID, 2000)
	SelectMsg(UID, 2, -1, 1114, NPC, 27, 168);
	end
end

--Bilbor's Gift -> Start
if (EVENT == 400) then
	SelectMsg(UID, 2, 60, 470, NPC, 4518, 401, 40515);
end

if (EVENT == 401) then
	SelectMsg(UID, 2, 60, 471, NPC, 4160, 402);
end

if (EVENT == 402) then
	-- Show quest
end

if (EVENT == 403) then
	SaveEvent(UID);
end
--Bilbor's Gift -> End


-- Celebration of the 10th Anniversary
if (EVENT == 500) then
	KC = HowmuchItem(UID, 700084000);
	if (KC < 1) then
		SelectMsg(UID, 2, -1, 45003, NPC, 18, 1000);
	else
	RobItem(UID, 700084000, 1)
	GiveKnightCash(UID, 1000)
	SelectMsg(UID, 2, -1, 1114, NPC, 27, 168);
	end
end

-- VIP Card Exchange
if (EVENT == 600) then
	KC = HowmuchItem(UID, 700083000);
	if (KC < 1) then
		SelectMsg(UID, 2, -1, 45004, NPC, 18, 1000);
	else
	RobItem(UID, 700083000, 1)
	GiveKnightCash(UID, 700)
	SelectMsg(UID, 2, -1, 1114, NPC, 27, 168);
	end
end

-- Joe's Slogan
if (EVENT == 700) then
	KC = HowmuchItem(UID, 700082000);
	if (KC < 1) then
		SelectMsg(UID, 2, -1, 45004, NPC, 18, 1000);
	else
	RobItem(UID, 700082000, 1)
	GiveKnightCash(UID, 350)
	SelectMsg(UID, 2, -1, 1114, NPC, 27, 168);
	end
end

-- Chaos Knight Day
if (EVENT == 800) then
	KC = HowmuchItem(UID, 700081000);
	if (KC < 1) then
		SelectMsg(UID, 2, -1, 45004, NPC, 18, 1000);
	else
	RobItem(UID, 700081000, 1)
	GiveKnightCash(UID, 100)
	SelectMsg(UID, 2, -1, 1114, NPC, 27, 168);
	end
end

--[Knight Chaos Day] job change
if (EVENT == 900) then
	JOBCHANGEITEM = HowmuchItem(UID, 900006000);
	if (JOBCHANGEITEM > 0) then
		Class = CheckClass(UID);
		if (Class == 1 or Class == 5 or Class == 6) then
			SelectMsg(UID, 3, -1, 44203, NPC, 8651, 302, 8652, 303, 8653, 304);
		elseif (Class == 2 or Class == 7 or Class == 8) then
			SelectMsg(UID, 3, -1, 44203, NPC, 8650, 301, 8652, 303, 8653, 304);
		elseif (Class == 3 or Class == 9 or Class == 10) then
			SelectMsg(UID, 3, -1, 44203, NPC, 8650, 301, 8651, 302, 8653, 304);
		elseif (Class == 4 or Class == 11 or Class == 12) then
			SelectMsg(UID, 3, -1, 44203, NPC, 8650, 301, 8651, 302, 8652, 303);
		end
	else
		SelectMsg(UID, 2, -1, 44217, NPC, 18, 1000);
	end
end

if (EVENT == 301) then
	JobChange(UID,1);
end

if (EVENT == 302) then
	JobChange(UID,2);
end

if (EVENT == 303) then
	JobChange(UID,3);
end

if (EVENT == 304) then
	JobChange(UID,4);
end

--Just Go
if (EVENT == 1000) then 
	--Ret = 1;
end


if EVENT == 150 then
   ITEMA = HowmuchItem(UID, 810926000); --solar tatto
   if (ITEMA > 0) then
      GoldLose(UID, 50000)
	  RobItem(UID, 810926000, 1)
      GiveItem(UID, 810930952,1, 30)       
   end
end
if EVENT == 151 then
   ITEMA = HowmuchItem(UID, 810927000); -- lunar tatto
   if (ITEMA > 0) then
      GoldLose(UID, 50000)
	  RobItem(UID, 810927000, 1)
     GiveItem(UID, 810931953,1, 30) 
   end
end
if EVENT == 152 then
   ITEMA = HowmuchItem(UID, 810928000); -- stellar tatto
   if (ITEMA > 0) then
      GoldLose(UID, 50000)
	  RobItem(UID, 810928000, 1)
      GiveItem(UID, 810932954,1, 30) 
   end
end
if EVENT == 153 then
   ITEMA = HowmuchItem(UID, 810929000); --nimbus tatto
   if (ITEMA > 0) then
   RobItem(UID, 810929000, 1)
   GiveItem(UID, 810933955,1, 30)  
   end
end