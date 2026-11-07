$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskReport=Join-Path $taskRoot '06_Dokumantasyon\Uyarlama'
$taskMaster=[System.Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=master;Integrated Security=True;Encrypt=False;Connect Timeout=10')
function Invoke-AdaptSql($Connection,[string]$Sql) {
    $taskCmd=$Connection.CreateCommand();$taskCmd.CommandText=$Sql;$taskCmd.CommandTimeout=180
    $taskDs=[Data.DataSet]::new();$taskAdapter=[Data.SqlClient.SqlDataAdapter]::new($taskCmd);[void]$taskAdapter.Fill($taskDs)
    return ,$taskDs
}
try {
    $taskMaster.Open()
    $taskExists=Invoke-AdaptSql $taskMaster "SELECT DB_ID(N'KNIGHT_24XX_ADAPT') AS DbId;"
    if($taskExists.Tables[0].Rows[0].IsNull('DbId')) {
        $taskBackup='C:\ProgramData\KnightOnlineLab\Backups\v24xx-original.bak'
        if(-not (Test-Path -LiteralPath $taskBackup -PathType Leaf)){throw 'Original backup copy is missing.'}
        $taskDefault=Invoke-AdaptSql $taskMaster "SELECT CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS nvarchar(4000)) AS DataDir;"
        $taskDataDir=[string]$taskDefault.Tables[0].Rows[0].DataDir
        $taskDataFile=Join-Path $taskDataDir 'KNIGHT_24XX_ADAPT_0.mdf'
        $taskLogFile=Join-Path $taskDataDir 'KNIGHT_24XX_ADAPT_1.ldf'
        if((Test-Path -LiteralPath $taskDataFile) -or (Test-Path -LiteralPath $taskLogFile)){throw 'Adapt database file path already exists; refusing to replace it.'}
        $taskSql="RESTORE DATABASE [KNIGHT_24XX_ADAPT] FROM DISK=N'$($taskBackup.Replace("'","''"))' WITH MOVE N'KN_Online_Data' TO N'$($taskDataFile.Replace("'","''"))', MOVE N'KN_Online_Log' TO N'$($taskLogFile.Replace("'","''"))', RECOVERY;"
        [void](Invoke-AdaptSql $taskMaster $taskSql)
    }
} finally {$taskMaster.Dispose()}
$taskDb=[System.Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_24XX_ADAPT;Integrated Security=True;Encrypt=False;Connect Timeout=10')
try {
    $taskDb.Open()
    if($taskDb.Database -ne 'KNIGHT_24XX_ADAPT'){throw 'Wrong database selected.'}
    $taskProc=Get-Content -LiteralPath (Join-Path $taskRoot '08_Arastirma_Adaylari\SQL_Referans\UPDATE_ALL_CHAR_ID.sql') -Raw
    $taskProc=$taskProc -replace 'CREATE PROCEDURE \[dbo\]\.\[UPDATE_ALL_CHAR_ID\]','CREATE OR ALTER PROCEDURE [dbo].[UPDATE_ALL_CHAR_ID]'
    [void](Invoke-AdaptSql $taskDb $taskProc)
    $taskTransaction=$taskDb.BeginTransaction()
    try {
        $taskCmd=$taskDb.CreateCommand();$taskCmd.Transaction=$taskTransaction
        $taskCmd.CommandText=@'
IF EXISTS(SELECT 1 FROM dbo.ACCOUNT_CHAR WHERE strAccountID IN ('__KO_ADAPT_A__','__KO_ADAPT_B__')) THROW 51000,'Test account already exists; refusing to alter it.',1;
INSERT INTO dbo.ACCOUNT_CHAR(strAccountID,bNation,bCharNum,strCharID1,strCharID2,strCharID3,strCharID4)
VALUES('__KO_ADAPT_A__',1,4,'BeforeA','','',''),('__KO_ADAPT_B__',2,1,'BeforeB','','','');
EXEC dbo.UPDATE_ALL_CHAR_ID '__KO_ADAPT_A__','AdaptChar1','AdaptChar2','AdaptChar3','AdaptChar4';
IF NOT EXISTS(SELECT 1 FROM dbo.ACCOUNT_CHAR WHERE strAccountID='__KO_ADAPT_A__' AND strCharID1='AdaptChar1' AND strCharID2='AdaptChar2' AND strCharID3='AdaptChar3' AND strCharID4='AdaptChar4' AND bNation=1 AND bCharNum=4) THROW 51001,'Target account assertion failed.',1;
IF NOT EXISTS(SELECT 1 FROM dbo.ACCOUNT_CHAR WHERE strAccountID='__KO_ADAPT_B__' AND strCharID1='BeforeB' AND bNation=2 AND bCharNum=1) THROW 51002,'Other account was changed.',1;
'@
        [void]$taskCmd.ExecuteNonQuery()
    } finally {$taskTransaction.Rollback();$taskTransaction.Dispose()}
    $taskCheck=Invoke-AdaptSql $taskDb "SELECT DB_NAME() AS DatabaseName, (SELECT COUNT(*) FROM sys.procedures WHERE name='UPDATE_ALL_CHAR_ID') AS ProcedureCount, (SELECT COUNT(*) FROM dbo.ACCOUNT_CHAR WHERE strAccountID IN ('__KO_ADAPT_A__','__KO_ADAPT_B__')) AS ResidualTestAccounts;"
    $taskResult=[pscustomobject]@{Database=[string]$taskCheck.Tables[0].Rows[0].DatabaseName;ProcedureCount=[int]$taskCheck.Tables[0].Rows[0].ProcedureCount;ResidualTestAccounts=[int]$taskCheck.Tables[0].Rows[0].ResidualTestAccounts;FiveParameterUpdateTestPassed=$true;OtherAccountUnchanged=$true;NationAndCharacterCountUnchanged=$true;TestDataRolledBack=$true;OriginalDatabase='KNIGHT_24XX_TEST';Utc=[DateTime]::UtcNow.ToString('o')}
    $taskResult | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $taskReport 'sql-uyarlama-testi.json') -Encoding utf8
    $taskResult | ConvertTo-Json
} finally {$taskDb.Dispose()}
