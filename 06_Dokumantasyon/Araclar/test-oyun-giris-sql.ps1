$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskCredentials=Get-Content -LiteralPath (Join-Path $taskRoot '11_Istemci_Uyumluluk\local-test-account.private.json') -Raw|ConvertFrom-Json
if($taskCredentials.Account -ne 'KnightLab1' -or $taskCredentials.Database -ne 'KNIGHT_TEMU_2239'){throw 'Unexpected test account'}
$taskSql=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_TEMU_2239;Integrated Security=True;Encrypt=False')
try {
 $taskSql.Open();$taskTransaction=$taskSql.BeginTransaction()
 try {
  $taskCmd=$taskSql.CreateCommand();$taskCmd.Transaction=$taskTransaction
  [void]$taskCmd.Parameters.AddWithValue('@account',[string]$taskCredentials.Account)
  [void]$taskCmd.Parameters.AddWithValue('@plain',[string]$taskCredentials.Password)
  $taskCmd.CommandText=@'
DECLARE @r int,@encoded varchar(28)=dbo.HashPasswordString(@plain),@wrong varchar(28)=dbo.HashPasswordString('WrongLocal123');
IF NOT EXISTS(SELECT 1 FROM ACCOUNT_CHAR WHERE strAccountID=@account AND bNation=0 AND bCharNum=0 AND strCharID1='' AND strCharID2='' AND strCharID3='' AND strCharID4='') THROW 51000,'Test account is no longer fresh',1;
EXEC @r=dbo.GAME_LOGIN_V2 @account,@encoded;
IF @r<>0 THROW 51001,'Fresh account cannot reach nation selection',1;
EXEC @r=dbo.GAME_LOGIN_V2 @account,@wrong;
IF @r<>-1 THROW 51002,'Wrong password accepted',1;
DECLARE @authority tinyint=(SELECT strAuthority FROM TB_USER WHERE strAccountID=@account);
UPDATE TB_USER SET strAuthority=9 WHERE strAccountID=@account;
EXEC @r=dbo.GAME_LOGIN_V2 @account,@encoded;
IF @r<>-1 THROW 51003,'Blocked account accepted',1;
UPDATE TB_USER SET strAuthority=@authority WHERE strAccountID=@account;
UPDATE ACCOUNT_CHAR SET bNation=3 WHERE strAccountID=@account;
EXEC @r=dbo.GAME_LOGIN_V2 @account,@encoded;
IF @r<>30 THROW 51004,'Invalid nation accepted',1;
UPDATE ACCOUNT_CHAR SET bNation=0,bCharNum=1 WHERE strAccountID=@account;
EXEC @r=dbo.GAME_LOGIN_V2 @account,@encoded;
IF @r<>30 THROW 51005,'Inconsistent character state accepted',1;
'@
  [void]$taskCmd.ExecuteNonQuery()
 }finally{$taskTransaction.Rollback();$taskTransaction.Dispose()}
 [pscustomobject]@{FreshAccountNationSelectionAllowed=$true;WrongPasswordRejected=$true;BlockedAccountRejected=$true;InvalidNationRejected=$true;InconsistentCharacterStateRejected=$true;AllTestChangesRolledBack=$true;CredentialsLogged=$false}|ConvertTo-Json|Tee-Object -FilePath (Join-Path $taskRoot '11_Istemci_Uyumluluk\game-account-sql-test.json')
}finally{$taskSql.Dispose()}
