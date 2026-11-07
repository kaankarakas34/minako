-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 102 or EVENT == 103 then
  SelectMsg(UID, 2, -1, 10526, 29055, 10, -1)
  return
end
local NPC = 29055;

if (EVENT == 100) then
	SelectMsg(UID, 2, -1, 9496, NPC, 10, 102);
end

if (EVENT == 101) then
	Ret = 1;
end

-- Unsupported EVENT branch is retained in the review copy.


-- Unsupported EVENT branch is retained in the review copy.


