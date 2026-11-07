$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskSql=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_TEMU_2239;Integrated Security=True;Encrypt=False')
try {
 $taskSql.Open();$taskTxn=$taskSql.BeginTransaction()
 try {
  $taskCmd=$taskSql.CreateCommand();$taskCmd.Transaction=$taskTxn
  $taskCmd.CommandText=@'
IF EXISTS(SELECT 1 FROM CURRENTUSER WHERE strAccountID='KnightLab1') THROW 51030,'Local character is online',1;
SELECT u.strUserID,u.strAchieve FROM USER_ACHIEVE_DATA u JOIN USERDATA d ON d.strUserID=u.strUserID JOIN ACCOUNT_CHAR a ON a.strAccountID='KnightLab1' AND u.strUserID IN(a.strCharID1,a.strCharID2,a.strCharID3,a.strCharID4)
WHERE d.[Level]=1 AND d.Zone=21 AND SUBSTRING(u.strAchieve,1,2)=0x2328;
'@
  $taskRows=[Data.DataTable]::new();$taskRows.Load($taskCmd.ExecuteReader())
  $taskOriginalJson=Get-Content -LiteralPath (Join-Path $taskRoot '10_Kaynak_Derleme\Veritabani_Hazirlik\CharacterDependencies\user_achieve_load_data.json') -Raw|ConvertFrom-Json
  $taskOriginal=[Convert]::FromHexString(([string]$taskOriginalJson.Rows[0][5]).Substring(2))
  $taskRepaired=[Collections.Generic.List[string]]::new()
  foreach($taskRow in $taskRows.Rows) {
   if([Convert]::ToBase64String([byte[]]$taskRow.strAchieve) -cne [Convert]::ToBase64String($taskOriginal)){throw 'Achievement data differs from known corrupt initial template'}
   $taskBackup=Join-Path $taskRoot ('11_Istemci_Uyumluluk\character-achievement-before-repair-'+[string]$taskRow.strUserID+'.json')
   if(Test-Path -LiteralPath $taskBackup){throw 'Achievement repair backup already exists'}
   [pscustomobject]@{Character=[string]$taskRow.strUserID;DataBase64=[Convert]::ToBase64String([byte[]]$taskRow.strAchieve)}|ConvertTo-Json|Set-Content -LiteralPath $taskBackup -Encoding utf8
   $taskCmd.Parameters.Clear();[void]$taskCmd.Parameters.AddWithValue('@char',[string]$taskRow.strUserID)
   $taskCmd.CommandText='UPDATE u SET strAchieve=t.strAchieve FROM USER_ACHIEVE_DATA u CROSS JOIN USER_ACHIEVE_LOAD_DATA t WHERE u.strUserID=@char AND t.sStatus=1 AND DATALENGTH(t.strAchieve)=5200'
   if($taskCmd.ExecuteNonQuery() -ne 1){throw 'Achievement repair did not update exactly one row'}
   $taskRepaired.Add([string]$taskRow.strUserID)
  }
  $taskTxn.Commit()
 }catch{if($taskTxn.Connection){$taskTxn.Rollback()};throw}finally{$taskTxn.Dispose()}
 [pscustomobject]@{Database=$taskSql.Database;RepairedCharacters=@($taskRepaired);OnlyExactCorruptStarterTemplatesReplaced=$true;BackupSaved=$true}|ConvertTo-Json|Tee-Object -FilePath (Join-Path $taskRoot '11_Istemci_Uyumluluk\character-achievement-repair.json')
}finally{$taskSql.Dispose()}
