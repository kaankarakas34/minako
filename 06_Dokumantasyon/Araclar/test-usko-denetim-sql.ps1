$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskDb=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_TEMU_2239;Integrated Security=True;Encrypt=False')
try {
 $taskDb.Open();$taskTxn=$taskDb.BeginTransaction()
 try {
  $taskCmd=$taskDb.CreateCommand();$taskCmd.Transaction=$taskTxn;$taskCmd.CommandTimeout=60
  $taskCmd.CommandText=@'
IF RTRIM(dbo.GetAccountID('cabbar'))<>'KnightLab1' THROW 51200,'Character account lookup failed',1;
IF dbo.GetAccountID('KoMissingProbe') IS NOT NULL THROW 51201,'Unknown character matched an account',1;
IF EXISTS(SELECT 1 FROM KNIGHTS WHERE IDNum IN(30000,30001)) THROW 51202,'Clan test IDs already exist',1;
DECLARE @r int;
EXEC @r=CASTLE_SIEGE_WAR_CONTROL 30000;
IF @r<>1 THROW 51203,'Orphan siege owner not identified',1;
INSERT KNIGHTS(IDNum,Flag,Nation,Ranking,IDName,Chief,bCapeR,bCapeG,bCapeB,bySiegeFlag,ClanPointMethod)
VALUES(30001,1,1,0,'KoSiegeProbe','KoProbe',0,0,0,0,0);
EXEC @r=CASTLE_SIEGE_WAR_CONTROL 30001;
IF @r<>0 THROW 51204,'Existing clan would lose castle',1;
EXEC dbo.UPDATE_RANKS;
IF (SELECT COUNT(*) FROM USER_KNIGHTS_RANK)<>200 THROW 51205,'Clan/player ranking template did not initialize',1;
IF EXISTS(SELECT 1 FROM K_NPCPOS p JOIN K_MONSTER m ON m.sSid=p.NpcID WHERE p.ZoneID IN(1,2,21) AND p.ActType<100 AND m.strName IN('Antares','Hyde') AND p.RegTime<>28800) THROW 51206,'Known respawn rule not applied',1;
'@
  [void]$taskCmd.ExecuteNonQuery()
 }finally{if($taskTxn.Connection){$taskTxn.Rollback()};$taskTxn.Dispose()}
 [pscustomobject]@{AccountLookupPassed=$true;UnknownCharacterRejected=$true;OrphanSiegeOwnerDetected=$true;ExistingSiegeOwnerPreserved=$true;FullRankingRefreshPassed=$true;AntaresHydeRespawnPassed=$true;TemporaryChangesRolledBack=$true}|ConvertTo-Json|Tee-Object -FilePath (Join-Path $taskRoot '12_USKO_Denetimi\sql-regression-test.json')
}finally{$taskDb.Dispose()}
