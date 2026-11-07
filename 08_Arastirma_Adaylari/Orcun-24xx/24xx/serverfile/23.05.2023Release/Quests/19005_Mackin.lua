local NPC = 19005;

local Ret = 0;


if (EVENT == 100) then
	SelectMsg(UID, 3, 974, 8082, NPC, 4481, 101, 8265, 102, 3019, 203);
end

if (EVENT == 203) then
	Ret = 1;
end

if (EVENT == 101) then
	MONEY = HowmuchItem(UID, 900000000);
	if (MONEY >= 10000) then
		SelectMsg(UID, 2, 974, 8083, NPC, 4484, 205, 4296, 203);
	else
		SelectMsg(UID, 2, 974, 8084, NPC, 18, 204);
	end
end

if (EVENT == 102) then
	SelectMsg(UID, 3, 974, 11705, NPC, 8246, 301, 8254, 312, 8258, 317, 8265, 323);
end

if (EVENT == 301) then
	if (checkQuestEvent(UID,53,4)) then -- GÖREV 1
		Level = CheckLevel(UID);
		if (Level > 83) then
		SelectMsg(UID, 3, 974, 11706, NPC, 65, 401);
		else
		SelectMsg(UID, 3, 974, 11694, NPC, 65, 203);
		end
	else 
	
		if(checkQuestEvent(UID,53,2)) then
		SelectMsg(UID, 3, 974, 11714, NPC, 65, 203);
		else
		SelectMsg(UID, 3, 974, 11686, NPC, 8247, 305);
		end
	end
end

if (EVENT == 401) then
	Level = CheckLevel(UID);
	if (checkQuestEvent(UID,53,4)) then
		if (Level > 83) then
		SaveEvent(UID,10307);-- 1. görevi bitir
		end
	end
end

if (EVENT == 305) then
	SelectMsg(UID, 3, 974, 11687, NPC, 8248, 306);
end

if (EVENT == 306) then
	SelectMsg(UID, 3, 974, 11688, NPC, 8249, 307);
end

if (EVENT == 307) then
	SelectMsg(UID, 3, 974, 11689, NPC, 8250, 308);
end

if (EVENT == 308) then
	SelectMsg(UID, 3, 974, 11690, NPC, 8251, 309);
end

if (EVENT == 309) then
	SelectMsg(UID, 3, 974, 11691, NPC, 8252, 310);
end

if (EVENT == 310) then
	SelectMsg(UID, 3, 974, 11692, NPC, 8253, 311);
end



if (EVENT == 311) then
	SelectMsg(UID, 3, 974, 11693, NPC, 65, 402);
end

if (EVENT == 402) then
	if (checkQuestEvent(UID,53,0)) then
	SaveEvent(UID, 10308);
	end
end

if (EVENT == 312) then
	Level = CheckLevel(UID);
	if (checkQuestEvent(UID,53,2)) then
				if (checkQuestEvent(UID,52,4)) then-- GÖREV 2 alýndýmý
					MONEY = HowmuchItem(UID, 900000000);
					if (MONEY >= 100000000) then
					SelectMsg(UID, 3, 974, 11707, NPC, 65, 316);
					else
					SelectMsg(UID, 3, 974, 11698, NPC, 65, 203);
					end	
				else 
				if(checkQuestEvent(UID,52,2)) then
				SelectMsg(UID, 3, 974, 11713, NPC, 65, 203);	
				else
				SelectMsg(UID, 3, 974, 11695, NPC, 8255, 313);
				end
				end
	else
	SelectMsg(UID, 3, 974, 11710, NPC, 10, 203);
	end
end


if (EVENT == 313) then
	if (checkQuestEvent(UID,53,2)) then
	SelectMsg(UID, 3, 974, 11696, NPC, 8256, 314);	
	else
		SelectMsg(UID, 3, 974, 11710, NPC, 65, 203);	
	end
end



if (EVENT == 314) then

	if (checkQuestEvent(UID,53,2)) then
	SelectMsg(UID, 3, 974, 11697, NPC, 65, 315);	
	else
		SelectMsg(UID, 3, 974, 11710, NPC, 65, 203);	
	end
end



if (EVENT == 315) then
	if (checkQuestEvent(UID,53,2)) then
	SaveEvent(UID,10306);--2. görevi baþlat
	else
		SelectMsg(UID, 3, 974, 11710, NPC, 65, 203);	
	end
end

if (EVENT == 316) then
	if (checkQuestEvent(UID,53,2)) then
		MONEY = HowmuchItem(UID, 900000000);

        	if (MONEY >= 100000000) then

		GoldLose(UID, 100000000)

		SaveEvent(UID,10305);-- 2. görevi bitir
		end
	else
		SelectMsg(UID, 3, 974, 11710, NPC, 65, 203);	
	end
end

if (EVENT == 317) then

	if (checkQuestEvent(UID,53,2)) then
		if (checkQuestEvent(UID,52,2)) then
			if(checkQuestEvent(UID,54,4)) then
			Loyalty = CheckLoyalty(UID);
				if (Loyalty > 9999)  then
				SelectMsg(UID, 3, 974, 11703, NPC, 8261, 322);	
				else
				SelectMsg(UID, 3, 974, 11708, NPC, 65, 203);	
				end
			else
				if(checkQuestEvent(UID,54,2)) then
				SelectMsg(UID, 3, 974, 11715, NPC, 65, 203);	
				else
				SelectMsg(UID, 3, 974, 11699, NPC, 8259, 318);	
				end
			end
		else
			SelectMsg(UID, 3, 974, 11711, NPC, 65, 203);
		end
	else
		SelectMsg(UID, 3, 974, 11710, NPC, 65, 203);	
	end
end

if (EVENT == 318) then

	if (checkQuestEvent(UID,53,2)) then
		if (checkQuestEvent(UID,52,2)) then
			SelectMsg(UID, 3, 974, 11700, NPC, 8260, 319);	
		else
			SelectMsg(UID, 3, 974, 11711, NPC, 65, 203);
		end	
	else
		SelectMsg(UID, 3, 974, 11710, NPC, 65, 203);	
	end
end

if (EVENT == 319) then

	if (checkQuestEvent(UID,53,2)) then
		if (checkQuestEvent(UID,52,2)) then
			SelectMsg(UID, 3, 974, 11701, NPC, 8256, 320);	
		else
			SelectMsg(UID, 3, 974, 11711, NPC, 65, 203);	
		end
	else
		SelectMsg(UID, 3, 974, 11710, NPC, 65, 203);	
	end
end

if (EVENT == 320) then

	if (checkQuestEvent(UID,53,2)) then
		if (checkQuestEvent(UID,52,2)) then
			SelectMsg(UID, 3, 974, 11702, NPC, 65, 321);	
		else
			SelectMsg(UID, 3, 974, 11711, NPC, 65, 203);
		end
	else
		SelectMsg(UID, 3, 974, 11710, NPC, 65, 203);	
	end
end

if (EVENT == 321) then

	if (checkQuestEvent(UID,53,2)) then
		if (checkQuestEvent(UID,52,2)) then
			SaveEvent(UID,10310);-- 3. görevi baþlat
		else
			SelectMsg(UID, 3, 974, 11711, NPC, 65, 203);
		end
	else
		SelectMsg(UID, 3, 974, 11710, NPC, 65, 203);	
	end
end

if (EVENT == 322) then
	if (checkQuestEvent(UID,53,2)) then
		if (checkQuestEvent(UID,52,2)) then
			Loyalty = CheckLoyalty(UID)
			if (Loyalty > 9999)  then
				SaveEvent(UID,10309);-- 3. görevi bitir
				RobLoyalty(UID, 10000);
				GiveItem(UID, 900579000);
			else
				SelectMsg(UID, 3, 974, 11708, NPC, 65, 203);	
			end
		else
			SelectMsg(UID, 3, 974, 11711, NPC, 65, 203);
		end
	else
		SelectMsg(UID, 3, 974, 11710, NPC, 65, 203);	
	end
end

if (EVENT == 323) then
	if (checkQuestEvent(UID,53,2)) then
		if (checkQuestEvent(UID,52,2)) then
			if (checkQuestEvent(UID,54,2)) then
			SelectMsg(UID, 3, 974, 11704, NPC, 8263, 324, 8264, 203);
			else
			SelectMsg(UID, 3, 974, 11709, NPC, 65, 203);
			end
		else
			SelectMsg(UID, 3, 974, 11711, NPC, 65, 203);
		end
	else
		SelectMsg(UID, 3, 974, 11710, NPC, 65, 203);	
	end
end

if (EVENT == 324) then

	if (checkQuestEvent(UID,53,2)) then
		if (checkQuestEvent(UID,52,2)) then
			if (checkQuestEvent(UID,54,2)) then
			ITEMA = HowmuchItem(UID, 900579000);
				if (ITEMA < 1) then
				SelectMsg(UID, 3, 974, 11709, NPC, 65, 203);
				else
				SelectMsg(UID, 48, -1, NPC);
				end
			else
			SelectMsg(UID, 3, 974, 11709, NPC, 65, 203);
			end
		else
			SelectMsg(UID, 3, 974, 11711, NPC, 65, 203);
		end
	else
		SelectMsg(UID, 3, 974, 11710, NPC, 65, 203);	
	end
end

if (EVENT == 204) then
	ShowMap(UID, 336);
end


if (EVENT == 205) then
	GoldLose(UID, 10000)
	SelectMsg(UID, 16, 974, NPC);

end

