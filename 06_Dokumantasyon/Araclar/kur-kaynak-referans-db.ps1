$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskOut=Join-Path $taskRoot '06_Dokumantasyon\Derleme'
$taskInput=Join-Path $taskRoot '08_Arastirma_Adaylari\AKGame_Veritabani\KO_DATABASE_SERVER_001.bak'
$taskExpectedHash='1961b62711f6a4e9c7e1cd8624e89be93dc15458fc973fd96c3aa98b3486ea58'
if((Get-Item -LiteralPath $taskInput).Length -ne 668164096){throw 'Download has not completed.'}
if((Get-FileHash -LiteralPath $taskInput -Algorithm SHA256).Hash -ne $taskExpectedHash){throw 'Backup integrity mismatch.'}
$taskBackup='C:\ProgramData\KnightOnlineLab\Backups\akgame-reference.bak'
if(-not (Test-Path -LiteralPath $taskBackup)) {Copy-Item -LiteralPath $taskInput -Destination $taskBackup}
if((Get-FileHash -LiteralPath $taskBackup -Algorithm SHA256).Hash -ne $taskExpectedHash){throw 'Service-readable backup mismatch.'}
$taskMaster=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=master;Integrated Security=True;Encrypt=False;Connect Timeout=10')
function Invoke-KnightRefSql($Connection,[string]$Sql) {
    $taskCommand=$Connection.CreateCommand();$taskCommand.CommandTimeout=600;$taskCommand.CommandText=$Sql
    $taskSet=[Data.DataSet]::new();$taskAdapter=[Data.SqlClient.SqlDataAdapter]::new($taskCommand);[void]$taskAdapter.Fill($taskSet)
    return ,$taskSet
}
try {
    $taskMaster.Open()
    $taskHeader=Invoke-KnightRefSql $taskMaster "RESTORE HEADERONLY FROM DISK=N'$taskBackup';"
    $taskHeader.Tables[0] | Select-Object DatabaseName,BackupStartDate,BackupFinishDate,SoftwareVersionMajor,SoftwareVersionMinor,CompatibilityLevel,Collation | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $taskOut 'akgame-backup-header.json') -Encoding utf8
    $taskExists=Invoke-KnightRefSql $taskMaster "SELECT DB_ID(N'KNIGHT_AKGAME_REF') AS DbId;"
    if($taskExists.Tables[0].Rows[0].IsNull('DbId')) {
        [void](Invoke-KnightRefSql $taskMaster "RESTORE VERIFYONLY FROM DISK=N'$taskBackup';")
        $taskFiles=Invoke-KnightRefSql $taskMaster "RESTORE FILELISTONLY FROM DISK=N'$taskBackup';"
        $taskDefault=Invoke-KnightRefSql $taskMaster "SELECT CAST(SERVERPROPERTY('InstanceDefaultDataPath') AS nvarchar(4000)) AS DataDir;"
        $taskDataRoot=[IO.Path]::GetFullPath([string]$taskDefault.Tables[0].Rows[0].DataDir)
        $taskMoves=@();$taskIndex=0
        foreach($taskFile in $taskFiles.Tables[0].Rows) {
            if($taskFile.Type -notin @('D','L')){throw 'Unsupported backup file type.'}
            $taskExtension=if($taskFile.Type -eq 'L'){'.ldf'}else{'.mdf'}
            $taskTarget=[IO.Path]::GetFullPath((Join-Path $taskDataRoot "KNIGHT_AKGAME_REF_$taskIndex$taskExtension"))
            if(-not $taskTarget.StartsWith($taskDataRoot,[StringComparison]::OrdinalIgnoreCase)){throw 'Unsafe database target path.'}
            if(Test-Path -LiteralPath $taskTarget){throw 'Database target file already exists; no replacement allowed.'}
            $taskMoves+="MOVE N'$(([string]$taskFile.LogicalName).Replace("'","''"))' TO N'$($taskTarget.Replace("'","''"))'"
            $taskIndex++
        }
        [void](Invoke-KnightRefSql $taskMaster ("RESTORE DATABASE [KNIGHT_AKGAME_REF] FROM DISK=N'$taskBackup' WITH "+($taskMoves -join ', ')+', RECOVERY;'))
    }
} finally {$taskMaster.Dispose()}
$taskDb=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_AKGAME_REF;Integrated Security=True;Encrypt=False;Connect Timeout=10')
try {
    $taskDb.Open()
    $taskSchema=Invoke-KnightRefSql $taskDb 'SELECT TABLE_NAME,COLUMN_NAME,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH,IS_NULLABLE,COLUMN_DEFAULT,ORDINAL_POSITION FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA=''dbo'' ORDER BY TABLE_NAME,ORDINAL_POSITION;'
    $taskSchema.Tables[0] | Select-Object TABLE_NAME,COLUMN_NAME,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH,IS_NULLABLE,COLUMN_DEFAULT,ORDINAL_POSITION | Export-Csv -LiteralPath (Join-Path $taskOut 'akgame-schema-columns.csv') -NoTypeInformation -Encoding utf8
    $taskCounts=Invoke-KnightRefSql $taskDb 'SELECT COUNT(*) AS TableCount FROM sys.tables; SELECT COUNT(*) AS ProcedureCount FROM sys.procedures;'
    [pscustomobject]@{Database=$taskDb.Database;TableCount=[int]$taskCounts.Tables[0].Rows[0].TableCount;ProcedureCount=[int]$taskCounts.Tables[1].Rows[0].ProcedureCount;SHA256=$taskExpectedHash;OriginalDatabaseUnchanged='KNIGHT_24XX_TEST';Purpose='Reference only; not yet selected for the game runtime.'} | ConvertTo-Json | Tee-Object -FilePath (Join-Path $taskOut 'akgame-restore-result.json')
} finally {$taskDb.Dispose()}
