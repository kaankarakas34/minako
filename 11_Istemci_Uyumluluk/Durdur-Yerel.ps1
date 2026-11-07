$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$taskRuntime=(Resolve-Path -LiteralPath (Join-Path $taskRoot '10_Kaynak_Derleme\Yerel_Calistirma')).Path
$taskSql=[Data.SqlClient.SqlConnection]::new('Server=lpc:.\KNIGHTLOCAL;Database=KNIGHT_TEMU_2239;Integrated Security=True;Encrypt=False')
try {
    $taskSql.Open();$taskCommand=$taskSql.CreateCommand();$taskCommand.CommandText='SELECT COUNT(*) FROM dbo.CURRENTUSER;'
    if($taskCommand.ExecuteScalar() -gt 0){throw 'There are online characters. Log out of the game before stopping this local test session.'}
}finally{$taskSql.Dispose()}
Get-Process -Name GameServer,LogInServer -ErrorAction SilentlyContinue|Where-Object {$_.Path -and [string]::Equals((Split-Path -Parent $_.Path),$taskRuntime,[StringComparison]::OrdinalIgnoreCase)}|ForEach-Object{$_.Kill();$_.WaitForExit()}
Get-CimInstance Win32_Process -Filter "Name='python.exe'"|Where-Object {$_.CommandLine -match 'istemci-yerel-kayit\.py --seconds 0$'}|ForEach-Object{Stop-Process -Id $_.ProcessId -Force}
'Only the local game/login/relay test processes were stopped. SQL Server was left running.'
