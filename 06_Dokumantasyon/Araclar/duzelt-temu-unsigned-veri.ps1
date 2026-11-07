$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskOut=Join-Path $taskRoot '06_Dokumantasyon\Derleme'
$taskColumns=Get-Content -LiteralPath (Join-Path $taskOut 'temu-unsigned-columns.json') -Raw | ConvertFrom-Json
$taskConnection=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_TEMU_2239;Integrated Security=True;Encrypt=False')
$taskChanges=[Collections.Generic.List[object]]::new();$taskInvalid=[Collections.Generic.List[object]]::new()
try {
    $taskConnection.Open();if($taskConnection.Database -ne 'KNIGHT_TEMU_2239'){throw 'Wrong database.'}
    $taskTransaction=$taskConnection.BeginTransaction()
    try {
        foreach($taskColumn in $taskColumns) {
            $taskTable=[string]$taskColumn.Table;$taskName=[string]$taskColumn.Column
            if($taskTable -notmatch '^\w+$' -or $taskName -notmatch '^\w+$'){throw 'Invalid identifier.'}
            $taskCmd=$taskConnection.CreateCommand();$taskCmd.Transaction=$taskTransaction;$taskCmd.CommandTimeout=180
            $taskCmd.CommandText="SELECT DATA_TYPE,IS_NULLABLE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA='dbo' AND TABLE_NAME=@table AND COLUMN_NAME=@column;"
            [void]$taskCmd.Parameters.AddWithValue('@table',$taskTable);[void]$taskCmd.Parameters.AddWithValue('@column',$taskName)
            $taskReader=$taskCmd.ExecuteReader()
            if(-not $taskReader.Read()){$taskReader.Close();continue}
            $taskType=$taskReader.GetString(0);$taskNullable=$taskReader.GetString(1);$taskReader.Close();$taskCmd.Parameters.Clear()
            if($taskType -notin @('tinyint','smallint','int','bigint','decimal','numeric')){continue}
            $taskMod=[System.Numerics.BigInteger]::Pow(2,[int]$taskColumn.Bits).ToString()
            $taskMin=(-[System.Numerics.BigInteger]::Pow(2,([int]$taskColumn.Bits-1))).ToString()
            $taskMax=([System.Numerics.BigInteger]::Pow(2,[int]$taskColumn.Bits)-1).ToString()
            $taskCmd.CommandText="SELECT SUM(CASE WHEN [$taskName]<0 THEN CONVERT(bigint,1) ELSE CONVERT(bigint,0) END), SUM(CASE WHEN [$taskName]<$taskMin OR [$taskName]>$taskMax THEN CONVERT(bigint,1) ELSE CONVERT(bigint,0) END) FROM dbo.[$taskTable];"
            $taskReader=$taskCmd.ExecuteReader();[void]$taskReader.Read()
            $taskNeg=if($taskReader.IsDBNull(0)){0}else{$taskReader.GetInt64(0)}
            $taskBad=if($taskReader.IsDBNull(1)){0}else{$taskReader.GetInt64(1)};$taskReader.Close()
            if($taskBad -gt 0){$taskInvalid.Add([pscustomobject]@{Table=$taskTable;Column=$taskName;Bits=$taskColumn.Bits;OutOfRange=$taskBad});continue}
            if($taskNeg -eq 0){continue}
            $taskWide=if($taskColumn.Bits -eq 16 -and $taskType -eq 'smallint'){'int'}elseif($taskColumn.Bits -eq 32 -and $taskType -in @('int','smallint')){'bigint'}elseif($taskColumn.Bits -eq 64){'decimal(20,0)'}else{$null}
            if($taskWide){
                $taskCmd.CommandText="SELECT dc.name,dc.definition FROM sys.default_constraints dc JOIN sys.columns c ON c.object_id=dc.parent_object_id AND c.column_id=dc.parent_column_id WHERE dc.parent_object_id=OBJECT_ID(N'dbo.[$taskTable]') AND c.name=N'$taskName';"
                $taskReader=$taskCmd.ExecuteReader();$taskDefaultName=$null;$taskDefaultDefinition=$null
                if($taskReader.Read()){$taskDefaultName=$taskReader.GetString(0);$taskDefaultDefinition=$taskReader.GetString(1)}
                $taskReader.Close()
                if($taskDefaultName){
                    $taskCmd.CommandText="ALTER TABLE dbo.[$taskTable] DROP CONSTRAINT [$($taskDefaultName.Replace(']',']]'))];";[void]$taskCmd.ExecuteNonQuery()
                }
                $taskNull=if($taskNullable -eq 'YES'){'NULL'}else{'NOT NULL'}
                $taskCmd.CommandText="ALTER TABLE dbo.[$taskTable] ALTER COLUMN [$taskName] $taskWide $taskNull;";[void]$taskCmd.ExecuteNonQuery()
                if($taskDefaultName){
                    $taskCmd.CommandText="ALTER TABLE dbo.[$taskTable] ADD CONSTRAINT [$($taskDefaultName.Replace(']',']]'))] DEFAULT $taskDefaultDefinition FOR [$taskName];";[void]$taskCmd.ExecuteNonQuery()
                }
            }
            $taskCmd.CommandText="UPDATE dbo.[$taskTable] SET [$taskName]=CONVERT(decimal(20,0),[$taskName])+$taskMod WHERE [$taskName]<0;"
            $taskChanged=$taskCmd.ExecuteNonQuery()
            if($taskChanged -ne $taskNeg){throw 'Unsigned correction row count mismatch.'}
            $taskChanges.Add([pscustomobject]@{Table=$taskTable;Column=$taskName;Bits=$taskColumn.Bits;ConvertedRows=$taskChanged;WidenedType=$taskWide})
        }
        $taskInvalid | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $taskOut 'temu-unsigned-out-of-range.json') -Encoding utf8
        $taskTransaction.Commit()
    }catch{try{$taskTransaction.Rollback()}catch{};throw}finally{$taskTransaction.Dispose()}
    $taskChanges | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $taskOut 'temu-unsigned-corrections.json') -Encoding utf8
    [pscustomobject]@{ColumnCorrections=$taskChanges.Count;ConvertedCells=($taskChanges|Measure-Object ConvertedRows -Sum).Sum;OutOfRangeColumns=$taskInvalid.Count;Method='Preserve published two-complement values in the unsigned C++ destination width.'} | ConvertTo-Json
} finally {$taskConnection.Dispose()}
