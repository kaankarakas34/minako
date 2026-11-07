-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-Old
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 100 then
  SelectMsg(UID, 2, -1, 10526, 29190, 10, -1)
  return
end
local NPC = 29190;
if(EVENT == 1000)then
SelectMsg(UID, 4, 932, 0, 29190, 22, 1001, 23, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
SelectMsg(UID, 4, 933, 0, 29190, 22, 1001, 23, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
SelectMsg(UID, 4, 957, 10543, 29190, 22, 1001, 23, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
if(true)then
SelectMsg(UID, 2, 957, 192, 29190, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
else
SelectMsg(UID, 4, 957, 10543, 29190, 10, 4, 27, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
SelectMsg(UID, 4, 958, 0, 29190, 22, 1001, 23, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
if(true)then
SelectMsg(UID, 2, 958, 192, 29190, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
else
SelectMsg(UID, 4, 958, 0, 29190, 10, 4, 27, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end
if(EVENT == 1001)then
SaveEvent(UID, 6746);
SaveEvent(UID, 6751);
SaveEvent(UID, 6871);
SaveEvent(UID, 6876);
end
if(EVENT == 1002)then
if(true)then
SelectMsg(UID, 2, 932, 192, 29190, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
else
SelectMsg(UID, 4, 932, 0, 29190, 10, 4, 27, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
if(true)then
SelectMsg(UID, 2, 933, 192, 29190, 10, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
else
SelectMsg(UID, 4, 933, 0, 29190, 10, 4, 27, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1);
end
end


-- Missing handlers verified against this database snapshot.
-- [AUTO-GEN] quest=957 status=255 n_index=6885
if (EVENT == 105) then
	SaveEvent(UID, 6870);
end

-- SQL completed-state dialog exit; no reward or state mutation.
if EVENT == 101 then return end
