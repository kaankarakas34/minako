local Ret = 0;
local NPC = 16085;

if (EVENT == 165) then
	NpcMsg(UID, 4131, NPC)
end

if (EVENT == 168) then
	Ret = 1;
end

if EVENT == 200 then --NCS
   ITEM_COUNTA = HowmuchItem(UID, 800032000);
    if ITEM_COUNTA > 0 then
       SendNameChange(UID)
    else
       SelectMsg(UID, 2, 3, 4454, 16085, 10, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0);

    end
end
if(EVENT==520)then
	SelectMsg(UID, 3, 2, 1111, 16085, 4583, 521, 4584,522, 4585, 523, 4586, 524, 7162, 525, 7163, 526, 4303, 165, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0);
end

if(EVENT==521)then --100 HP
   ITEMA = HowmuchItem(UID, 889310000);
   if ITEMA == 0 then
      SelectMsg(UID, 2, -1, 1113, NPC, 27, 168);
   else
      SelectMsg(UID, 2, -1, 1112, NPC, 4006, 527, 4005, 168);
   end
end
if EVENT == 527 then
   ITEMA = HowmuchItem(UID, 889310000);
   if ITEMA > 0 then
   Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   RobItem(UID, 889310000, 1)
   GiveItem(UID, 389310000, 1)
   SelectMsg(UID, 2, -1, 1114, NPC, 27, 168);
end
end
end
if(EVENT==522)then --300 HP
   ITEMB = HowmuchItem(UID, 889320000);
   if ITEMB == 0 then
      SelectMsg(UID, 2, -1, 1116, NPC, 27, 168);
   else
      SelectMsg(UID, 2, -1, 1115, NPC, 4006, 528, 4005, 168);
   end
end
if EVENT == 528 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMB = HowmuchItem(UID, 889320000);
   if ITEMB > 0 then
   RobItem(UID, 889320000, 1)
   GiveItem(UID, 389320000, 1)
   SelectMsg(UID, 2, -1, 1114, NPC, 27, 168);
end
end
end

if(EVENT==523)then --100 MP
   ITEMC = HowmuchItem(UID, 889340000);
   if ITEMC == 0 then
      SelectMsg(UID, 2, -1, 1118, NPC, 27, 168);
   else
      SelectMsg(UID, 2, -1, 1117, NPC, 4006, 529, 4005, 168);
   end

end
if EVENT == 529 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
  ITEMC = HowmuchItem(UID, 889340000);
   if ITEMC > 0 then
   RobItem(UID, 889340000, 1)
   GiveItem(UID, 389340000, 1)
   SelectMsg(UID, 2, -1, 1114, NPC, 27, 168);
end
end
end


if(EVENT==524)then --300 MP
   ITEMD = HowmuchItem(UID, 889350000);
   if ITEMD == 0 then
      SelectMsg(UID, 2, -1, 1120, NPC, 27, 168);
   else
      SelectMsg(UID, 2, -1, 1119, NPC, 4006, 530, 4005, 168);
   end

end
if EVENT == 530 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMD = HowmuchItem(UID, 889350000);
   if ITEMD > 0 then
   RobItem(UID, 889350000, 1)
   GiveItem(UID, 389350000, 1)
   SelectMsg(UID, 2, -1, 1114, NPC, 27, 168);
end
end
end


if(EVENT==525)then --5K HP
   ITEME = HowmuchItem(UID, 889330000);
   if ITEME == 0 then
      SelectMsg(UID, 2, -1, 1669, NPC, 27, 168);
   else
      SelectMsg(UID, 2, -1, 1668, NPC, 4006, 531, 4005, 168);
   end

end
if EVENT == 531 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEME = HowmuchItem(UID, 889330000);
   if ITEME > 0 then
   RobItem(UID, 889330000, 1)
   GiveItem(UID, 389390000, 1)
   SelectMsg(UID, 2, -1, 1114, NPC, 27, 168);
end
end
end

if(EVENT==526)then --5K MP
   ITEMF = HowmuchItem(UID, 889360000);
   if ITEMF == 0 then
      SelectMsg(UID, 2, -1, 1671, NPC, 27, 168);
   else
      SelectMsg(UID, 2, -1, 1670, NPC, 4006, 532, 4005, 168);
   end

end
if EVENT == 532 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMF = HowmuchItem(UID, 889360000);
   if ITEMF > 0 then
   RobItem(UID, 889360000, 1)
   GiveItem(UID, 389400000, 1)
   SelectMsg(UID, 2, -1, 1114, NPC, 27, 168);
end
end
end

if(EVENT==300)then

SelectMsg(UID, 2, 4, 4455, 16085, 10, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0);
end
if(EVENT==400)then

SelectMsg(UID, 2, 7, 4457, 16085, 4192, 0, 4191, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0);
end

if(EVENT==500)then

SelectMsg(UID, 2, 8, 4462, 16085, 10, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0);
end

if(EVENT==600)then
 ITEM_COUNTA = HowmuchItem(UID, 800086000);
    if ITEM_COUNTA > 0 then
        Check = isClanLeader(UID)
        if Check then 
           SendClanNameChange(UID)
        else
           SelectMsg(UID, 2, savenum, 4671, NPC, 10, 168);
        end
    else
        SelectMsg(UID, 2, savenum, 4670, NPC, 10, 168);
    end
end

if(EVENT==700)then

SelectMsg(UID, 2, 6, 4672, 16085, 10, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0);
end

if(EVENT==850)then --Cospre Item ->Existing Minerva ->Minerva Clothing ->Pathos' Glove
	SelectMsg(UID, 3, 9, 8973, 16085, 7040, 851, 7055, 920, 4504, 900, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0);
end
if(EVENT==851)then --Existing Minerva
	SelectMsg(UID, 3, 9, 4914, 16085, 4285, 852, 4286, 853, 4287, 858, 4420, 863, 4421, 868, 4589, 880, 4588, 890, 27, 0, -1, 0, -1, 0, -1, 0, -1, 0);
end
if(EVENT==852)then --Try it on
	SelectMsg(UID, 11, 9, 4900, 16085, 4233, 0, 4285, 0, 27, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0);
end
if(EVENT==853)then --Valkrie Armor
	ITEMARMOR = HowmuchItem(UID, 800180000);
   if ITEMARMOR > 0 then
      SelectMsg(UID, 3, -1, 4902, NPC, 4288, 854, 4289, 855, 4290, 856, 4291, 857);
   else
      SelectMsg(UID, 2, 9, 4921, 16085, 10, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0);	
   end
end



if EVENT == 854 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
	ITEMARMOR = HowmuchItem(UID, 800180000);
   if ITEMARMOR > 0 then
   RobItem(UID, 800180000, 1)
   GiveItem(UID, 508011441, 1,30)
end
end
end

if EVENT == 855 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
	ITEMARMOR = HowmuchItem(UID, 800180000);
   if ITEMARMOR > 0 then
   RobItem(UID, 800180000, 1)
   GiveItem(UID, 508011442, 1,30)
end
end
end

if EVENT == 856 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
	ITEMARMOR = HowmuchItem(UID, 800180000);
   if ITEMARMOR > 0 then
   RobItem(UID, 800180000, 1)
   GiveItem(UID, 508011443, 1,30)
end
end
end

if EVENT == 857 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
	ITEMARMOR = HowmuchItem(UID, 800180000);
   if ITEMARMOR > 0 then
   RobItem(UID, 800180000, 1)
   GiveItem(UID, 508011444, 1,30)
end
end
end

if EVENT == 858 then --Valkrie Helmet
   ITEMHELMET = HowmuchItem(UID, 800170000);
   if ITEMHELMET > 0 then
      SelectMsg(UID, 3, -1, 4902, NPC, 4292, 859, 4293, 860, 4294, 861, 4295, 862);
   else
      SelectMsg(UID, 2, 9, 4911, 16085, 10, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0);

   end
end

if EVENT == 859 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMHELMET = HowmuchItem(UID, 800170000);
   if ITEMHELMET > 0 then
   RobItem(UID, 800170000, 1)
   GiveItem(UID, 508013318, 1,30)
end
end
end

if EVENT == 860 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMHELMET = HowmuchItem(UID, 800170000);
   if ITEMHELMET > 0 then
   RobItem(UID, 800170000, 1)
   GiveItem(UID, 508013319, 1,30)
end
end
end

if EVENT == 861 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMHELMET = HowmuchItem(UID, 800170000);
   if ITEMHELMET > 0 then
   RobItem(UID, 800170000, 1)
   GiveItem(UID, 508013320, 1,30)
end
end
end

if EVENT == 862 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMHELMET = HowmuchItem(UID, 800170000);
   if ITEMHELMET > 0 then
   RobItem(UID, 800170000, 1)
   GiveItem(UID, 508013321, 1,30)
end
end
end



if EVENT == 863 then  --Gryp Helmet
   ITEMGRYPA = HowmuchItem(UID, 800240000);
   if ITEMGRYPA > 0 then
      SelectMsg(UID, 3, -1, 4902, NPC, 4288, 864, 4289, 865, 4290, 866, 4291, 867);
   else
      SelectMsg(UID, 2, -1, 6488, NPC, 27, 168);
   end
end


if EVENT == 864 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMGRYPA = HowmuchItem(UID, 800240000);
   if ITEMGRYPA > 0 then
   RobItem(UID, 800240000, 1)
   GiveItem(UID, 508471453, 1,30)
end
end
end

if EVENT == 865 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMGRYPA = HowmuchItem(UID, 800240000);
   if ITEMGRYPA > 0 then
   RobItem(UID, 800240000, 1)
   GiveItem(UID, 508471454, 1,30)
end
end
end

if EVENT == 866 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMGRYPA = HowmuchItem(UID, 800240000);
   if ITEMGRYPA > 0 then
   RobItem(UID, 800240000, 1)
   GiveItem(UID, 508471455, 1,30)
end
end
end

if EVENT == 867 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMGRYPA = HowmuchItem(UID, 800240000);
   if ITEMGRYPA > 0 then
   RobItem(UID, 800240000, 1)
   GiveItem(UID, 508471456, 1,30)
end
end
end

if EVENT == 868 then ---Gryp Armor
   ITEMGRYPH = HowmuchItem(UID, 800230000);
   if ITEMGRYPH > 0 then
      SelectMsg(UID, 3, -1, 4902, NPC, 4288, 870, 4289, 871, 4290, 872, 4291, 873);
   else
      SelectMsg(UID, 2, -1, 6497, NPC, 27, 168);
   end
end



if EVENT == 870 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMGRYPH = HowmuchItem(UID, 800230000);
   if ITEMGRYPH > 0 then
   RobItem(UID, 800230000, 1)
   GiveItem(UID, 508473453, 1,30)
end
end
end

if EVENT == 871 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMGRYPH = HowmuchItem(UID, 800230000);
   if ITEMGRYPH > 0 then
   RobItem(UID, 800230000, 1)
   GiveItem(UID, 508473454, 1,30)
end
end
end

if EVENT == 872 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMGRYPH = HowmuchItem(UID, 800230000);
   if ITEMGRYPH > 0 then
   RobItem(UID, 800230000, 1)
   GiveItem(UID, 508473455, 1,30)
end
end
end

if EVENT == 873 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMGRYPH = HowmuchItem(UID, 800230000);
   if ITEMGRYPH > 0 then
   RobItem(UID, 800230000, 1)
   GiveItem(UID, 508473456, 1,30)
end
end
end


if EVENT == 880 then --Bahamut Armor
   ITEMBHMTA = HowmuchItem(UID, 800270000);
   if ITEMBHMTA > 0 then
      SelectMsg(UID, 3, -1, 4902, NPC, 4288, 881, 4289, 882, 4290, 883, 4291, 884);
   else
      SelectMsg(UID, 2, -1, 1126, NPC, 27, 168);
   end
end

if EVENT == 881 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMBHMTA = HowmuchItem(UID, 800270000);
   if ITEMBHMTA > 0 then
   RobItem(UID, 800270000, 1)
   GiveItem(UID, 508051466, 1,30)
end
end
end

if EVENT == 882 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMBHMTA = HowmuchItem(UID, 800270000);
   if ITEMBHMTA > 0 then
   RobItem(UID, 800270000, 1)
   GiveItem(UID, 508051467, 1,30)
end
end
end

if EVENT == 883 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMBHMTA = HowmuchItem(UID, 800270000);
   if ITEMBHMTA > 0 then
   RobItem(UID, 800270000, 1)
   GiveItem(UID, 508051468, 1,30)
end
end
end

if EVENT == 884 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMBHMTA = HowmuchItem(UID, 800270000);
   if ITEMBHMTA > 0 then
   RobItem(UID, 800270000, 1)
   GiveItem(UID, 508051469, 1,30)
end
end
end

if EVENT == 890 then --Bahamut
   ITEMBHMTH = HowmuchItem(UID, 800260000);
   if ITEMBHMTH > 0 then
      SelectMsg(UID, 3, -1, 4902, NPC, 4288, 891, 4289, 892, 4290, 893, 4291, 894);
   else
      SelectMsg(UID, 2, -1, 1126, NPC, 27, 168);
   end
end

if EVENT == 891 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMBHMTH = HowmuchItem(UID, 800260000);
   if ITEMBHMTH > 0 then
   RobItem(UID, 800260000, 1)
   GiveItem(UID, 508053466, 1, 30)
end
end
end

if EVENT == 892 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMBHMTH = HowmuchItem(UID, 800260000);
   if ITEMBHMTH > 0 then
   RobItem(UID, 800260000, 1)
   GiveItem(UID, 508053467, 1,30)
end
end
end

if EVENT == 893 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMBHMTH = HowmuchItem(UID, 800260000);
   if ITEMBHMTH > 0 then
   RobItem(UID, 800260000, 1)
   GiveItem(UID, 508053468, 1,30)
end
end
end

if EVENT == 894 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMBHMTH = HowmuchItem(UID, 800260000);
   if ITEMBHMTH > 0 then
   RobItem(UID, 800260000, 1)
   GiveItem(UID, 508053469, 1,30)
end
end
end

if EVENT == 900 then --Pathos
   ITEMPTHS = HowmuchItem(UID, 800250000);
   if ITEMPTHS > 0 then
      SelectMsg(UID, 3, -1, 748, NPC, 4509, 901, 4510, 906);
   else
      SelectMsg(UID, 2, -1, 749, NPC, 27, 168);
   end
end

if EVENT == 901 then --Pathos Attack
   SelectMsg(UID, 3, -1, 750, NPC, 4505, 902, 4506, 903, 4507, 904, 4508, 905);
end
if EVENT == 902 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMPTHS = HowmuchItem(UID, 800250000);
   if ITEMPTHS > 0 then
   RobItem(UID, 800250000, 1)
   GiveItem(UID, 502573462, 1,30)
   SelectMsg(UID, 2, -1, 752, NPC, 27, 168);
end
end
end

if EVENT == 903 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMPTHS = HowmuchItem(UID, 800250000);
   if ITEMPTHS > 0 then
   RobItem(UID, 800250000, 1)
   GiveItem(UID, 503573463, 1,30)
   SelectMsg(UID, 2, -1, 752, NPC, 27, 168);
end
end
end

if EVENT == 904 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMPTHS = HowmuchItem(UID, 800250000);
   if ITEMPTHS > 0 then
   RobItem(UID, 800250000, 1)
   GiveItem(UID , 504573464, 1,30)
   SelectMsg(UID, 2, -1, 752, NPC, 27, 168);
end
end
end

if EVENT == 905 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMPTHS = HowmuchItem(UID, 800250000);
   if ITEMPTHS > 0 then
   RobItem(UID, 800250000, 1)
   GiveItem(UID, 505573465, 1,30)
   SelectMsg(UID, 2, -1, 752, NPC, 27, 168);
end
end
end

if EVENT == 906 then
   SelectMsg(UID, 3, -1, 751, NPC, 4514, 907, 4515, 908, 4516, 909, 4517, 910);
end

if EVENT == 907 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMPTHS = HowmuchItem(UID, 800250000);
   if ITEMPTHS > 0 then
   RobItem(UID, 800250000, 1)
   GiveItem(UID, 511573471, 1,30)
   SelectMsg(UID, 2, -1, 752, NPC, 27, 168);
end
end
end

if EVENT == 908 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMPTHS = HowmuchItem(UID, 800250000);
   if ITEMPTHS > 0 then
   RobItem(UID, 800250000, 1)
   GiveItem(UID, 512573472, 1,30)
   SelectMsg(UID, 2, -1, 752, NPC, 27, 168);
end
end
end

if EVENT ==909 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMPTHS = HowmuchItem(UID, 800250000);
   if ITEMPTHS > 0 then
   RobItem(UID, 800250000, 1)
   GiveItem(UID , 513573473, 1, 30)
   SelectMsg(UID, 2, -1, 752, NPC, 27, 168);
end
end
end

if EVENT == 910 then
Slot = CheckGiveSlot(UID,1)
if (Slot == true) then -- slotta yer var
   ITEMPTHS = HowmuchItem(UID, 800250000);
   if ITEMPTHS > 0 then
   RobItem(UID, 800250000, 1)
   GiveItem(UID, 514573474, 1, 30)
   SelectMsg(UID, 2, -1, 752, NPC, 27, 168);
end
end
end

if EVENT == 920 then --Minerva Clothing
   SelectMsg(UID, 3, 9, 8983, 16085, 10, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0, -1, 0);
end


