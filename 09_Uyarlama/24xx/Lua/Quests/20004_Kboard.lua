-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 102 then
  SelectMsg(UID, 2, -1, 10526, 20004, 10, -1)
  return
end
local Ret = 0;
local NPC = 20004;

if (EVENT == 100) then
	SelectMsg(UID, 3, -1, 1377, NPC, 4609, 102, 4610, 103, 4262, 104);
end

-- Unsupported EVENT branch is retained in the review copy.
