-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
local NPC = 29157;
if(EVENT == 100)then
SelectMsg(UID, 4, 898, 0, 29157, 22, 101, 23, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
if(EVENT == 101)then
SaveEvent(UID, 6570);
end
if(EVENT == 1004)then
if(true)then
SelectMsg(UID, 2, 898, 192, 29157, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
else
SelectMsg(UID, 4, 898, 0, 29157, 10, 4, 27, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end
