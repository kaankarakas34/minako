-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
local Ret = 0;
local NPC = 31102;

if (EVENT == 100) then
	SelectMsg(UID, 2, -1, 4072, NPC, 10, 101);
end

if (EVENT == 101) then
	Ret = 1;
end