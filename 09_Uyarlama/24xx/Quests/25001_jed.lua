-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
-- Completion guards use this SQL snapshot and the native 2083 API.
local __KO_Stop = {}
local __KO_Save = SaveEvent
local __KO_Run = RunExchange
local __KO_Select = RunSelectExchange
local __KO_Done = {}
local __KO_Committed = {}
local __KO_Requirements = {
  [6006]={{900599000,1}},
  [6007]={{900005000,1211}},
  [6008]={{900632000,1},{900631000,1}},
  [6009]={{810418000,4}},
  [6010]={{900005000,1216}},
  [6011]={{810418000,2}},
  [6012]={{900615000,1}},
  [6013]={{810418000,4}},
  [6014]={{900005000,1220}},
  [6015]={{810418000,2}},
  [6016]={{900608000,1}},
  [6017]={},
  [6020]={{900609000,1}},
  [6021]={{810418000,3},{900678000,1}},
  [6022]={},
  [6023]={{900005000,1229}},
  [6024]={},
  [6026]={{900614000,1}},
}
local __KO_Completion = {
  [7369]={1210,6006},
  [7375]={1211,6007},
  [7393]={1214,6008},
  [7399]={1215,6009},
  [7405]={1216,6010},
  [7411]={1217,6011},
  [7417]={1218,6012},
  [7423]={1219,6013},
  [7429]={1220,6014},
  [7435]={1221,6015},
  [7441]={1222,6016},
  [7447]={1223,6017},
  [7465]={1226,6020},
  [7471]={1227,6021},
  [7477]={1228,6022},
  [7483]={1229,6023},
  [7489]={1230,6024},
  [7495]={1231,6026},
}
local __KO_Quests = {
  [6006]={1210},
  [6007]={1211},
  [6008]={1214},
  [6009]={1215},
  [6010]={1216},
  [6011]={1217},
  [6012]={1218},
  [6013]={1219},
  [6014]={1220},
  [6015]={1221},
  [6016]={1222},
  [6017]={1223},
  [6020]={1226},
  [6021]={1227},
  [6022]={1228},
  [6023]={1229},
  [6024]={1230},
  [6026]={1231},
}
local function __KO_Ready(uid, exchange)
  if not CheckExchange(uid, exchange) then return false end
  local required = __KO_Requirements[exchange]
  if required == nil then return false end
  for _, pair in ipairs(required) do
    if HowmuchItem(uid, pair[1]) < pair[2] then return false end
  end
  return true
end
local function __KO_AlreadyComplete(uid, exchange)
  local quests = __KO_Quests[exchange]
  if quests == nil then return false end
  local completed = false
  for _, quest in ipairs(quests) do
    if CheckExistEvent(uid, quest, 1) or CheckExistEvent(uid, quest, 3) or CheckExistEvent(uid, quest, 4) then return false end
    if CheckExistEvent(uid, quest, 2) and not __KO_Committed[quest] then completed = true end
  end
  return completed
end
local function RunExchange(uid, exchange)
  if __KO_AlreadyComplete(uid, exchange) and not __KO_Done[exchange] then error(__KO_Stop) end
  if __KO_Done[exchange] and __KO_Quests[exchange] ~= nil then return true end
  if not __KO_Ready(uid, exchange) then error(__KO_Stop) end
  local ok = __KO_Run(uid, exchange)
  if not ok then error(__KO_Stop) end
  __KO_Done[exchange] = true
  return true
end
local function RunSelectExchange(uid, exchange)
  if __KO_AlreadyComplete(uid, exchange) and not __KO_Done[exchange] then error(__KO_Stop) end
  if __KO_Done[exchange] and __KO_Quests[exchange] ~= nil then return true end
  if not __KO_Ready(uid, exchange) then error(__KO_Stop) end
  local ok = __KO_Select(uid, exchange)
  if not ok then error(__KO_Stop) end
  __KO_Done[exchange] = true
  return true
end
local function SaveEvent(uid, helper)
  local completing = __KO_Completion[helper]
  if completing ~= nil then
    if CheckExistEvent(uid, completing[1], 2) then error(__KO_Stop) end
    if completing[2] > 0 and not __KO_Done[completing[2]] and not __KO_Ready(uid, completing[2]) then error(__KO_Stop) end
  end
  __KO_Save(uid, helper)
  if completing ~= nil then __KO_Committed[completing[1]] = true end
end
local __KO_OK, __KO_Error = pcall(function()
local function GetQuestStatus(uid, quest)
  for state=0,4 do
    if CheckExistEvent(uid, quest, state) then return state end
  end
  if CheckExistEvent(uid, quest, 255) then return 255 end
  return 0
end
local NPC = 25001;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 43651, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 43651, NPC)
	else
		EVENT = QuestNum
	end
end

if(EVENT == 110) then
	SelectMsg(UID, 2, 1210, 43650, NPC, 40151, 111,3019,-1);
end

if (EVENT == 111) then
	REQUEST = HowmuchItem(UID, 900599000);
	if (REQUEST < 1) then
		SelectMsg(UID, 2, 1210, 43650, NPC, 19, 113);
	else
		SelectMsg(UID, 4, 1210, 43650, NPC, 65, 116, 27, -1);
	end
end

if(EVENT == 114) then
	SaveEvent(UID, 7370);
end

if(EVENT == 113) then
	ShowMap(UID, 1187);
end

if(EVENT == 116) then
	RunExchange(UID, 6006);
	SaveEvent(UID, 7369)
end

if(EVENT == 122) then
	SelectMsg(UID, 2, 1211, 43654, NPC, 40152, 123);
end

if(EVENT == 123) then
	SelectMsg(UID, 4, 1211, 43668, NPC, 22, 124,23,-1);
end

if(EVENT == 124) then
	SaveEvent(UID, 7374)
end

if(EVENT == 127) then
	SaveEvent(UID, 7376)
end

if(EVENT == 125) then
	MonsterCount  = CountMonsterQuestSub(UID, 1211, 1);
	if (MonsterCount < 2) then
		SelectMsg(UID, 2, 1211, 8267, NPC, 18, 129);
	else
		SelectMsg(UID, 4, 1211, 8268, NPC, 41, 130, 27, 158);
	end
end

if(EVENT == 129) then
	ShowMap(UID, 1198)
end

if(EVENT == 130) then
	RunExchange(UID, 6007);
	SaveEvent(UID, 7375)
end

if(EVENT == 132) then
	SelectMsg(UID, 2, 1214, 43676, NPC, 40157, 133);
end

if(EVENT == 133) then
	SaveEvent(UID, 7392)
end

if(EVENT == 137) then
	SaveEvent(UID, 7394)
end

if (EVENT == 135) then
	CONTTA = HowmuchItem(UID, 900632000);
	CONTTB = HowmuchItem(UID, 900631000);
	if (CONTTA < 1 and CONTTB < 1) then
		SelectMsg(UID, 2, 1214, 43676, NPC, 19, 136);
	else
		SelectMsg(UID, 2, 1214, 43677, NPC, 10, 138);
	end
end

if(EVENT == 136) then
	ShowMap(UID, 1198)
end

if(EVENT == 138) then
	RunExchange(UID, 6008);
	SaveEvent(UID, 7393)
end

if(EVENT == 142) then
	SelectMsg(UID, 2, 1215, 43686, NPC, 8259, 143);
end

if(EVENT == 143) then
	SelectMsg(UID, 2, 1215, 43687, NPC, 40265, 144);
end

if(EVENT == 144) then
	SaveEvent(UID, 7398)
end

if(EVENT == 147) then
	SaveEvent(UID, 7400)
end

if (EVENT == 145) then
	CONTTA = HowmuchItem(UID, 810418000);
	if (CONTTA < 4) then
		SelectMsg(UID, 2, 1215, 43691, NPC, 19, 146);
	else
		SelectMsg(UID, 4, 1215, 43691, NPC, 10, 148,20,-1);
	end
end

if(EVENT == 146) then
	ShowMap(UID, 567)
end

if(EVENT == 148) then
	RunExchange(UID, 6009);
	SaveEvent(UID, 7399)
end

if(EVENT == 152) then
	SelectMsg(UID, 2, 1216, 43693, NPC, 40157, 153);
end

if(EVENT == 153) then
	SaveEvent(UID, 7404)
end

if(EVENT == 157) then
	SaveEvent(UID, 7406)
end

if(EVENT == 155) then
	MonsterCount  = CountMonsterQuestSub(UID, 1216, 1);
	if (MonsterCount < 10) then
		SelectMsg(UID, 2, 1216, 43695, NPC, 18, 156);
	else
		SelectMsg(UID, 4, 1216, 43695, NPC, 41, 158, 27, 158);
	end
end

if(EVENT == 156) then
	ShowMap(UID, 1253)
end

if(EVENT == 158) then
	RunExchange(UID, 6010);
	SaveEvent(UID, 7405)
end


if(EVENT == 162) then
	SelectMsg(UID, 2, 1217, 43696, NPC, 40157, 163);
end

if(EVENT == 163) then
	SaveEvent(UID, 7410)
end

if(EVENT == 167) then
	SaveEvent(UID, 7412)
end

if (EVENT == 165) then
	CONTTA = HowmuchItem(UID, 810418000);
	if (CONTTA < 2) then
		SelectMsg(UID, 2, 1217, 43698, NPC, 19, 166);
	else
		SelectMsg(UID, 4, 1217, 43698, NPC, 10, 168,20,-1);
	end
end

if(EVENT == 166) then
	ShowMap(UID, 1253)
end

if(EVENT == 168) then
	RunExchange(UID, 6011);
	SaveEvent(UID, 7411)
end

if(EVENT == 172) then
	SelectMsg(UID, 2, 1218, 43699, NPC, 40157, 173);
end

if(EVENT == 173) then
	SaveEvent(UID, 7416)
end

if(EVENT == 177) then
	SaveEvent(UID, 7418)
end

if (EVENT == 175) then
	CONTTA = HowmuchItem(UID, 900615000);
	if (CONTTA < 1) then
		SelectMsg(UID, 2, 1218, 43701, NPC, 19, 176);
	else
		SelectMsg(UID, 4, 1218, 43701, NPC, 10, 178,20,-1);
	end
end

if(EVENT == 176) then
	ShowMap(UID, 1256)
end

if(EVENT == 178) then
	RunExchange(UID, 6012);
	SaveEvent(UID, 7417)
end

if(EVENT == 192) then
	SelectMsg(UID, 2, 1220, 43705, NPC, 40174, 193);
end

if(EVENT == 193) then
	SelectMsg(UID, 2, 1220, 43706, NPC, 40157, 194);
end

if(EVENT == 194) then
	SaveEvent(UID, 7428)
end

if(EVENT == 197) then
	SaveEvent(UID, 7430)
end

if (EVENT == 195) then
	MonsterCount01 = CountMonsterQuestSub(UID, 1220, 1);
	MonsterCount02 = CountMonsterQuestSub(UID, 1220, 2);
	MonsterCount03 = CountMonsterQuestSub(UID, 1220, 3);
	MonsterCount04 = CountMonsterQuestSub(UID, 1220, 4);
	if (MonsterCount01 > 2 and MonsterCount02 > 2 and MonsterCount03 > 2 and MonsterCount04 > 2) then 
	SelectMsg(UID, 4, 1220, 43708, NPC, 10, 196, 27, -1);
	else
		if (MonsterCount01 < 3) then
			SelectMsg(UID, 2, 1220, 43706, NPC, 18, 198);
		elseif ( MonsterCount02 < 3) then
			SelectMsg(UID, 2, 1220, 43706, NPC, 18, 199);
		elseif ( MonsterCount03 < 3) then
			SelectMsg(UID, 2, 1220, 43706, NPC, 18, 200);
		elseif ( MonsterCount04 < 3) then
			SelectMsg(UID, 2, 1220, 43706, NPC, 18, 201);
		end
	end
end
	
if(EVENT == 198) then
	ShowMap(UID, 580);
end

if(EVENT == 199) then
	ShowMap(UID, 576);
end

if(EVENT == 200) then
	ShowMap(UID, 572);
end

if(EVENT == 201) then
	ShowMap(UID, 523);
end

if(EVENT == 196) then
	RunExchange(UID, 6014);
	SaveEvent(UID, 7429);
end

if(EVENT == 202) then
	SelectMsg(UID, 2, 1221, 43710, NPC, 40175, 203);
end

if(EVENT == 203) then
	SelectMsg(UID, 2, 1221, 43711, NPC, 40176, 204);
end

if(EVENT == 204) then
	SelectMsg(UID, 2, 1221, 43712, NPC, 40177, 208);
end

if(EVENT == 208) then
	SelectMsg(UID, 2, 1221, 43713, NPC, 40178, 206,40179,-1);
end

if(EVENT == 206) then
	SaveEvent(UID, 7434);
end

if(EVENT == 207) then
	SaveEvent(UID, 7436);
end

if(EVENT == 205) then
	CountA = HowmuchItem(UID, 810418000)
	if( CountA < 2) then
		SelectMsg(UID, 2, 1221, 43715, NPC, 18, -1);
	else
		SelectMsg(UID, 4, 1221, 43715, NPC, 41, 209, 27, -1);
	end
end

if(EVENT == 209) then
	RunExchange(UID, 6015);
	SaveEvent(UID, 7435);
end

if(EVENT == 212) then
	SelectMsg(UID, 2, 1222, 43716, NPC, 40181, 213,40182,-1);
end

if(EVENT == 213) then
	SelectMsg(UID, 2, 1222, 43717, NPC, 40183, -1);
	SaveEvent(UID, 7440);
end

if(EVENT == 214) then
	SaveEvent(UID, 7443);
end

if(EVENT == 217) then
	SaveEvent(UID, 7442);
end

if(EVENT == 215) then
	CountA = HowmuchItem(UID, 900608000)
	if( CountA < 1) then
		SelectMsg(UID, 2, 1222, 43718, NPC, 18,-1);
	else
		SelectMsg(UID, 4, 1222, 43718, NPC, 41, 216, 27, -1);
	end
end

if(EVENT == 216) then
	RunExchange(UID, 6016);
	SaveEvent(UID, 7441);
end

if(EVENT == 222) then
	SelectMsg(UID, 2, 1223, 43719, NPC, 40320, 223);
end

if(EVENT == 223) then
	SelectMsg(UID, 2, 1223, 43720, NPC, 40192, 224,40193,-1);
end

if(EVENT == 224) then
	SelectMsg(UID, 2, 1223, 43721, NPC, 40142,-1);
	SaveEvent(UID, 7446);
end

if(EVENT == 225) then
	QuestStatusCheck = GetQuestStatus(UID, 1223)	
	if(QuestStatusCheck == 1) then
	SelectMsg(UID, 2, 1223, 43721, NPC, 40142,-1);
		else
    SelectMsg(UID, 4, 1223, 43722, NPC, 10, 226,27,-1);
	end
end

if(EVENT == 226) then
	RunExchange(UID, 6017);
	SaveEvent(UID, 7447);
end

if(EVENT == 232) then
	SelectMsg(UID, 4, 1226, 43723, NPC, 22, 233,23,-1);
end

if(EVENT == 233) then
	SaveEvent(UID, 7464);
end

if(EVENT == 237) then
	SaveEvent(UID, 7466);
end

if(EVENT == 235) then
	CountA = HowmuchItem(UID, 900609000)
	if( CountA < 1) then
		SelectMsg(UID, 2, 1226, 43725, NPC, 18,236);
	else
		SelectMsg(UID, 4, 1226, 43725, NPC, 40185, 238, 23, -1);
	end
end

if (EVENT == 236) then
	ShowMap(UID, 1197);
end

if(EVENT == 238) then
SelectMsg(UID, 2, 1226, 44076, NPC, 10,-1);
	RunExchange(UID, 6020);
	SaveEvent(UID, 7465);
end

if(EVENT == 242) then
	SelectMsg(UID, 4, 1227, 43726, NPC, 8280, 243,23,-1);
end

if(EVENT == 243) then
	SaveEvent(UID, 7470);
end

if(EVENT == 247) then
	SaveEvent(UID, 7472);
end

if (EVENT == 245) then
	ITEMA  = HowmuchItem(UID, 810418000);
	ITEMB  = HowmuchItem(UID, 900678000);
	if(ITEMA > 2 and ITEMB > 0) then
		SelectMsg(UID, 4, 1227, 43728, NPC, 4452, 248, 27, -1);
	else
		SelectMsg(UID, 2, 1227, 43726, NPC, 10, 246);
	end
end

if (EVENT == 246) then
	ShowMap(UID, 22);
end

if(EVENT == 248) then
	RunExchange(UID, 6021);
	SaveEvent(UID, 7471);
end

if(EVENT == 252) then
		SelectMsg(UID, 2, 1228, 43729, NPC, 8280, 253);
end

if(EVENT == 253) then
	SelectMsg(UID, 2, 1228, 43730, NPC, 40186, -1);
	SaveEvent(UID, 7476);
	--SaveEvent(UID, 7478)
end

if(EVENT == 255) then
	QuestStatusCheck = GetQuestStatus(UID, 1228)	
	if(QuestStatusCheck == 1) then
		SelectMsg(UID, 2, 1228, 43730, NPC, 40186, -1);
	else
		SelectMsg(UID, 2, 1228, 43731, NPC, 40187, 256,27,-1);	
	end
end

if(EVENT == 256) then
	RunExchange(UID, 6022);
	SaveEvent(UID, 7477);
end

if(EVENT == 262) then
	SelectMsg(UID, 4, 1229, 43732, NPC, 22, 263,23,-1);
end

if(EVENT == 263) then
	SaveEvent(UID, 7482);
end

if(EVENT == 265) then
	MonsterCount  = CountMonsterQuestSub(UID, 1229, 1);
	if (MonsterCount < 1) then
		SelectMsg(UID, 2, 1229, 43734, NPC, 18, 266);
	else
		SelectMsg(UID, 4, 1229, 43734, NPC, 40189, 267, 22, -1);
	end
end

if (EVENT == 266) then
	ShowMap(UID, 1257);
end

if(EVENT == 267) then
	RunExchange(UID, 6023);
	SaveEvent(UID, 7483);
end

if(EVENT == 272) then
	SelectMsg(UID, 4, 1230, 43735, NPC, 65, 273,23,-1);
end

if(EVENT == 273) then
	RunExchange(UID, 6024);
	SaveEvent(UID, 7489);
end

if(EVENT == 182) then
	SelectMsg(UID, 2, 1219, 43702, NPC, 40157, 183);
end

if(EVENT == 183) then
	SaveEvent(UID, 7422);
end

if(EVENT == 187) then
	SaveEvent(UID, 7424);
end

if(EVENT == 185) then
	CountA = HowmuchItem(UID, 810418000)	
	if( CountA < 4) then
		SelectMsg(UID, 2, 1219, 43704, NPC, 18, 186);
	else
		SelectMsg(UID, 4, 1219, 43704, NPC, 4319, 188);
	end
end

if (EVENT == 186 ) then
	ShowMap(UID, 1);
end

if(EVENT == 188) then
	RunExchange(UID, 6013);
	SaveEvent(UID, 7423);
end

if(EVENT == 282) then
	SelectMsg(UID, 2, 1231, 43737, NPC, 40194, 283);
end

if(EVENT == 283) then
	SelectMsg(UID, 2, 1231, 43738, NPC, 40195, 284);
end

if(EVENT == 284) then
	SelectMsg(UID, 2, 1231, 43739, NPC, 8280, 286);
end

if(EVENT == 286) then
	SaveEvent(UID, 7494);

end

if(EVENT == 287) then
	SaveEvent(UID, 7496);
end

if(EVENT == 285) then
	CountA = HowmuchItem(UID, 900614000)	
	if( CountA < 1) then
		SelectMsg(UID, 2, 1231, 43739, NPC, 18, 288);
	else
		SelectMsg(UID, 2, 1231, 43741, NPC, 40196, 289);
	end
end

if (EVENT == 288 ) then
	ShowMap(UID, 1257);
end

if(EVENT == 289) then
	SaveEvent(UID, 7495);
	SaveEvent(UID, 7500);
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=1211 status=255 n_index=7372
if (EVENT == 120) then
	SaveEvent(UID, 7373);
end

-- [AUTO-GEN] quest=1215 status=255 n_index=7396
if (EVENT == 140) then
	SaveEvent(UID, 7397);
end

-- [AUTO-GEN] quest=1216 status=255 n_index=7402
if (EVENT == 150) then
	SaveEvent(UID, 7403);
end

-- [AUTO-GEN] quest=1217 status=255 n_index=7408
if (EVENT == 160) then
	SaveEvent(UID, 7409);
end

-- [AUTO-GEN] quest=1218 status=255 n_index=7414
if (EVENT == 170) then
	SaveEvent(UID, 7415);
end

-- [AUTO-GEN] quest=1219 status=255 n_index=7420
if (EVENT == 180) then
	SaveEvent(UID, 7421);
end

-- [AUTO-GEN] quest=1220 status=255 n_index=7426
if (EVENT == 190) then
	SearchQuest(UID, 25001);
end

-- [AUTO-GEN] quest=1222 status=255 n_index=7438
if (EVENT == 210) then
	SaveEvent(UID, 7439);
end

-- [AUTO-GEN] quest=1223 status=255 n_index=7444
if (EVENT == 220) then
	SaveEvent(UID, 7445);
end

-- [AUTO-GEN] quest=1226 status=255 n_index=7462
if (EVENT == 230) then
	SaveEvent(UID, 7463);
end

-- [AUTO-GEN] quest=1227 status=255 n_index=7468
if (EVENT == 240) then
	SaveEvent(UID, 7469);
end

-- [AUTO-GEN] quest=1228 status=255 n_index=7474
if (EVENT == 250) then
	SaveEvent(UID, 7475);
end

-- [AUTO-GEN] quest=1229 status=255 n_index=7480
if (EVENT == 260) then
	SaveEvent(UID, 7481);
end

-- [AUTO-GEN] quest=1230 status=255 n_index=7486
if (EVENT == 270) then
	SaveEvent(UID, 7487);
end

-- [AUTO-GEN] quest=1230 status=1 n_index=7488
if (EVENT == 275) then
	ItemA = HowmuchItem(UID, 900012000);
	if (ItemA < 0) then
		SelectMsg(UID, 2, 1230, 43735, NPC, 18, 276);
	else
		SelectMsg(UID, 4, 1230, 43735, NPC, 41, 277, 27, -1);
	end
end

-- [AUTO-GEN] quest=1230 status=1 n_index=7488
if (EVENT == 276) then
	ShowMap(UID, 21);
end

-- [AUTO-GEN] quest=1230 status=1 n_index=7488
if (EVENT == 277) then
	QuestStatusCheck = GetQuestStatus(UID, 1230)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		RunExchange(UID, 6024);
		SaveEvent(UID, 7489);
	end
end

-- [AUTO-GEN] quest=1231 status=255 n_index=7492
if (EVENT == 280) then
	SaveEvent(UID, 7493);
end


end)
if not __KO_OK and __KO_Error ~= __KO_Stop then error(__KO_Error) end
