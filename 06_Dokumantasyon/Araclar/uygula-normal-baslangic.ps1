param([switch]$Apply)
$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskDb=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_TEMU_2239;Integrated Security=True;Encrypt=False')
try {
 $taskDb.Open();$taskTxn=$taskDb.BeginTransaction()
 try {
  $taskCmd=$taskDb.CreateCommand();$taskCmd.Transaction=$taskTxn
  $taskCmd.CommandText="SELECT COUNT(*) FROM CURRENTUSER WHERE strAccountID='KnightLab1'"
  $taskOnline=[int]$taskCmd.ExecuteScalar()
  if($Apply -and $taskOnline -ne 0){throw 'cabbar is online. Log out before applying; no data changed.'}
  $taskCmd.CommandText="SELECT u.strUserID,u.Class,u.[Level],u.Exp,u.Gold,u.strItem,u.strSerial,u.strItemTime FROM USERDATA u WITH(UPDLOCK,HOLDLOCK) JOIN ACCOUNT_CHAR a WITH(UPDLOCK,HOLDLOCK) ON a.strAccountID='KnightLab1' AND u.strUserID IN(a.strCharID1,a.strCharID2,a.strCharID3,a.strCharID4) WHERE u.strUserID='cabbar'"
  $taskData=[Data.DataTable]::new();$taskData.Load($taskCmd.ExecuteReader())
  if($taskData.Rows.Count -ne 1){throw 'Expected the existing local character cabbar'}
  $taskRow=$taskData.Rows[0];$taskClass=[int]$taskRow.Class%100
  $taskItems=([byte[]]$taskRow.strItem).Clone();$taskSerial=([byte[]]$taskRow.strSerial).Clone();$taskTime=([byte[]]$taskRow.strItemTime).Clone()
  if($taskItems.Length -ne 600 -or $taskSerial.Length -ne 600 -or $taskTime.Length -ne 300){throw 'Unexpected inventory binary layout'}
  $taskCmd.CommandText="SELECT strItem FROM BEGINNER_ITEMS WHERE iClass=$taskClass"
  $taskOld=[byte[]]$taskCmd.ExecuteScalar();if($taskOld.Length -ne 600){throw 'Missing original boosted template'}
  $taskBoosted=[Collections.Generic.HashSet[uint32]]::new()
  for($taskSlot=0;$taskSlot -lt 75;$taskSlot++){$taskID=[BitConverter]::ToUInt32($taskOld,$taskSlot*8);if($taskID -ne 0){[void]$taskBoosted.Add($taskID)}}
  $taskRemoved=[Collections.Generic.List[object]]::new()
  for($taskSlot=0;$taskSlot -lt 75;$taskSlot++) {
   $taskID=[BitConverter]::ToUInt32($taskItems,$taskSlot*8)
   if($taskBoosted.Contains($taskID)) {
    $taskRemoved.Add([pscustomobject]@{Slot=$taskSlot;Item=$taskID})
    [Array]::Clear($taskItems,$taskSlot*8,8);[Array]::Clear($taskSerial,$taskSlot*8,8);[Array]::Clear($taskTime,$taskSlot*4,4)
   }
  }
  $taskCmd.CommandText="SELECT s.SlotID,s.ItemID,i.Duration,i.strName FROM KNIGHTLAB_NORMAL_STARTER_ITEMS s JOIN ITEM i ON i.num=s.ItemID WHERE s.ClassType=$taskClass ORDER BY s.SlotID"
  $taskPreset=[Data.DataTable]::new();$taskPreset.Load($taskCmd.ExecuteReader())
  $taskAdded=[Collections.Generic.List[object]]::new()
  foreach($taskPart in $taskPreset.Rows) {
   $taskSlot=[int]$taskPart.SlotID;$taskID=[BitConverter]::ToUInt32($taskItems,$taskSlot*8)
   if($taskID -eq [uint32]$taskPart.ItemID){continue}
   if($taskID -ne 0) {
    $taskFree=-1
    for($taskBag=14;$taskBag -lt 42;$taskBag++){if([BitConverter]::ToUInt32($taskItems,$taskBag*8) -eq 0){$taskFree=$taskBag;break}}
    if($taskFree -lt 0){throw 'No bag space to preserve an earned equipped item'}
    [Array]::Copy($taskItems,$taskSlot*8,$taskItems,$taskFree*8,8);[Array]::Copy($taskSerial,$taskSlot*8,$taskSerial,$taskFree*8,8);[Array]::Copy($taskTime,$taskSlot*4,$taskTime,$taskFree*4,4)
   }
   [Array]::Copy([BitConverter]::GetBytes([uint32]$taskPart.ItemID),0,$taskItems,$taskSlot*8,4)
   [Array]::Copy([BitConverter]::GetBytes([int16]$taskPart.Duration),0,$taskItems,$taskSlot*8+4,2)
   [Array]::Copy([BitConverter]::GetBytes([int16]1),0,$taskItems,$taskSlot*8+6,2)
   [Array]::Clear($taskSerial,$taskSlot*8,8);[Array]::Clear($taskTime,$taskSlot*4,4)
   $taskAdded.Add([pscustomobject]@{Slot=$taskSlot;Item=[int]$taskPart.ItemID;Name=[string]$taskPart.strName})
  }
  $taskCmd.CommandText="SELECT m.nLetterID,m.nItemID,m.sCount,m.bStatus,m.bDeleted FROM MAIL_BOX m WHERE m.strRecipientID='cabbar' AND m.bDeleted=0 AND m.bStatus=1 AND EXISTS(SELECT 1 FROM LETTER_GIFT g WHERE g.SenderID=m.strSenderID AND g.ItemName=m.strSubject AND g.ItemID=m.nItemID AND g.ItemCount=m.sCount AND g.ItemDuration=m.sDurability)"
  $taskMail=[Data.DataTable]::new();$taskMail.Load($taskCmd.ExecuteReader())
  $taskMailIDs=@(foreach($taskLetter in $taskMail.Rows){[long]$taskLetter.nLetterID})
  if($Apply) {
   $taskBackup=Join-Path $taskRoot ('11_Istemci_Uyumluluk\normal-start-before-cabbar-'+[DateTime]::UtcNow.ToString('yyyyMMdd-HHmmss')+'.json')
   [pscustomobject]@{Character='cabbar';Level=[int]$taskRow.Level;Exp=[long]$taskRow.Exp;Gold=[long]$taskRow.Gold;Items=[Convert]::ToBase64String([byte[]]$taskRow.strItem);Serials=[Convert]::ToBase64String([byte[]]$taskRow.strSerial);Times=[Convert]::ToBase64String([byte[]]$taskRow.strItemTime);SoftDeletedStarterLetterIDs=$taskMailIDs}|ConvertTo-Json -Depth 4|Set-Content -LiteralPath $taskBackup -Encoding utf8
   foreach($taskEntry in @(@{Name='@items';Data=$taskItems},@{Name='@serial';Data=$taskSerial},@{Name='@time';Data=$taskTime})) {[void]$taskCmd.Parameters.Add($taskEntry.Name,[Data.SqlDbType]::VarBinary,$taskEntry.Data.Length);$taskCmd.Parameters[$taskEntry.Name].Value=$taskEntry.Data}
   $taskCmd.CommandText="UPDATE USERDATA SET strItem=@items,strSerial=@serial,strItemTime=@time WHERE strUserID='cabbar'"
   if($taskCmd.ExecuteNonQuery() -ne 1){throw 'Character update did not affect exactly one row'}
   if($taskMailIDs.Count -gt 0){$taskCmd.CommandText='UPDATE MAIL_BOX SET bDeleted=1 WHERE nLetterID IN('+($taskMailIDs -join ',')+')';[void]$taskCmd.ExecuteNonQuery()}
   $taskTxn.Commit()
  } else {$taskTxn.Rollback()}
  [pscustomobject]@{Applied=[bool]$Apply;Online=$taskOnline;Character='cabbar';Level=[int]$taskRow.Level;ExperiencePreserved=[long]$taskRow.Exp;NoahPreserved=[long]$taskRow.Gold;RemovedBoostedItems=@($taskRemoved);BasicItems=@($taskAdded);UnusedBoostedGiftLetters=$taskMailIDs.Count;OtherLootPreserved=$true}|ConvertTo-Json -Depth 6|Tee-Object -FilePath (Join-Path $taskRoot ('11_Istemci_Uyumluluk\normal-start-'+$(if($Apply){'applied'}else{'preview'})+'.json'))
 }catch{if($taskTxn.Connection){$taskTxn.Rollback()};throw}finally{$taskTxn.Dispose()}
}finally{$taskDb.Dispose()}
