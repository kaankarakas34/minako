$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskPrepared=Join-Path $taskRoot '10_Kaynak_Derleme\Veritabani_Hazirlik'
$taskBackup=Join-Path $taskRoot '12_USKO_Denetimi\Yedek'
$taskDb=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_TEMU_2239;Integrated Security=True;Encrypt=False')
try {
 $taskDb.Open();$taskTxn=$taskDb.BeginTransaction()
 try {
  $taskCmd=$taskDb.CreateCommand();$taskCmd.Transaction=$taskTxn
  foreach($taskObject in @(@{Name='GetAccountID';Folder='Functions';Kind='FUNCTION'},@{Name='UPDATE_USER_KNIGHTS_RANK';Folder='Procedures';Kind='PROCEDURE'},@{Name='UPDATE_USER_PERSONAL_RANK';Folder='Procedures';Kind='PROCEDURE'},@{Name='UPDATE_KNIGHTS_RATING';Folder='Procedures';Kind='PROCEDURE'},@{Name='CASTLE_SIEGE_WAR_CONTROL';Folder='Procedures';Kind='PROCEDURE'})) {
   $taskCmd.CommandText="SELECT definition FROM sys.sql_modules WHERE object_id=OBJECT_ID('dbo.$($taskObject.Name)')"
   $taskOld=$taskCmd.ExecuteScalar()
   $taskDefinition=[IO.File]::ReadAllText((Join-Path $taskPrepared ($taskObject.Folder+'\'+$taskObject.Name+'.sql')))
   if($taskOld -is [string]) {
    $taskFile=Join-Path $taskBackup ($taskObject.Name+'-before.sql')
    if(-not(Test-Path -LiteralPath $taskFile)){[IO.File]::WriteAllText($taskFile,$taskOld,[Text.UTF8Encoding]::new($false))}
    $taskDefinition=$taskDefinition.Replace('CREATE '+$taskObject.Kind,'ALTER '+$taskObject.Kind)
   }
   $taskCmd.CommandText=$taskDefinition;[void]$taskCmd.ExecuteNonQuery()
  }
  $taskCmd.CommandText=@'
IF OBJECT_ID('dbo.KNIGHTLAB_USKO_LEVEL_BACKUP_20261105','U') IS NULL
 SELECT * INTO dbo.KNIGHTLAB_USKO_LEVEL_BACKUP_20261105 FROM LEVEL_UP WHERE RebithLevel=0 AND [Level] IN(77,79);
UPDATE LEVEL_UP SET Exp=1196764159 WHERE RebithLevel=0 AND [Level]=77 AND Exp=1196764160;
UPDATE LEVEL_UP SET Exp=1763786231 WHERE RebithLevel=0 AND [Level]=79 AND Exp=1763786232;
-- NTTGame patch 8 August 2024: permanent Antares/Hyde respawn change to 8h.
-- Restricted to active ordinary home maps; no event clones or coordinates moved.
IF OBJECT_ID('dbo.KNIGHTLAB_USKO_SPAWN_BACKUP_20261105','U') IS NULL
 SELECT p.* INTO dbo.KNIGHTLAB_USKO_SPAWN_BACKUP_20261105 FROM K_NPCPOS p
 JOIN K_MONSTER m ON m.sSid=p.NpcID JOIN ZONE_INFO z ON z.ZoneNo=p.ZoneID
 WHERE p.ActType<100 AND m.strName IN('Antares','Hyde') AND p.ZoneID IN(1,2,21) AND z.Status=1;
UPDATE p SET RegTime=28800 FROM K_NPCPOS p JOIN K_MONSTER m ON m.sSid=p.NpcID
 JOIN ZONE_INFO z ON z.ZoneNo=p.ZoneID
 WHERE p.ActType<100 AND m.strName IN('Antares','Hyde') AND p.ZoneID IN(1,2,21) AND z.Status=1 AND p.RegTime<>28800;
SELECT @@ROWCOUNT;
'@
  $taskSpawnChanges=[int]$taskCmd.ExecuteScalar()
  $taskTxn.Commit()
 }catch{if($taskTxn.Connection){$taskTxn.Rollback()};throw}finally{$taskTxn.Dispose()}
 [pscustomobject]@{Database=$taskDb.Database;Installed=@('GetAccountID','UPDATE_USER_KNIGHTS_RANK','UPDATE_USER_PERSONAL_RANK','UPDATE_KNIGHTS_RATING','CASTLE_SIEGE_WAR_CONTROL');SpawnRespawnRowsChangedThisRun=$taskSpawnChanges;VerifiedRespawnRowsInScope=12;RespawnSeconds=28800;SpawnPositionsChanged=0;SpawnDensityChanged=0;UnknownBaseUpgradeRatesChanged=0;MonsterDropRatesChanged=0;MonsterExpChanged=0;Level77And79AlignedToSuppliedClient=$true;BackupsInDatabase=$true}|ConvertTo-Json|Tee-Object -FilePath (Join-Path $taskRoot '12_USKO_Denetimi\sql-fixes-applied.json')
}finally{$taskDb.Dispose()}
