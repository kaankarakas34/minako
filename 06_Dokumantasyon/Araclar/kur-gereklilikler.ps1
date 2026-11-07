[CmdletBinding()]
param([Parameter(Mandatory=$true)][string]$SqlAdminAccount)
$ErrorActionPreference = 'Stop'
$taskRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskPackages = Join-Path $taskRoot '07_Kurulum_Paketleri'
$taskReport = Join-Path $taskRoot '06_Dokumantasyon\Kurulum'
$taskLocal = Join-Path $env:LOCALAPPDATA 'KnightOnlineLab'
$taskInstance = 'KNIGHTLOCAL'
$taskDatabase = 'KNIGHT_24XX_TEST'
$taskHistory = @()
$taskNeedsReboot = $false
New-Item -ItemType Directory -Path $taskReport,$taskLocal -Force | Out-Null

function Set-TaskStage([string]$Stage,[string]$Message) {
    $script:taskHistory += [pscustomobject]@{Stage=$Stage; Message=$Message; Utc=[DateTime]::UtcNow.ToString('o')}
    [pscustomobject]@{Stage=$Stage; Message=$Message; NeedsReboot=$script:taskNeedsReboot; History=$script:taskHistory} |
        ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $taskReport 'kurulum-durumu.json') -Encoding utf8
}
function Wait-TaskInstaller([string]$Name,[long]$ExpectedBytes=0,[string]$Sha256='') {
    Set-TaskStage 'WaitingForInstaller' $Name
    $taskPath=Join-Path $taskPackages $Name
    $taskDeadline=[DateTime]::UtcNow.AddMinutes(45)
    $taskLastSize=-1L
    while([DateTime]::UtcNow -lt $taskDeadline) {
        if(Test-Path -LiteralPath $taskPath) {
            $taskSize=(Get-Item -LiteralPath $taskPath).Length
            if(($ExpectedBytes -gt 0 -and $taskSize -eq $ExpectedBytes) -or ($ExpectedBytes -eq 0 -and $taskSize -gt 1000000 -and $taskSize -eq $taskLastSize)) {
                $taskSignature=Get-AuthenticodeSignature -LiteralPath $taskPath
                if($taskSignature.Status -eq 'Valid' -and $taskSignature.SignerCertificate.Subject -match 'Microsoft Corporation') {
                    if($Sha256 -and (Get-FileHash -LiteralPath $taskPath -Algorithm SHA256).Hash -ne $Sha256) { throw "SHA256 mismatch: $Name" }
                    return $taskPath
                }
            }
            $taskLastSize=$taskSize
        }
        Start-Sleep -Seconds 10
    }
    throw "Installer download/verification timed out: $Name"
}
function Invoke-TaskProcess([string]$FilePath,[string[]]$Arguments) {
    $taskProcess=Start-Process -FilePath $FilePath -ArgumentList ($Arguments -join ' ') -Wait -PassThru -WindowStyle Hidden
    if($taskProcess.ExitCode -eq 3010) { $script:taskNeedsReboot=$true }
    if($taskProcess.ExitCode -notin 0,3010) { throw "Installer failed: $FilePath; exit=$($taskProcess.ExitCode)" }
}
function Invoke-TaskQuery([string]$Query,[string]$Database='master',[int]$Timeout=300) {
    $taskConnection=New-Object System.Data.SqlClient.SqlConnection
    $taskConnection.ConnectionString="Server=lpc:.\$taskInstance;Database=$Database;Integrated Security=True;Encrypt=False;Connect Timeout=15;Application Name=KnightOnlineSetupAudit"
    try {
        $taskConnection.Open()
        $taskCommand=$taskConnection.CreateCommand()
        $taskCommand.CommandText=$Query
        $taskCommand.CommandTimeout=$Timeout
        $taskTable=New-Object System.Data.DataTable
        $taskAdapter=New-Object System.Data.SqlClient.SqlDataAdapter $taskCommand
        [void]$taskAdapter.Fill($taskTable)
        return ,$taskTable
    } finally { $taskConnection.Dispose() }
}
function Convert-TaskRows($Table) {
    foreach($taskRow in $Table.Rows) {
        $taskObject=[ordered]@{}
        foreach($taskColumn in $Table.Columns) {
            $taskValue=$taskRow[$taskColumn.ColumnName]
            if($taskValue -is [DBNull]) { $taskValue=$null }
            $taskObject[$taskColumn.ColumnName]=$taskValue
        }
        [pscustomobject]$taskObject
    }
}

try {
    $taskPrincipal=New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if(-not $taskPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) { throw 'Windows administrator elevation is required.' }
    Set-TaskStage 'Started' 'Microsoft-signed prerequisites; local-only SQL instance; no game executables are started.'

    $taskOdbcPlatforms=@(Get-OdbcDriver | Where-Object Name -EQ 'ODBC Driver 18 for SQL Server' | Select-Object -ExpandProperty Platform -Unique)
    if('32-bit' -notin $taskOdbcPlatforms -or '64-bit' -notin $taskOdbcPlatforms) {
        $taskOdbc=Wait-TaskInstaller 'msodbcsql18-x64.msi' 10092544 '21EF69E4B942F18ACED55FA7C3A8D7263004E113A96690BAC7509645E1B1A310'
        Set-TaskStage 'InstallingOdbc' 'ODBC Driver 18 x64 package, including x86 driver support.'
        Invoke-TaskProcess 'msiexec.exe' @('/i',('"'+$taskOdbc+'"'),'/qn','/norestart','REBOOT=ReallySuppress','MSIRESTARTMANAGERCONTROL=DisableShutdown','IACCEPTMSODBCSQLLICENSETERMS=YES','/L*v',('"'+(Join-Path $taskReport 'odbc-install.log')+'"'))
    } else { Set-TaskStage 'OdbcAlreadyInstalled' 'Both x86 and x64 ODBC Driver 18 are present.' }

    if(-not (Test-Path -LiteralPath (Join-Path $env:ProgramFiles 'sqlcmd\sqlcmd.exe'))) {
        $taskSqlcmd=Wait-TaskInstaller 'sqlcmd-amd64.msi'
        Set-TaskStage 'InstallingSqlcmd' 'Microsoft sqlcmd command-line management tool.'
        Invoke-TaskProcess 'msiexec.exe' @('/i',('"'+$taskSqlcmd+'"'),'/qn','/norestart','REBOOT=ReallySuppress','MSIRESTARTMANAGERCONTROL=DisableShutdown','/L*v',('"'+(Join-Path $taskReport 'sqlcmd-install.log')+'"'))
    } else { Set-TaskStage 'SqlcmdAlreadyInstalled' 'sqlcmd.exe is present.' }

    if(-not (Get-Service -Name 'MSSQL$KNIGHTLOCAL' -ErrorAction SilentlyContinue)) {
        $taskSqlMedia=Wait-TaskInstaller 'SQLEXPR_x64_ENU.exe'
        $taskExtract=Join-Path $env:ProgramData 'KnightOnlineLab\Sql2022Media'
        New-Item -ItemType Directory -Path $taskExtract -Force | Out-Null
        Set-TaskStage 'ExtractingSql' $taskExtract
        Invoke-TaskProcess $taskSqlMedia @('/q',('/x:"'+$taskExtract+'"'))
        $taskSetup=Join-Path $taskExtract 'setup.exe'
        if(-not (Test-Path -LiteralPath $taskSetup)) { throw 'SQL setup.exe was not extracted.' }
        Set-TaskStage 'InstallingSql' 'KNIGHTLOCAL; Windows authentication; TCP and named pipes disabled; max memory 2048 MB.'
        Invoke-TaskProcess $taskSetup @('/Q','/ACTION=Install','/FEATURES=SQLENGINE','/INSTANCENAME=KNIGHTLOCAL','/INSTANCEID=KNIGHTLOCAL','/SQLSVCSTARTUPTYPE=Automatic',('/SQLSYSADMINACCOUNTS="'+$SqlAdminAccount+'"'),'/TCPENABLED=0','/NPENABLED=0','/SQLMAXMEMORY=2048','/SQLCOLLATION=SQL_Latin1_General_CP1_CI_AS','/IACCEPTSQLSERVERLICENSETERMS','/UPDATEENABLED=False')
    }

    Start-Service -Name 'MSSQL$KNIGHTLOCAL'
    $taskVersionTable=Invoke-TaskQuery "SELECT CONVERT(varchar(50),SERVERPROPERTY('ProductVersion')) AS ProductVersion;"
    $taskCurrentVersion=[version]$taskVersionTable.Rows[0].ProductVersion
    if($taskCurrentVersion -lt [version]'16.0.4295.3') {
        $taskCu=Wait-TaskInstaller 'SQLServer2022-KB5104824-x64.exe' 490559304
        Set-TaskStage 'InstallingSqlCu' 'SQL Server 2022 CU27, KB5104824.'
        Invoke-TaskProcess $taskCu @('/QUIET','/ACTION=Patch','/INSTANCENAME=KNIGHTLOCAL','/IACCEPTSQLSERVERLICENSETERMS')
    }
    if($taskCurrentVersion -lt [version]'16.0.4305.5') {
        $taskSecurity=Wait-TaskInstaller 'SQLServer2022-KB5126934-x64.exe' 491045896 '8F1A7F0AC5F47FF98F5825687C8CCD897563AA835915F2271F908273E962E7E2'
        Set-TaskStage 'InstallingSqlSecurity' 'SQL Server 2022 CU27 security update, KB5126934.'
        Invoke-TaskProcess $taskSecurity @('/QUIET','/ACTION=Patch','/INSTANCENAME=KNIGHTLOCAL','/IACCEPTSQLSERVERLICENSETERMS')
    }
    Start-Service -Name 'MSSQL$KNIGHTLOCAL'

    Set-TaskStage 'InspectingBackup' 'Copying the original backup to a local service-readable directory; original backup remains unchanged.'
    $taskBackupDir=Join-Path $env:ProgramData 'KnightOnlineLab\Backups'
    New-Item -ItemType Directory -Path $taskBackupDir -Force | Out-Null
    $taskAcl=Get-Acl -LiteralPath $taskBackupDir
    $taskAcl.SetAccessRuleProtection($true,$false)
    foreach($taskSidString in 'S-1-5-18','S-1-5-32-544') {
        $taskSid=New-Object Security.Principal.SecurityIdentifier($taskSidString)
        $taskRule=New-Object Security.AccessControl.FileSystemAccessRule($taskSid,'FullControl','ContainerInherit,ObjectInherit','None','Allow')
        $taskAcl.AddAccessRule($taskRule)
    }
    $taskOwnerRule=New-Object Security.AccessControl.FileSystemAccessRule($SqlAdminAccount,'FullControl','ContainerInherit,ObjectInherit','None','Allow')
    $taskAcl.AddAccessRule($taskOwnerRule)
    $taskServiceRule=New-Object Security.AccessControl.FileSystemAccessRule('NT SERVICE\MSSQL$KNIGHTLOCAL','ReadAndExecute','ContainerInherit,ObjectInherit','None','Allow')
    $taskAcl.AddAccessRule($taskServiceRule)
    Set-Acl -LiteralPath $taskBackupDir -AclObject $taskAcl
    $taskOriginalBackup=Join-Path $taskRoot '03_Veritabanlari\24xx\v24xx Database.bak'
    $taskLocalBackup=Join-Path $taskBackupDir 'v24xx-original.bak'
    if(Test-Path -LiteralPath $taskLocalBackup) {
        if((Get-FileHash -LiteralPath $taskLocalBackup).Hash -ne (Get-FileHash -LiteralPath $taskOriginalBackup).Hash) { throw 'Existing local backup differs; refusing to overwrite.' }
    } else { Copy-Item -LiteralPath $taskOriginalBackup -Destination $taskLocalBackup }
    $taskBackupSql=$taskLocalBackup.Replace("'","''")
    $taskHeader=Invoke-TaskQuery "RESTORE HEADERONLY FROM DISK=N'$taskBackupSql';"
    @(Convert-TaskRows $taskHeader) | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $taskReport 'backup-header.json') -Encoding utf8
    $taskFileList=Invoke-TaskQuery "RESTORE FILELISTONLY FROM DISK=N'$taskBackupSql';"
    @(Convert-TaskRows $taskFileList) | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $taskReport 'backup-filelist.json') -Encoding utf8
    [void](Invoke-TaskQuery "RESTORE VERIFYONLY FROM DISK=N'$taskBackupSql';")

    $taskDbExists=Invoke-TaskQuery "SELECT DB_ID(N'$taskDatabase') AS DatabaseId;"
    if($taskDbExists.Rows[0].DatabaseId -is [DBNull]) {
        Set-TaskStage 'RestoringTestDatabase' $taskDatabase
        $taskDefaults=Invoke-TaskQuery "SELECT CONVERT(nvarchar(4000),SERVERPROPERTY('InstanceDefaultDataPath')) AS DataPath, CONVERT(nvarchar(4000),SERVERPROPERTY('InstanceDefaultLogPath')) AS LogPath;"
        $taskMoves=@()
        $taskFileIndex=0
        foreach($taskFileRow in $taskFileList.Rows) {
            $taskType=[string]$taskFileRow.Type
            if($taskType -notin 'D','L') { throw "Backup contains an unsupported file type: $taskType" }
            $taskLogical=([string]$taskFileRow.LogicalName).Replace("'","''")
            $taskFileDir=if($taskType -eq 'L'){$taskDefaults.Rows[0].LogPath}else{$taskDefaults.Rows[0].DataPath}
            $taskExtension=if($taskType -eq 'L'){'.ldf'}else{'.mdf'}
            $taskPhysical=(Join-Path $taskFileDir ($taskDatabase+'_'+$taskFileIndex+$taskExtension)).Replace("'","''")
            if(Test-Path -LiteralPath $taskPhysical) { throw "Restore target file exists: $taskPhysical" }
            $taskMoves += "MOVE N'$taskLogical' TO N'$taskPhysical'"
            $taskFileIndex++
        }
        $taskRestore="RESTORE DATABASE [$taskDatabase] FROM DISK=N'$taskBackupSql' WITH "+($taskMoves -join ', ')+', RECOVERY;'
        [void](Invoke-TaskQuery $taskRestore 'master' 600)
    }
    [void](Invoke-TaskQuery "ALTER DATABASE [$taskDatabase] SET TRUSTWORTHY OFF; ALTER DATABASE [$taskDatabase] SET DB_CHAINING OFF;")
    Set-TaskStage 'CheckingTestDatabase' 'DBCC CHECKDB PHYSICAL_ONLY and schema/file-reference inventory.'
    [void](Invoke-TaskQuery "DBCC CHECKDB (N'$taskDatabase') WITH PHYSICAL_ONLY, NO_INFOMSGS;" 'master' 600)
    $taskDbSummary=Invoke-TaskQuery "SELECT @@VERSION AS EngineVersion, SERVERPROPERTY('ProductVersion') AS ProductVersion, SERVERPROPERTY('Edition') AS Edition, DATABASEPROPERTYEX(N'$taskDatabase','Collation') AS DatabaseCollation, (SELECT compatibility_level FROM sys.databases WHERE name=N'$taskDatabase') AS CompatibilityLevel, (SELECT COUNT(*) FROM [$taskDatabase].sys.tables) AS TableCount, (SELECT COUNT(*) FROM [$taskDatabase].sys.procedures) AS ProcedureCount;"
    @(Convert-TaskRows $taskDbSummary) | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $taskReport 'sql-database-summary.json') -Encoding utf8
    $taskObjects=Invoke-TaskQuery "SELECT SCHEMA_NAME(schema_id) AS SchemaName, name AS ObjectName, type_desc AS ObjectType FROM sys.objects WHERE is_ms_shipped=0 ORDER BY type_desc,name;" $taskDatabase
    @(Convert-TaskRows $taskObjects) | Export-Csv -LiteralPath (Join-Path $taskReport 'sql-nesne-envanteri.csv') -NoTypeInformation -Encoding utf8
    $taskReferenceColumns=Invoke-TaskQuery "SELECT TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME,DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE DATA_TYPE IN ('varchar','nvarchar','char','nchar') AND (COLUMN_NAME LIKE '%Smd%' OR COLUMN_NAME LIKE '%Lua%' OR COLUMN_NAME LIKE '%File%') ORDER BY TABLE_NAME,COLUMN_NAME;" $taskDatabase
    @(Convert-TaskRows $taskReferenceColumns) | Export-Csv -LiteralPath (Join-Path $taskReport 'sql-dosya-kolonlari.csv') -NoTypeInformation -Encoding utf8
    $taskZoneExists=Invoke-TaskQuery "SELECT OBJECT_ID(N'dbo.ZONE_INFO') AS ObjectId;" $taskDatabase
    if($taskZoneExists.Rows[0].ObjectId -isnot [DBNull]) {
        $taskZones=Invoke-TaskQuery 'SELECT * FROM dbo.ZONE_INFO;' $taskDatabase
        $taskMapColumn=@($taskZones.Columns | Where-Object ColumnName -Match '(?i)smd' | Select-Object -First 1)
        if($taskMapColumn.Count -eq 1) {
            $taskMapRoot=Join-Path $taskRoot '02_Sunucu\24xx\Map'
            $taskMapPrefix=[IO.Path]::GetFullPath($taskMapRoot).TrimEnd('\')+'\'
            $taskMapInventory=@(Get-ChildItem -LiteralPath $taskMapRoot -Recurse -File)
            $taskMapChecks=@(foreach($taskZone in $taskZones.Rows) {
                $taskMapName=([string]$taskZone[$taskMapColumn[0].ColumnName]).Trim()
                $taskRequested=[IO.Path]::GetFullPath((Join-Path $taskMapRoot $taskMapName))
                $taskWithin=$taskRequested.StartsWith($taskMapPrefix,[StringComparison]::OrdinalIgnoreCase)
                $taskPresent=$taskWithin -and (Test-Path -LiteralPath $taskRequested -PathType Leaf)
                $taskElsewhere=@($taskMapInventory | Where-Object Name -EQ ([IO.Path]::GetFileName($taskMapName)) | Select-Object -ExpandProperty FullName)
                [pscustomobject]@{MapName=$taskMapName; PresentAtMapRoot=$taskPresent; FoundElsewhere=($taskElsewhere -join ';'); SafeRelativePath=$taskWithin}
            })
            $taskMapChecks | Export-Csv -LiteralPath (Join-Path $taskReport 'sql-harita-dosya-kontrolu.csv') -NoTypeInformation -Encoding utf8
        }
    }

    $taskDrivers=@(Get-OdbcDriver | Where-Object Name -EQ 'ODBC Driver 18 for SQL Server' | Select-Object Name,Platform)
    $taskDrivers | ConvertTo-Json | Set-Content -LiteralPath (Join-Path $taskReport 'odbc-drivers.json') -Encoding utf8
    if(-not (Get-OdbcDsn -Name 'Knight24xx_Audit' -DsnType System -Platform '32-bit' -ErrorAction SilentlyContinue)) {
        Add-OdbcDsn -Name 'Knight24xx_Audit' -DriverName 'ODBC Driver 18 for SQL Server' -DsnType System -Platform '32-bit' -SetPropertyValue @('Server=(local)\KNIGHTLOCAL','Database=KNIGHT_24XX_TEST','Trusted_Connection=Yes','Encrypt=Yes','TrustServerCertificate=Yes') | Out-Null
    }
    Set-TaskStage 'Completed' 'SQL, updates, ODBC, sqlcmd installed; backup restored only into KNIGHT_24XX_TEST; metadata and map audit written. Game binaries not started; original configs unchanged.'
} catch {
    Set-TaskStage 'Failed' $_.Exception.Message
    $_ | Out-String | Set-Content -LiteralPath (Join-Path $taskReport 'kurulum-hata.txt') -Encoding utf8
    exit 1
}
