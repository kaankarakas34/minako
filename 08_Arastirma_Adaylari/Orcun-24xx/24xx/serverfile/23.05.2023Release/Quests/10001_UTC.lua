---Author:Terry---
local Ret = 0;
local NPC = 10001;

if (EVENT == 100) then
	SelectMsg(UID, 3, -1, 29030, NPC ,10,101)	   
end

if (EVENT == 101) then ---SonYaratýk
	ZoneChange(UID, 86, 831, 771)
end
