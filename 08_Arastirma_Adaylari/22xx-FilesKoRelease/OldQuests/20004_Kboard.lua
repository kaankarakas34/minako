local Ret = 0;
local NPC = 20004;

if (EVENT == 100) then
	SelectMsg(UID, 3, -1, 1377, NPC, 4609, 102);
end

if (EVENT == 102) then
	Ret = 1;
end

if (EVENT == 102) then
	UserEvent(UID,1)
end
