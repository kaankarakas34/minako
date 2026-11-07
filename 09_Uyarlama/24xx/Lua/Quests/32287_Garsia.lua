-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
local Ret = 0;
local NPC = 32287;

if (EVENT == 100) then
		SelectMsg(UID, 3, -1, 906, NPC, 4076, 102, 4154, 101);
end


if (EVENT == 102) then
		ZoneChange(UID, 71, 630, 919)
end