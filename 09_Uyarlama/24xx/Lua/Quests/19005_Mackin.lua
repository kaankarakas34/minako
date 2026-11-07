-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 208 then
  SelectMsg(UID, 2, -1, 10526, 19005, 10, -1)
  return
end
local NPC = 19005;
local Ret = 0;


if (EVENT == 100) then
 SelectMsg(UID, 3, 974, 8075, NPC, 4481, 101, 41003, 102);
end

if (EVENT == 101) then
 MONEY = HowmuchItem(UID, 900000000);
 if (MONEY >= 10000) then
  SelectMsg(UID, 2, 974, 8083, NPC, 4484, 205, 4296, 203);
 else
  SelectMsg(UID, 2, 974, 8084, NPC, 18, 204);
 end
end

if (EVENT == 102) then
SelectMsg(UID, 3, 974, 11705, NPC, 41005, 208, 41004, 209);
end


-- Unsupported EVENT branch is retained in the review copy.


if (EVENT == 209) then
Item = HowmuchItem(UID, 900579000);
if (Item == 1) then
SelectMsg(UID, 48, -1, -1);
else
SelectMsg(UID, 2, -1, 7116, NPC, 10, 151);
end

end