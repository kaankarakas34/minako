param([int]$Seconds=300)
$ErrorActionPreference='Stop'
if($Seconds -lt 0 -or $Seconds -gt 900){throw 'Invalid test duration. Use 0 for a local session without an automatic timeout.'}
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskRun=Join-Path $taskRoot '10_Kaynak_Derleme\Yerel_Calistirma'
$taskProcesses=[Collections.Generic.List[object]]::new()
try {
    foreach($taskServer in @('LogInServer','GameServer')) {
        $taskInfo=[Diagnostics.ProcessStartInfo]::new()
        $taskInfo.FileName=Join-Path $taskRun ($taskServer+'.exe');$taskInfo.WorkingDirectory=$taskRun
        $taskInfo.UseShellExecute=$false;$taskInfo.CreateNoWindow=$true;$taskInfo.WindowStyle=[Diagnostics.ProcessWindowStyle]::Hidden
        $taskInfo.RedirectStandardOutput=$true;$taskInfo.RedirectStandardError=$true;$taskInfo.RedirectStandardInput=$true
        $taskProcess=[Diagnostics.Process]::new();$taskProcess.StartInfo=$taskInfo
        if(-not $taskProcess.Start()){throw 'Could not launch local server.'}
        $taskProcesses.Add([pscustomobject]@{Process=$taskProcess;Server=$taskServer;Output=$taskProcess.StandardOutput.ReadToEndAsync();Error=$taskProcess.StandardError.ReadToEndAsync()})
    }
    $taskDeadline=if($Seconds -eq 0){[DateTime]::MaxValue}else{[DateTime]::UtcNow.AddSeconds($Seconds)};$taskReady=$false
    while([DateTime]::UtcNow -lt $taskDeadline) {
        foreach($taskEntry in $taskProcesses){if($taskEntry.Process.HasExited){throw "$($taskEntry.Server) exited early with code $($taskEntry.Process.ExitCode)."}}
        if(-not $taskReady) {
            $taskPorts=@(Get-NetTCPConnection -State Listen -LocalAddress '127.0.0.1' -ErrorAction SilentlyContinue | Where-Object OwningProcess -in $taskProcesses.Process.Id | Select-Object -ExpandProperty LocalPort)
            if($taskPorts -contains 15001 -and $taskPorts -contains 15100){'Local login/game servers ready for the client compatibility test.';$taskReady=$true}
        }
        [void]$taskProcesses[0].Process.WaitForExit(1000)
    }
}finally {
    foreach($taskEntry in $taskProcesses) {
        $taskProcess=$taskEntry.Process
        if(-not $taskProcess.HasExited){$taskProcess.Kill($true);$taskProcess.WaitForExit()}
        $taskLog=Join-Path $taskRoot "11_Istemci_Uyumluluk\$($taskEntry.Server)-session.log"
        [IO.File]::WriteAllText($taskLog,$taskEntry.Output.GetAwaiter().GetResult(),[Text.UTF8Encoding]::new($false))
        $taskProcess.Dispose()
    }
    'Local client test servers stopped.'
}
