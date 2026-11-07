$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskPrepared=Join-Path $taskRoot '10_Kaynak_Derleme\Veritabani_Hazirlik'
$taskManifest=Get-Content -LiteralPath (Join-Path $taskPrepared 'manifest.json') -Raw | ConvertFrom-Json
if($taskManifest.TargetDatabase -ne 'KNIGHT_TEMU_2239'){throw 'Unexpected database manifest.'}
function Invoke-TemuScalar($Connection,[string]$Sql) {
    $taskCommand=$Connection.CreateCommand();$taskCommand.CommandTimeout=600;$taskCommand.CommandText=$Sql
    return $taskCommand.ExecuteScalar()
}
$taskMaster=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=master;Integrated Security=True;Encrypt=False')
try {
    $taskMaster.Open()
    if([DBNull]::Value -eq (Invoke-TemuScalar $taskMaster "SELECT DB_ID(N'KNIGHT_TEMU_2239');")) {
        [void](Invoke-TemuScalar $taskMaster 'CREATE DATABASE [KNIGHT_TEMU_2239] COLLATE SQL_Latin1_General_CP1_CI_AS;')
    }
}finally{$taskMaster.Dispose()}
$taskConnection=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_TEMU_2239;Integrated Security=True;Encrypt=False')
try {
    $taskConnection.Open()
    if((Invoke-TemuScalar $taskConnection 'SELECT COUNT(*) FROM sys.tables;') -ne 0) {throw 'Lab already contains tables; refusing to overwrite it.'}
    $taskTransaction=$taskConnection.BeginTransaction()
    $taskFailures=[Collections.Generic.List[object]]::new()
    $taskImported=[Collections.Generic.List[object]]::new()
    try {
        $taskCommand=$taskConnection.CreateCommand();$taskCommand.Transaction=$taskTransaction;$taskCommand.CommandTimeout=600
        $taskCommand.CommandText=Get-Content -LiteralPath (Join-Path $taskPrepared 'schema.sql') -Raw
        [void]$taskCommand.ExecuteNonQuery()
        # Validate authored procedures before the larger static-data import.
        foreach($taskProc in Get-ChildItem -LiteralPath (Join-Path $taskPrepared 'Procedures') -Filter '*.sql') {
            try {
                $taskCommand.CommandText=Get-Content -LiteralPath $taskProc.FullName -Raw
                [void]$taskCommand.ExecuteNonQuery()
            }catch{$taskFailures.Add([pscustomobject]@{Procedure=$taskProc.BaseName;Error=$_.Exception.Message})}
        }
        $taskFailures | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $taskRoot '06_Dokumantasyon\Derleme\temu-procedure-errors.json') -Encoding utf8
        if($taskFailures.Count -gt 0){throw "$($taskFailures.Count) authored procedures failed validation; transaction will be rolled back."}
        foreach($taskTable in $taskManifest.Tables) {
            if(-not $taskTable.ImportStaticData -or $taskTable.Rows -eq 0){continue}
            if($taskTable.Name -notmatch '^\w+$'){throw 'Invalid table name in manifest.'}
            $taskCommand.CommandText="SELECT TOP(0) * FROM dbo.[$($taskTable.Name)];"
            $taskData=[Data.DataTable]::new();$taskReader=$taskCommand.ExecuteReader();$taskData.Load($taskReader);$taskReader.Dispose()
            $taskOptions=[Data.SqlClient.SqlBulkCopyOptions]::KeepIdentity -bor [Data.SqlClient.SqlBulkCopyOptions]::CheckConstraints
            $taskBulk=[Data.SqlClient.SqlBulkCopy]::new($taskConnection,$taskOptions,$taskTransaction)
            $taskBulk.DestinationTableName="dbo.[$($taskTable.Name)]";$taskBulk.BulkCopyTimeout=600;$taskBulk.BatchSize=1000
            foreach($taskColumn in $taskTable.Columns){[void]$taskBulk.ColumnMappings.Add([string]$taskColumn.Name,[string]$taskColumn.Name)}
            $taskStream=[IO.File]::OpenText((Join-Path $taskPrepared "StaticData\$($taskTable.Name).jsonl"));$taskCount=0
            try {
                while($null -ne ($taskLine=$taskStream.ReadLine())) {
                    $taskValues=ConvertFrom-Json -InputObject $taskLine -NoEnumerate
                    $taskRow=$taskData.NewRow()
                    for($taskIndex=0;$taskIndex -lt $taskValues.Count;$taskIndex++) {
                        $taskValue=$taskValues[$taskIndex]
                        if($null -eq $taskValue){$taskRow[$taskIndex]=[DBNull]::Value}
                        elseif($taskTable.Columns[$taskIndex].Type -eq 'varbinary(max)') {
                            if(-not ([string]$taskValue).StartsWith('\x')){throw 'Unsupported bytea format.'}
                            $taskRow[$taskIndex]=[Convert]::FromHexString(([string]$taskValue).Substring(2))
                        }
                        elseif($taskTable.Columns[$taskIndex].Type -eq 'bit'){$taskRow[$taskIndex]=($taskValue -eq 't' -or $taskValue -eq 'true' -or $taskValue -eq '1')}
                        else {$taskRow[$taskIndex]=$taskValue}
                    }
                    [void]$taskData.Rows.Add($taskRow);$taskCount++
                    if($taskData.Rows.Count -ge 1000){$taskBulk.WriteToServer($taskData);$taskData.Clear()}
                }
                if($taskData.Rows.Count -gt 0){$taskBulk.WriteToServer($taskData)}
                if($taskCount -ne $taskTable.Rows){throw 'Static row count mismatch.'}
            } finally {$taskStream.Dispose();$taskBulk.Dispose();$taskData.Dispose()}
            $taskImported.Add([pscustomobject]@{Table=$taskTable.Name;Rows=$taskCount})
        }
        $taskCommand.CommandText='SELECT COUNT(*) FROM dbo.TB_USER;'
        if($taskCommand.ExecuteScalar() -ne 0){throw 'Unexpected imported accounts.'}
        $taskTransaction.Commit()
        $taskImported | Export-Csv -LiteralPath (Join-Path $taskRoot '06_Dokumantasyon\Derleme\temu-imported-static-tables.csv') -NoTypeInformation -Encoding utf8
        [pscustomobject]@{Database=$taskConnection.Database;Tables=$taskManifest.Tables.Count;StaticRows=($taskImported | Measure-Object -Property Rows -Sum).Sum;ImportedAccountRows=0;OriginalDatabasesUnchanged=$true} | ConvertTo-Json | Tee-Object -FilePath (Join-Path $taskRoot '06_Dokumantasyon\Derleme\temu-lab-import-result.json')
    } catch {try{$taskTransaction.Rollback()}catch{};throw} finally {$taskTransaction.Dispose()}
} finally {$taskConnection.Dispose()}
