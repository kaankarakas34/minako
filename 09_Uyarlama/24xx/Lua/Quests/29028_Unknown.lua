-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 103 or EVENT == 104 then
  SelectMsg(UID, 2, -1, 10526, 29028, 10, -1)
  return
end
local NPC = 29028;
if (EVENT == 100)then
	QuestStatus = SearchQuest(UID, 775)	 
	if(QuestStatus == 1) then
		EVENT = 101
		else
	QuestStatus = SearchQuest(UID, 776)	 
	if(QuestStatus == 1) then
		EVENT = 102	
		else
SelectMsg(UID, 2, -1, 22281, NPC,10,-1);
end
end
end

if (EVENT == 101)then
SelectMsg(UID, 2, -1, 22281, NPC, 3000,103,3005,-1);
end

if (EVENT == 102)then
SelectMsg(UID, 2, -1, 22281, NPC, 3000,104,3005,-1);
end


-- Unsupported EVENT branch is retained in the review copy.


-- Unsupported EVENT branch is retained in the review copy.
