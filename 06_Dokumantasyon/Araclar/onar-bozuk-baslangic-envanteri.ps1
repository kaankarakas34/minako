$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskSql=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_TEMU_2239;Integrated Security=True;Encrypt=False')
try {
 $taskSql.Open();$taskTxn=$taskSql.BeginTransaction()
 try {
  $taskCmd=$taskSql.CreateCommand();$taskCmd.Transaction=$taskTxn
  $taskCmd.CommandText=@'
IF EXISTS(SELECT 1 FROM CURRENTUSER WHERE strAccountID='KnightLab1') THROW 51020,'Local player is online; no inventory repair allowed',1;
SELECT u.strUserID,u.Class,u.strItem,u.strItemTime FROM USERDATA u JOIN ACCOUNT_CHAR a ON a.strAccountID='KnightLab1' AND u.strUserID IN(a.strCharID1,a.strCharID2,a.strCharID3,a.strCharID4)
WHERE u.[Level]=1 AND u.Zone=21 AND SUBSTRING(u.strItem,1,2)=0x2328;
'@
  $taskData=[Data.DataTable]::new();$taskData.Load($taskCmd.ExecuteReader())
  $taskBackupInput=Get-Content -LiteralPath (Join-Path $taskRoot '11_Istemci_Uyumluluk\beginner-items-before-binary-fix.json') -Raw|ConvertFrom-Json
  $taskRepaired=[Collections.Generic.List[string]]::new()
  foreach($taskRow in $taskData.Rows) {
   $taskOld=@($taskBackupInput|Where-Object {$_.Class -eq ([int]$taskRow.Class % 100)})
   if($taskOld.Count -ne 1){throw 'Missing original starter template'}
   $taskOriginal=[Convert]::FromBase64String($taskOld[0].Base64)
   $taskCurrent=[byte[]]$taskRow.strItem
   if($taskCurrent.Length -ne 600 -or $taskOriginal.Length -le 600){throw 'Unexpected corrupt inventory length'}
   for($taskIndex=0;$taskIndex -lt 600;$taskIndex++){if($taskCurrent[$taskIndex] -ne $taskOriginal[$taskIndex]){throw 'Inventory differs from the known corrupt starter template; refusing overwrite'}}
   $taskBackup=Join-Path $taskRoot ('11_Istemci_Uyumluluk\character-inventory-before-repair-'+[string]$taskRow.strUserID+'.json')
   if(Test-Path -LiteralPath $taskBackup){throw 'Character repair backup already exists; inspect before repeating'}
   [pscustomobject]@{Character=[string]$taskRow.strUserID;Class=[int]$taskRow.Class;ItemBase64=[Convert]::ToBase64String($taskCurrent);TimeBase64=[Convert]::ToBase64String([byte[]]$taskRow.strItemTime)}|ConvertTo-Json|Set-Content -LiteralPath $taskBackup -Encoding utf8
   $taskCmd.Parameters.Clear();[void]$taskCmd.Parameters.AddWithValue('@char',[string]$taskRow.strUserID);[void]$taskCmd.Parameters.AddWithValue('@class',[int]$taskRow.Class)
   $taskCmd.CommandText='EXEC dbo.LOAD_NEW_CHAR_SET @char,@class; IF NOT EXISTS(SELECT 1 FROM USERDATA WHERE strUserID=@char AND DATALENGTH(strItem)=600 AND DATALENGTH(strItemTime)=300 AND SUBSTRING(strItem,1,2)<>0x2328) THROW 51021,''Inventory repair failed'',1;'
   [void]$taskCmd.ExecuteNonQuery();$taskRepaired.Add([string]$taskRow.strUserID)
  }
  $taskTxn.Commit()
 }catch{if($taskTxn.Connection){$taskTxn.Rollback()};throw}finally{$taskTxn.Dispose()}
 [pscustomobject]@{Database=$taskSql.Database;RepairedCharacters=@($taskRepaired);OnlyExactCorruptStarterTemplatesReplaced=$true;CharacterStatsChanged=$false;BackupSaved=$true}|ConvertTo-Json|Tee-Object -FilePath (Join-Path $taskRoot '11_Istemci_Uyumluluk\character-inventory-repair.json')
}finally{$taskSql.Dispose()}
