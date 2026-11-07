-- Adapted for bundled GameServer SHA256 19e92a27...; source 22xx-New
local function GetQuestStatus(uid, quest)
  for state=0,4 do
    if CheckExistEvent(uid, quest, state) then return state end
  end
  if CheckExistEvent(uid, quest, 255) then return 255 end
  return 0
end
local NPC = 25117;

if (EVENT == 100) then
	QuestStatus = GetQuestStatus(UID, 1337)	
		if(QuestStatus == 1) then
			EVENT = 101
	end
end

if (EVENT == 101) then		
	SelectMsg(UID, 2, -1, 43914, NPC, 40348, 102,40349,-1);
end

if (EVENT == 102) then		
	SelectMsg(UID, 2, -1, 44079, NPC, 65, 103);
end

if (EVENT == 103) then
	SlotCheck = CheckGiveSlot(UID, 1)
		if SlotCheck == false then
			
        else		
			SelectMsg(UID, 2, -1, 44081, NPC, 10, -1);
			GiveItem(UID, 900683000,1);
			
	end
end