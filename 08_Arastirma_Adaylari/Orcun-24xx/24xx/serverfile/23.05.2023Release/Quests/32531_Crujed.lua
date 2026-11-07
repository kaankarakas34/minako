local Ret = 0;
local NPC = 32531;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 8986, NPC, 10, 101);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 8986, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 101) then
	Ret = 1;
end


local savenum = 318;

if (EVENT == 9400) then -- 66 Level Duke & Bishop & Bach
	SaveEvent(UID, 9435);
end

if (EVENT == 9402) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 8693, NPC, 22, 9403, 23, 9404);
	else
		SelectMsg(UID, 2, savenum, 8693, NPC, 10, 101);
	end
end

if (EVENT == 9403) then
	SaveEvent(UID, 9436);
end

if (EVENT == 9404) then
	SaveEvent(UID, 9439);
end

if (EVENT == 9405) then
	SaveEvent(UID, 9438);
end

if (EVENT == 9407) then
	MonsterCount1 = CountMonsterQuestSub(UID, 318, 1);
	MonsterCount2 = CountMonsterQuestSub(UID, 318, 2);
	MonsterCount2 = CountMonsterQuestSub(UID, 318, 3);
	if (MonsterCount1 > 0 and MonsterCount2 > 0 or MonsterCount3 > 0) then
		SelectMsg(UID, 4, savenum, 8693, NPC, 41, 9409, 23, 101);
	else
		if (MonsterCount1 < 1) then
			SelectMsg(UID, 2, savenum, 8693, NPC, 18, 9408);
		elseif (MonsterCount2 < 1) then
			SelectMsg(UID, 2, savenum, 8693, NPC, 18, 1000);
		elseif (MonsterCount2 < 1) then
			SelectMsg(UID, 2, savenum, 8693, NPC, 18, 1001);
		end
	end
end

if (EVENT == 9408) then
	ShowMap(UID, 614);
end

if (EVENT == 1000) then
	ShowMap(UID, 613);
end

if (EVENT == 1001) then
	ShowMap(UID, 612);
end

if (EVENT == 9409) then
	RunQuestExchange(UID, 1101)
	SaveEvent(UID, 9437);
end

local savenum2 = 190;
local talknum2 = 8880;

if (EVENT == 200) then
	PAPER = HowmuchItem(UID, 900037000);
	if (PAPER < 1) then
		SelectMsg(UID, 2, savenum2, talknum2, NPC, 19, 201,23,205);
	else
		SelectMsg(UID, 4, savenum2, talknum2, NPC, 22, 221, 23, 158);
	end
end

if (EVENT == 201) then
	SaveEvent(UID, 1281);
end

if (EVENT == 220) then
	SaveEvent(UID,1283);
end


if (EVENT == 221) then
RunQuestExchange(UID,191)
	SaveEvent(UID, 1282);
end

local savenum3 = 576;
local talknum3 = 20722;

if (EVENT == 1000) then 
	SaveEvent(UID, 11780);
end

if (EVENT == 1002) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum3, talknum3, NPC, 22, 1003, 23, 193);
	else
		SelectMsg(UID, 2, savenum3, talknum3, NPC, 10, 193);
	end
end

if (EVENT == 1003) then
	SaveEvent(UID, 11782);
	SaveEvent(UID, 11784);
end

if (EVENT == 1005) then
RunQuestExchange(UID,3066)
	SaveEvent(UID, 11783);
end



local savenum4 = 577;
local talknum4 = 20724;

if (EVENT == 1100) then 
	SaveEvent(UID, 11792);
end

if (EVENT == 1102) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum4, talknum4, NPC, 22, 1103, 23, 193);
	else
		SelectMsg(UID, 2, savenum4, talknum4, NPC, 10, 193);
	end
end

if (EVENT == 1103) then 
	SaveEvent(UID, 11794);
end

if (EVENT == 1105) then
	MonsterCount = CountMonsterQuestSub(UID, 577, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum4, talknum4, NPC, 18, 1106);
	else
		SelectMsg(UID, 4, savenum4, talknum4, NPC, 41, 1107, 27, 193);
	end
end

if (EVENT == 1106) then
	ShowMap(UID, 755);
end

if (EVENT == 1107) then
	RunQuestExchange(UID,3067)
	SaveEvent(UID, 11795);
end

local savenum4 = 578;
local talknum4 = 20726;

if (EVENT == 1200) then 
	SaveEvent(UID, 11805);
end

if (EVENT == 1202) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum4, talknum4, NPC, 22, 1203, 23, 193);
	else
		SelectMsg(UID, 2, savenum4, talknum4, NPC, 10, 193);
	end
end

if (EVENT == 1203) then 
	SaveEvent(UID, 11806);
end

if (EVENT == 1204) then 
	SaveEvent(UID, 11808);
end

if (EVENT == 1205) then
	MonsterCount = CountMonsterQuestSub(UID, 578, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum4, talknum4, NPC, 18, 1206);
	else
		SelectMsg(UID, 4, savenum4, talknum4, NPC, 41, 1207, 27, 193);
	end
end

if (EVENT == 1206) then
	ShowMap(UID, 756);
end

if (EVENT == 1207) then
	RunQuestExchange(UID,3068)
	SaveEvent(UID, 11807);
end

local savenum4 = 579;
local talknum4 = 20728;

if (EVENT == 1300) then 
	SaveEvent(UID, 11817);
end

if (EVENT == 1302) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum4, talknum4, NPC, 22, 1303, 23, 193);
	else
		SelectMsg(UID, 2, savenum4, talknum4, NPC, 10, 193);
	end
end

if (EVENT == 1303) then 
	SaveEvent(UID, 11818);
end

if (EVENT == 1304) then 
	SaveEvent(UID, 11820);
end

if (EVENT == 1305) then
	MonsterCount = CountMonsterQuestSub(UID, 579, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum4, talknum4, NPC, 18, 1306);
	else
		SelectMsg(UID, 4, savenum4, talknum4, NPC, 41, 1307, 27, 193);
	end
end

if (EVENT == 1306) then
	ShowMap(UID, 757);
end

if (EVENT == 1307) then
	RunQuestExchange(UID,3069)
	SaveEvent(UID, 11819);
end

local savenum4 = 274;
local talknum4 = 8986;

if (EVENT == 110) then 
	SaveEvent(UID, 1686);
end

if (EVENT == 111) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum4, talknum4, NPC, 22, 112, 23, 193);
	else
		SelectMsg(UID, 2, savenum4, talknum4, NPC, 10, 193);
	end
end

if (EVENT == 112) then 
	SaveEvent(UID, 1687);
end

if (EVENT == 113) then 
	SaveEvent(UID, 1689);
end

if (EVENT == 116) then
	MonsterCount = CountMonsterQuestSub(UID, 274, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum4, talknum4, NPC, 18, 115);
	else
		SelectMsg(UID, 4, savenum4, talknum4, NPC, 22, 117, 23, 193);
	end
end

if (EVENT == 115) then
	ShowMap(UID, 757);
end

if (EVENT == 117) then
	RunQuestExchange(UID,3)
	SaveEvent(UID, 1688);
end