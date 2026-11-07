$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskReport=Join-Path $taskRoot '06_Dokumantasyon\Kurulum'
$taskConnection=New-Object System.Data.SqlClient.SqlConnection('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_24XX_TEST;Integrated Security=True;Encrypt=False;Connect Timeout=10')
function Read-TaskTable([string]$Query) {
    $taskCommand=$taskConnection.CreateCommand()
    $taskCommand.CommandText=$Query
    $taskCommand.CommandTimeout=60
    $taskTable=New-Object System.Data.DataTable
    $taskAdapter=New-Object System.Data.SqlClient.SqlDataAdapter $taskCommand
    [void]$taskAdapter.Fill($taskTable)
    return ,$taskTable
}
function Test-TaskAsset([string]$Base,[string]$Reference) {
    if([string]::IsNullOrWhiteSpace($Reference)) { return $false }
    $taskPrefix=[IO.Path]::GetFullPath($Base).TrimEnd('\')+'\'
    $taskPath=[IO.Path]::GetFullPath((Join-Path $Base $Reference))
    return ($taskPath.StartsWith($taskPrefix,[StringComparison]::OrdinalIgnoreCase) -and (Test-Path -LiteralPath $taskPath -PathType Leaf))
}
try {
    $taskConnection.Open()
    $taskObjects=Read-TaskTable 'SELECT SCHEMA_NAME(schema_id) AS SchemaName,name,type FROM sys.objects WHERE is_ms_shipped=0;'
    $taskReferences=Import-Csv -LiteralPath (Join-Path $taskReport 'hazir-sunucu-sql-referanslari.csv')
    $taskObjectChecks=@(foreach($taskReference in $taskReferences) {
        $taskMatches=@($taskObjects.Rows | Where-Object name -EQ $taskReference.ObjectName)
        if($taskReference.Kind -eq 'ProcedureReference') { $taskMatches=@($taskMatches | Where-Object { ([string]$_.type).Trim() -in 'P','PC','X' }) }
        [pscustomobject]@{Binary=$taskReference.Binary; Kind=$taskReference.Kind; ObjectName=$taskReference.ObjectName; Present=$taskMatches.Count -gt 0; MatchingSchemas=(@($taskMatches | ForEach-Object SchemaName) -join ';')}
    })
    $taskObjectChecks | Export-Csv -LiteralPath (Join-Path $taskReport 'hazir-sunucu-sql-uyumluluk.csv') -NoTypeInformation -Encoding utf8

    $taskZones=Read-TaskTable 'SELECT * FROM dbo.ZONE_INFO;'
    $taskZoneColumns=@($taskZones.Columns | ForEach-Object ColumnName)
    $taskMapColumn=@($taskZones.Columns | Where-Object ColumnName -Match '(?i)smd' | Select-Object -First 1)
    if($taskMapColumn.Count -eq 0 -and 'strZoneName' -in $taskZoneColumns -and @($taskZones.Rows | Where-Object { [string]$_.strZoneName -match '(?i)\.smd$' }).Count -gt 0) {
        $taskMapColumn=@($taskZones.Columns | Where-Object ColumnName -EQ 'strZoneName')
    }
    $taskMapChecks=@()
    if($taskMapColumn.Count -eq 1) {
        $taskMapRoot=Join-Path $taskRoot '02_Sunucu\24xx\Map'
        $taskAllMaps=@(Get-ChildItem -LiteralPath $taskMapRoot -Recurse -File -Filter '*.smd')
        $taskMapChecks=@(foreach($taskZone in $taskZones.Rows) {
            $taskName=([string]$taskZone[$taskMapColumn[0].ColumnName]).Trim()
            [pscustomobject]@{ZoneNo=if('ZoneNo' -in $taskZoneColumns){$taskZone.ZoneNo}else{$null}; ZoneName=if('strZoneName' -in $taskZoneColumns){$taskZone.strZoneName}else{$null}; MapName=$taskName; DatabaseStatus=if('Status' -in $taskZoneColumns){$taskZone.Status}else{$null}; PresentAtMapRoot=Test-TaskAsset $taskMapRoot $taskName; OtherLocations=(@($taskAllMaps | Where-Object Name -EQ ([IO.Path]::GetFileName($taskName)) | ForEach-Object FullName) -join ';')}
        })
        $taskMapChecks | Export-Csv -LiteralPath (Join-Path $taskReport 'sql-harita-detayli-kontrol.csv') -NoTypeInformation -Encoding utf8
    }

    $taskScriptColumns=Read-TaskTable "SELECT TABLE_SCHEMA,TABLE_NAME,COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME LIKE '%QUEST%' AND DATA_TYPE IN ('varchar','nvarchar','char','nchar') AND (COLUMN_NAME LIKE '%Lua%' OR COLUMN_NAME LIKE '%File%');"
    $taskScriptChecks=@(foreach($taskColumn in $taskScriptColumns.Rows) {
        $taskSchema=([string]$taskColumn.TABLE_SCHEMA).Replace(']',']]')
        $taskTable=([string]$taskColumn.TABLE_NAME).Replace(']',']]')
        $taskField=([string]$taskColumn.COLUMN_NAME).Replace(']',']]')
        $taskScriptValues=Read-TaskTable "SELECT DISTINCT [$taskField] AS ScriptFile FROM [$taskSchema].[$taskTable] WHERE [$taskField] IS NOT NULL;"
        foreach($taskValue in $taskScriptValues.Rows) {
            $taskName=([string]$taskValue.ScriptFile).Trim()
            if(-not $taskName) { continue }
            [pscustomobject]@{Table=$taskColumn.TABLE_NAME; Column=$taskColumn.COLUMN_NAME; ScriptFile=$taskName; PresentInQuests=Test-TaskAsset (Join-Path $taskRoot '02_Sunucu\24xx\Quests') $taskName; PresentInLuaQuests=Test-TaskAsset (Join-Path $taskRoot '02_Sunucu\24xx\Lua\Quests') $taskName}
        }
    })
    if($taskScriptChecks.Count) { $taskScriptChecks | Export-Csv -LiteralPath (Join-Path $taskReport 'sql-gorev-dosya-kontrolu.csv') -NoTypeInformation -Encoding utf8 }
    $taskSummary=[pscustomobject]@{RuntimeSqlProcedureNames=@($taskObjectChecks | Where-Object Kind -EQ 'ProcedureReference' | Select-Object -ExpandProperty ObjectName -Unique).Count; MissingRuntimeProcedures=@($taskObjectChecks | Where-Object { $_.Kind -eq 'ProcedureReference' -and -not $_.Present } | Select-Object -ExpandProperty ObjectName -Unique); MissingSqlTableCandidates=@($taskObjectChecks | Where-Object { $_.Kind -eq 'TableCandidate' -and -not $_.Present } | Select-Object -ExpandProperty ObjectName -Unique); ZoneRows=$taskZones.Rows.Count; ZoneColumns=$taskZoneColumns; MapReferencesChecked=$taskMapChecks.Count; MissingMapReferences=@($taskMapChecks | Where-Object {-not $_.PresentAtMapRoot}); QuestFilenameColumns=$taskScriptColumns.Rows.Count; QuestFileReferencesChecked=$taskScriptChecks.Count; MissingQuestFiles=@($taskScriptChecks | Where-Object { -not $_.PresentInQuests -and -not $_.PresentInLuaQuests }); Utc=[DateTime]::UtcNow.ToString('o')}
    $taskSummary | ConvertTo-Json -Depth 7 | Set-Content -LiteralPath (Join-Path $taskReport 'eksik-dosya-sql-ozeti.json') -Encoding utf8
    [pscustomobject]@{RuntimeSqlProcedureNames=$taskSummary.RuntimeSqlProcedureNames; MissingRuntimeProcedures=$taskSummary.MissingRuntimeProcedures; MissingSqlTableCandidates=$taskSummary.MissingSqlTableCandidates; ZoneRows=$taskSummary.ZoneRows; MapReferencesChecked=$taskSummary.MapReferencesChecked; MissingMapReferencesCount=@($taskSummary.MissingMapReferences).Count; MissingMapSamples=@($taskSummary.MissingMapReferences | Select-Object -First 5 -ExpandProperty MapName); QuestFileReferencesChecked=$taskSummary.QuestFileReferencesChecked; MissingQuestFilesCount=@($taskSummary.MissingQuestFiles).Count; MissingQuestSamples=@($taskSummary.MissingQuestFiles | Select-Object -First 5 -ExpandProperty ScriptFile)} | ConvertTo-Json -Depth 5
} finally { $taskConnection.Dispose() }
