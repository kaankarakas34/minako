-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 101 or EVENT == 3010 then
  SelectMsg(UID, 2, -1, 10526, 24438, 10, -1)
  return
end
local Ret = 0;
local NPC = 24438;

if (EVENT == 3000) then
	SelectMsg(UID, 3, -1, 803, NPC, 67, 100, 68, 201);
end

if (EVENT == 201) then
	Ret = 1;
end

if (EVENT == 100) then
	Level = CheckLevel(UID);
	if (Level > 69) then
		SelectMsg(UID, 2, -1, 804, NPC, 2002, 101);
	else
		SelectMsg(UID, 2, -1, 810, NPC, 10, 201);
	end
end

-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 102) then
	TempleEventJoin(UID)
	--SelectMsg(UID, 2, -1, 812, NPC, 10, 201);
end

-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=333 status=255 n_index=692
if (EVENT == 3005) then
	SaveEvent(UID, 694);
end
