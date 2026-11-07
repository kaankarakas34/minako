-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 102 or EVENT == 3010 then
  SelectMsg(UID, 2, -1, 10526, 14438, 10, -1)
  return
end
local Ret = 0;
local NPC = 14438;

if (EVENT == 3000) then
	SelectMsg(UID, 3, -1, 807, NPC, 67, 100, 68, 201);
end

if (EVENT == 201) then
	Ret = 1;
end

if (EVENT == 100) then
	Level = CheckLevel(UID);
	if (Level > 69) then
		SelectMsg(UID, 2, -1, 808, NPC, 2002, 101);
	else
		SelectMsg(UID, 2, -1, 810, NPC, 10, 201);
	end
end

if (EVENT == 101) then
	SelectMsg(UID, 2, -1, 809, NPC, 65, 102);
end

-- Unsupported EVENT branch is retained in the review copy.


-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=333 status=255 n_index=693
if (EVENT == 3005) then
	SaveEvent(UID, 695);
end
