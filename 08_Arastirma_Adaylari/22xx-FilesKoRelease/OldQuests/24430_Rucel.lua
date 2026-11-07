local Ret = 0;
local NPC = 24430;

if (EVENT == 150) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 8199, NPC, 10, 153);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 8201, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 153) then
	Ret = 1;
end

if (EVENT == 8600) then -- 44 Level Ape
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8889);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8894);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8899);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8904);
	end
end 

if (EVENT == 8610) then
	SelectMsg(UID, 2, 152, 8201, NPC, 3002, 8611);
end

if (EVENT == 8611) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 152, 8181, NPC, 3018, 8612, 3019, 8619);
	else
		SelectMsg(UID, 2, 152, 8182, NPC, 4242, 153);
	end
end

if (EVENT == 8612) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8890);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8895);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8900);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8905);
	end
end

if (EVENT == 8619) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8893);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8898);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8903);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8908);
	end
end 

if (EVENT == 8613) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8892);
		EVENT = 8614
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8897);
		EVENT = 8614
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8902);
		EVENT = 8614
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8907);
		EVENT = 8614
	end
end

if (EVENT == 8614) then
	SelectMsg(UID, 2, 152, 8401, NPC, 4080, 153);
end

if (EVENT == 8615) then
	MonsterCount = QuestMonsterCount(UID, 152, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 152, 8182, NPC, 18, 8617);
	else
		SelectMsg(UID, 4, 152, 8411, NPC, 41, 8618, 27, 153);
	end
end

if (EVENT == 8617) then
	ShowMap(UID, 113);
end

if (EVENT == 8618) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID,928)
		SaveEvent(UID, 8891);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunExchange(UID,929)
		SaveEvent(UID, 8896);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunExchange(UID,930)
		SaveEvent(UID, 8901);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunExchange(UID,931)
		SaveEvent(UID, 8906);
	end	 	 
end
end

if (EVENT == 8270) then -- 45 Level Kongau
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8847);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8852);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8857);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8862);
	end
end

if (EVENT == 8272) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 180, 8398, NPC, 10, 8275);
	else
		SelectMsg(UID, 2, 180, 8399, NPC, 10, 153);
	end
end

if (EVENT == 8275) then
	SelectMsg(UID, 4, 180, 8400, NPC, 22, 8273, 23, 8274);
end

if (EVENT == 8273) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8848);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8853);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8858);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8863);
	end
end

if (EVENT == 8274) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8851);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8856);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8861);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8866);
	end
end

if (EVENT == 8280) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8850);
		EVENT = 8281
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8855);
		EVENT = 8281
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8860);
		EVENT = 8281
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8865);
		EVENT = 8281
	end
end

if (EVENT == 8281) then
	SelectMsg(UID, 2, 180, 8401, NPC, 3002, 153);
end

if (EVENT == 8276) then
	MonsterCount = QuestMonsterCount(UID, 180, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 180, 8402, NPC, 18, 8277);
	else
		SelectMsg(UID, 4, 180, 8403, NPC, 41, 8278, 27, 153);
	end
end

if (EVENT == 8277) then
	ShowMap(UID, 512);
end

if (EVENT == 8278) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID,989)
		SaveEvent(UID, 8849);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunExchange(UID,990)
		SaveEvent(UID, 8854);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunExchange(UID,991)
		SaveEvent(UID, 8859);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunExchange(UID,992)
		SaveEvent(UID, 8864);
	end	 
end
end

if (EVENT == 8500) then  -- 46 Level Burning Skeleton
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8931);
		EVENT = 8501
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8936);
		EVENT = 8501
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8941);
		EVENT = 8501
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8946);
		EVENT = 8501
	end
end

if (EVENT == 8501) then
	SelectMsg(UID, 2, 197, 8191, NPC, 56, 153);
end

if (EVENT == 8502) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 197, 8192, NPC, 10, 8505);
	else
		SelectMsg(UID, 2, 197, 8399, NPC, 10, 153);
	end
end

if (EVENT == 8505) then
	SelectMsg(UID, 4, 197, 8193, NPC, 22, 8503, 23, 8504);
end

if (EVENT == 8503) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8932);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8937);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8942);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8947);
	end
end

if (EVENT == 8504) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8935);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8940);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8945);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8950);
	end 
end

if (EVENT == 8510) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 8934);
		EVENT = 8511
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 8939);
		EVENT = 8511
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 8944);
		EVENT = 8511
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 8949);
		EVENT = 8511
	end
end

if (EVENT == 8511) then
	SelectMsg(UID, 2, 197, 8180, NPC, 3007, 153);
end

if (EVENT == 8506) then
	MonsterCount = QuestMonsterCount(UID, 197, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 197, 8402, NPC, 18, 8507);
	else
		SelectMsg(UID, 4, 197, 8194, NPC, 41, 8508, 27, 153);
	end
end

if (EVENT == 8507) then
	ShowMap(UID, 510);
end

if (EVENT == 8508) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID,920)
		SaveEvent(UID, 8933);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunExchange(UID,921)
		SaveEvent(UID, 8938);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunExchange(UID,922)
		SaveEvent(UID, 8943);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunExchange(UID,923)
		SaveEvent(UID, 8948);
	end 
end

if (EVENT == 8070) then -- 48 Level Ash Knight
	SelectMsg(UID, 2, 208, 8147, NPC, 14, 8071);
end

if (EVENT == 8071) then
	SaveEvent(UID, 8985);
end

if (EVENT == 8072) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 208, 8155, NPC, 10, 8080);
	else
		SelectMsg(UID, 2, 208, 8399, NPC, 10, 153);
	end
end

if (EVENT == 8080) then
	SelectMsg(UID, 4, 208, 8173, NPC, 22, 8073, 23, 8074);
end

if (EVENT == 8073) then
	SaveEvent(UID, 8986);
end

if (EVENT == 8074) then
	SaveEvent(UID, 8989);
end

if (EVENT == 8075) then
	SelectMsg(UID, 2, 208, 8213, NPC, 3014, 153);
	SaveEvent(UID, 8988);
end

if (EVENT == 8077) then
	MonsterCount = QuestMonsterCount(UID, 208, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 208, 8402, NPC, 18, 8078);
	else
		SelectMsg(UID, 4, 208, 8214, NPC, 41, 8079, 27, 153);
	end
end

if (EVENT == 8078) then
	ShowMap(UID, 504);
end

if (EVENT == 8079) then
RunExchange(UID,818)
	SaveEvent(UID, 8987);	 
end

if (EVENT == 8150) then -- 49 Level Haunga
	SelectMsg(UID, 2, 212, 8217, NPC, 3002, 8151);
end

if (EVENT == 8151) then
	SaveEvent(UID, 8997);
end

if (EVENT == 8152) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 212, 8218, NPC, 10, 8160);
	else
		SelectMsg(UID, 2, 212, 8399, NPC, 10, 153);
	end
end

if (EVENT == 8160) then
	SelectMsg(UID, 4, 212, 8219, NPC, 22, 8153, 23, 8154);
end

if (EVENT == 8153) then
	SaveEvent(UID, 8998);
end

if (EVENT == 8154) then
	SaveEvent(UID, 9001);
end

if (EVENT == 8155) then
	SelectMsg(UID, 2, 212, 8213, NPC, 3014, 153);
	SaveEvent(UID, 9000);
end

if (EVENT == 8157) then
	MonsterCount = QuestMonsterCount(UID, 212, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 212, 8402, NPC, 18, 8158);
	else
		SelectMsg(UID, 4, 212, 8220, NPC, 41, 8159, 27, 153);
	end
end

if (EVENT == 8158) then
	ShowMap(UID, 516);
end

if (EVENT == 8159) then
RunExchange(UID,948)
	SaveEvent(UID, 8999);	 
end

if (EVENT == 9470) then -- 50 Level Sheriff
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9555);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9560);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9565);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9570);
	end
end

if (EVENT == 9472) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 221, 8766, NPC, 10, 9475);
	else
		SelectMsg(UID, 2, 221, 8766, NPC, 10, 153);
	end
end

if (EVENT == 9475) then
	SelectMsg(UID, 4, 221, 8764, NPC, 22, 9473, 23, 9474);
end

if (EVENT == 9473) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9556);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9561);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9566);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9571);
	end
end

if (EVENT == 9474) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9559);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9564);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9569);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9574);
	end
end

if (EVENT == 9480) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9558);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9563);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9568);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9573);
	end
end

if (EVENT == 9476) then
	MonsterCount = QuestMonsterCount(UID, 221, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 221, 8765, NPC, 18, 9477);
	else
		SelectMsg(UID, 4, 221, 8766, NPC, 41, 9478, 27, 153);
	end
end

if (EVENT == 9477) then
	ShowMap(UID, 621);
end

if (EVENT == 9478) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID,1122)
		SaveEvent(UID, 9557);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunExchange(UID,1123)
		SaveEvent(UID, 9562);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunExchange(UID,1124)
		SaveEvent(UID, 9567);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunExchange(UID,1125)
		SaveEvent(UID, 9572);
	end
end
end

if (EVENT == 8550) then -- 52 Level Dragon Tooth Soldier
	SelectMsg(UID, 2, 229, 8000, NPC, 14, 8551);
end

if (EVENT == 8551) then
	SaveEvent(UID, 9045);
end

if (EVENT == 8552) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 229, 8001, NPC, 10, 8560);
	else
		SelectMsg(UID, 2, 229, 8399, NPC, 10, 153);
	end
end

if (EVENT == 8560) then
	SelectMsg(UID, 4, 229, 8002, NPC, 22, 8553, 23, 8554);
end

if (EVENT == 8553) then
	SaveEvent(UID, 9046);
end

if (EVENT == 8554) then
	SaveEvent(UID, 9049);
end

if (EVENT == 8555) then
	SelectMsg(UID, 2, 229, 8003, NPC, 3014, 153);
	SaveEvent(UID, 9048);
end

if (EVENT == 8557) then
	MonsterCount = QuestMonsterCount(UID, 229, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 229, 8402, NPC, 18, 8558);
	else
		SelectMsg(UID, 5, 229, 8004, NPC, 41, 8559, 27, 153);
	end
end

if (EVENT == 8558) then
	ShowMap(UID, 585);
end

if (EVENT == 8559) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
RunExchange(UID,1001)  
		SaveEvent(UID, 9047);

end
end

if (EVENT == 9490) then -- 52 Level Garuna
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9597);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9602);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9607);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9612);
	end
end

if (EVENT == 9492) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 231, 8192, NPC, 10, 9495);
	else
		SelectMsg(UID, 2, 231, 8402, NPC, 10, 153);
	end
end

if (EVENT == 9495) then
	SelectMsg(UID, 4, 231, 8193, NPC, 22, 9493, 23, 9494);
end

if (EVENT == 9493) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9598);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9603);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9608);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9613);
	end
end

if (EVENT == 9494) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9601);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9606);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9611);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9616);
	end
end

if (EVENT == 9500) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 9600);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 9605);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 9610);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 9615);
	end
end

if (EVENT == 9496) then
	MonsterCount = QuestMonsterCount(UID, 231, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 231, 8402, NPC, 18, 9497);
	else
		SelectMsg(UID, 4, 231, 8194, NPC, 41, 9498, 27, 153);
	end
end

if (EVENT == 9497) then
	ShowMap(UID, 178);
end

if (EVENT == 9498) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
RunExchange(UID,1130)
		SaveEvent(UID, 9599);
	elseif (Class == 2 or Class == 7 or Class == 8) then
RunExchange(UID,1131)
		SaveEvent(UID, 9604);
	elseif (Class == 3 or Class == 9 or Class == 10) then
RunExchange(UID,1132)
		SaveEvent(UID, 9609);
	elseif (Class == 4 or Class == 11 or Class == 12) then
RunExchange(UID,1133)
		SaveEvent(UID, 9614);
	end
end
end

if (EVENT == 400) then -- 54 Level Dragon Tooth Skeleton Premium
	SaveEvent(UID, 2265);
end

if (EVENT == 402) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 469, 8167, NPC, 22, 403, 23, 404);
	else
		SelectMsg(UID, 2, 469, 8167, NPC, 10, 153);
	end
end

if (EVENT == 403) then
	SaveEvent(UID, 2266);
end

if (EVENT == 404) then
	SaveEvent(UID, 2269);
end

if (EVENT == 405) then
	SaveEvent(UID, 2268);
end

if (EVENT == 407) then
	MonsterCount = QuestMonsterCount(UID, 469, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 469, 8167, NPC, 18, 408);
	else
		SelectMsg(UID, 4, 469, 8167, NPC, 41, 409, 23, 408);
	end
end

if (EVENT == 408) then
	ShowMap(UID, 186);
end

if (EVENT == 409) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,1942)
		SaveEvent(UID, 2267);
	else
		RunExchange(UID,1942)
		SaveEvent(UID, 2267);
	end
end

if (EVENT == 9000) then -- 54 Level Dragon Tooth Skeleton
	SelectMsg(UID, 2, 239, 8000, NPC, 14, 9001);
end

if (EVENT == 9001) then
	SaveEvent(UID, 9081);
end

if (EVENT == 9002) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 2, 239, 8013, NPC, 10, 9010);
	else
		SelectMsg(UID, 2, 239, 8399, NPC, 10, 153);
	end
end

if (EVENT == 9010) then
	SelectMsg(UID, 4, 239, 8014, NPC, 22, 9003, 23, 9004);
end

if (EVENT == 9003) then
	SaveEvent(UID, 9082);
end

if (EVENT == 9004) then
	SaveEvent(UID, 9085);
end

if (EVENT == 9005) then
	SelectMsg(UID, 2, 239, 8003, NPC, 3014, 153);
	SaveEvent(UID, 9084);
end

if (EVENT == 9007) then
	MonsterCount = QuestMonsterCount(UID, 239, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 239, 8402, NPC, 18, 9008);
	else
		SelectMsg(UID, 4, 239, 8220, NPC, 41, 9009, 27, 153);
	end
end

if (EVENT == 9008) then
	ShowMap(UID, 186);
end

if (EVENT == 9009) then
RunExchange(UID,942)
	SaveEvent(UID, 9083);	 
end

if (EVENT == 1000) then -- 44 Level Ape Premium
	SaveEvent(UID, 2109);
end

if (EVENT == 1010) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 419, 8495, NPC, 22, 1011, 23, 1012);
	else
		SelectMsg(UID, 2, 419, 8496, NPC, 10, 153);
	end
end

if (EVENT == 1011) then
	SaveEvent(UID, 2110);
end

if (EVENT == 1012) then
	SaveEvent(UID, 2113);
end

if (EVENT == 1013) then
	SaveEvent(UID, 2112);
end

if (EVENT == 1015) then
	MonsterCount = QuestMonsterCount(UID, 419, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 419, 8495, NPC, 18, 1016);
	else
		SelectMsg(UID, 4, 419, 8496, NPC, 41, 1017, 23, 1016);
	end
end

if (EVENT == 1016) then
	ShowMap(UID, 29);
end

if (EVENT == 1017) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,1198)
		SaveEvent(UID, 2111);
	else
		RunExchange(UID,1198)
		SaveEvent(UID, 2111);
	end
end

if (EVENT == 1100) then -- 45 Level Kangaus  Premium
	SaveEvent(UID, 2133);
end

if (EVENT == 1102) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 423, 8153, NPC, 22, 1103, 23, 1104);
	else
		SelectMsg(UID, 2, 423, 8153, NPC, 10, 153);
	end
end

if (EVENT == 1103) then
	SaveEvent(UID, 2134);
end

if (EVENT == 1104) then
	SaveEvent(UID, 2137);
end

if (EVENT == 1105) then
	SaveEvent(UID, 2136);
end

if (EVENT == 1106) then
	MonsterCount = QuestMonsterCount(UID, 423, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 423, 8153, NPC, 18, 1107);
	else
		SelectMsg(UID, 4, 423, 8153, NPC, 41, 1108, 23, 1107);
	end
end

if (EVENT == 1107) then
	ShowMap(UID, 29);
end

if (EVENT == 1108) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,1200)
		SaveEvent(UID, 2135);
	else
		RunExchange(UID,1200)
		SaveEvent(UID, 2135);
	end
end

if (EVENT == 1200) then -- 46 Level Burning Skeleton  Premium
	SaveEvent(UID, 2145);
end

if (EVENT == 1202) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 425, 8494, NPC, 22, 1203, 23, 1204);
	else
		SelectMsg(UID, 2, 425, 8494, NPC, 10, 153);
	end
end

if (EVENT == 1203) then
	SaveEvent(UID, 2146);
end

if (EVENT == 1204) then
	SaveEvent(UID, 2149);
end

if (EVENT == 1205) then
	SaveEvent(UID, 2148);
end

if (EVENT == 1206) then
	MonsterCount = QuestMonsterCount(UID, 425, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 425, 8154, NPC, 18, 1207);
	else
		SelectMsg(UID, 4, 425, 8155, NPC, 41, 1208, 23, 1207);
	end
	end
	
if (EVENT == 1107) then
	ShowMap(UID, 29);
end

if (EVENT == 1208) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,1201)
		SaveEvent(UID, 2147);
	else
		RunExchange(UID,1201)
		SaveEvent(UID, 2147);
	end
end

if (EVENT == 1300) then -- 47 Level Ash Knight  Premium
	SaveEvent(UID, 2169);
end

if (EVENT == 1302) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 429, 8018, NPC, 22, 1303, 23, 1304);
	else
		SelectMsg(UID, 2, 429, 8018, NPC, 10, 153);
	end
end

if (EVENT == 1303) then
	SaveEvent(UID, 2170);
end

if (EVENT == 1304) then
	SaveEvent(UID, 2173);
end

if (EVENT == 1305) then
	SaveEvent(UID, 2172);
end

if (EVENT == 1307) then
	MonsterCount = QuestMonsterCount(UID, 429, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 429, 8018, NPC, 18, 1308);
	else
		SelectMsg(UID, 4, 429, 8018, NPC, 22, 1309, 23, 1308);
	end
	end
	
	if (EVENT == 1308) then
	ShowMap(UID, 508);
end

if (EVENT == 1309) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,1203)
		SaveEvent(UID, 2171);
	else
		RunExchange(UID,1203)
		SaveEvent(UID, 2171);
	end
end

if (EVENT == 1400) then -- Haunga  Premium
	SaveEvent(UID, 2181);
end

if (EVENT == 1402) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 431, 8159, NPC, 22, 1403, 23, 1404);
	else
		SelectMsg(UID, 2, 431, 8159, NPC, 10, 153);
	end
end

if (EVENT == 1403) then
	SaveEvent(UID, 2182);
end

if (EVENT == 1404) then
	SaveEvent(UID, 2185);
end

if (EVENT == 1405) then
	SaveEvent(UID, 2184);
end

if (EVENT == 1407) then
	MonsterCount = QuestMonsterCount(UID, 431, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 431, 8159, NPC, 18, 1408);
	else
		SelectMsg(UID, 4, 431, 8159, NPC, 22, 1409, 23, 1408);
	end
	end
	
	if (EVENT == 1408) then
	ShowMap(UID, 508);
end

if (EVENT == 1409) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,1204)
		SaveEvent(UID, 2183);
	else
		RunExchange(UID,1204)
		SaveEvent(UID, 2183);
	end
end

if (EVENT == 300) then -- Dragon Tooth Skeleton Premium
	SaveEvent(UID, 2229);
end

if (EVENT == 302) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 463, 8167, NPC, 22, 303, 23, 304);
	else
		SelectMsg(UID, 2, 463, 8167, NPC, 10, 153);
	end
end

if (EVENT == 303) then
	SaveEvent(UID, 2230);
end

if (EVENT == 304) then
	SaveEvent(UID, 2233);
end

if (EVENT == 305) then
	SaveEvent(UID, 2232);
end

if (EVENT == 307) then
	MonsterCount = QuestMonsterCount(UID, 463, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 463, 8167, NPC, 18, 308);
	else
		SelectMsg(UID, 4, 463, 8169, NPC, 41, 309, 23, 308);
	end
end

if (EVENT == 308) then
	ShowMap(UID, 29);
end

if (EVENT == 309) then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID,21001)
		SaveEvent(UID, 2231);
	else
		RunExchange(UID,21001)
		SaveEvent(UID, 2231);
	end
end

local savenum=395
local talknum=8764
local exchangeid=8764

if (EVENT == 9900) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 9901, 23, 163);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 163);
	end
end

if (EVENT == 9901) then
	Class = CheckClass(UID);
	if (Class == 1 or  Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 1385);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 1388);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 1391);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 1394);
	end
end

if(EVENT == 9905) then
	Class = CheckClass(UID);
	if (Class == 1 or  Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 1386);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 1389);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 1392);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 1395);
	end
end

if(EVENT == 9903) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 163);
	else
		SelectMsg(UID, 4, savenum, talknum, NPC, 41, 9904, 27, 163);
	end
end

if(EVENT == 9904) then
	Class = CheckClass(UID);
	if (Class == 1 or  Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		RunExchange(UID, 11126)
		SaveEvent(UID, 1387);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		RunExchange(UID, 11127)
		SaveEvent(UID, 1390);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		RunExchange(UID, 11128)
		SaveEvent(UID, 1393);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		RunExchange(UID, 11129)
		SaveEvent(UID, 1396);
	end
end

local savenum=398
local talknum=8766


if (EVENT == 9800) then 
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 9801, 23, 163);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 163);
	end
end

if (EVENT == 9801) then
	Class = CheckClass(UID);
	if (Class == 1 or  Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 1421);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 1424);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 1427);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 1430);
	end
end

if(EVENT == 9805) then
	Class = CheckClass(UID);
	if (Class == 1 or  Class == 5 or Class == 6 or Class == 13 or Class == 14 or Class == 15) then
		SaveEvent(UID, 1422);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 1425);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 1428);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 1431);
	end
end

if(EVENT == 9803) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 163);
	else
		SelectMsg(UID, 4, savenum, talknum, NPC, 41, 9804, 27, 163);
	end
end

if (EVENT == 9804) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
	RunExchange(UID,11130)
	SaveEvent(UID, 1423);
	elseif (Class == 2 or Class == 7 or Class == 8) then
	RunExchange(UID,11131)
	SaveEvent(UID, 1426);
	elseif (Class == 3 or Class == 9 or Class == 10) then
	RunExchange(UID,11132)
	SaveEvent(UID, 1429);
	elseif (Class == 4 or Class == 11 or Class == 12) then
	RunExchange(UID,11133)
	SaveEvent(UID, 1429);
	end
end

if (EVENT == 202) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
     EVENT = 211
	elseif (Class == 2 or Class == 7 or Class == 8) then
     EVENT = 212
	elseif (Class == 3 or Class == 9 or Class == 10) then
     EVENT = 213
	elseif (Class == 4 or Class == 11 or Class == 12) then
	 EVENT = 214
	end
end

if(EVENT == 211) then
	SelectMsg(UID, 4, 448, 9222, NPC, 22, 215, 23, -1);
end

if(EVENT == 212) then
	SelectMsg(UID, 4, 449, 9222, NPC, 22, 215, 23, -1);
end

if(EVENT == 213) then
	SelectMsg(UID, 4, 450, 9222, NPC, 22, 215, 23, -1);
end

if(EVENT == 214) then
	SelectMsg(UID, 4, 451, 9222, NPC, 22, 215, 23, -1);
end

if (EVENT == 210) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
     SaveEvent(UID, 7163);
	elseif (Class == 2 or Class == 7 or Class == 8) then
     SaveEvent(UID, 7168);
	elseif (Class == 3 or Class == 9 or Class == 10) then
     SaveEvent(UID, 7173);
	elseif (Class == 4 or Class == 11 or Class == 12) then
	 SaveEvent(UID, 7178);
	end
end

if (EVENT == 215) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
     SaveEvent(UID, 7161);
	elseif (Class == 2 or Class == 7 or Class == 8) then
     SaveEvent(UID, 7166);
	elseif (Class == 3 or Class == 9 or Class == 10) then
     SaveEvent(UID, 7171);
	elseif (Class == 4 or Class == 11 or Class == 12) then
	 SaveEvent(UID, 7178);
	end
end

if (EVENT == 206) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
     EVENT = 216
	elseif (Class == 2 or Class == 7 or Class == 8) then
     EVENT = 217
	elseif (Class == 3 or Class == 9 or Class == 10) then
     EVENT = 218
	elseif (Class == 4 or Class == 11 or Class == 12) then
	 EVENT = 219
	end
end

if(EVENT == 216) then
	MonsterCount1 = QuestMonsterCount(UID, 448, 1);
	MonsterCount2 = QuestMonsterCount(UID, 448, 2);
	if (MonsterCount1 < 10) then
		SelectMsg(UID, 2, 448, 9222, NPC, 18, 220);
	elseif (MonsterCount2 < 10) then
		SelectMsg(UID, 2, 448, 9222, NPC, 18, 221);
	else
		SelectMsg(UID, 4, 448, 9222, NPC, 41, 203, 27, -1);
	end
end

if (EVENT == 220) then
	ShowMap(UID, 706);--706
end

if (EVENT == 221) then
	ShowMap(UID, 708);--708
end

if(EVENT == 217) then
	MonsterCount1 = QuestMonsterCount(UID, 449, 1);
	MonsterCount2 = QuestMonsterCount(UID, 449, 2);
	if (MonsterCount1 < 10) then
		SelectMsg(UID, 2, 449, 9222, NPC, 18, 222);
	elseif (MonsterCount2 < 10) then
		SelectMsg(UID, 2, 449, 9222, NPC, 18, 223);
	else
		SelectMsg(UID, 4, 449, 9222, NPC, 41, 203, 27, -1);
	end
end

if (EVENT == 222) then
	ShowMap(UID, 706);--706
end

if (EVENT == 223) then
	ShowMap(UID, 710);--710
end

if(EVENT == 218) then
	MonsterCount1 = QuestMonsterCount(UID, 450, 1);
	MonsterCount2 = QuestMonsterCount(UID, 450, 2);
	if (MonsterCount1 < 10) then
		SelectMsg(UID, 2, 450, 9222, NPC, 18, 224);
	elseif (MonsterCount2 < 10) then
		SelectMsg(UID, 2, 450, 9222, NPC, 18, 225);
	else
		SelectMsg(UID, 4, 450, 9222, NPC, 41, 203, 27, -1);
	end
end

if (EVENT == 224) then
	ShowMap(UID, 712);--712
end

if (EVENT == 225) then
	ShowMap(UID, 714);--714
end

if(EVENT == 219) then
	MonsterCount1 = QuestMonsterCount(UID, 451, 1);
	MonsterCount2 = QuestMonsterCount(UID, 451, 2);
	if (MonsterCount1 < 10) then
		SelectMsg(UID, 2, 451, 9222, NPC, 18, 226);
	elseif (MonsterCount2 < 10) then
		SelectMsg(UID, 2, 451, 9222, NPC, 18, 227);
	else
		SelectMsg(UID, 4, 451, 9222, NPC, 41, 203, 27, -1);
	end
end

if (EVENT == 226) then
	ShowMap(UID, 714);--714
end

if (EVENT == 227) then
	ShowMap(UID, 710);--710
end

if (EVENT == 203) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
     RunExchange(UID,701)
	SaveEvent(UID, 7162);
	elseif (Class == 2 or Class == 7 or Class == 8) then
     RunExchange(UID,702)
	SaveEvent(UID, 7167);
	elseif (Class == 3 or Class == 9 or Class == 10) then
     RunExchange(UID,703)
	SaveEvent(UID, 7172);
	elseif (Class == 4 or Class == 11 or Class == 12) then
	 RunExchange(UID,704)
	SaveEvent(UID, 7177);
	end
end
---------------------------------------------------------------------------------------------------------------------
if (EVENT == 502) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
     EVENT = 511
	elseif (Class == 2 or Class == 7 or Class == 8) then
     EVENT = 512
	elseif (Class == 3 or Class == 9 or Class == 10) then
     EVENT = 513
	elseif (Class == 4 or Class == 11 or Class == 12) then
	 EVENT = 514
	end
end

if(EVENT == 511) then
	SelectMsg(UID, 4, 483, 9222, NPC, 22, 515, 23, -1);
end

if(EVENT == 512) then
	SelectMsg(UID, 4, 484, 9222, NPC, 22, 515, 23, -1);
end

if(EVENT == 513) then
	SelectMsg(UID, 4, 485, 9222, NPC, 22, 515, 23, -1);
end

if(EVENT == 514) then
	SelectMsg(UID, 4, 486, 9222, NPC, 22, 515, 23, -1);
end

if (EVENT == 510) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
     SaveEvent(UID, 2364);
	elseif (Class == 2 or Class == 7 or Class == 8) then
     SaveEvent(UID, 2369);
	elseif (Class == 3 or Class == 9 or Class == 10) then
     SaveEvent(UID, 2374);
	elseif (Class == 4 or Class == 11 or Class == 12) then
	 SaveEvent(UID, 2379);
	end
end

if (EVENT == 515) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
     SaveEvent(UID, 2362);
	elseif (Class == 2 or Class == 7 or Class == 8) then
     SaveEvent(UID, 2367);
	elseif (Class == 3 or Class == 9 or Class == 10) then
     SaveEvent(UID, 2372);
	elseif (Class == 4 or Class == 11 or Class == 12) then
	 SaveEvent(UID, 2377);
	end
end

if (EVENT == 506) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
     EVENT = 516
	elseif (Class == 2 or Class == 7 or Class == 8) then
     EVENT = 517
	elseif (Class == 3 or Class == 9 or Class == 10) then
     EVENT = 518
	elseif (Class == 4 or Class == 11 or Class == 12) then
	 EVENT = 519
	end
end

if(EVENT == 516) then
	MonsterCount1 = QuestMonsterCount(UID, 483, 1);
	MonsterCount2 = QuestMonsterCount(UID, 483, 2);
	if (MonsterCount1 < 2) then
		SelectMsg(UID, 2, 483, 9222, NPC, 18, 520);
	elseif (MonsterCount2 < 2) then
		SelectMsg(UID, 2, 483, 9222, NPC, 18, 521);
	else
		SelectMsg(UID, 4, 483, 9222, NPC, 41, 503, 27, -1);
	end
end

if (EVENT == 520) then
	ShowMap(UID, 706);--706
end

if (EVENT == 521) then
	ShowMap(UID, 708);--708
end

if(EVENT == 517) then
	MonsterCount1 = QuestMonsterCount(UID, 484, 1);
	MonsterCount2 = QuestMonsterCount(UID, 484, 2);
	if (MonsterCount1 < 2) then
		SelectMsg(UID, 2, 484, 9222, NPC, 18, 522);
	elseif (MonsterCount2 < 2) then
		SelectMsg(UID, 2, 484, 9222, NPC, 18, 523);
	else
		SelectMsg(UID, 4, 484, 9222, NPC, 41, 503, 27, -1);
	end
end

if (EVENT == 522) then
	ShowMap(UID, 706);--706
end

if (EVENT == 523) then
	ShowMap(UID, 712);--710
end

if(EVENT == 518) then
	MonsterCount1 = QuestMonsterCount(UID, 485, 1);
	MonsterCount2 = QuestMonsterCount(UID, 485, 2);
	if (MonsterCount1 < 2) then
		SelectMsg(UID, 2, 485, 9222, NPC, 18, 524);
	elseif (MonsterCount2 < 2) then
		SelectMsg(UID, 2, 485, 9222, NPC, 18, 525);
	else
		SelectMsg(UID, 4, 485, 9222, NPC, 41, 503, 27, -1);
	end
end

if (EVENT == 524) then
	ShowMap(UID, 712);--712
end

if (EVENT == 525) then
	ShowMap(UID, 714);--714
end

if(EVENT == 519) then
	MonsterCount1 = QuestMonsterCount(UID, 486, 1);
	MonsterCount2 = QuestMonsterCount(UID, 486, 2);
	if (MonsterCount1 < 2) then
		SelectMsg(UID, 2, 486, 9222, NPC, 18, 526);
	elseif (MonsterCount2 < 2) then
		SelectMsg(UID, 2, 486, 9222, NPC, 18, 527);
	else
		SelectMsg(UID, 4, 486, 9222, NPC, 41, 503, 27, -1);
	end
end

if (EVENT == 526) then
	ShowMap(UID, 714);--714
end

if (EVENT == 527) then
	ShowMap(UID, 710);--710
end

if (EVENT == 503) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
     RunExchange(UID,1701)
	SaveEvent(UID, 2363);
	elseif (Class == 2 or Class == 7 or Class == 8) then
     RunExchange(UID,1702)
	SaveEvent(UID, 2368);
	elseif (Class == 3 or Class == 9 or Class == 10) then
     RunExchange(UID,1703)
	SaveEvent(UID, 2373);
	elseif (Class == 4 or Class == 11 or Class == 12) then
	 RunExchange(UID,1704)
	SaveEvent(UID, 2378);
	end
end