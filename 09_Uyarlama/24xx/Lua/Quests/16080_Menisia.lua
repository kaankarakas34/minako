-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
local NPC = 16079;

if (EVENT == 193) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 323, NPC, 10, -1);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 323, NPC)
	else
		EVENT = QuestNum
	end
end
