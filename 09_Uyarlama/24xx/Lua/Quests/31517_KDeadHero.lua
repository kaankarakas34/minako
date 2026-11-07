-- Adapted for bundled GameServer SHA256 19e92a27...; source AKGame
local NPC = 31517;

if (EVENT == 100) then
	NATION = CheckNation(UID);
	if (NATION == 1) then
		GiveItem(UID, 910228000, 1);
		SelectMsg(UID, 2, -1, 20511, NPC, 10, -1);
	else
	    GiveItem(UID, 900071000, 1);
		SelectMsg(UID, 2, -1, 20511, NPC, 10, -1);
	end
end