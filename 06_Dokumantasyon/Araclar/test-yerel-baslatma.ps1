param([ValidateSet('LogInServer','GameServer')][string]$Server='LogInServer',[int]$TimeoutSeconds=90,[switch]$Probe)
$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskRun=Join-Path $taskRoot '10_Kaynak_Derleme\Yerel_Calistirma'
$taskReport=Join-Path $taskRoot '06_Dokumantasyon\Derleme'
$taskPort=if($Server -eq 'GameServer'){15001}else{15100}
if(Get-NetTCPConnection -LocalPort $taskPort -State Listen -ErrorAction SilentlyContinue){throw 'Test port is already in use.'}
$taskInfo=[Diagnostics.ProcessStartInfo]::new()
$taskInfo.FileName=Join-Path $taskRun ($Server+'.exe');$taskInfo.WorkingDirectory=$taskRun
$taskInfo.UseShellExecute=$false;$taskInfo.CreateNoWindow=$true;$taskInfo.WindowStyle=[Diagnostics.ProcessWindowStyle]::Hidden
$taskInfo.RedirectStandardOutput=$true;$taskInfo.RedirectStandardError=$true;$taskInfo.RedirectStandardInput=$true
$taskProcess=[Diagnostics.Process]::new();$taskProcess.StartInfo=$taskInfo
$taskStarted=[DateTime]::UtcNow
if(-not $taskProcess.Start()){throw 'Could not launch compiled server.'}
$taskPid=$taskProcess.Id;$taskStdout=$taskProcess.StandardOutput.ReadToEndAsync();$taskStderr=$taskProcess.StandardError.ReadToEndAsync()
$taskBindings=@();$taskForcedStop=$false;$taskExit=$null
try {
    $taskDeadline=[DateTime]::UtcNow.AddSeconds($TimeoutSeconds)
    while(-not $taskProcess.WaitForExit(1000) -and [DateTime]::UtcNow -lt $taskDeadline) {
        $taskBindings=@(Get-NetTCPConnection -OwningProcess $taskPid -State Listen -ErrorAction SilentlyContinue | Select-Object LocalAddress,LocalPort)
        if($taskBindings.Count -gt 0) {
            if(@($taskBindings | Where-Object LocalAddress -ne '127.0.0.1').Count -gt 0){throw 'Unexpected non-loopback listener.'}
            if($taskBindings.LocalPort -contains $taskPort){
                if($Probe){
                    & python (Join-Path $PSScriptRoot 'istemci-protokol-test.py') --server $Server
                    if($LASTEXITCODE -ne 0){throw 'Native protocol test failed.'}
                }
                [void]$taskProcess.WaitForExit(3000);break
            }
        }
    }
    if(-not $taskProcess.HasExited){$taskProcess.Kill($true);$taskProcess.WaitForExit();$taskForcedStop=$true}
    else {$taskExit=$taskProcess.ExitCode}
    $taskOutput=$taskStdout.GetAwaiter().GetResult();$taskError=$taskStderr.GetAwaiter().GetResult()
    $taskOutput=$taskOutput -replace '(?im)^.*(?:License|Lisans) Number:\s*\d+.*$','[Local hardware diagnostic redacted]'
    [IO.File]::WriteAllText((Join-Path $taskReport ($Server+'-startup.stdout.log')),$taskOutput,[Text.UTF8Encoding]::new($false))
    [IO.File]::WriteAllText((Join-Path $taskReport ($Server+'-startup.stderr.log')),$taskError,[Text.UTF8Encoding]::new($false))
    $taskSuccess=$taskOutput.Contains('Server started up successfully!') -and ($taskBindings.LocalPort -contains $taskPort)
    [pscustomobject]@{Server=$Server;StartedUtc=$taskStarted.ToString('o');Seconds=([DateTime]::UtcNow-$taskStarted).TotalSeconds;StartupSucceeded=$taskSuccess;LoopbackBindings=$taskBindings;ExitCode=$taskExit;StoppedAfterBoundedTest=$taskForcedStop;ClientLoginTested=$false;Published=$false} | ConvertTo-Json -Depth 5 | Tee-Object -FilePath (Join-Path $taskReport ($Server+'-startup-result.json'))
    if(-not $taskSuccess){Get-Content -LiteralPath (Join-Path $taskReport ($Server+'-startup.stdout.log')) -Tail 26;exit 1}
} finally {
    if(-not $taskProcess.HasExited){$taskProcess.Kill($true);$taskProcess.WaitForExit()}
    $taskProcess.Dispose()
}
