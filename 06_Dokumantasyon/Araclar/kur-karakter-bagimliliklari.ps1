$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskPrepared=Join-Path $taskRoot '10_Kaynak_Derleme\Veritabani_Hazirlik'
$taskSql=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_TEMU_2239;Integrated Security=True;Encrypt=False')
try {
 $taskSql.Open();$taskTxn=$taskSql.BeginTransaction();$taskReport=[Collections.Generic.List[object]]::new()
 try {
  $taskCmd=$taskSql.CreateCommand();$taskCmd.Transaction=$taskTxn
  $taskCmd.CommandText=[IO.File]::ReadAllText((Join-Path $taskPrepared 'normal-baslangic.sql'))
  [void]$taskCmd.ExecuteNonQuery()
  $taskCmd.CommandText="SELECT COUNT(*) FROM sys.objects WHERE object_id=OBJECT_ID('dbo.IsValidCharacters') AND type='FN'"
  if($taskCmd.ExecuteScalar() -eq 0) {
   $taskCmd.CommandText=[IO.File]::ReadAllText((Join-Path $taskPrepared 'Functions\IsValidCharacters.sql'))
   [void]$taskCmd.ExecuteNonQuery()
  }
  foreach($taskName in @('LOAD_NEW_CHAR_VALUE','LOAD_NEW_CHAR_SET','DELETE_GM','CREATE_NEW_CHAR')) {
   $taskCmd.CommandText="SELECT definition FROM sys.sql_modules WHERE object_id=OBJECT_ID('dbo.$taskName')"
   $taskOld=$taskCmd.ExecuteScalar()
   $taskBackup=Join-Path $taskRoot "11_Istemci_Uyumluluk\$taskName-before-character-fix.sql"
   if($taskOld -is [string] -and -not(Test-Path -LiteralPath $taskBackup)){[IO.File]::WriteAllText($taskBackup,$taskOld,[Text.UTF8Encoding]::new($false))}
   $taskDefinition=[IO.File]::ReadAllText((Join-Path $taskPrepared "Procedures\$taskName.sql"))
   if($taskOld -is [string]){$taskDefinition=$taskDefinition.Replace('CREATE PROCEDURE','ALTER PROCEDURE')}
   $taskCmd.CommandText=$taskDefinition;[void]$taskCmd.ExecuteNonQuery()
   $taskReport.Add([pscustomobject]@{Kind='AuthoredProcedure';Name=$taskName})
  }
  foreach($taskName in @('letter_gift','user_achieve_load_data')) {
   $taskInput=Get-Content -LiteralPath (Join-Path $taskPrepared "CharacterDependencies\$taskName.json") -Raw|ConvertFrom-Json
   $taskCmd.CommandText="SELECT COUNT(*) FROM dbo.[$taskName]";$taskCount=[int]$taskCmd.ExecuteScalar()
   if($taskCount -eq 0) {
    $taskCmd.CommandText="SELECT TOP(0) * FROM dbo.[$taskName]";$taskData=[Data.DataTable]::new();$taskReader=$taskCmd.ExecuteReader();$taskData.Load($taskReader);$taskReader.Dispose()
    foreach($taskValues in $taskInput.Rows) {
     $taskRow=$taskData.NewRow()
     for($taskIndex=0;$taskIndex -lt $taskInput.Columns.Count;$taskIndex++) {
      $taskColumn=[string]$taskInput.Columns[$taskIndex];$taskValue=$taskValues[$taskIndex]
      if($null -eq $taskValue){$taskRow[$taskColumn]=[DBNull]::Value}
      elseif($taskData.Columns[$taskColumn].DataType -eq [byte[]]) {
       if(-not ([string]$taskValue).StartsWith('\x')){throw 'Unexpected authored binary format'}
       $taskRow[$taskColumn]=[Convert]::FromHexString(([string]$taskValue).Substring(2))
      } else {$taskRow[$taskColumn]=$taskValue}
     }
     [void]$taskData.Rows.Add($taskRow)
    }
    $taskBulk=[Data.SqlClient.SqlBulkCopy]::new($taskSql,[Data.SqlClient.SqlBulkCopyOptions]::KeepIdentity,$taskTxn)
    try{$taskBulk.DestinationTableName="dbo.[$taskName]";foreach($taskCol in $taskInput.Columns){[void]$taskBulk.ColumnMappings.Add([string]$taskCol,[string]$taskCol)};$taskBulk.WriteToServer($taskData)}finally{$taskBulk.Dispose();$taskData.Dispose()}
   } elseif($taskCount -ne $taskInput.Rows.Count){throw 'Configuration table is populated differently; refusing to overwrite it'}
   $taskReport.Add([pscustomobject]@{Kind='AuthoredStaticTemplate';Name=$taskName;Rows=$taskInput.Rows.Count})
  }
  # The PostgreSQL conversion retained Lisp-style byte vectors as ASCII. Decode only
  # recognized 600-byte static templates; refuse unrelated or malformed contents.
  $taskCmd.CommandText='SELECT iClass,strItem FROM dbo.BEGINNER_ITEMS'
  $taskTemplates=[Data.DataTable]::new();$taskTemplates.Load($taskCmd.ExecuteReader())
  $taskTemplateBackup=Join-Path $taskRoot '11_Istemci_Uyumluluk\beginner-items-before-binary-fix.json'
  if(-not(Test-Path -LiteralPath $taskTemplateBackup)) {
   @(foreach($taskTemplate in $taskTemplates.Rows){[pscustomobject]@{Class=$taskTemplate.iClass;Base64=[Convert]::ToBase64String([byte[]]$taskTemplate.strItem)}})|ConvertTo-Json|Set-Content -LiteralPath $taskTemplateBackup -Encoding utf8
  }
  foreach($taskTemplate in $taskTemplates.Rows) {
   $taskRaw=[byte[]]$taskTemplate.strItem
   if($taskRaw.Length -eq 600){continue}
   $taskText=[Text.Encoding]::ASCII.GetString($taskRaw)
   if($taskText -notmatch '^#\([\s\d]+\)$'){throw 'Unrecognized starter inventory encoding'}
   $taskNumbers=[regex]::Matches($taskText,'\d+')
   if($taskNumbers.Count -ne 600){throw 'Incorrect starter inventory byte count'}
   $taskBytes=[byte[]]::new(600)
   for($taskIndex=0;$taskIndex -lt 600;$taskIndex++){$taskBytes[$taskIndex]=[byte]::Parse($taskNumbers[$taskIndex].Value)}
   $taskCmd.Parameters.Clear()
   [void]$taskCmd.Parameters.Add('@items',[Data.SqlDbType]::VarBinary,600);$taskCmd.Parameters['@items'].Value=$taskBytes
   [void]$taskCmd.Parameters.AddWithValue('@class',[int]$taskTemplate.iClass)
   $taskCmd.CommandText='UPDATE dbo.BEGINNER_ITEMS SET strItem=@items WHERE iClass=@class'
   [void]$taskCmd.ExecuteNonQuery()
   $taskReport.Add([pscustomobject]@{Kind='DecodedStaticInventory';Class=$taskTemplate.iClass;Bytes=600})
  }
  $taskCmd.Parameters.Clear()
  $taskCmd.CommandText='SELECT sStatus,strAchieve FROM dbo.USER_ACHIEVE_LOAD_DATA'
  $taskAchieveTemplates=[Data.DataTable]::new();$taskAchieveTemplates.Load($taskCmd.ExecuteReader())
  foreach($taskTemplate in $taskAchieveTemplates.Rows) {
   $taskRaw=[byte[]]$taskTemplate.strAchieve
   if($taskRaw.Length -eq 5200){continue}
   $taskText=[Text.Encoding]::ASCII.GetString($taskRaw)
   if($taskText -notmatch '^#\([\s\d]+\)$'){throw 'Unrecognized achievement template encoding'}
   $taskNumbers=[regex]::Matches($taskText,'\d+')
   if($taskNumbers.Count -ne 5200){throw 'Incorrect achievement template byte count'}
   $taskBytes=[byte[]]::new(5200)
   for($taskIndex=0;$taskIndex -lt 5200;$taskIndex++){$taskBytes[$taskIndex]=[byte]::Parse($taskNumbers[$taskIndex].Value)}
   $taskCmd.Parameters.Clear();[void]$taskCmd.Parameters.Add('@data',[Data.SqlDbType]::VarBinary,5200);$taskCmd.Parameters['@data'].Value=$taskBytes
   [void]$taskCmd.Parameters.AddWithValue('@status',[int]$taskTemplate.sStatus)
   $taskCmd.CommandText='UPDATE dbo.USER_ACHIEVE_LOAD_DATA SET strAchieve=@data WHERE sStatus=@status'
   [void]$taskCmd.ExecuteNonQuery()
   $taskReport.Add([pscustomobject]@{Kind='DecodedStaticAchievement';Status=$taskTemplate.sStatus;Bytes=5200})
  }
  $taskCmd.Parameters.Clear()
  # Type 4 has no matching authored start-level row; type 0 is the normal level-1 profile.
  $taskCmd.CommandText='UPDATE dbo.BEGINNER_SETTINGS SET BeginnerType=0 WHERE ServerNo=1 AND BeginnerType=4;'
  $taskChanged=$taskCmd.ExecuteNonQuery()
  $taskCmd.CommandText='SELECT BeginnerType FROM BEGINNER_SETTINGS WHERE ServerNo=1'
  $taskBeginnerType=[int]$taskCmd.ExecuteScalar()
  $taskTxn.Commit()
 }catch{if($taskTxn.Connection){$taskTxn.Rollback()};throw}finally{$taskTxn.Dispose()}
 [pscustomobject]@{Database=$taskSql.Database;Dependencies=@($taskReport);NormalLevelOneProfileSelected=($taskBeginnerType -eq 0);StarterProfileChangedThisRun=($taskChanged -gt 0);ExistingPlayerRowsUpdated=0;OriginalDatabasesChanged=$false}|ConvertTo-Json -Depth 6|Tee-Object -FilePath (Join-Path $taskRoot '11_Istemci_Uyumluluk\character-dependencies-install.json')
}finally{$taskSql.Dispose()}
