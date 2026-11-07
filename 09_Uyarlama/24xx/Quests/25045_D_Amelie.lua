-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 102 then
  SelectMsg(UID, 2, -1, 10526, 25045, 10, -1)
  return
end
local NPC = 25045;
if(EVENT == 100) then
		SelectMsg(UID, 2, -1, 43788, NPC, 40216, 101);
end

if(EVENT == 101) then
		SelectMsg(UID, 2, -1, 43789, NPC, 40217, 102);
end

-- Unsupported EVENT branch is retained in the review copy.
