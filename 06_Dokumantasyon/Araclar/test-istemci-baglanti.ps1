param([Parameter(Mandatory=$true)][int]$ClientProcessId,[int]$Seconds=240)
$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskProcess=Get-Process -Id $ClientProcessId -ErrorAction Stop
if($taskProcess.ProcessName -ne 'KnightOnLine' -or $taskProcess.Path -notlike '*\KnightOnlineLab\ClientGamesoft\KnightOnLine.exe'){throw 'Unexpected client process; refusing to monitor it.'}
$taskFile=Join-Path $taskRoot '11_Istemci_Uyumluluk\client-tcp-endpoints.jsonl'
$taskSeen=[Collections.Generic.HashSet[string]]::new()
$taskDeadline=[DateTime]::UtcNow.AddSeconds($Seconds)
while([DateTime]::UtcNow -lt $taskDeadline) {
    if(-not(Get-Process -Id $ClientProcessId -ErrorAction SilentlyContinue)){break}
    $taskLines=& netstat.exe -ano -p tcp
    foreach($taskLine in $taskLines) {
        if($taskLine -notmatch "\s$ClientProcessId\s*$"){continue}
        $taskParts=$taskLine.Trim() -split '\s+'
        if($taskParts.Count -lt 5){continue}
        $taskKey=$taskParts[1]+'|'+$taskParts[2]+'|'+$taskParts[3]
        if($taskSeen.Add($taskKey)) {
            [pscustomobject]@{Utc=[DateTime]::UtcNow.ToString('o');ClientPid=$ClientProcessId;Local=$taskParts[1];Remote=$taskParts[2];State=$taskParts[3]} | ConvertTo-Json -Compress | Add-Content -LiteralPath $taskFile -Encoding utf8
        }
    }
    [Threading.Thread]::Sleep(250)
}
[pscustomobject]@{ClientPid=$ClientProcessId;DistinctTcpStates=$taskSeen.Count;CredentialsCaptured=$false}|ConvertTo-Json -Compress
