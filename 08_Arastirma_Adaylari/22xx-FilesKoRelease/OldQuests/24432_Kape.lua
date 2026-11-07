local Ret = 0;
local NPC = 24432;

if (EVENT == 160) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 8255, NPC, 10, 163);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 8257, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 163) then
	Ret = 1;
end

local savenum = 413;

if (EVENT == 1000) then
	SaveEvent(UID, 2073);
end

if (EVENT == 1002) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 798, NPC, 22, 1003, 23, 1004);
	else
		SelectMsg(UID, 2, savenum, 798, NPC, 10, 163);
	end
end

if (EVENT == 1003) then
	SaveEvent(UID, 2074);
end

if (EVENT == 1004) then
	SaveEvent(UID, 2077);
end

if (EVENT == 1010) then
	SaveEvent(UID, 2076);
end

if (EVENT == 1006) then
	MonsterCount = QuestMonsterCount(UID, 413, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum, 798, NPC, 18, 1007);
	else
		SelectMsg(UID, 4, savenum, 798, NPC, 41, 1008, 27, 163);
	end
end

if (EVENT == 1007) then
	ShowMap(UID, 107);
end

if (EVENT == 1008) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,1195)
		SaveEvent(UID, 2075);
	else
		RunExchange(UID,1195)
		SaveEvent(UID, 2075);   
	end
end

local savenum = 143;

if (EVENT == 8750) then -- 41 Level Lard Orc
	SelectMsg(UID, 2, savenum, 8151, NPC, 10, 8751);
end

if (EVENT == 8751) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8679);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8684);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8689);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8694);
	end
end

if (EVENT == 8752) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 8151, NPC, 22, 8753, 23, 8754);
	else
		SelectMsg(UID, 2, savenum, 8151, NPC, 10, 163);
	end
end

if (EVENT == 8753) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8680);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8685);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8690);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8695);
	end
end

if (EVENT == 8754) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8683);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8688);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8693);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8698);
	end
end

if (EVENT == 8760) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8682);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8687);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8692);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8697);
	end
end

if (EVENT == 8756) then
	MonsterCount = QuestMonsterCount(UID, 143, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum, 8151, NPC, 18, 8757);
	else
		SelectMsg(UID, 5, savenum, 8151, NPC, 41, 8758, 41, 8758,41, 8758,23, 163);
	end
end

if (EVENT == 8757) then
	ShowMap(UID, 107);
end

if (EVENT == 8758) then
SLOTKONTROL = CheckGiveSlot(UID, 2)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID,957)
		SaveEvent(UID, 8681);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunExchange(UID,958)
		SaveEvent(UID, 8686);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunExchange(UID,959)
		SaveEvent(UID, 8691);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunExchange(UID,960)
		SaveEvent(UID, 8696);
	end
end
end

if (EVENT == 8170) then -- 45 Level Scolar
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8805);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8810);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8815);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8820);
	end
end

if (EVENT == 8172) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 175, 8390, NPC, 10, 8175);
	else
		SelectMsg(UID, 2, 175, 8259, NPC, 10, 163);
	end
end

if (EVENT == 8175) then
	SelectMsg(UID, 4, 175, 8391, NPC, 22, 8173, 23, 163);
end

if (EVENT == 8173) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8806);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8811);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8816);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8821);
	end
end

if (EVENT == 8180) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8808);
		EVENT = 8181
    elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8813);
		EVENT = 8181
    elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8818);
		EVENT = 8181
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8823);
		EVENT = 8181
	end
end

if (EVENT == 8181) then
	SelectMsg(UID, 2, 175, 8375, NPC, 3007, 163);
end

if (EVENT == 8176) then
	MonsterCount = QuestMonsterCount(UID, 175, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 175, 8376, NPC, 18, 8177);
	else
		SelectMsg(UID, 4, 175, 8392, NPC, 41, 8178, 27, 163);
	end
end

if (EVENT == 8177) then
	ShowMap(UID, 540);
end

if (EVENT == 8178) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID,981)
		SaveEvent(UID, 8807);
	elseif (Class == 2 or Class == 7 or Class == 8) then      
RunExchange(UID,982)
		SaveEvent(UID, 8812);
	elseif (Class == 3 or Class == 9 or Class == 10) then    
RunExchange(UID,983)
		SaveEvent(UID, 8817);
    elseif (Class == 4 or Class == 11 or Class == 12) then     
RunExchange(UID,984)
		SaveEvent(UID, 8822);
	end	 
end
end

if (EVENT == 9430) then -- 47 Level Macairodus
	SelectMsg(UID, 2, 206, 8760, NPC, 10, 9431);
end

if (EVENT == 9431) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9471);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9476);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9481);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9486);
	end 
end

if (EVENT == 9432) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 206, 8760, NPC, 22, 9433, 23, 9434);
	else
		SelectMsg(UID, 2, 206, 8760, NPC, 10, 163);
	end
end

if (EVENT == 9433) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9472);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9477);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9482);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9487);
	end
end

if (EVENT == 9434) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9475);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9480);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9485);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9490);
	end
end

if (EVENT == 9440) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9474);
		EVENT = 9441
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9479);
		EVENT = 9441
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9484);
		EVENT = 9441
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9489);
		EVENT = 9441
	end
end

if (EVENT == 9441) then
	SelectMsg(UID, 2, 206, 8758, NPC, 3007, 163);
end

if (EVENT == 9436) then
	MonsterCount = QuestMonsterCount(UID, 206, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 206, 8376, NPC, 18, 9437);
	else
		SelectMsg(UID, 4, 206, 8392, NPC, 41, 9438, 27, 163);
	end
end

if (EVENT == 9437) then
	ShowMap(UID, 619);
end

if (EVENT == 9438) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID,1106)
		SaveEvent(UID, 9473);
	elseif (Class == 2 or Class == 7 or Class == 8) then      
RunExchange(UID,1107)
		SaveEvent(UID, 9478);
	elseif (Class == 3 or Class == 9 or Class == 10) then    
RunExchange(UID,1108)
		SaveEvent(UID, 9483);
	elseif (Class == 4 or Class == 11 or Class == 12) then     
RunExchange(UID,1109)
		SaveEvent(UID, 9488);
	end	 
end
end

if (EVENT == 9450) then -- 51 Level Blood Don
	SelectMsg(UID, 2, 227, 8762, NPC, 10, 9451);
end

if (EVENT == 9451) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9513);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9518);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9523);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9528);
	end
end

if (EVENT == 9452) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 227, 8762, NPC, 22, 9453, 23, 163);
	else
		SelectMsg(UID, 2, 227, 8762, NPC, 10, 163);
	end
end

if (EVENT == 9453) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9514);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9519);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9524);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9529);
	end
end

if (EVENT == 9460) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9516);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9521);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9526);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9531);
	end
end

if (EVENT == 9456) then
	MonsterCount = QuestMonsterCount(UID, 227, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 227, 8376, NPC, 18, 9457);
	else
		SelectMsg(UID, 4, 227, 8392, NPC, 41, 9458, 27, 163);
	end
end

if (EVENT == 9457) then
	ShowMap(UID, 623);
end

if (EVENT == 9458) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID,1114)
		SaveEvent(UID, 9515);
	elseif (Class == 2 or Class == 7 or Class == 8) then      
RunExchange(UID,1115)
		SaveEvent(UID, 9520);
	elseif (Class == 3 or Class == 9 or Class == 10) then    
RunExchange(UID,1116)
		SaveEvent(UID, 9525);
	elseif (Class == 4 or Class == 11 or Class == 12) then     
RunExchange(UID,1117)
		SaveEvent(UID, 9530);
	end	 
end
end

if (EVENT == 9060) then -- 56 Level Grell
	SelectMsg(UID, 2, 265, 8225, NPC, 3003, 9061);
end

if (EVENT == 9061) then
	SaveEvent(UID, 9117);
end

if (EVENT == 9062) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 265, 8420, NPC, 10, 9070);
	else
		SelectMsg(UID, 2, 265, 8422, NPC, 10, 163);
	end
end

if (EVENT == 9070) then
	SelectMsg(UID, 4, 265, 8421, NPC, 22, 9063, 23, 9064);
end

if (EVENT == 9063) then
	SaveEvent(UID, 9118);
end

if (EVENT == 9064) then
	SaveEvent(UID, 9121);
end

if (EVENT == 9065) then
	SelectMsg(UID, 2, 265, 8423, NPC, 3014, 163);
	SaveEvent(UID, 9120);
end

if (EVENT == 9067) then
	MonsterCount = QuestMonsterCount(UID, 265, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 265, 8424, NPC, 18, 9068);
	else
		SelectMsg(UID, 4, 265, 8425, NPC, 41, 9069, 27, 163);
	end
end

if (EVENT == 9068) then
	ShowMap(UID, 330);
end

if (EVENT == 9069) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
RunExchange(UID,1042)
	SaveEvent(UID, 9119);
end
end

if (EVENT == 9320) then -- 57 Level Hell Hound
	SelectMsg(UID, 2, 267, 8676, NPC, 10, 9321);
end

if (EVENT == 9321) then
	SaveEvent(UID, 9339);
end

if (EVENT == 9322) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 267, 8676, NPC, 22, 9323, 23, 9324);
	else
		SelectMsg(UID, 2, 267, 8676, NPC, 10, 163);
	end
end

if (EVENT == 9323) then
	SaveEvent(UID, 9340);
end

if (EVENT == 9324) then
	SaveEvent(UID, 9343);
end

if (EVENT == 9325) then
	SaveEvent(UID, 9342);
end

if (EVENT == 9327) then
	MonsterCount = QuestMonsterCount(UID, 267, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 267, 8551, NPC, 18, 9328);
	else
		SelectMsg(UID, 4, 267, 8425, NPC, 41, 9329, 27, 163);
	end
end

if (EVENT == 9328) then
	ShowMap(UID, 37);
end

if (EVENT == 9329) then
RunExchange(UID,1089)
	SaveEvent(UID, 9341); 
end

if (EVENT == 9340) then -- 59 Level DTC
	SelectMsg(UID, 2, 269, 8680, NPC, 10, 9341);
end

if (EVENT == 9341) then
	SaveEvent(UID, 9363);
end

if (EVENT == 9342) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 269, 8680, NPC, 22, 9343, 23, 9344);
	else
		SelectMsg(UID, 2, 269, 8680, NPC, 10, 163);
	end
end

if (EVENT == 9343) then
	SaveEvent(UID, 9364);
end

if (EVENT == 9344) then
	SaveEvent(UID, 9367);
end

if (EVENT == 9345) then
	SaveEvent(UID, 9366);
end

if (EVENT == 9347) then
	MonsterCount = QuestMonsterCount(UID, 269, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 269, 8565, NPC, 18, 9348);
	else
		SelectMsg(UID, 4, 269, 8425, NPC, 41, 9349, 27, 163);
	end
end

if (EVENT == 9348) then
	ShowMap(UID, 704);
end

if (EVENT == 9349) then
RunExchange(UID,1092)
	SaveEvent(UID, 9365); 
end

if (EVENT == 9140) then -- 60 Level Lich
	SelectMsg(UID, 2, 291, 8207, NPC, 4244, 9141);
end

if (EVENT == 9141) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9255);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9260);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9265);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9270);
	end
end

if (EVENT == 9150) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 291, 8435, NPC, 3018, 9152, 3019, 9159);
	else
		SelectMsg(UID, 2, 291, 8436, NPC, 4242, 163);
	end
end

if (EVENT == 9152) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9256);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9261);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9266);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9271);
	end
end

if (EVENT == 9159) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9259);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9264);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9269);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9274);
	end
end

if (EVENT == 9153) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9258);
		EVENT = 9154
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9263);
		EVENT = 9154
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9268);
		EVENT = 9154
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9273);
		EVENT = 9154
	end
end

if (EVENT == 9154) then
	SelectMsg(UID, 2, 291, 8434, NPC, 57, 163);
end

if (EVENT == 9155) then
	MonsterCount = QuestMonsterCount(UID, 291, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 291, 8437, NPC, 18, 9157);
	else
		SelectMsg(UID, 4, 291, 8438, NPC, 41, 9158, 27, 163);
	end
end

if (EVENT == 9157) then
	ShowMap(UID, 17);
end

if (EVENT == 9158) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
    Class = CheckClass(UID);
    if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID,1052)
		SaveEvent(UID, 9257);
    elseif (Class == 2 or Class == 7 or Class == 8) then
RunExchange(UID,1053)
		SaveEvent(UID, 9262);
    elseif (Class == 3 or Class == 9 or Class == 10) then
RunExchange(UID,1054)
		SaveEvent(UID, 9267);
    elseif (Class == 4 or Class == 11 or Class == 12) then
RunExchange(UID,1055)
		SaveEvent(UID, 9272);
	end	 
end
end

if (EVENT == 1100) then -- 43 Level Megantilion   Premium
	SaveEvent(UID, 2097);
end

if (EVENT == 1102) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 417, 842, NPC, 22, 1103, 23, 1104);
	else
		SelectMsg(UID, 2, 417, 842, NPC, 10, 153);
	end
end

if (EVENT == 1103) then
	SaveEvent(UID, 2098);
end

if (EVENT == 1104) then
	SaveEvent(UID, 2101);
end

if (EVENT == 1105) then
	SaveEvent(UID, 2100);
end

if (EVENT == 1106) then
	MonsterCount = QuestMonsterCount(UID, 417, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 417, 842, NPC, 18, 1107);
	else
		SelectMsg(UID, 4, 417, 842, NPC, 41, 1108, 23, 1107);
	end
end

if (EVENT == 1107) then
	ShowMap(UID, 29);
end

if (EVENT == 1108) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,1197)
		SaveEvent(UID, 2099);
	else
		RunExchange(UID,1197)
		SaveEvent(UID, 2099);
	end
end

if (EVENT == 1200) then -- 45 Level Scolar  Premium
	SaveEvent(UID, 2121);
end

if (EVENT == 1202) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 421, 1199, NPC, 22, 1203, 23, 1204);
	else
		SelectMsg(UID, 2, 421, 1199, NPC, 10, 153);
	end
end

if (EVENT == 1203) then
	SaveEvent(UID, 2122);
end

if (EVENT == 1204) then
	SaveEvent(UID, 2125);
end

if (EVENT == 1205) then
	SaveEvent(UID, 2124);
end

if (EVENT == 1206) then
	MonsterCount = QuestMonsterCount(UID, 421, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 421, 1199, NPC, 18, 1207);
	else
		SelectMsg(UID, 4, 421, 1199, NPC, 41, 1208, 23, 1207);
	end
	end
	
if (EVENT == 1207) then
	ShowMap(UID, 29);
end

if (EVENT == 1208) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,1199)
		SaveEvent(UID, 2123);
	else
		RunExchange(UID,1199)
		SaveEvent(UID, 2123);
	end
end

if (EVENT == 200) then -- 56 Level Grell  Premium
	SaveEvent(UID, 2301);
end

if (EVENT == 202) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 475, 8169, NPC, 22, 203, 23, 204);
	else
		SelectMsg(UID, 2, 475, 8169, NPC, 10, 153);
	end
end

if (EVENT == 203) then
	SaveEvent(UID, 2302);
end

if (EVENT == 204) then
	SaveEvent(UID, 2305);
end

if (EVENT == 205) then
	SaveEvent(UID, 2304);
end

if (EVENT == 207) then
	MonsterCount = QuestMonsterCount(UID, 475, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 475, 8169, NPC, 10, 206);
	else
		SelectMsg(UID, 4, 475, 8169, NPC, 41, 208, 23, 206);
	end
	end
	
if (EVENT == 208) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,21042)
		SaveEvent(UID, 2303);
	else
		RunExchange(UID,21042)
		SaveEvent(UID, 2303);
	end
end

if (EVENT == 300) then -- 56 Level Hell Hound  Premium
	SaveEvent(UID, 2325);
end

if (EVENT == 302) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 478, 8676, NPC, 22, 303, 23, 304);
	else
		SelectMsg(UID, 2, 478, 8676, NPC, 10, 153);
	end
end

if (EVENT == 303) then
	SaveEvent(UID, 2326);
end

if (EVENT == 304) then
	SaveEvent(UID, 2329);
end

if (EVENT == 305) then
	SaveEvent(UID, 2328);
end

if (EVENT == 307) then
	MonsterCount = QuestMonsterCount(UID, 478, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 478, 8676, NPC, 10, 306);
	else
		SelectMsg(UID, 4, 478, 8676, NPC, 41, 308, 23, 306);
	end
	end
	
if (EVENT == 308) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,11089)
		SaveEvent(UID, 2327);
	else
		RunExchange(UID,11089)
		SaveEvent(UID, 2327);
	end
end

if (EVENT == 400) then -- 58 Level Manticore  Premium
	SaveEvent(UID, 2349);
end

if (EVENT == 402) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 481, 8680, NPC, 22, 403, 23, 404);
	else
		SelectMsg(UID, 2, 481, 8680, NPC, 10, 153);
	end
end

if (EVENT == 403) then
	SaveEvent(UID, 2350);
end

if (EVENT == 404) then
	SaveEvent(UID, 2353);
end

if (EVENT == 405) then
	SaveEvent(UID, 2352);
end

if (EVENT == 407) then
	MonsterCount = QuestMonsterCount(UID, 481, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 481, 8680, NPC, 10, 406);
	else
		SelectMsg(UID, 4, 481, 8680, NPC, 41, 408, 23, 406);
	end
	end
	
if (EVENT == 408) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,11092)
		SaveEvent(UID, 2351);
	else
		RunExchange(UID,11092)
		SaveEvent(UID, 2351);
	end
end

local savenum = 149;

if (EVENT == 8950) then -- 43 Level Megantilion
	SelectMsg(UID, 2, savenum, 842, NPC, 10, 8951);
end 

if (EVENT == 8951) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8763);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8768);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8773);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8778);
	end
end

if (EVENT == 8952) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 842, NPC, 22, 8953, 23, 8954);
	else
		SelectMsg(UID, 2, savenum, 842, NPC, 10, 163);
	end
end

if (EVENT == 8953) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8764);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8769);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8774);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8779);
	end
end

if (EVENT == 8954) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8767);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8772);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8777);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8782);
	end
end

if (EVENT == 8960) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8766);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8771);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8776);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8781);
	end
end

if (EVENT == 8956) then
	MonsterCount = QuestMonsterCount(UID, 149, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum, 842, NPC, 18, 8957);
	else
		SelectMsg(UID, 4, savenum, 842, NPC, 41, 8958, 23, 163);
	end
end

if (EVENT == 8958) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID,973)
		SaveEvent(UID, 8765);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunExchange(UID,974)
		SaveEvent(UID, 8770);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunExchange(UID,975)
		SaveEvent(UID, 8775);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunExchange(UID,976)
		SaveEvent(UID, 8780);
	end
end
end

local savenum=392
local talknum=8760


if (EVENT == 9900) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 9901, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == 9901) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 1301);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 1304);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 1307);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 1310);
	end
end

if(EVENT == 9905) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 1302);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 1305);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 1308);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 1311);
	end
end

if(EVENT == 9903) then
	MonsterCount1 = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount1 > 2) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 9906, 27, 153);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end





if (EVENT == 9906) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
	RunExchange(UID,11106)
	SaveEvent(UID, 1303);
	elseif (Class == 2 or Class == 7 or Class == 8) then
	RunExchange(UID,11107)
	SaveEvent(UID, 1306);
	elseif (Class == 3 or Class == 9 or Class == 10) then
	RunExchange(UID,11108)
	SaveEvent(UID, 1309);
	elseif (Class == 4 or Class == 11 or Class == 12) then
	RunExchange(UID,11110)
	SaveEvent(UID, 1312);
	end
end

local savenum=396
local talknum=8762


if (EVENT == 9800) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 9801, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == 9801) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 1397);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 1400);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 1403);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 1406);
	end
end

if(EVENT == 9805) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 1398);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 1401);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 1404);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 1407);
	end
end

if(EVENT == 9803) then
	MonsterCount1 = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount1 > 19) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 9806, 27, 153);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 9806) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
	RunExchange(UID,11114)
	SaveEvent(UID, 1399);
	elseif (Class == 2 or Class == 7 or Class == 8) then
	RunExchange(UID,11115)
	SaveEvent(UID, 1402);
	elseif (Class == 3 or Class == 9 or Class == 10) then
	RunExchange(UID,11116)
	SaveEvent(UID, 1405);
	elseif (Class == 4 or Class == 11 or Class == 12) then
	RunExchange(UID,11117)
	SaveEvent(UID, 1408);
	end
end