$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskOut=Join-Path $taskRoot '12_USKO_Denetimi'
New-Item -ItemType Directory -Path $taskOut -Force|Out-Null
$taskDb=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_TEMU_2239;Integrated Security=True;Encrypt=False')
$taskQueries=[ordered]@{
 'levels'='SELECT * FROM LEVEL_UP ORDER BY RebithLevel,[Level]';
 'upgrade-rates'='SELECT nReqItem1,ScrollName,UpgradeNote,nGenRate,nReqNoah,COUNT(*) AS DefinitionCount FROM ITEM_UPGRADE GROUP BY nReqItem1,ScrollName,UpgradeNote,nGenRate,nReqNoah ORDER BY nReqItem1,UpgradeNote';
 'spawn-map'='SELECT p.*,COALESCE(m.strName,n.strName) AS PrototypeName,CASE WHEN m.sSid IS NOT NULL THEN ''Monster'' WHEN n.sSid IS NOT NULL THEN ''Npc'' ELSE ''Missing'' END AS PrototypeKind,z.strZoneName,z.strZoneSmdName FROM K_NPCPOS p LEFT JOIN K_MONSTER m ON m.sSid=p.NpcID LEFT JOIN K_NPC n ON n.sSid=p.NpcID LEFT JOIN ZONE_INFO z ON z.ZoneNo=p.ZoneID ORDER BY p.ZoneID,p.NpcID,p.LeftX,p.TopZ';
 'spawn-summary'='SELECT p.ZoneID,z.strZoneName,COUNT(*) AS Rows,SUM(CONVERT(bigint,p.NumNPC)) AS SpawnCount,MIN(p.RegTime) AS MinRespawnSeconds,MAX(p.RegTime) AS MaxRespawnSeconds FROM K_NPCPOS p LEFT JOIN ZONE_INFO z ON z.ZoneNo=p.ZoneID GROUP BY p.ZoneID,z.strZoneName ORDER BY p.ZoneID';
 'events'='SELECT * FROM EVENT_START_SCHEDULE ORDER BY EventLocalID';
 'variable-respawn'='SELECT * FROM MONSTER_RESPAWN_VARIABLE_LIST ORDER BY sIndex';
 'stable-respawn'='SELECT * FROM MONSTER_RESPAWN_STABLE_LIST ORDER BY sIndex';
 'drop-definitions'='SELECT * FROM K_MONSTER_ITEM ORDER BY sIndex';
 'monster-base'='SELECT sSid,strName,sLevel,iExp,iMoney,iLoyalty,sItem,iHpPoint,sPid FROM K_MONSTER ORDER BY sSid';
 'missing-sql-dependencies'="SELECT DISTINCT OBJECT_NAME(referencing_id) AS Caller,referenced_database_name AS ReferencedDatabase,referenced_schema_name AS ReferencedSchema,referenced_entity_name AS MissingName FROM sys.sql_expression_dependencies WHERE referenced_id IS NULL AND referenced_database_name IS NULL AND referenced_server_name IS NULL AND is_caller_dependent=0 ORDER BY Caller,MissingName";
 'schema'="SELECT t.name AS TableName,c.name AS ColumnName,ty.name AS DataType FROM sys.tables t JOIN sys.columns c ON t.object_id=c.object_id JOIN sys.types ty ON ty.user_type_id=c.user_type_id WHERE t.name IN('K_NPCPOS','K_MONSTER','K_MONSTER_ITEM','MAKE_ITEM_GROUP','ITEM_UPGRADE','LEVEL_UP','EVENT_START_SCHEDULE') ORDER BY t.name,c.column_id";
}
try {
 $taskDb.Open();$taskSummary=[ordered]@{Utc=[DateTime]::UtcNow.ToString('o');Database=$taskDb.Database;ReadOnly=$true;Outputs=@()}
 foreach($taskName in $taskQueries.Keys) {
  $taskCmd=$taskDb.CreateCommand();$taskCmd.CommandTimeout=90;$taskCmd.CommandText=$taskQueries[$taskName]
  $taskTable=[Data.DataTable]::new();$taskTable.Load($taskCmd.ExecuteReader())
  $taskRows=@(foreach($taskRow in $taskTable.Rows){$taskObject=[ordered]@{};foreach($taskCol in $taskTable.Columns){$taskValue=$taskRow[$taskCol];$taskObject[$taskCol.ColumnName]=$(if($taskValue -is [DBNull]){$null}else{$taskValue})};[pscustomobject]$taskObject})
  $taskRows|ConvertTo-Json -Depth 5 -AsArray|Set-Content -LiteralPath (Join-Path $taskOut ($taskName+'.json')) -Encoding utf8
  if($taskName -in 'spawn-map','spawn-summary','upgrade-rates'){$taskRows|Export-Csv -LiteralPath (Join-Path $taskOut ($taskName+'.csv')) -NoTypeInformation -Encoding utf8}
  $taskSummary.Outputs+=@{Name=$taskName;Rows=$taskRows.Count};$taskTable.Dispose();$taskCmd.Dispose()
 }
 $taskSummary|ConvertTo-Json -Depth 5|Tee-Object -FilePath (Join-Path $taskOut 'audit-summary.json')
}finally{$taskDb.Dispose()}
