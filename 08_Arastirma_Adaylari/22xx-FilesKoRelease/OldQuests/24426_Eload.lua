local Ret = 0;
local NPC = 24426;

if (EVENT == 190) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 4597, NPC, 10, 193);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 4598, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 193) then
	Ret = 1;
end

local savenum = 280;

if (EVENT == 170) then -- 60 Level Darkness Knight
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 235, NPC, 22, 171, 23, -1);
	else
		SelectMsg(UID, 2, savenum, 235, NPC, 10, 193);
	end
end

if (EVENT == 171) then
	SaveEvent(UID, 270);
end

if (EVENT == 172) then
	SaveEvent(UID, 207);
end

if (EVENT == 174) then
	SaveEvent(UID, 206);
	SelectMsg(UID, 2, savenum, 235, NPC, 14, 193);
end

if (EVENT == 175) then
	MonsterCount = QuestMonsterCount(UID, 280, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum, 235, NPC, 18, 193);
	else
		SelectMsg(UID, 4, savenum, 235, NPC, 41, 176, 27, 193);
	end
end

if (EVENT == 177) then
	ShowMap(UID, 80);
end

if (EVENT == 176) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID, 13)
		SaveEvent(UID, 271);  
	else
		RunExchange(UID, 13)
		SaveEvent(UID, 271); 
	end   
end

local savenum = 281;

if (EVENT == 180) then -- 60 Level Troll Shaman
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 253, NPC, 22, 181, 23, -1);
	else
		SelectMsg(UID, 2, savenum, 253, NPC, 10, 193);
	end
end

if (EVENT == 181) then
	SaveEvent(UID, 214);
end

if (EVENT == 182) then
	SaveEvent(UID, 217);
end

if (EVENT == 184) then
	SaveEvent(UID, 216);
	SelectMsg(UID, 2, savenum, 253, NPC, 14, 193);
end

if (EVENT == 185) then
	MonsterCount = QuestMonsterCount(UID, 281, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum, 253, NPC, 18, 187);
	else
		SelectMsg(UID, 4, savenum, 253, NPC, 41, 186, 27, 193);
	end
end

if (EVENT == 187) then
	ShowMap(UID, 86);
end

if (EVENT == 186) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID, 14)
		SaveEvent(UID, 215);  
	else
		RunExchange(UID, 14)
		SaveEvent(UID, 215); 
	end   
end

local savenum = 282;

if (EVENT == 200) then -- 60 Level Crimson Wing
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 265, NPC, 22, 201, 23, -1);
	else
		SelectMsg(UID, 2, savenum, 265, NPC, 10, 193);
	end
end

if (EVENT == 201) then
	SaveEvent(UID, 224);
end

if (EVENT == 202) then
	SaveEvent(UID, 227);
end

if (EVENT == 204) then
	SaveEvent(UID, 226);
	SelectMsg(UID, 2, savenum, 265, NPC, 14, 193);
end

if (EVENT == 205) then
	MonsterCount01 = QuestMonsterCount(UID, 282, 1);
	MonsterCount02 = QuestMonsterCount(UID, 282, 2);
	if (MonsterCount01 < 20 and MonsterCount02 < 20) then
		SelectMsg(UID, 2, savenum, 265, NPC, 18, 207);
	else
		SelectMsg(UID, 4, savenum, 265, NPC, 41, 206, 27, 193);
	end
end

if (EVENT == 207) then
	ShowMap(UID, 83);
end

if (EVENT == 206) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID, 15)
		SaveEvent(UID, 225);  
	else
		RunExchange(UID, 15)
		SaveEvent(UID, 225); 
	end   
end

local savenum = 283;

if (EVENT == 210) then -- 60 Level Apostle Piercing
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 276, NPC, 22, 211, 23, -1);
	else
		SelectMsg(UID, 2, savenum, 276, NPC, 10, 193);
	end
end

if (EVENT == 211) then
	SaveEvent(UID, 234);
end

if (EVENT == 212) then
	SaveEvent(UID, 237);
end

if (EVENT == 214) then
	SaveEvent(UID, 236);
	SelectMsg(UID, 2, savenum, 276, NPC, 14, 193);
end

if (EVENT == 215) then
	MonsterCount = QuestMonsterCount(UID, 283, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum, 276, NPC, 18, 217);
	else
		SelectMsg(UID, 4, savenum, 276, NPC, 41, 216, 27, 193);
	end
end

if (EVENT == 217) then
	ShowMap(UID, 87);
end

if (EVENT == 216) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID, 16)
		SaveEvent(UID, 235);  
	else
		RunExchange(UID, 16)
		SaveEvent(UID, 235); 
	end  
end

local savenum = 284;

if (EVENT == 220) then -- 60 Level Apostle Flame
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 8649, NPC, 22, 221, 23, -1);
	else
		SelectMsg(UID, 2, savenum, 8649, NPC, 10, 193);
	end
end

if (EVENT == 221) then
	SaveEvent(UID, 244);
end

if (EVENT == 222) then
	SaveEvent(UID, 247);
end

if (EVENT == 224) then
	SaveEvent(UID, 246);
	SelectMsg(UID, 2, savenum, 8649, NPC, 14, 193);
end

if (EVENT == 225) then
	MonsterCount = QuestMonsterCount(UID, 284, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum, 8649, NPC, 18, 227);
	else
		SelectMsg(UID, 4, savenum, 8649, NPC, 41, 226, 27, 193);
	end
end

if (EVENT == 227) then
	ShowMap(UID, 88);
end

if (EVENT == 226) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID, 17)
		SaveEvent(UID, 245);  
	else
		RunExchange(UID, 17)
		SaveEvent(UID, 245); 
	end  
end

local savenum = 279;

if (EVENT == 160) then -- 60 Level Doom Soldier
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 215, NPC, 22, 161, 23, -1);
	else
		SelectMsg(UID, 2, savenum, 215, NPC, 10, 193);
	end
end

if (EVENT == 161) then
	SaveEvent(UID, 260);
end

if (EVENT == 163) then
	SaveEvent(UID, 263);
end

if (EVENT == 164) then
	SaveEvent(UID, 262);
	SelectMsg(UID, 2, savenum, 215, NPC, 14, 193);
end

if (EVENT == 165) then
	MonsterCount = QuestMonsterCount(UID, 279, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum, 215, NPC, 18, 167);
	else
		SelectMsg(UID, 4, savenum, 215, NPC, 41, 166, 27, 193);
	end
end

if (EVENT == 167) then
	ShowMap(UID, 81);
end

if (EVENT == 166) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID, 12)
		SaveEvent(UID, 261);
	else
		RunExchange(UID, 12)
		SaveEvent(UID, 261); 
	end   
end

local savenum = 340;

if (EVENT == 530) then -- 70 Level 100 Kill
	SaveEvent(UID, 826);
	SelectMsg(UID, 2, savenum, 723, NPC, 4080, 193);
end

if (EVENT == 532) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 723, NPC, 22, 533, 23, -1);
	else
		SelectMsg(UID, 2, savenum, 723, NPC, 10, 193);
	end
end

if (EVENT == 533) then
	SaveEvent(UID, 827);
end

if (EVENT == 534) then
	SaveEvent(UID, 830);
end

if (EVENT == 535) then
	SaveEvent(UID, 829);
	SelectMsg(UID, 2, savenum, 723, NPC, 14, 193);
end

if (EVENT == 536) then
	MonsterCount = QuestMonsterCount(UID, 340, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum, 723, NPC, 18, 538);
	else
		SelectMsg(UID, 4, savenum, 723, NPC, 4172, 537, 4173, 193);
	end
end

if (EVENT == 538) then
	ShowMap(UID, 489);
end

if (EVENT == 537) then
	RunExchange(UID,133)
	SaveEvent(UID, 828);   
end

local savenum = 342;

if (EVENT == 320) then -- 70 Level Ewil Wizard
	SaveEvent(UID, 905);
end

if (EVENT == 321) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 3120, NPC, 22, 322, 23, -1);
	else
		SelectMsg(UID, 2, savenum, 3120, NPC, 10, 193);
	end
end

if (EVENT == 322) then
	SaveEvent(UID, 906);
end

if (EVENT == 323) then
	SaveEvent(UID, 909);
end

if (EVENT == 324) then
	SaveEvent(UID, 908);
	SelectMsg(UID, 2, savenum, 3120, NPC, 14, 193);
end

if (EVENT == 325) then
	MonsterCount = QuestMonsterCount(UID, 342, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum, 3120, NPC, 18, 327);
	else
		SelectMsg(UID, 4, savenum, 3120, NPC, 41, 326, 27, 193);
	end
end

if (EVENT == 327) then
	ShowMap(UID, 169);
end

if (EVENT == 326) then
	RunExchange(UID,157)
	SaveEvent(UID, 907);   
end

local savenum = 356;

if (EVENT == 310) then -- 74 Level Keramash & Manicmash & Nigmash
	SaveEvent(UID, 893);
end

if (EVENT == 311) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 365, NPC, 22, 312, 23, 313);
	else
		SelectMsg(UID, 2, savenum, 365, NPC, 10, 193);
	end
end

if (EVENT == 312) then
	SaveEvent(UID, 894);
end

if (EVENT == 323) then
	SaveEvent(UID, 897);
end

if (EVENT == 314) then
	SaveEvent(UID, 896);
	SelectMsg(UID, 2, savenum, 365, NPC, 14, 193);
end

if (EVENT == 315) then
	MonsterCount01 = QuestMonsterCount(UID, 356, 1); --kera
	MonsterCount02 = QuestMonsterCount(UID, 356, 2); --medik
	MonsterCount03 = QuestMonsterCount(UID, 356, 3); --nigmash
	if (MonsterCount01 > 59 and MonsterCount02 > 59 and MonsterCount03 > 79) then 
		SelectMsg(UID, 4, savenum, 371, NPC, 41, 316, 27, 193);
	else
		if     ( MonsterCount01 < 60) then
			SelectMsg(UID, 2, savenum, 4626, NPC, 18, 317);
		elseif ( MonsterCount02 < 60) then
			SelectMsg(UID, 2, savenum, 4627, NPC, 18, 318);
		elseif ( MonsterCount03 < 80) then
			SelectMsg(UID, 2, savenum, 4628, NPC, 18, 319);
		end
	end
end


if (EVENT == 317) then
	ShowMap(UID, 168);
end

if (EVENT == 318) then
	ShowMap(UID, 167);
end

if (EVENT == 319) then
	ShowMap(UID, 166);
end

if (EVENT == 316) then
	RunExchange(UID,156)
	SaveEvent(UID, 895);   
end

local savenum = 369;

if (EVENT == 300) then -- 80 Level Enigma & Cruel
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 851);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 856);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 861);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 866);
	end
end

if (EVENT == 302) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 357, NPC, 22, 303, 23, -1);
	else
		SelectMsg(UID, 2, savenum, 357, NPC, 10, 193);
	end
end

if (EVENT == 303) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 852);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 857);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 862);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 867);
	end
end

if (EVENT == 304) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 855);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 860);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 865);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 870);
	end
end

if (EVENT == 305) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 854);
		SelectMsg(UID, 2, savenum, 357, NPC, 14, 193);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 859);
		SelectMsg(UID, 2, savenum, 357, NPC, 14, 193);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 864);
		SelectMsg(UID, 2, savenum, 357, NPC, 14, 193);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 869);
		SelectMsg(UID, 2, savenum, 357, NPC, 14, 193);
	end
end

if (EVENT == 307) then
	MonsterCount1 = QuestMonsterCount(UID, 369,1);
	MonsterCount2 = QuestMonsterCount(UID, 369,2);
	if (MonsterCount1 < 1) then
		SelectMsg(UID, 2, savenum, 357, NPC, 18, 306);
	elseif (MonsterCount2 < 1) then
		SelectMsg(UID, 2, savenum, 357, NPC, 18, 309);
	else
		SelectMsg(UID, 5, savenum, 357, NPC, 41, 308,41, 308,41, 308,41, 308, 27, 193);
	end
end

if (EVENT == 306) then
	ShowMap(UID, 165);
end

if (EVENT == 309) then
	ShowMap(UID, 163);
end

if (EVENT == 308) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID,148)
		SaveEvent(UID, 853);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunExchange(UID,149)
		SaveEvent(UID, 858);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunExchange(UID,150)
		SaveEvent(UID, 863);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunExchange(UID,151)
		SaveEvent(UID, 868);
	end  
end

if (EVENT == 400) then
SelectMsg(UID, 4, 444, 6133, NPC, 22, 401,23,-1);
end

if (EVENT == 401) then
SelectMsg(UID, 15, savenum, -1, NPC);
SaveEvent(UID, 7145);
RunExchange(UID,536);
end
