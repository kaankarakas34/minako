-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 1000 or EVENT == 1002 or EVENT == 1003 or EVENT == 1005 or EVENT == 1100 or EVENT == 1102 or EVENT == 1105 or EVENT == 1106 then
  SelectMsg(UID, 2, -1, 10526, 31524, 10, -1)
  return
end
local NPC = 31524;
local Ret = 0;

if (EVENT == 100) then
	SelectMsg(UID, 2, -1, 21215, NPC, 7494, 102, 8351, 103);
end

if (EVENT == 101) then
	Ret = 1;
end
--Dissamble!
if (EVENT == 102) then
	SelectMsg(UID, 27, -1, -1, NPC);
end
--SideTracked
if (EVENT == 103) then
	SelectMsg(UID, 2, 616, 21215, NPC, 10, 101);
end