-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 102 then
  SelectMsg(UID, 2, -1, 10526, 29002, 10, -1)
  return
end
local NPC = 29002;
if (EVENT == 100)then
	QuestStatus = SearchQuest(UID, 703)	 
	if(QuestStatus == 1) then
		EVENT = 101
		else
SelectMsg(UID, 2, -1, 22279, NPC,10,-1);
end
end

if (EVENT == 101)then
SelectMsg(UID, 2, -1, 22279, NPC, 3000,102,3005,-1);
end


-- Unsupported EVENT branch is retained in the review copy.
