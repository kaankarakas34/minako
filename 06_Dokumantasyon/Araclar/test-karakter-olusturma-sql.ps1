$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskSql=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_TEMU_2239;Integrated Security=True;Encrypt=False')
try {
 $taskSql.Open();$taskTxn=$taskSql.BeginTransaction()
 try {
  $taskCmd=$taskSql.CreateCommand();$taskCmd.Transaction=$taskTxn
  $taskCmd.CommandText=@'
DECLARE @a varchar(21)='KoCreateProbe',@c varchar(21)='KoPriestProbe',@r int;
IF EXISTS(SELECT 1 FROM TB_USER WHERE strAccountID=@a) OR EXISTS(SELECT 1 FROM USERDATA WHERE strUserID=@c) THROW 51000,'Probe identifiers already exist',1;
INSERT INTO TB_USER(strAccountID,strPasswd,strSealPasswd,OTPPassword,bPremiumType,dtCreateTime,strAuthority)
VALUES(@a,dbo.HashPasswordString('ProbeOnly123'),'LabSea91','739415',0,GETDATE(),1);
INSERT INTO ACCOUNT_CHAR(strAccountID,bNation,bCharNum,strCharID1,strCharID2,strCharID3,strCharID4) VALUES(@a,1,0,'','','','');
EXEC @r=CREATE_NEW_CHAR @a,0,@c,4,104,62405454,4,60,60,60,70,50;
IF @r<>0 THROW 51001,'CREATE_NEW_CHAR did not succeed',1;
EXEC LOAD_NEW_CHAR_SET @c,104;
EXEC LOAD_NEW_CHAR_VALUE @c,104,1;
IF NOT EXISTS(SELECT 1 FROM USERDATA WHERE strUserID=@c AND DATALENGTH(strItem)=600 AND DATALENGTH(strSerial)=600 AND DATALENGTH(strItemTime)=300 AND SUBSTRING(strItem,1,2)<>0x2328) THROW 51005,'Inventory binary format is incorrect',1;
EXEC @r=CREATE_NEW_CHAR @a,1,@c,4,104,62405454,4,60,60,60,70,50;
IF @r<>3 THROW 51006,'Duplicate character name accepted',1;
EXEC @r=CREATE_NEW_CHAR @a,1,'Bad!Probe',4,104,62405454,4,60,60,60,70,50;
IF @r<>5 THROW 51007,'Invalid character name accepted',1;
EXEC @r=CREATE_NEW_CHAR @a,1,'KoNationProbe',12,204,62405454,4,60,60,60,70,50;
IF @r<>2 THROW 51008,'Wrong nation race accepted',1;
-- Verify endian order and the last slot, not just the all-zero expiry template.
UPDATE BEGINNER_SETTINGS SET BeginnerType=1 WHERE ServerNo=1;
UPDATE CREATE_NEW_CHAR_SET SET ItemExpireTime=305419896 WHERE ClassType=4 AND SlotID=74;
EXEC LOAD_NEW_CHAR_SET @c,104;
IF NOT EXISTS(SELECT 1 FROM USERDATA WHERE strUserID=@c AND DATALENGTH(strItemTime)=300 AND SUBSTRING(strItemTime,297,4)=0x78563412) THROW 51009,'Last-slot expiry serialization is incorrect',1;
UPDATE BEGINNER_SETTINGS SET BeginnerType=0 WHERE ServerNo=1;
EXEC LOAD_NEW_CHAR_SET @c,104;
IF EXISTS(SELECT 1 FROM MAIL_BOX WHERE strRecipientID=@c) THROW 51103,'Boosted starter gift was sent to normal character',1;
IF EXISTS(SELECT 1 FROM TB_USER WHERE strAccountID=@a AND (CashPoint>0 OR BonusCashPoint>0)) THROW 51104,'Free starter cash was granted to normal account',1;
IF NOT EXISTS(SELECT 1 FROM USERDATA WHERE strUserID=@c AND Loyalty=0 AND LoyaltyMonthly=0 AND Gold=0 AND Exp=0) THROW 51106,'Normal newborn currencies or experience are not zero',1;
DECLARE @items varbinary(max)=(SELECT strItem FROM USERDATA WHERE strUserID=@c),@slot int=0,@item int;
DECLARE @classes TABLE(ClassType int);INSERT @classes VALUES(1),(2),(3),(4),(13);
DECLARE @testClass int,@nativeClass smallint;
WHILE EXISTS(SELECT 1 FROM @classes)
BEGIN
 SELECT @testClass=MIN(ClassType) FROM @classes;SET @nativeClass=100+@testClass;
 EXEC LOAD_NEW_CHAR_SET @c,@nativeClass;
 SELECT @items=strItem FROM USERDATA WHERE strUserID=@c;
 SET @slot=0;
WHILE @slot<75
BEGIN
 SET @item=CONVERT(int,SUBSTRING(@items,@slot*8+1,1))+256*CONVERT(int,SUBSTRING(@items,@slot*8+2,1))+65536*CONVERT(int,SUBSTRING(@items,@slot*8+3,1))+16777216*CONVERT(int,SUBSTRING(@items,@slot*8+4,1));
 IF @item<>COALESCE((SELECT ItemID FROM KNIGHTLAB_NORMAL_STARTER_ITEMS WHERE ClassType=@testClass AND SlotID=@slot),0) THROW 51105,'Inventory differs from the normal starter preset',1;
 SET @slot+=1;
END;
 DELETE FROM @classes WHERE ClassType=@testClass;
END;
EXEC LOAD_NEW_CHAR_SET @c,104;
IF NOT EXISTS(SELECT 1 FROM ACCOUNT_CHAR WHERE strAccountID=@a AND bNation=1 AND bCharNum=1 AND strCharID1=@c) THROW 51002,'Character slot was not saved',1;
IF NOT EXISTS(SELECT 1 FROM USERDATA WHERE strUserID=@c AND Nation=1 AND Race=4 AND Class=104 AND [Level]=1 AND Authority=1 AND Zone=21) THROW 51003,'Starter character fields are incorrect',1;
IF NOT EXISTS(SELECT 1 FROM USER_QUEST_DATA WHERE strUserID=@c) OR NOT EXISTS(SELECT 1 FROM USER_ACHIEVE_DATA WHERE strUserID=@c) OR NOT EXISTS(SELECT 1 FROM USER_GENIE_DATA WHERE strUserID=@c) THROW 51004,'Dependent character data missing',1;
DECLARE @achieve varbinary(max),@achieveCount int,@i int=0,@id int;
SELECT @achieve=strAchieve,@achieveCount=sAchieveCount FROM USER_ACHIEVE_DATA WHERE strUserID=@c;
IF DATALENGTH(@achieve)<>5200 OR @achieveCount>(DATALENGTH(@achieve)-36)/11 THROW 51012,'Invalid achievement binary layout',1;
WHILE @i<@achieveCount
BEGIN
 SET @id=CONVERT(int,SUBSTRING(@achieve,37+11*@i,1))+256*CONVERT(int,SUBSTRING(@achieve,38+11*@i,1));
 IF NOT EXISTS(SELECT 1 FROM ACHIEVE_MAIN WHERE sIndex=@id) THROW 51013,'Achievement template refers to missing definition',1;
 SET @i+=1;
END;
SELECT strUserID,Nation,Race,Class,[Level],Authority,Zone,Strong,Sta,Dex,Intel,Cha,
DATALENGTH(strItem) AS ItemBytes,DATALENGTH(strSerial) AS SerialBytes,DATALENGTH(strItemTime) AS ExpirationBytes,DATALENGTH(strSkill) AS SkillBytes,
(SELECT COUNT(*) FROM MAIL_BOX WHERE strRecipientID=@c) AS StarterLetters,
(SELECT COUNT(*) FROM USER_SAVED_MAGIC WHERE strCharID=@c) AS SavedMagicRows,
(SELECT COUNT(*) FROM USER_KNIGHTDATA WHERE strUserID=@c) AS ClanRows,
DATALENGTH(@achieve) AS AchievementBytes,@achieveCount AS ValidatedAchievementIds FROM USERDATA WHERE strUserID=@c;
'@
  $taskData=[Data.DataTable]::new();$taskReader=$taskCmd.ExecuteReader();$taskData.Load($taskReader);$taskReader.Dispose()
  $taskRows=@(foreach($taskRow in $taskData.Rows){$taskItem=[ordered]@{};foreach($taskCol in $taskData.Columns){$taskItem[$taskCol.ColumnName]=$taskRow[$taskCol]};[pscustomobject]$taskItem})
 }finally{if($taskTxn.Connection){$taskTxn.Rollback()};$taskTxn.Dispose()}
 $taskCmd.Transaction=$null;$taskCmd.CommandText="SELECT (SELECT COUNT(*) FROM TB_USER WHERE strAccountID='KoCreateProbe')+(SELECT COUNT(*) FROM USERDATA WHERE strUserID='KoPriestProbe')"
 if($taskCmd.ExecuteScalar() -ne 0){throw 'Temporary probe rows remain'}
 [pscustomobject]@{CharacterCreationPassed=$true;NativePostCreateProceduresPassed=$true;Character=$taskRows;AllProbeRowsRolledBack=$true;ExistingPlayerRowsUpdated=0;GraphicalRetryVerified=$false}|ConvertTo-Json -Depth 5|Tee-Object -FilePath (Join-Path $taskRoot '11_Istemci_Uyumluluk\character-creation-sql-test.json')
}finally{$taskSql.Dispose()}
