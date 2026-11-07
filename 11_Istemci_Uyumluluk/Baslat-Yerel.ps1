param([switch]$VerifyOnly,[switch]$NoClient)
$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$taskRuntime=Join-Path $taskRoot '10_Kaynak_Derleme\Yerel_Calistirma'
$taskLogs=Join-Path $PSScriptRoot 'Oturum_Gunlukleri'
New-Item -ItemType Directory -Path $taskLogs -Force|Out-Null
function Get-LocalListener([string]$Address,[int]$Port) {
    # Windows PowerShell 5.1 exposes no scalar .Count on CimInstance. Keep the
    # collection intact even when exactly one listener is returned.
    return ,@(Get-NetTCPConnection -State Listen -LocalAddress $Address -LocalPort $Port -ErrorAction SilentlyContinue)
}
$taskRoles=@(@{Name='LogInServer';Port=15100},@{Name='GameServer';Port=15001})
foreach($taskRole in $taskRoles) {
    $taskListeners=Get-LocalListener '127.0.0.1' $taskRole.Port
    $taskExe=Join-Path $taskRuntime ($taskRole.Name+'.exe')
    if($taskListeners.Count -gt 0) {
        foreach($taskListener in $taskListeners) {
            $taskOwner=Get-Process -Id $taskListener.OwningProcess
            if(-not [string]::Equals($taskOwner.Path,$taskExe,[StringComparison]::OrdinalIgnoreCase)){throw "Local port $($taskRole.Port) belongs to a different application."}
        }
    } elseif(-not $VerifyOnly) {
        Start-Process -FilePath $taskExe -WorkingDirectory $taskRuntime -WindowStyle Hidden -RedirectStandardOutput (Join-Path $taskLogs ($taskRole.Name+'.stdout.log')) -RedirectStandardError (Join-Path $taskLogs ($taskRole.Name+'.stderr.log')) | Out-Null
    }
}
$taskRelay=Get-LocalListener '127.0.0.2' 15100
if($taskRelay.Count -gt 0) {
    $taskRelayOwner=Get-CimInstance Win32_Process -Filter "ProcessId=$($taskRelay[0].OwningProcess)"
    if($taskRelayOwner.CommandLine -notmatch 'istemci-yerel-kayit\.py'){throw 'The local relay port belongs to another application.'}
} elseif(-not $VerifyOnly) {
    $taskPython=(Get-Command python.exe -ErrorAction Stop).Source
    $taskRelayScript=Join-Path $taskRoot '06_Dokumantasyon\Araclar\istemci-yerel-kayit.py'
    Start-Process -FilePath $taskPython -ArgumentList @(('"'+$taskRelayScript+'"'),'--seconds','0') -WorkingDirectory $taskRoot -WindowStyle Hidden -RedirectStandardOutput (Join-Path $taskLogs 'Relay.stdout.log') -RedirectStandardError (Join-Path $taskLogs 'Relay.stderr.log') | Out-Null
}
$taskDeadline=[DateTime]::UtcNow.AddSeconds(60)
do {
    $taskLoginReady=(Get-LocalListener '127.0.0.1' 15100).Count -gt 0
    $taskGameReady=(Get-LocalListener '127.0.0.1' 15001).Count -gt 0
    $taskRelayReady=(Get-LocalListener '127.0.0.2' 15100).Count -gt 0
    if($VerifyOnly -or ($taskLoginReady -and $taskGameReady -and $taskRelayReady)){break}
    [Threading.Thread]::Sleep(500)
}while([DateTime]::UtcNow -lt $taskDeadline)
$taskClientPath=Join-Path $PSScriptRoot 'Gamesoft_Yerel\KnightOnLine.exe'
$taskClientPresent=Test-Path -LiteralPath $taskClientPath -PathType Leaf
$taskResult=[pscustomobject]@{LoginReady=$taskLoginReady;GameReady=$taskGameReady;RelayReady=$taskRelayReady;AllLocalServicesReady=($taskLoginReady -and $taskGameReady -and $taskRelayReady);ClientExecutablePresent=$taskClientPresent;ClientIssue=$(if($taskClientPresent){$null}else{'KnightOnLine.exe is missing; server readiness does not verify the client.'});Published=$false;GraphicalLoginVerified=$false;Utc=[DateTime]::UtcNow.ToString('o')}
$taskResult|ConvertTo-Json|Set-Content -LiteralPath (Join-Path $PSScriptRoot 'local-session-health.json') -Encoding utf8
if(-not $taskResult.AllLocalServicesReady){$taskResult|ConvertTo-Json;throw 'Local services are not ready; inspect Oturum_Gunlukleri.'}
if(-not $VerifyOnly -and -not $NoClient) {
    $taskClientAlias=Join-Path $env:USERPROFILE 'KnightOnlineLab\ClientGamesoft\KnightOnLine.exe'
    $taskClient=Get-Process -Name KnightOnLine -ErrorAction SilentlyContinue|Where-Object {$_.Path -eq $taskClientPath -or $_.Path -eq $taskClientAlias}
    if(-not $taskClient) {
        $taskLauncher=Join-Path $PSScriptRoot 'Yerel_Launcher\bin\Launcher.exe'
        Start-Process -FilePath $taskLauncher -ArgumentList '--start' -WorkingDirectory (Split-Path -Parent $taskLauncher)|Out-Null
    }
}
$taskResult|ConvertTo-Json
