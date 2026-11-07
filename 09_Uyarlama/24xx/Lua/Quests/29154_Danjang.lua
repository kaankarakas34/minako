-- Adapted for bundled GameServer SHA256 19e92a27...; source Rust
local function GetQuestStatus(uid, quest)
  for state=0,4 do
    if CheckExistEvent(uid, quest, state) then return state end
  end
  if CheckExistEvent(uid, quest, 255) then return 255 end
  return 0
end
local NPC = 29154;

if (EVENT == 100) then
	QuestNum = SearchQuest(UID, NPC);
	if (QuestNum == 0) then
		SelectMsg(UID, 2, -1, 21206, NPC, 10, -1);
	elseif (QuestNum > 1 and QuestNum < 100) then
		NpcMsg(UID, 21206, NPC)
	else
		EVENT = QuestNum
	end
end

-- ═══════════════════════════════════════════════════════════════════
-- AUTO-GENERATED EVENT HANDLERS (ko-quest-gen)
-- ═══════════════════════════════════════════════════════════════════

-- [AUTO-GEN] quest=899 status=2 n_index=6576
if (EVENT == 101) then
	QuestStatusCheck = GetQuestStatus(UID, 899)
	if(QuestStatusCheck == 2) then
		SelectMsg(UID, 2, -1, 8779, NPC, 10, -1);
	else
		SaveEvent(UID, 6578);
	end
end

-- [AUTO-GEN] quest=899 status=0 n_index=6574
if (EVENT == 1000) then
	SelectMsg(UID, 4, 899, 0, NPC, 22, 1001, 23, -1);
end

-- [AUTO-GEN] quest=899 status=0 n_index=6574
if (EVENT == 1001) then
	SaveEvent(UID, 6575);
end

-- [AUTO-GEN] quest=899 status=1 n_index=6575
if (EVENT == 1002) then
	ShowMap(UID, 21);
end

-- [AUTO-GEN] quest=907 status=1 n_index=6621
if (EVENT == 1003) then
	ShowMap(UID, 21);
end

