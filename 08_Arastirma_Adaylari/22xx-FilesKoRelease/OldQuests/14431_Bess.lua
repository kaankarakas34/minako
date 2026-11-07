local Ret = 0;
local NPC = 14431;

if (EVENT == 155) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 8256, NPC, 10, 158);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 8258, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 158) then
	Ret = 1;
end

if (EVENT == 8250) then -- 50 Level Lamia
	SelectMsg(UID, 2, 219, 8242, NPC, 28, 8251);
end

if (EVENT == 8251) then
	ShowMap(UID, 563);
	SaveEvent(UID, 9015);
end

if (EVENT == 8252) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 219, 8243, NPC, 10, 8260);
	else
		SelectMsg(UID, 2, 219, 8265, NPC, 10, 158);
	end
end

if (EVENT == 8260) then
	SelectMsg(UID, 4, 219, 8244, NPC, 22, 8253, 23, 8254);
end

if (EVENT == 8253) then
	SaveEvent(UID, 9016);
end

if (EVENT == 8254) then
	SaveEvent(UID, 9019);
end

if (EVENT == 8255) then
	SelectMsg(UID, 2, 219, 8266, NPC, 3007, 158);
	SaveEvent(UID, 9018);
end

if (EVENT == 8257) then
	MonsterCount  = QuestMonsterCount(UID, 219, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 219, 8267, NPC, 18, 8258);
	else
		SelectMsg(UID, 5, 219, 8268, NPC, 41, 8259, 27, 158);
	end
end

if (EVENT == 8258) then
	ShowMap(UID, 183);
end

if (EVENT == 8259) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
RunExchange(UID,1004)
		SaveEvent(UID, 9017); 
end
end

if (EVENT == 8350) then -- 50 Level Uruk Hai
	SelectMsg(UID, 2, 224, 8274, NPC, 14, 8351);
end

if (EVENT == 8351) then
	SaveEvent(UID, 9027);
end

if (EVENT == 8352) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 224, 8275, NPC, 10, 8360);
	else
		SelectMsg(UID, 2, 224, 8265, NPC, 10, 158);
	end
end

if (EVENT == 8360) then
	SelectMsg(UID, 4, 224, 8276, NPC, 22, 8353, 23, 8354);
end

if (EVENT == 8353) then
	SaveEvent(UID, 9028);
end

if (EVENT == 8354) then
	SaveEvent(UID, 9031);
end

if (EVENT == 8355) then
	SelectMsg(UID, 2, 224, 8266, NPC, 3007, 158);
	SaveEvent(UID, 9030);
end

if (EVENT == 8357) then
	MonsterCount = QuestMonsterCount(UID, 224, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 224, 8267, NPC, 18, 8358);
	else
		SelectMsg(UID, 5, 224, 8268, NPC, 41, 8359, 27, 158);
	end
end

if (EVENT == 8358) then
	ShowMap(UID, 543);
end

if (EVENT == 8359) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
RunExchange(UID,1006)
		SaveEvent(UID, 9029);
end
end

if (EVENT == 8650) then -- 53 Level Treant
	SelectMsg(UID, 2, 234, 8291, NPC, 3008, 8651);
end

if (EVENT == 8651) then
	SelectMsg(UID, 2, 234, 8292, NPC, 4080, 158);
	SaveEvent(UID, 9063);
end

if (EVENT == 8660) then
	SelectMsg(UID, 2, 234, 8296, NPC, 3002, 8661);
end

if (EVENT == 8661) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 234, 8297, NPC, 3018, 8662, 3019, 8668);
	else
		SelectMsg(UID, 2, 234, 8299, NPC, 10, 158);
	end
end

if (EVENT == 8662) then
	SaveEvent(UID, 9064);
end

if (EVENT == 8668) then
	SaveEvent(UID, 9067);
end

if (EVENT == 8663) then
	SelectMsg(UID, 2, 234, 8300, NPC, 4080, 158);
	SaveEvent(UID, 9066);
end

if (EVENT == 8665) then
	MonsterCount = QuestMonsterCount(UID, 234, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 234, 8301, NPC, 18, 8669);
	else
		SelectMsg(UID, 4, 234, 8302, NPC, 41, 8667, 27, 158);
	end
end

if (EVENT == 8669) then
	ShowMap(UID, 505);
end

if (EVENT == 8667) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
RunExchange(UID,945)
	SaveEvent(UID, 9065);	 	 
end
end

if (EVENT == 9180) then -- 54 Level Ancient
	SelectMsg(UID, 2, 238, 8274, NPC, 14, 9181);
end

if (EVENT == 9181) then
	SaveEvent(UID, 9075);
end

if (EVENT == 9182) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 238, 8305, NPC, 10, 9190);
	else
		SelectMsg(UID, 2, 238, 8265, NPC, 10, 158);
	end
end

if (EVENT == 9190) then
	SelectMsg(UID, 4, 238, 8306, NPC, 22, 9183, 23, 9184);
end

if (EVENT == 9183) then
	SaveEvent(UID, 9076);
end

if (EVENT == 9184) then
	SaveEvent(UID, 9079);
end

if (EVENT == 9185) then
	SelectMsg(UID, 2, 238, 8266, NPC, 3007, 158);
	SaveEvent(UID, 9078);
end

if (EVENT == 9187) then
	MonsterCount = QuestMonsterCount(UID, 238, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 238, 8267, NPC, 18, 9188);
	else
		SelectMsg(UID, 5, 238, 8268, NPC, 41, 9189, 27, 158);
	end
end

if (EVENT == 9188) then
	ShowMap(UID, 546);
end

if (EVENT == 9189) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
RunExchange(UID,947)
		SaveEvent(UID, 9077);
end
end

if (EVENT == 9020) then -- 55 Level Dragon Tooth Commander
	SelectMsg(UID, 2, 242, 8274, NPC, 14, 9021);
end

if (EVENT == 9021) then
	SaveEvent(UID, 9099);
end

if (EVENT == 9022) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 242, 8446, NPC, 10, 9030);
	else
		SelectMsg(UID, 2, 242, 8265, NPC, 10, 158);
	end
end

if (EVENT == 9030) then
	SelectMsg(UID, 4, 242, 8447, NPC, 22, 9023, 23, 9024);
end

if (EVENT == 9023) then
	SaveEvent(UID, 9100);
end

if (EVENT == 9024) then
	SaveEvent(UID, 9103);
end

if (EVENT == 9025) then
	SelectMsg(UID, 2, 242, 8266, NPC, 3007, 158);
	SaveEvent(UID, 9102);
end

if (EVENT == 9027) then
	MonsterCount = QuestMonsterCount(UID, 242, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 242, 8267, NPC, 18, 9028);
	else
		SelectMsg(UID, 4, 242, 8451, NPC, 41, 9029, 27, 158);
	end
end

if (EVENT == 9028) then
	ShowMap(UID, 586);
end

if (EVENT == 9029) then
RunExchange(UID,1008)
	SaveEvent(UID, 9101);	 
end

if (EVENT == 9040) then -- 56 Level Uruk Blade
	SelectMsg(UID, 2, 264, 8274, NPC, 14, 9041);
end

if (EVENT == 9041) then
	SaveEvent(UID, 9111);
end

if (EVENT == 9042) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 264, 8456, NPC, 10, 9050);
	else
		SelectMsg(UID, 2, 264, 8265, NPC, 10, 158);
	end
end

if (EVENT == 9050) then
	SelectMsg(UID, 4, 264, 8457, NPC, 22, 9043, 23, 9044);
end

if (EVENT == 9043) then
	SaveEvent(UID, 9112);
end

if (EVENT == 9044) then
	SaveEvent(UID, 9115);
end

if (EVENT == 9045) then
	SelectMsg(UID, 2, 264, 8266, NPC, 3007, 158);
	SaveEvent(UID, 9114);
end

if (EVENT == 9047) then
	MonsterCount = QuestMonsterCount(UID, 264, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 264, 8267, NPC, 18, 9048);
	else
		SelectMsg(UID, 4, 264, 8268, NPC, 41, 9049, 27, 158);
	end
end

if (EVENT == 9048) then
	ShowMap(UID, 550);
end

if (EVENT == 9049) then
RunExchange(UID,1041)
	SaveEvent(UID, 9113);	 
end

if (EVENT == 9080) then -- 60 Level Deruvish
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9150);
		EVENT = 9081
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9155);
		EVENT = 9081
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9160);
		EVENT = 9081
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9165);
		EVENT = 9081
	end
end

if (EVENT == 9081) then
	SelectMsg(UID, 2, 286, 8464, NPC, 4080, 158);
end

if (EVENT == 9082) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 286, 8465, NPC, 10, 9085);
	else
		SelectMsg(UID, 2, 286, 8265, NPC, 10, 158);
	end
end

if (EVENT == 9085) then
	SelectMsg(UID, 4, 286, 8466, NPC, 22, 9083, 23, 9084);
end

if (EVENT == 9083) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9151);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9156);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9161);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9166);
	end
end

if (EVENT == 9084) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9154);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9159);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9164);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9169);
	end
end

if (EVENT == 9090) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9153);
		EVENT = 9091
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9158);
		EVENT = 9091
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9163);
		EVENT = 9091
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9168);
		EVENT = 9091
	end
end

if (EVENT == 9091) then
	SelectMsg(UID, 2, 286, 8467, NPC, 3002, 158);
end

if (EVENT == 9086) then
	MonsterCount = QuestMonsterCount(UID, 286, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 286, 8468, NPC, 18, 9087);
	else
		SelectMsg(UID, 4, 286, 8469, NPC, 41, 9088, 27, 158);
	end
end

if (EVENT == 9087) then
	ShowMap(UID, 517);
end

if (EVENT == 9088) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		RunExchange(UID,936)
		SaveEvent(UID, 9152);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		RunExchange(UID,937)
		SaveEvent(UID, 9157);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		RunExchange(UID,938)
		SaveEvent(UID, 9162);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		RunExchange(UID,939)
		SaveEvent(UID, 9167);
	end 
end
end

if (EVENT == 9100) then -- 60 Level Apostle
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9192);
		EVENT = 9101
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9197);
		EVENT = 9101
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9202);
		EVENT = 9101
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9207);
		EVENT = 9101
	end
end

if (EVENT == 9101) then
	SelectMsg(UID, 2, 288, 8476, NPC, 4080, 158);
end

if (EVENT == 9102) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 288, 8477, NPC, 10, 9105);
	else
		SelectMsg(UID, 2, 288, 8265, NPC, 10, 158);
	end
end

if (EVENT == 9105) then
	SelectMsg(UID, 4, 288, 8478, NPC, 22, 9103, 23, 9104);
end

if (EVENT == 9103) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9193);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9198);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9203);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9208);
	end
end

if (EVENT == 9104) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9196);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9201);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9206);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9211);
	end
end

if (EVENT == 9110) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9195);
		EVENT = 9111
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9200);
		EVENT = 9111
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9205);
		EVENT = 9111
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9210);
		EVENT = 9111
	end
end

if (EVENT == 9111) then
	SelectMsg(UID, 2, 288, 8467, NPC, 3002, 158);
end

if (EVENT == 9106) then
	MonsterCount = QuestMonsterCount(UID, 288, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 288, 8468, NPC, 18, 9107);
	else
		SelectMsg(UID, 4, 288, 8479, NPC, 41, 9108, 27, 158);
	end
end

if (EVENT == 9107) then
	ShowMap(UID, 552);
end

if (EVENT == 9108) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		RunExchange(UID,916)
		SaveEvent(UID, 9194);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		RunExchange(UID,917)
		SaveEvent(UID, 9199);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		RunExchange(UID,918)
		SaveEvent(UID, 9204);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		RunExchange(UID,919)
		SaveEvent(UID, 9209);
	end
end
end

if (EVENT == 9120) then -- 60 Level Troll
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9234);
		EVENT = 9121
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9239);
		EVENT = 9121
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9244);
		EVENT = 9121
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9249);
		EVENT = 9121
	end
end

if (EVENT == 9121) then
	SelectMsg(UID, 2, 290, 8476, NPC, 4080, 158);
end

if (EVENT == 9122) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 290, 8483, NPC, 10, 9125);
	else
		SelectMsg(UID, 2, 290, 8265, NPC, 10, 158);
	end
end

if (EVENT == 9125) then
	SelectMsg(UID, 4, 290, 8484, NPC, 22, 9123, 23, 9124);
end

if (EVENT == 9123) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9235);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9240);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9245);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9250);
	end
end

if (EVENT == 9124) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9238);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9243);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9248);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9253);
	end
end

if (EVENT == 9130) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9237);
		EVENT = 9131
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9242);
		EVENT = 9131
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9247);
		EVENT = 9131
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9252);
		EVENT = 9131
	end
end

if (EVENT == 9131) then
	SelectMsg(UID, 2, 290, 8467, NPC, 29, 158);
end

if (EVENT == 9126) then
	MonsterCount = QuestMonsterCount(UID, 290, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 290, 8468, NPC, 18, 9127);
	else
		SelectMsg(UID, 4, 290, 8485, NPC, 10, 9128, 27, 158);
	end
end

if (EVENT == 9127) then
	ShowMap(UID, 554);
end

if (EVENT == 9128) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		RunExchange(UID,1048)
		SaveEvent(UID, 9236);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		RunExchange(UID,1049)
		SaveEvent(UID, 9241);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		RunExchange(UID,1050)
		SaveEvent(UID, 9246);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		RunExchange(UID,1051)
		SaveEvent(UID, 9251);
	end
end
end

if (EVENT == 9160) then -- 60 Level Stone Golem
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9318);
		EVENT = 9161
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9323);
		EVENT = 9161
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9328);
		EVENT = 9161
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9333);
		EVENT = 9161
	end
end

if (EVENT == 9161) then
	SelectMsg(UID, 2, 294, 8476, NPC, 4080, 158);
end

if (EVENT == 9162) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 294, 8489, NPC, 10, 9165);
	else
		SelectMsg(UID, 2, 294, 8265, NPC, 10, 158);
	end
end

if (EVENT == 9165) then
	SelectMsg(UID, 4, 294, 8490, NPC, 22, 9163, 23, 9164);
end

if (EVENT == 9163) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9319);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9324);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9329);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9334);
	end
end

if (EVENT == 9164) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9322);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9327);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9332);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9337);
	end
end

if (EVENT == 9170) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9321);
		EVENT = 9171
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9326);
		EVENT = 9171
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9331);
		EVENT = 9171
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9336);
		EVENT = 9171
	end
end

if (EVENT == 9171) then
	SelectMsg(UID, 2, 294, 8467, NPC, 29, 158);
end

if (EVENT == 9166) then
	MonsterCount = QuestMonsterCount(UID, 294, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 294, 8468, NPC, 18, 9167);
	else
		SelectMsg(UID, 4, 294, 8491, NPC, 41, 9168, 27, 158);
	end
end

if (EVENT == 9167) then
	ShowMap(UID, 556);
end

if (EVENT == 9168) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		RunExchange(UID,997)
		SaveEvent(UID, 9320);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		RunExchange(UID,998)
		SaveEvent(UID, 9325);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		RunExchange(UID,999)
		SaveEvent(UID, 9330);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		RunExchange(UID,1000)
		SaveEvent(UID, 9335);
	end
end
end

if (EVENT == 200) then -- 50 Level Lamia Premium
	SaveEvent(UID, 2199);
end

if (EVENT == 202) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 458, 8162, NPC, 22, 203, 23, 204);
	else
		SelectMsg(UID, 2, 458, 8162, NPC, 10, 153);
	end
end

if (EVENT == 203) then
	SaveEvent(UID, 2200);
end

if (EVENT == 204) then
	SaveEvent(UID, 2203);
end

if (EVENT == 205) then
	SaveEvent(UID, 2202);
end

if (EVENT == 207) then
	MonsterCount = QuestMonsterCount(UID, 458, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 458, 8162, NPC, 18, 208);
	else
		SelectMsg(UID, 4, 458, 8162, NPC, 41, 209, 23, 208);
	end
end


if (EVENT == 209) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,21004)
		SaveEvent(UID, 2201);
	else
		RunExchange(UID,21004)
		SaveEvent(UID, 2201);
	end
end

if (EVENT == 300) then -- 51 Level Uruk Hai Premium
	SaveEvent(UID, 2211);
end

if (EVENT == 302) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 460, 8270, NPC, 22, 303, 23, 304);
	else
		SelectMsg(UID, 2, 460, 8270, NPC, 10, 153);
	end
end

if (EVENT == 303) then
	SaveEvent(UID, 2212);
end

if (EVENT == 304) then
	SaveEvent(UID, 2215);
end

if (EVENT == 305) then
	SaveEvent(UID, 2214);
end

if (EVENT == 307) then
	MonsterCount = QuestMonsterCount(UID, 460, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 460, 8270, NPC, 18, 308);
	else
		SelectMsg(UID, 4, 460, 8270, NPC, 41, 309, 23, 308);
	end
end


if (EVENT == 309) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,21006)
		SaveEvent(UID, 2213);
	else
		RunExchange(UID,21006)
		SaveEvent(UID, 2213);
	end
end

if (EVENT == 400) then -- 51 Level Treant Premium
	SaveEvent(UID, 2247);
end

if (EVENT == 410) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 466, 8164, NPC, 22, 411, 23, 412);
	else
		SelectMsg(UID, 2, 466, 8164, NPC, 10, 153);
	end
end

if (EVENT == 411) then
	SaveEvent(UID, 2248);
end

if (EVENT == 412) then
	SaveEvent(UID, 2251);
end

if (EVENT == 413) then
	SaveEvent(UID, 2250);
end

if (EVENT == 415) then
	MonsterCount = QuestMonsterCount(UID, 466, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 466, 8164, NPC, 18, 414);
	else
		SelectMsg(UID, 4, 466, 8164, NPC, 41, 416, 23, 414);
	end
end

if (EVENT == 416) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,1945)
		SaveEvent(UID, 2249);
	else
		RunExchange(UID,1945)
		SaveEvent(UID, 2249);
	end
end

if (EVENT == 500) then -- 54 Level Ancient Premium
	SaveEvent(UID, 2259);
end

if (EVENT == 502) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 468, 8308, NPC, 22, 503, 23, 504);
	else
		SelectMsg(UID, 2, 468, 8308, NPC, 10, 153);
	end
end

if (EVENT == 503) then
	SaveEvent(UID, 2260);
end

if (EVENT == 504) then
	SaveEvent(UID, 2263);
end

if (EVENT == 505) then
	SaveEvent(UID, 2262);
end

if (EVENT == 507) then
	MonsterCount = QuestMonsterCount(UID, 468, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 468, 8308, NPC, 18, 508);
	else
		SelectMsg(UID, 4, 468, 8308, NPC, 41, 509, 23, 508);
	end
end


if (EVENT == 509) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,1947)
		SaveEvent(UID, 2261);
	else
		RunExchange(UID,1947)
		SaveEvent(UID, 2261);
	end
end

if (EVENT == 600) then -- 55 Level Dragon Tooth Commander Premium
	SaveEvent(UID, 2283);
end

if (EVENT == 602) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 472, 8449, NPC, 22, 603, 23, 604);
	else
		SelectMsg(UID, 2, 472, 8449, NPC, 10, 153);
	end
end

if (EVENT == 603) then
	SaveEvent(UID, 2284);
end

if (EVENT == 604) then
	SaveEvent(UID, 2287);
end

if (EVENT == 605) then
	SaveEvent(UID, 2286);
end

if (EVENT == 607) then
	MonsterCount = QuestMonsterCount(UID, 472, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 472, 8449, NPC, 18, 608);
	else
		SelectMsg(UID, 4, 472, 8449, NPC, 41, 609, 23, 608);
	end
end


if (EVENT == 609) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,21008)
		SaveEvent(UID, 2285);
	else
		RunExchange(UID,21008)
		SaveEvent(UID, 2285);
	end
end

if (EVENT == 700) then -- 56 Level Uruk Blade Premium
	SaveEvent(UID, 2295);
end

if (EVENT == 702) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 474, 8453, NPC, 22, 703, 23, 704);
	else
		SelectMsg(UID, 2, 474, 8453, NPC, 10, 153);
	end
end

if (EVENT == 703) then
	SaveEvent(UID, 2296);
end

if (EVENT == 704) then
	SaveEvent(UID, 2299);
end

if (EVENT == 705) then
	SaveEvent(UID, 2298);
end

if (EVENT == 707) then
	MonsterCount = QuestMonsterCount(UID, 474, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 474, 8453, NPC, 18, 708);
	else
		SelectMsg(UID, 4, 474, 8453, NPC, 41, 709, 23, 708);
	end
end


if (EVENT == 709) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,21041)
		SaveEvent(UID, 2297);
	else
		RunExchange(UID,21041)
		SaveEvent(UID, 2297);
	end
end
