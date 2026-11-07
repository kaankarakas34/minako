-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 1000 or EVENT == 1003 or EVENT == 1004 or EVENT == 5000 or EVENT == 5005 or EVENT == 5006 or EVENT == 7000 or EVENT == 7005 or EVENT == 7006 then
  SelectMsg(UID, 2, -1, 10526, 29142, 10, -1)
  return
end
local NPC = 29142;
local Ret = 0;
-----------------------------------------------------
if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 723, NPC, 10, 0);
	elseif (QuestNum > 1 and  QuestNum < 100) then
		NpcMsg(UID, 723, NPC)
	else
		EVENT = QuestNum
	end
end
-- SQL completed-state dialog exit; no reward or state mutation.
if EVENT == 101 then return end
