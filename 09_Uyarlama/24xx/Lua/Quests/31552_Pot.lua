-- Adapted for bundled GameServer SHA256 19e92a27...; source Original
local function GetQuestStatus(uid, quest)
  for state=0,4 do
    if CheckExistEvent(uid, quest, state) then return state end
  end
  if CheckExistEvent(uid, quest, 255) then return 255 end
  return 0
end
local Ret = 0;
local NPC = 31552;

if (EVENT == 100) then
	QuestStatus = GetQuestStatus(UID, 633)
	
	if(QuestStatus == 1) then
		EVENT = 101
	end
end

if(EVENT == 101) then
	COUNTA = HowmuchItem(UID, 900151000) 
	if(COUNTA < 1) then
		GiveItem(UID, 900151000)
		RobItem(UID, 900200000)
	end
end
