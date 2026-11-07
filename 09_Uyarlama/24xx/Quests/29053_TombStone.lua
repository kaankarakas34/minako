-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
local NPC = 29053;
if (EVENT == 100) then
SelectMsg(UID, 2, -1, 9489, NPC, 10, 101);
end

if (EVENT == 101) then
SelectMsg(UID, 2, -1, 9491, NPC, 3000, 102,3005);
end

if (EVENT == 102) then
ZoneChange(UID, 35, 335, 416);
end