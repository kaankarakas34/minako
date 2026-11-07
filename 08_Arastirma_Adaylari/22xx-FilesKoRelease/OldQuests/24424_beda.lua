local Ret = 0;
local NPC = 24424;

if (EVENT == 190) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 4513, NPC, 10, 193);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 4514, NPC)
	else
		EVENT = QuestNum
	end
end

if (EVENT == 193) then
	Ret = 1;
end

if (EVENT == 9540) then -- 61 Level Doom Soldier
	SaveEvent(UID, 9723);
end

if (EVENT == 9542) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 302, 8772, NPC, 22, 9543, 23, 9544);
	else
		SelectMsg(UID, 2, 302, 8772, NPC, 10, 193);
	end
end

if (EVENT == 9543) then
	SaveEvent(UID, 9724);
end

if (EVENT == 9544) then
	SaveEvent(UID, 9727);
end

if (EVENT == 9546) then
	SaveEvent(UID, 9726);
end

if (EVENT == 9547) then
	MonsterCount = QuestMonsterCount(UID, 302, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 302, 8772, NPC, 18, 9548);
	else
		SelectMsg(UID, 4, 302, 8772, NPC, 41, 9549, 27, 9548);
	end
end

if (EVENT == 9548) then
	ShowMap(UID, 627);
end

if (EVENT == 9549) then
	RunExchange(UID,1154)
	SaveEvent(UID, 9725);
end

local savenum = 317;

if (EVENT == 530) then -- 62 Level 7 Certificate of Suffering
	SaveEvent(UID, 4266);
	SelectMsg(UID, 2, savenum, 4503, NPC, 4080, 193);
end

if (EVENT == 532) then   
	SelectMsg(UID, 4, savenum, 4505, NPC, 22, 533, 23, 534);
end

if (EVENT == 533) then
	GiveItemLua(UID,910127000,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 0,0, 0,0);
	SaveEvent(UID, 4267);
end

if (EVENT == 535) then
	SaveEvent(UID, 4269);
end

if (EVENT == 536) then
	ItemA = HowmuchItem(UID, 910134000);
	ItemB = HowmuchItem(UID, 910127000);
	if (ItemA < 1) then
		if (ItemB < 1) then
			Check = isRoomForItem(UID, 910127000);
			if (Check == -1) then
				SelectMsg(UID, 2, savenum, 832, NPC, 27 , 193);
			else
				GiveItemLua(UID,910127000,1,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0, 0,0, 0,0, 0,0, 0,0);
				SelectMsg(UID, 2, savenum, 4507, NPC, 18, 538);
			end
		else
			SelectMsg(UID, 2, savenum, 4508, NPC, 18, 538);
		end
	else
		SelectMsg(UID, 2, savenum, 4506, NPC, 4172, 537, 4173, 193);
	end
end

if (EVENT == 538) then
	ShowMap(UID, 454);
end

if (EVENT == 537) then
RunExchange(UID, 481);
	SaveEvent(UID, 4268); 
end

if (EVENT == 9370) then -- 62 Level Brahman
	SaveEvent(UID, 9399);
end

if (EVENT == 9372) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 311, 8686, NPC, 22, 9373, 23, 9374);
	else
		SelectMsg(UID, 2, 311, 8686, NPC, 10, 193);
	end
end

if (EVENT == 9373) then
	SaveEvent(UID, 9400);
end

if (EVENT == 9374) then
	SaveEvent(UID, 9403);
end

if (EVENT == 9376) then
	SaveEvent(UID, 9402);
end

if (EVENT == 9377) then
	MonsterCount = QuestMonsterCount(UID, 311, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 311, 8686, NPC, 18, 9378);
	else
		SelectMsg(UID, 4, 311, 8686, NPC, 41, 9379, 27, 9378);
	end
end

if (EVENT == 9378) then
	ShowMap(UID, 607);
end

if (EVENT == 9379) then
	RunExchange(UID,1096)
	SaveEvent(UID, 9401);
end

if (EVENT == 9380) then -- 63 Level Crimson Wing
	SaveEvent(UID, 9411);
end

if (EVENT == 9382) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 313, 8688, NPC, 22, 9383, 23, 9384);
	else
		SelectMsg(UID, 2, 313, 8688, NPC, 10, 193);
	end
end

if (EVENT == 9383) then
	SaveEvent(UID, 9412);
end

if (EVENT == 9384) then
	SaveEvent(UID, 9415);
end

if (EVENT == 9386) then
	SaveEvent(UID, 9414);
end

if (EVENT == 9387) then
	MonsterCount = QuestMonsterCount(UID, 313, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 313, 8688, NPC, 18, 9388);
	else
		SelectMsg(UID, 4, 313, 8688, NPC, 41, 9389, 27, 9388);
	end
end

if (EVENT == 9388) then
	ShowMap(UID, 609);
end

if (EVENT == 9389) then
	RunExchange(UID,1098)
	SaveEvent(UID, 9413);
end

if (EVENT == 9390) then -- 64 Level Gargoyle
	SaveEvent(UID, 9423);
end

if (EVENT == 9392) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 315, 8690, NPC, 22, 9393, 23, 9394);
	else
		SelectMsg(UID, 2, 315, 8690, NPC, 10, 193);
	end
end

if (EVENT == 9393) then
	SaveEvent(UID, 9424);
end

if (EVENT == 9394) then
	SaveEvent(UID, 9427);
end

if (EVENT == 9396) then
	SaveEvent(UID, 9426);
end

if (EVENT == 9397) then
	MonsterCount = QuestMonsterCount(UID, 315, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 315, 8690, NPC, 18, 9398);
	else
		SelectMsg(UID, 4, 315, 8690, NPC, 41, 9399, 27, 9398);
	end
end

if (EVENT == 9398) then
	ShowMap(UID, 611);
end

if (EVENT == 9399) then
	RunExchange(UID,1100)
	SaveEvent(UID, 9425);
end

if (EVENT == 9410) then -- 67 Level Apostle Piercing Cold 
	SaveEvent(UID, 9447);
end

if (EVENT == 9412) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 319, 8694, NPC, 22, 9413, 23, 9414);
	else
		SelectMsg(UID, 2, 319, 8694, NPC, 10, 193);
	end
end

if (EVENT == 9413) then
	SaveEvent(UID, 9448);
end

if (EVENT == 9414) then
	SaveEvent(UID, 9451);
end

if (EVENT == 9416) then
	SaveEvent(UID, 9450);
end

if (EVENT == 9417) then
	MonsterCount = QuestMonsterCount(UID, 319, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 319, 8694, NPC, 18, 9418);
	else
		SelectMsg(UID, 4, 319, 8694, NPC, 41, 9419, 27, 9418);
	end
end

if (EVENT == 9418) then
	ShowMap(UID, 616);
end

if (EVENT == 9419) then
	RunExchange(UID,1103)
	SaveEvent(UID, 9449);
end

if (EVENT == 9420) then -- 69 Level Apostle of Flames
	SaveEvent(UID, 9459);
end

if (EVENT == 9422) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 321, 8696, NPC, 22, 9423, 23, 9424);
	else
		SelectMsg(UID, 2, 321, 8696, NPC, 10, 193);
	end
end

if (EVENT == 9423) then
	SaveEvent(UID, 9460);
end

if (EVENT == 9424) then
	SaveEvent(UID, 9463);
end

if (EVENT == 9426) then
	SaveEvent(UID, 9462);
end

if (EVENT == 9427) then
	MonsterCount = QuestMonsterCount(UID, 321, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 321, 8696, NPC, 18, 9428);
	else
		SelectMsg(UID, 4, 321, 8696, NPC, 41, 9429, 27, 9428);
	end
end

if (EVENT == 9428) then
	ShowMap(UID, 618);
end

if (EVENT == 9429) then
	RunExchange(UID,1104)
	SaveEvent(UID, 9461);
end

local savenum = 338;

if (EVENT == 630) then -- 70 Level Selfname Quest
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 4333);
		EVENT = 631
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 4338);
		EVENT = 631
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 4343);
		EVENT = 631
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 4348);
		EVENT = 631
	end
end

if (EVENT == 631) then
	SelectMsg(UID, 2, savenum, 4613, NPC, 4080, 193);
end

if (EVENT == 632) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, 4614, NPC, 22, 633, 23, 634);
	else
		SelectMsg(UID, 2, savenum, 4615, NPC, 10, 193);
	end
end

if (EVENT == 633) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 4334);
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 4339);
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 4344);
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 4349);
	end
end

if (EVENT == 634) then
	SaveEvent(UID, 4337);
end

if (EVENT == 280) then
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		SaveEvent(UID, 4336);
		EVENT = 281
	elseif (Class == 2 or Class == 7 or Class == 8) then
		SaveEvent(UID, 4341);
		EVENT = 281
	elseif (Class == 3 or Class == 9 or Class == 10) then
		SaveEvent(UID, 4346);
		EVENT = 281
	elseif (Class == 4 or Class == 11 or Class == 12) then
		SaveEvent(UID, 4351);
		EVENT = 281
	end
end

if (EVENT == 281) then
	SelectMsg(UID, 2, savenum, 4616, NPC, 14, 193);
end

if (EVENT == 636) then
	MonsterCount01 = QuestMonsterCount(UID, 338,1); --Quest Uruk Hai
	MonsterCount02 = QuestMonsterCount(UID, 338,2); --Quest Stone Golem
	MonsterCount03 = QuestMonsterCount(UID, 338,3); --Quest Troll Berserker
	MonsterCount04 = QuestMonsterCount(UID, 338,4); --Quest Apostles
	if (MonsterCount01 > 0 and MonsterCount02 > 0 and MonsterCount03 > 0 and MonsterCount04 > 0) then 
		SelectMsg(UID, 5, savenum, 4621, NPC, 41, 637,41, 637,41, 637,41, 637, 27, 193);
	else
		if (MonsterCount01 < 1) then
			SelectMsg(UID, 2, savenum, 4617, NPC, 18, 638);
		elseif ( MonsterCount02 < 1) then
			SelectMsg(UID, 2, savenum, 4618, NPC, 18, 639);
		elseif ( MonsterCount03 < 1) then
			SelectMsg(UID, 2, savenum, 4619, NPC, 18, 640);
		elseif ( MonsterCount04 < 1) then
			SelectMsg(UID, 2, savenum, 4620, NPC, 18, 641);
		end
	end
end

if (EVENT == 638) then
	ShowMap(UID, 474);
end

if (EVENT == 639) then
	ShowMap(UID, 475);
end

if (EVENT == 640) then
	ShowMap(UID, 476);
end

if (EVENT == 641) then
	ShowMap(UID, 477);
end

if (EVENT == 637) then
SLOTKONTROL = CheckGiveSlot(UID, 1)
     if SLOTKONTROL == false then
       SelectMsg(UID,2,-1,8898,NPC,10)
         else
	Class = CheckClass(UID);
	if (Class == 1 or Class == 5 or Class == 6) then
		RunExchange(UID,493, 1)
		--SaveEvent(UID, 4335);
		ShowEffect(UID, 300391) 
	elseif (Class == 2 or Class == 7 or Class == 8) then
		RunExchange(UID,494)
		--SaveEvent(UID, 4340);
		ShowEffect(UID, 300391) 
	elseif (Class == 3 or Class == 9 or Class == 10) then
		RunExchange(UID,495, 1)
		--SaveEvent(UID, 4345);
		ShowEffect(UID, 300391) 
	elseif (Class == 4 or Class == 11 or Class == 12) then
		RunExchange(UID,496, 1)
		--SaveEvent(UID, 4350);
		ShowEffect(UID, 300391) 
	end	 
end
end

if (EVENT == 200) then -- 71 Level Troll Berserker
	SaveEvent(UID, 917);
end

if (EVENT == 202) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 343, 1401, NPC, 22, 203, 23, 204);
	else
		SelectMsg(UID, 2, 343, 1401, NPC, 10, 193);
	end
end

if (EVENT == 203) then
	SaveEvent(UID, 918);
end

if (EVENT == 204) then
	SaveEvent(UID, 921);
end

if (EVENT == 205) then
	SaveEvent(UID, 920);
end

if (EVENT == 206) then
	MonsterCount = QuestMonsterCount(UID, 343, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 343, 1401, NPC, 18, 207);
	else
		SelectMsg(UID, 4, 343, 1401, NPC, 41, 208, 27, 207);
	end
end

if (EVENT == 207) then
	ShowMap(UID, 130);
end

if (EVENT == 208) then
	RunExchange(UID,158)
	SaveEvent(UID, 919);
end

if (EVENT == 210) then -- 71 Level Troll Captain
	SaveEvent(UID, 929);
end

if (EVENT == 212) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 345, 1414, NPC, 22, 213, 23, 214);
	else
		SelectMsg(UID, 2, 345, 1414, NPC, 10, 193);
	end
end

if (EVENT == 213) then
	SaveEvent(UID, 930);
end

if (EVENT == 214) then
	SaveEvent(UID, 933);
end

if (EVENT == 215) then
	SaveEvent(UID, 932);
end

if (EVENT == 216) then
	MonsterCount = QuestMonsterCount(UID, 345, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 345, 1414, NPC, 18, 217);
	else
		SelectMsg(UID, 4, 345, 1414, NPC, 41, 218, 27, 217);
	end
end

if (EVENT == 217) then
	ShowMap(UID, 171);
end

if (EVENT == 218) then
	RunExchange(UID,160)
	SaveEvent(UID, 931);
end

if (EVENT == 220) then -- 72 Level Booro 
	SaveEvent(UID, 941);
end

if (EVENT == 222) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 350, 1427, NPC, 22, 223, 23, 224);
	else
		SelectMsg(UID, 2, 350, 1427, NPC, 10, 193);
	end
end

if (EVENT == 223) then
	SaveEvent(UID, 942);
end

if (EVENT == 224) then
	SaveEvent(UID, 945);
end

if (EVENT == 225) then
	SaveEvent(UID, 944);
end

if (EVENT == 226) then
	MonsterCount = QuestMonsterCount(UID, 350, 1);
	if (MonsterCount < 80) then
		SelectMsg(UID, 2, 350, 1427, NPC, 18, 227);
	else
		SelectMsg(UID, 4, 350, 1427, NPC, 41, 228, 27, 227);
	end
end

if (EVENT == 227) then
	ShowMap(UID, 172);
end

if (EVENT == 228) then
	RunExchange(UID,162)
	SaveEvent(UID, 943);
end

if (EVENT == 230) then -- 72 Level Dark Stone
	SaveEvent(UID, 953);
end

if (EVENT == 232) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 352, 1440, NPC, 22, 233, 23, 234);
	else
		SelectMsg(UID, 2, 352, 1440, NPC, 10, 193);
	end
end

if (EVENT == 233) then
	SaveEvent(UID, 954);
end

if (EVENT == 234) then
	SaveEvent(UID, 957);
end

if (EVENT == 235) then
	SaveEvent(UID, 956);
end

if (EVENT == 236) then
	MonsterCount = QuestMonsterCount(UID, 352, 1);
	if (MonsterCount < 80) then
		SelectMsg(UID, 2, 352, 1440, NPC, 18, 237);
	else
		SelectMsg(UID, 4, 352, 1440, NPC, 41, 238, 27, 237);
	end
end

if (EVENT == 237) then
	ShowMap(UID, 174);
end

if (EVENT == 238) then
	RunExchange(UID,164)
	SaveEvent(UID, 955);
end

if (EVENT == 240) then -- 73 Level Balog
	SaveEvent(UID, 965);
end

if (EVENT == 242) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, 354, 1451, NPC, 22, 243, 23, 244);
	else
		SelectMsg(UID, 2, 354, 1451, NPC, 10, 193);
	end
end

if (EVENT == 243) then
	SaveEvent(UID, 966);
end

if (EVENT == 244) then
	SaveEvent(UID, 969);
end

if (EVENT == 245) then
	SaveEvent(UID, 968);
end

if (EVENT == 246) then
	MonsterCount = QuestMonsterCount(UID, 354, 1);
	if (MonsterCount < 80) then
		SelectMsg(UID, 2, 354, 1451, NPC, 18, 247);
	else
		SelectMsg(UID, 4, 354, 1451, NPC, 41, 248, 27, 247);
	end
end

if (EVENT == 247) then
	ShowMap(UID, 175);
end

if (EVENT == 248) then
	RunExchange(UID,166)
	SaveEvent(UID, 967);
end

if (EVENT == 1000) then 
	SaveEvent(UID, 11391);
end

if (EVENT == 1002) then
		SelectMsg(UID, 4, 546, 20061, NPC, 22, 1003, 23, 1004);
end

if (EVENT == 1003) then
	SaveEvent(UID, 11392);
end

if (EVENT == 1004) then
	SaveEvent(UID, 11395);
end

if (EVENT == 1005) then
	SaveEvent(UID, 11394);
end

if (EVENT == 1006) then
		SelectMsg(UID, 4, 546, 20061, NPC, 41, 1008);
end

if (EVENT == 1008) then
	RunExchange(UID,3033)
	SaveEvent(UID, 11393);
end


savenum				=1066
talknum				=11386
exchangeid			=1376
moncount			=25 	  -- Yaratık sayısı
accept				=4501 -- Görevi al
iscomplate			=4503 -- Görevi kontrol et
complate			=4502 -- Görevi verme event
event1				=2412 -- Görev açma
event2				=2413 -- Görev kabul etme
event3				=2415 -- Görev bittimi kontrolü uzak
event4				=2416 -- Görev bittimi kontrolü npc
event5				=2417 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end


---------- Death Wizard 1- Quest 
--------------------------------------


savenum				=1070
talknum				=11392
exchangeid			=1378
moncount			=25 	  -- Yaratık sayısı
accept				=4521 -- Görevi al
iscomplate			=4523 -- Görevi kontrol et
complate			=4522 -- Görevi verme event
event1				=2432 -- Görev açma
event2				=2433 -- Görev kabul etme
event3				=2435 -- Görev bittimi kontrolü uzak
event4				=2436 -- Görev bittimi kontrolü npc
event5				=2437 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

---------- Satiros 1- Quest 
--------------------------------------


savenum				=1074
talknum				=11396
exchangeid			=1380
moncount			=30 	  -- Yaratık sayısı
accept				=4541 -- Görevi al
iscomplate			=4543 -- Görevi kontrol et
complate			=4542 -- Görevi verme event
event1				=2452 -- Görev açma
event2				=2453 -- Görev kabul etme
event3				=2455 -- Görev bittimi kontrolü uzak
event4				=2456 -- Görev bittimi kontrolü npc
event5				=2457 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

savenum				=1078
talknum				=11402
exchangeid			=1382
moncount			=30 	  -- Yaratık sayısı
accept				=4561 -- Görevi al
iscomplate			=4563 -- Görevi kontrol et
complate			=4562 -- Görevi verme event
event1				=2472 -- Görev açma
event2				=2473 -- Görev kabul etme
event3				=2475 -- Görev bittimi kontrolü uzak
event4				=2476 -- Görev bittimi kontrolü npc
event5				=2477 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

---------- Raven Harpy 1- Quest 
--------------------------------------


savenum				=1082
talknum				=11406
exchangeid			=1384
moncount			=30 	  -- Yaratık sayısı
accept				=4581 -- Görevi al
iscomplate			=4583 -- Görevi kontrol et
complate			=4582 -- Görevi verme event
event1				=2492 -- Görev açma
event2				=2493 -- Görev kabul etme
event3				=2495 -- Görev bittimi kontrolü uzak
event4				=2496 -- Görev bittimi kontrolü npc
event5				=2497 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end


---------- Falcon 1- Quest 
--------------------------------------


savenum				=1086
talknum				=11410
exchangeid			=1386
moncount			=30 	  -- Yaratık sayısı
accept				=4601 -- Görevi al
iscomplate			=4603 -- Görevi kontrol et
complate			=4602 -- Görevi verme event
event1				=2512 -- Görev açma
event2				=2513 -- Görev kabul etme
event3				=2515 -- Görev bittimi kontrolü uzak
event4				=2516 -- Görev bittimi kontrolü npc
event5				=2517 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

local savenum=1090
local talknum=11414
local exchangeid=1388 --1388

if (EVENT == 2532) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 2533, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 2533) then
	SaveEvent(UID, 4621);
end

if (EVENT == 2535) then
	ITEMA  = HowmuchItem(UID, 810294000);--810294000
	if(ITEMA > 9) then
		SaveEvent(UID, 4623)
	end	
end

if (EVENT == 2536) then
	ITEMA  = HowmuchItem(UID, 810294000);--810294000
	if(ITEMA > 9) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 2534, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if (EVENT == 2534)then
		RunExchange(UID, exchangeid)
	SaveEvent(UID, 4622)
end

local savenum=1092
local talknum=11417
local exchangeid=1389

if (EVENT == 2542) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 2543, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 2543) then
	SaveEvent(UID, 4631);
end

if (EVENT == 2545) then
	ITEMA  = HowmuchItem(UID, 810295000);
	if(ITEMA > 9) then
		SaveEvent(UID, 4633)
	end	
end

if (EVENT == 2546) then
ITEMA  = HowmuchItem(UID, 810295000);
	if(ITEMA > 9) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 2544, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 2544)then
RunExchange(UID, exchangeid)
	SaveEvent(UID,4632)
end

---------------Acolty Evidence----------
----------------------------------------------

local savenum=1094
local talknum=11421
local exchangeid=1390

if (EVENT == 2552) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 2553, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 2553) then
	SaveEvent(UID, 4641);
end

if (EVENT == 2555) then
	ITEMA  = HowmuchItem(UID, 810296000);
	if(ITEMA > 19) then
		SaveEvent(UID, 4643)
	end	
end

if (EVENT == 2556) then
ITEMA  = HowmuchItem(UID, 810296000);
	if(ITEMA > 19) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 2554, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 2554)then
RunExchange(UID, exchangeid)
	SaveEvent(UID,4642)
end

---------------Giants Bone----------
----------------------------------------------

local savenum=1096
local talknum=11425
local exchangeid=1391

if (EVENT == 2562) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 2563, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 2563) then
	SaveEvent(UID, 4651);
end

if (EVENT == 2565) then
	ITEMA  = HowmuchItem(UID, 810297000);
	if(ITEMA > 19) then
		SaveEvent(UID, 4653)
	end	
end

if (EVENT == 2566) then
ITEMA  = HowmuchItem(UID, 810297000);
	if(ITEMA > 19) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 2564, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 2564)then
	RunExchange(UID, exchangeid)
	SaveEvent(UID,4652)
end

---------------Skin Harder Stone----------
----------------------------------------------

local savenum=1098
local talknum=11429
local exchangeid=1392

if (EVENT == 2572) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 2573, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 2573) then
	SaveEvent(UID, 4661);
end

if (EVENT == 2575) then
	ITEMA  = HowmuchItem(UID, 810298000);
	if(ITEMA > 19) then
		SaveEvent(UID, 4663)
	end	
end

if (EVENT == 2576) then
ITEMA  = HowmuchItem(UID, 810298000);
	if(ITEMA > 19) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 2574, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 2574)then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID, exchangeid, 1)
	else
		RunExchange(UID, exchangeid, 1)
	end
	SaveEvent(UID,4662)
end

local savenum=1100
local talknum=11433
local exchangeid=1393

if (EVENT == 2582) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 2583, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 2583) then
	SaveEvent(UID, 4671);
end

if (EVENT == 2585) then
	ITEMA  = HowmuchItem(UID, 810299000);
	if(ITEMA > 19) then
		SaveEvent(UID, 4673)
	end	
end

if (EVENT == 2586) then
ITEMA  = HowmuchItem(UID, 810299000);
	if(ITEMA > 19) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 2584, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 2584)then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID, exchangeid)
	else
		RunExchange(UID, exchangeid)
	end
	SaveEvent(UID,4672)
end

local savenum=1102
local talknum=11437
local exchangeid=1394

if (EVENT == 2592) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 2593, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 2593) then
	SaveEvent(UID, 4681);
end

if (EVENT == 2595) then
	ITEMA  = HowmuchItem(UID, 810301000);
	if(ITEMA > 19) then
		SaveEvent(UID, 4683)
	end	
end

if (EVENT == 2596) then
ITEMA  = HowmuchItem(UID, 810301000);
	if(ITEMA > 19) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 2594, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 2594)then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID, exchangeid)
	else
		RunExchange(UID, exchangeid)
	end
	SaveEvent(UID,4682)
end

local savenum=1104
local talknum=11441
local exchangeid=1395

if (EVENT == 2602) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 2603, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 2603) then
	SaveEvent(UID, 4691);
end

if (EVENT == 2605) then
	ITEMA  = HowmuchItem(UID, 810302000);
	if(ITEMA > 0) then
		SaveEvent(UID, 4693)
	end	
end

if (EVENT == 2606) then
ITEMA  = HowmuchItem(UID, 810302000);
	if(ITEMA > 0) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 2604, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 2604)then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID, exchangeid)
	else
		RunExchange(UID, exchangeid)
	end
	SaveEvent(UID,4692)
end

local savenum=1106
local talknum=11444
local exchangeid=1396

if (EVENT == 2612) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 2613, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 2613) then
	SaveEvent(UID, 4701);
end

if (EVENT == 2615) then
	ITEMA  = HowmuchItem(UID, 810303000);
	if(ITEMA > 19) then
		SaveEvent(UID, 4703)
	end	
end

if (EVENT == 2616) then
ITEMA  = HowmuchItem(UID, 810303000);
	if(ITEMA > 19) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 2614, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 2614)then
		Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID, exchangeid)
	else
		RunExchange(UID, exchangeid)
	end
	SaveEvent(UID,4702)
end

local savenum=1034
local talknum=11339
local exchangeid=1360

if (EVENT == 2252) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 2253, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 2253) then
	SaveEvent(UID, 5833);
end

if (EVENT == 2255) then
	MonsterCount01 = QuestMonsterCount(UID, savenum, 1);
	if(MonsterCount01 > 19) then
		SaveEvent(UID, 5835)
	end	
end

if (EVENT == 2256) then
MonsterCount01 = QuestMonsterCount(UID, savenum, 1);
	if(MonsterCount01 > 19) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 2254, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 2254)then
	RunExchange(UID, exchangeid)
	SaveEvent(UID,5834)
end

local savenum=1038
local talknum=11345
local exchangeid=1362

if (EVENT == 2272) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 2273, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 2273) then
	SaveEvent(UID, 5853);
end

if (EVENT == 2275) then
	MonsterCount01 = QuestMonsterCount(UID, savenum, 1);
	if(MonsterCount01 > 19) then
		SaveEvent(UID, 5855)
	end	
end

if (EVENT == 2276) then
MonsterCount01 = QuestMonsterCount(UID, savenum, 1);
	if(MonsterCount01 > 19) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 2274, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 2274)then
	RunExchange(UID, exchangeid)
	SaveEvent(UID,5854)
end

------- Apostle Quest - 1 
------------------------------------

local savenum			=1042 			-- Event kayıt numarası
local talknum			=11351 			-- mesaj 
local moncount			=20 				-- Yaratık sayısı
local exchangeid		=1364 			-- Hediye
local accept			=5873 			-- Görevi al
local iscomplate		=5875 			-- Görevi kontrol et
local complate			=5874 			-- Görevi verme event
local event1			=2292 			-- Görev açma
local event2			=2293 			-- Görev kabul etme
local event3			=2295 			-- Görev bittimi kontrolü uzak
local event4			=2296 			-- Görev bittimi kontrolü npc
local event5			=2298 			-- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 4, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end


-------------------------------------------------------------------


local savenum=1046
local talknum=11357
local moncount=40
local exchangeid=1366
local accept=5893
local iscomplate=5895
local complate=5894
local event1=2312 -- Görev açma
local event2=2313 -- Görev kabul etme
local event3=2315 -- Görev bittimi kontrolü uzak
local event4=2316 -- Görev bittimi kontrolü npc
local event5=2318 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 4, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end


---------- Half troll busucker 1 - Quest 
--------------------------------------


local savenum				=1050
local talknum				=11364
local exchangeid			=1368
local moncount				=40 	  -- Yaratık sayısı
local accept				=5913 -- Görevi al
local iscomplate			=5915 -- Görevi kontrol et
local complate				=5914 -- Görevi verme event
local event1				=2332 -- Görev açma
local event2				=2333 -- Görev kabul etme
local event3				=2335 -- Görev bittimi kontrolü uzak
local event4				=2336 -- Görev bittimi kontrolü npc
local event5				=2337 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

--------------------------------------


local savenum				=1054
local talknum				=11371
local exchangeid			=1370
local moncount				=40 	  -- Yaratık sayısı
local accept				=5933 -- Görevi al
local iscomplate			=5935 -- Görevi kontrol et
local complate				=5934 -- Görevi verme event
local event1				=2352 -- Görev açma
local event2				=2353 -- Görev kabul etme
local event3				=2355 -- Görev bittimi kontrolü uzak
local event4				=2356 -- Görev bittimi kontrolü npc
local event5				=2357 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

--------------------------------------


savenum				=1058
talknum				=11378
exchangeid			=1372
moncount			=40 	  -- Yaratık sayısı
accept				=5953 -- Görevi al
iscomplate			=5955 -- Görevi kontrol et
complate			=5954 -- Görevi verme event
event1				=2372 -- Görev açma
event2				=2373 -- Görev kabul etme
event3				=2375 -- Görev bittimi kontrolü uzak
event4				=2376 -- Görev bittimi kontrolü npc
event5				=2377 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

savenum				=1062
talknum				=11382
exchangeid			=1374
moncount			=25 	  -- Yaratık sayısı
accept				=5973 -- Görevi al
iscomplate			=5975 -- Görevi kontrol et
complate			=5974 -- Görevi verme event
event1				=2392 -- Görev açma
event2				=2393 -- Görev kabul etme
event3				=2395 -- Görev bittimi kontrolü uzak
event4				=2396 -- Görev bittimi kontrolü npc
event5				=2397 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

savenum				=1068
talknum				=11390
exchangeid			=1377
moncount			=25 	  -- Yaratık sayısı
accept				=4511 -- Görevi al
iscomplate			=4513 -- Görevi kontrol et
complate			=4512 -- Görevi verme event
event1				=2422 -- Görev açma
event2				=2423 -- Görev kabul etme
event3				=2425 -- Görev bittimi kontrolü uzak
event4				=2426 -- Görev bittimi kontrolü npc
event5				=2427 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

savenum				=1072
talknum				=11394
exchangeid			=1379
moncount			=25 	  -- Yaratık sayısı
accept				=4531 -- Görevi al
iscomplate			=4533 -- Görevi kontrol et
complate			=4532 -- Görevi verme event
event1				=2442 -- Görev açma
event2				=2443 -- Görev kabul etme
event3				=2445 -- Görev bittimi kontrolü uzak
event4				=2446 -- Görev bittimi kontrolü npc
event5				=2447 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

savenum				=1076
talknum				=11399
exchangeid			=1381
moncount			=30 	  -- Yaratık sayısı
accept				=4551 -- Görevi al
iscomplate			=4553 -- Görevi kontrol et
complate			=4552 -- Görevi verme event
event1				=2462 -- Görev açma
event2				=2463 -- Görev kabul etme
event3				=2465 -- Görev bittimi kontrolü uzak
event4				=2466 -- Görev bittimi kontrolü npc
event5				=2467 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

-------------------------------------------------
local savenum=1080
local talknum=11404
local exchangeid=1383

if (EVENT == 2482) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 2483, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 2483) then
	SaveEvent(UID, 4571);
end

if (EVENT == 2485) then
	MonsterCount01 = QuestMonsterCount(UID, savenum, 1);
	if(MonsterCount01 > 29) then
		SaveEvent(UID, 4573)
	end	
end

if (EVENT == 2486) then
MonsterCount01 = QuestMonsterCount(UID, savenum, 1);
	if(MonsterCount01 > 29) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 2484, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 2484)then
	RunExchange(UID, exchangeid)
	SaveEvent(UID,4572)
end

local savenum=1084
local talknum=11408
local exchangeid=1385

if (EVENT == 2502) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 2503, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 2503) then
	SaveEvent(UID, 4591);
end

if (EVENT == 2505) then
	MonsterCount01 = QuestMonsterCount(UID, savenum, 1);
	if(MonsterCount01 > 29) then
		SaveEvent(UID, 4593)
	end	
end

if (EVENT == 2506) then
MonsterCount01 = QuestMonsterCount(UID, savenum, 1);
	if(MonsterCount01 > 29) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 2504, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 2504)then
	RunExchange(UID, exchangeid)
	SaveEvent(UID,4592)
end

local savenum=1088
local talknum=11412
local exchangeid=1387

if (EVENT == 2522) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 2523, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 2523) then
	SaveEvent(UID, 4611);
end

if (EVENT == 2525) then
	MonsterCount01 = QuestMonsterCount(UID, savenum, 1);
	if(MonsterCount01 > 29) then
		SaveEvent(UID, 4613)
	end	
end

if (EVENT == 2526) then
MonsterCount01 = QuestMonsterCount(UID, savenum, 1);
	if(MonsterCount01 > 29) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 2524, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 2524)then
	RunExchange(UID, exchangeid)
	SaveEvent(UID,4612)
end

local savenum=1036
local talknum=11343
local exchangeid=1361
local moncount=20 -- Yaratık sayısı
local accept=5843 -- Görevi al
local iscomplate=5845 -- Görevi kontrol et
local complate=5844 -- Görevi verme event
local event1=2262 -- Görev açma
local event2=2263 -- Görev kabul etme
local event3=2265 -- Görev bittimi kontrolü uzak
local event4=2266 -- Görev bittimi kontrolü npc
local event5=2267 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

local savenum=1108
local talknum=11447
local exchangeid=1397

if (EVENT == 2622) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, 2623, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end
	
if (EVENT == 2623) then
	SaveEvent(UID, 4711);
end

if (EVENT == 2625) then
	ITEMA  = HowmuchItem(UID, 810304000);
	if(ITEMA > 19) then
		SaveEvent(UID, 4713)
	end	
end

if (EVENT == 2626) then
ITEMA  = HowmuchItem(UID, 810304000);
	if(ITEMA > 19) then
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, 2624, 27, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 217);
	end
end

if (EVENT == 2624)then
	Prem = GetPremium(UID);
	if (Prem > 0) then
		RunExchange(UID, exchangeid)
	else
		RunExchange(UID, exchangeid)
	end
	SaveEvent(UID,4712)
end


local savenum=1007
local talknum=8772
local exchangeid=1300
local moncount=20 -- Yaratık sayısı
local accept=5702 -- Görevi al
local iscomplate=5704 -- Görevi kontrol et
local complate=5703 -- Görevi verme event
local event1=8542 -- Görev açma
local event2=8543 -- Görev kabul etme
local event3=8546 -- Görev bittimi kontrolü uzak
local event4=8547 -- Görev bittimi kontrolü npc
local event5=8548 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end


local savenum				=1009
local talknum				=8686
local exchangeid			=1302
local moncount				=40 	  -- Yaratık sayısı
local accept				=5714 -- Görevi al
local iscomplate			=5716 -- Görevi kontrol et
local complate				=5715 -- Görevi verme event
local event1				=8372 -- Görev açma
local event2				=8373 -- Görev kabul etme
local event3				=8376 -- Görev bittimi kontrolü uzak
local event4				=8377 -- Görev bittimi kontrolü npc
local event5				=8378 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end


savenum				=1011
talknum				=8688
exchangeid			=1304
moncount			=40	  -- Yaratık sayısı
accept				=5726 -- Görevi al
iscomplate			=5728 -- Görevi kontrol et
complate			=5727 -- Görevi verme event
event1				=8382 -- Görev açma
event2				=8383 -- Görev kabul etme
event3				=8386 -- Görev bittimi kontrolü uzak
event4				=8387 -- Görev bittimi kontrolü npc
event5				=8388 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end


savenum				=1013
talknum				=8690
exchangeid			=1306
moncount			=7 	  -- Yaratık sayısı
accept				=5738 -- Görevi al
iscomplate			=5740 -- Görevi kontrol et
complate			=5739 -- Görevi verme event
event1				=8392 -- Görev açma
event2				=8393 -- Görev kabul etme
event3				=8396 -- Görev bittimi kontrolü uzak
event4				=8397 -- Görev bittimi kontrolü npc
event5				=8398 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

savenum				=1015
talknum				=8694
exchangeid			=1308
moncount			=40 	  -- Yaratık sayısı
accept				=5750 -- Görevi al
iscomplate			=5752 -- Görevi kontrol et
complate			=5751 -- Görevi verme event
event1				=8412 -- Görev açma
event2				=8413 -- Görev kabul etme
event3				=8416 -- Görev bittimi kontrolü uzak
event4				=8417 -- Görev bittimi kontrolü npc
event5				=8418 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

local savenum=1040
local talknum=11349
local exchangeid=1363
local moncount=20 -- Yaratık sayısı
local accept=5863 -- Görevi al
local iscomplate=5865 -- Görevi kontrol et
local complate=5864 -- Görevi verme event
local event1=2282 -- Görev açma
local event2=2283 -- Görev kabul etme
local event3=2285 -- Görev bittimi kontrolü uzak
local event4=2286 -- Görev bittimi kontrolü npc
local event5=2287 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

local savenum=1044
local talknum=11355
local exchangeid=1365
local moncount=20 -- Yaratık sayısı
local accept=5883 -- Görevi al
local iscomplate=5885 -- Görevi kontrol et
local complate=5884 -- Görevi verme event
local event1=2302 -- Görev açma
local event2=2303 -- Görev kabul etme
local event3=2305 -- Görev bittimi kontrolü uzak
local event4=2306 -- Görev bittimi kontrolü npc
local event5=2307 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

local savenum				=1048
local talknum				=11360
local exchangeid			=1367
local moncount				=40 	  -- Yaratık sayısı
local accept				=5903 -- Görevi al
local iscomplate			=5905 -- Görevi kontrol et
local complate				=5904 -- Görevi verme event
local event1				=2322 -- Görev açma
local event2				=2323 -- Görev kabul etme
local event3				=2325 -- Görev bittimi kontrolü uzak
local event4				=2326 -- Görev bittimi kontrolü npc
local event5				=2327 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

savenum				=1052
talknum				=11368
exchangeid			=1369
moncount			=40 	  -- Yaratık sayısı
accept				=5923 -- Görevi al
iscomplate			=5925 -- Görevi kontrol et
complate			=5924 -- Görevi verme event
event1				=2342 -- Görev açma
event2				=2343 -- Görev kabul etme
event3				=2345 -- Görev bittimi kontrolü uzak
event4				=2346 -- Görev bittimi kontrolü npc
event5				=2347 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

savenum				=1056
talknum				=11375
exchangeid			=1371
moncount			=40 	  -- Yaratık sayısı
accept				=5943 -- Görevi al
iscomplate			=5945 -- Görevi kontrol et
complate			=5944 -- Görevi verme event
event1				=2362 -- Görev açma
event2				=2363 -- Görev kabul etme
event3				=2365 -- Görev bittimi kontrolü uzak
event4				=2366 -- Görev bittimi kontrolü npc
event5				=2367 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end



savenum				=1060
talknum				=11380
exchangeid			=1373
moncount			=40	  -- Yaratık sayısı
accept				=5963 -- Görevi al
iscomplate			=5965 -- Görevi kontrol et
complate			=5964 -- Görevi verme event
event1				=2382 -- Görev açma
event2				=2383 -- Görev kabul etme
event3				=2385 -- Görev bittimi kontrolü uzak
event4				=2386 -- Görev bittimi kontrolü npc
event5				=2387 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end

savenum				=1064
talknum				=11384
exchangeid			=1375
moncount			=25 	  -- Yaratık sayısı
accept				=5983 -- Görevi al
iscomplate			=5985 -- Görevi kontrol et
complate			=5984 -- Görevi verme event
event1				=2402 -- Görev açma
event2				=2403 -- Görev kabul etme
event3				=2405 -- Görev bittimi kontrolü uzak
event4				=2406 -- Görev bittimi kontrolü npc
event5				=2407 -- Görev hediyelerini ver

if(EVENT == event1) then
	MonsterSub = ExistMonsterQuestSub(UID);
	if (MonsterSub == 0) then
		SelectMsg(UID, 4, savenum, talknum, NPC, 22, event2, 23, 193);
	else
		SelectMsg(UID, 2, savenum, talknum, NPC, 10, 193);
	end
end

if(EVENT == event2) then
	SaveEvent(UID, accept)
end

if(EVENT == event3) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount ==	moncount) then
		SaveEvent(UID, iscomplate)
	end
end

if(EVENT == event4) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount < moncount) then
		SelectMsg(UID, 2, savenum, talknum, NPC, 18, 193);
	else
		SelectMsg(UID, 5, savenum, talknum, NPC, 41, event5, 27, 193);
	end
end

if(EVENT == event5) then
	MonsterCount = QuestMonsterCount(UID, savenum, 1);
	if (MonsterCount >= moncount) then
		RunExchange(UID, exchangeid)
		SaveEvent(UID, complate)
	end
end