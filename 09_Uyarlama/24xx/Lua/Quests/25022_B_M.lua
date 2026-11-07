-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-New
local function GetQuestStatus(uid, quest)
  for state=0,4 do
    if CheckExistEvent(uid, quest, state) then return state end
  end
  if CheckExistEvent(uid, quest, 255) then return 255 end
  return 0
end
-- These events require missing native/server data; no costs or quest state changes are allowed.
if EVENT == 104 then
  SelectMsg(UID, 2, -1, 10526, 25022, 10, -1)
  return
end
local NPC = 25022;

if(EVENT == 100)then
	QuestStatusCheck = GetQuestStatus(UID, 1211)	
		if(QuestStatusCheck == 1) then
			EVENT = 101
		else
	QuestStatusCheck = GetQuestStatus(UID, 1214)	
		if(QuestStatusCheck == 1) then
			EVENT = 105
		else
			SelectMsg(UID, 2, -1, 43671, NPC, 10, -1);
		end
	end
end

if(EVENT == 101)then
	SelectMsg(UID, 2, -1, 43671, NPC, 40164, 102);
end

if(EVENT == 102)then
	ShowEffect(UID, 300435);
	SelectMsg(UID, 2, -1, 43672, NPC, 40159, 103);
end

if(EVENT == 103)then
	SelectMsg(UID, 2, -1, 43673, NPC, 40160, 104);
end

-- Unsupported EVENT branch is retained in the review copy.


if(EVENT == 105)then
	SelectMsg(UID, 2, -1, 43681, NPC, 40166, 106);
end

if(EVENT == 106)then
	SelectMsg(UID, 2, -1, 43682, NPC, 40167, 107);
end

if(EVENT == 107)then
	SelectMsg(UID, 2, -1, 43683, NPC, 40169, 108);
end

if(EVENT == 108)then
	SlotCheck = CheckGiveSlot(UID, 2)
		if SlotCheck == false then
			
        else
	QuestStatusCheck = GetQuestStatus(UID, 1214)	
		if(QuestStatusCheck == 2) then
			SelectMsg(UID, 2, -1, 43671, NPC, 10, -1);
		else
			GiveItem(UID, 900632000, 1);
			GiveItem(UID, 900631000, 1);
		end
	end
end