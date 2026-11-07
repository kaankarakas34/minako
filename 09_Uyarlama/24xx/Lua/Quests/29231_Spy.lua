-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
local NPC = 29231;
if(EVENT == 100)then
SelectMsg(UID, 4, 982, 0, 29231, 22, 101, 23, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
if(true)then
SelectMsg(UID, 2, 982, 192, 29231, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
else
SelectMsg(UID, 4, 982, 0, 29231, 10, 4, 27, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end
if(EVENT == 101)then
SaveEvent(UID, 6998);
end
