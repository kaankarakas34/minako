$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskPrivate=Join-Path $taskRoot '11_Istemci_Uyumluluk\local-test-account.private.json'
$taskAccount='KnightLab1'
if(Test-Path -LiteralPath $taskPrivate){$taskCredentials=Get-Content -LiteralPath $taskPrivate -Raw|ConvertFrom-Json}
else {
    $taskAlphabet='ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789'
    $taskPassword=-join (1..12|ForEach-Object{$taskAlphabet[[Security.Cryptography.RandomNumberGenerator]::GetInt32($taskAlphabet.Length)]})
    $taskCredentials=[pscustomobject]@{Account=$taskAccount;Password=$taskPassword;Database='KNIGHT_TEMU_2239';Purpose='Local game test only; not an imported player account.'}
}
if($taskCredentials.Account -ne $taskAccount -or $taskCredentials.Database -ne 'KNIGHT_TEMU_2239'){throw 'Unexpected credential file.'}
$taskConnection=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_TEMU_2239;Integrated Security=True;Encrypt=False')
try {
    $taskConnection.Open()
    $taskCommand=$taskConnection.CreateCommand()
    $taskCommand.CommandText="SELECT COUNT(*) FROM sys.objects WHERE object_id=OBJECT_ID('dbo.HashPasswordString') AND type='FN'"
    if($taskCommand.ExecuteScalar() -eq 0) {
        $taskFunction=Join-Path $taskRoot '10_Kaynak_Derleme\Veritabani_Hazirlik\Functions\HashPasswordString.sql'
        $taskCommand.CommandText=[IO.File]::ReadAllText($taskFunction)
        [void]$taskCommand.ExecuteNonQuery()
    }
    [void]$taskCommand.Parameters.AddWithValue('@account',$taskAccount)
    $taskCommand.CommandText='SELECT dbo.HashPasswordString(@plain)'
    [void]$taskCommand.Parameters.AddWithValue('@plain',[string]$taskCredentials.Password)
    $taskEncodedPassword=[string]$taskCommand.ExecuteScalar()
    [void]$taskCommand.Parameters.AddWithValue('@password',$taskEncodedPassword)
    $taskCommand.CommandText=@'
SET XACT_ABORT ON;
BEGIN TRANSACTION;
IF NOT EXISTS(SELECT 1 FROM dbo.TB_USER WHERE strAccountID=@account)
BEGIN
 INSERT INTO dbo.TB_USER(strAccountID,strPasswd,strSealPasswd,OTPPassword,bPremiumType,dtCreateTime,strAuthority)
 VALUES(@account,@password,'LabSea91','739415',0,GETDATE(),1);
 INSERT INTO dbo.ACCOUNT_LOGIN_CONTROL(strAccountID,BanGameMasterName,isAuthority,BanReason,BanCount,OpenCount,UpdateTime)
 VALUES(@account,'',1,'',0,0,GETDATE());
 INSERT INTO dbo.ACCOUNT_CHAR(strAccountID,bNation,bCharNum,strCharID1,strCharID2,strCharID3,strCharID4)
 VALUES(@account,0,0,'','','','');
END
ELSE IF NOT EXISTS(SELECT 1 FROM dbo.TB_USER WHERE strAccountID=@account AND strPasswd=@password)
 THROW 51001,'Existing local account has a different password; no replacement allowed.',1;
COMMIT;
'@
    [void]$taskCommand.ExecuteNonQuery()
    $taskCredentials|ConvertTo-Json|Set-Content -LiteralPath $taskPrivate -Encoding utf8
    $taskTransaction=$taskConnection.BeginTransaction()
    try {
        $taskCommand.Transaction=$taskTransaction
        $taskCommand.CommandText=@'
DECLARE @r int;
UPDATE dbo.GAME_OPTIONS SET AutoRegister=0,OpenOTP=0;
EXEC @r=dbo.ACCOUNT_LOGIN @account,@password;
IF @r<>1 THROW 51002,'Valid login test failed.',1;
DECLARE @wrong varchar(28)=dbo.HashPasswordString('WrongLocal123');
EXEC @r=dbo.ACCOUNT_LOGIN @account,@wrong;
IF @r<>3 THROW 51003,'Wrong password was not rejected.',1;
EXEC @r=dbo.ACCOUNT_LOGIN '__KO_MISSING_TEST__',@wrong;
IF @r<>2 THROW 51004,'Unknown account test failed.',1;
UPDATE dbo.ACCOUNT_LOGIN_CONTROL SET isAuthority=0 WHERE strAccountID=@account;
EXEC @r=dbo.ACCOUNT_LOGIN @account,@password;
IF @r<>4 THROW 51005,'Blocked account was not rejected.',1;
UPDATE dbo.ACCOUNT_LOGIN_CONTROL SET isAuthority=1 WHERE strAccountID=@account;
INSERT INTO dbo.CURRENTUSER VALUES(@account,'__KO_LAB_PROBE__',1,'127.0.0.1','127.0.0.1');
EXEC @r=dbo.ACCOUNT_LOGIN @account,@password;
IF @r<>5 THROW 51006,'Already-online login test failed.',1;
IF EXISTS(SELECT 1 FROM dbo.CURRENTUSER WHERE strAccountID=@account) THROW 51007,'Stale local session was not cleared.',1;
'@
        [void]$taskCommand.ExecuteNonQuery()
    } finally {$taskTransaction.Rollback();$taskTransaction.Dispose()}
    [pscustomobject]@{Account=$taskAccount;Database=$taskConnection.Database;ValidLoginPassed=$true;WrongPasswordRejected=$true;UnknownAccountRejected=$true;BlockedAccountRejected=$true;AlreadyOnlineHandled=$true;TemporaryChangesRolledBack=$true;PasswordStoredLocally=$true;ImportedPlayerAccounts=0} | ConvertTo-Json | Tee-Object -FilePath (Join-Path $taskRoot '06_Dokumantasyon\Derleme\local-account-sql-test.json')
}finally{$taskConnection.Dispose()}
