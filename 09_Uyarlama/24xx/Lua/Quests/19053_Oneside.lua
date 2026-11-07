-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
local Ret = 0;
local NPC = 19053;
----------------------------------
if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 664, NPC, 10, 193);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 664, NPC)
	else
		EVENT = QuestNum
	end
end