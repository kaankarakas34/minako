local NPC = 25199;

if (EVENT == 100) then
		SaveEvent(UID, 855); 
		SelectMsg(UID, 3, -1, 3017, NPC, 8737, 200, 8738, 300, 8739, 400,8740, 500);	
end

if (EVENT == 200) then 
	Cast = CastSkill(UID, 504005);
	
  SendNpcKillID(UID, 25178)
	if (Cast) then
	CastSkill(UID, 504005)

	else
		NpcMsg(UID, 9137);
	end
end
	
if (EVENT == 300) then 
	Cast = CastSkill(UID, 500109);
		
  SendNpcKillID(UID, 25178)
	if (Cast) then
		CastSkill(UID, 25178)
		
		
	else
		NpcMsg(UID, 9137);
	end
end
if (EVENT == 400) then 
	Cast = CastSkill(UID, 504006)
	  SendNpcKillID(UID, 25178)
	if (Cast) then
		CastSkill(UID, 504006)
		
		
	else
		NpcMsg(UID, 9137);
	end
end

if (EVENT == 500) then 
	Cast = CastSkill(UID, 504007);
	  SendNpcKillID(UID, 25178);
	if (Cast) then
		CastSkill(UID, 504008)
		
	else
		NpcMsg(UID, 9137);
	end
end