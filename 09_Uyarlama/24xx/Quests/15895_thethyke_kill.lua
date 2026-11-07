-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-New
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 110 or EVENT == 113 or EVENT == 118 or EVENT == 120 or EVENT == 130 or EVENT == 133 or EVENT == 138 or EVENT == 140 or EVENT == 150 or EVENT == 153 or EVENT == 158 or EVENT == 160 then
  SelectMsg(UID, 2, -1, 10526, 15895, 10, -1)
  return
end
local NPC = 15895;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 723, NPC, 10, -1);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 723, NPC)
	else
		EVENT = QuestNum
	end
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 112) then
	SelectMsg(UID, 4, 1604, 723, NPC, 22, 113, 23, -1);
end

-- Unsupported EVENT branch is retained in the review copy.


-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 116) then
	MonsterCount = CountMonsterQuestSub(UID, 1604, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 1604, 723, NPC, 18, 117);
	else
		SelectMsg(UID, 4, 1604, 723, NPC, 22, 118, 23, -1);
	end
end

if (EVENT == 117) then
	ShowMap(UID, 488);
end

-- Unsupported EVENT branch is retained in the review copy.


--2.Wing Görevi 1000 Kills

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 132) then
	SelectMsg(UID, 4, 1605, 723, NPC, 22, 133, 23, -1);
end

-- Unsupported EVENT branch is retained in the review copy.


-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 136) then
	MonsterCount = CountMonsterQuestSub(UID, 1605, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 1605, 723, NPC, 18, 137);
	else
		SelectMsg(UID, 4, 1605, 723, NPC, 22, 138, 23, -1);
	end
end

if (EVENT == 137) then
	ShowMap(UID, 488);
end

-- Unsupported EVENT branch is retained in the review copy.


--3.Wing ve Pathos Görevi 3000 Kills

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 152) then
	SelectMsg(UID, 4, 1606, 723, NPC, 22, 153, 23, -1);
end

-- Unsupported EVENT branch is retained in the review copy.


-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 156) then
	MonsterCount = CountMonsterQuestSub(UID, 1606, 1);
	if (MonsterCount < 0) then
		SelectMsg(UID, 2, 1606, 723, NPC, 18, 157);
	else
		SelectMsg(UID, 4, 1606, 723, NPC, 22, 158, 23, -1);
	end
end

if (EVENT == 157) then
	ShowMap(UID, 489);
end

-- Unsupported EVENT branch is retained in the review copy.


-- SQL completed-state dialog exit; no reward or state mutation.
if EVENT == 153 then return end
