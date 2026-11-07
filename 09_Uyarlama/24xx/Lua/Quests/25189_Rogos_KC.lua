-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-New
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 240 or EVENT == 242 or EVENT == 245 or EVENT == 247 then
  SelectMsg(UID, 2, -1, 10526, 25189, 10, -1)
  return
end
local NPC = 25189;

if (EVENT == 100) then
	SelectMsg(UID, 3, -1, 12181, NPC,8737,101,8738,102,8739,103,8740,104);
end

if (EVENT == 101) then
Cast = CastSkill(UID, 492017);
	if (Cast) then
		CastSkill(UID, 492017);
		
	end
end

if (EVENT == 102) then
Cast = CastSkill(UID, 492018);
	if (Cast) then
		CastSkill(UID, 492018);
		
	end
end

if (EVENT == 103) then
Cast = CastSkill(UID, 492019);
	if (Cast) then
		CastSkill(UID, 492019);
		
	end
end

if (EVENT == 104) then
Cast = CastSkill(UID, 492020);
	if (Cast) then
		CastSkill(UID, 492020);
		
	end
end