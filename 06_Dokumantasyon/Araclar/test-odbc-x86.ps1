$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskOutput=Join-Path $taskRoot '06_Dokumantasyon\Kurulum\odbc-x86-baglanti-testi.json'
$taskConnection=New-Object System.Data.Odbc.OdbcConnection('DSN=Knight24xx_Audit;Trusted_Connection=Yes;')
try {
    if([IntPtr]::Size -ne 4) { throw 'Run this script with the SysWOW64 Windows PowerShell executable.' }
    $taskConnection.Open()
    $taskCommand=$taskConnection.CreateCommand()
    $taskCommand.CommandText="SELECT DB_NAME()+'|'+CONVERT(varchar(50),SERVERPROPERTY('ProductVersion'));"
    $taskResult=[pscustomobject]@{Status='Passed'; ProcessArchitecture='x86'; Dsn='Knight24xx_Audit'; DatabaseAndVersion=[string]$taskCommand.ExecuteScalar(); Utc=[DateTime]::UtcNow.ToString('o')}
    $taskResult | ConvertTo-Json | Set-Content -LiteralPath $taskOutput -Encoding utf8
    $taskResult | ConvertTo-Json
} catch {
    [pscustomobject]@{Status='Failed'; Error=$_.Exception.Message; Utc=[DateTime]::UtcNow.ToString('o')} | ConvertTo-Json | Set-Content -LiteralPath $taskOutput -Encoding utf8
    throw
} finally { $taskConnection.Dispose() }
