$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$taskReport=Join-Path $taskRoot '06_Dokumantasyon\Kurulum'
$taskStatus=Get-Content -LiteralPath (Join-Path $taskReport 'kurulum-durumu.json') -Raw | ConvertFrom-Json
if($taskStatus.Stage -ne 'InstallingSql') { throw 'SQL setup is not in the expected stage; no service was changed.' }
$taskLog='C:\Program Files\Microsoft SQL Server\160\Setup Bootstrap\Log\20261104_211615\Detail.txt'
if(-not ((Get-Content -LiteralPath $taskLog -Tail 15) -match 'msiserver')) { throw 'SQL setup is not waiting on Windows Installer.' }
$taskInProgress='HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\InProgress'
if(Test-Path -LiteralPath $taskInProgress -ErrorAction Stop) { throw 'An MSI installation is in progress; refusing to stop the installer service.' }
$taskService=Get-CimInstance Win32_Service -Filter "Name='msiserver'"
$taskProcesses=@(Get-CimInstance Win32_Process -Filter "Name='msiexec.exe'")
$taskClients=@($taskProcesses | Where-Object { $_.ProcessId -ne $taskService.ProcessId })
if($taskClients.Count -gt 0) { throw 'An MSI client is active; refusing to stop the installer service.' }
$taskServer=@($taskProcesses | Where-Object ProcessId -EQ $taskService.ProcessId)
if($taskServer.Count -ne 1 -or $taskServer[0].CommandLine -notmatch '(?i)\s/V\s*$') { throw 'The process is not an idle Windows Installer service server.' }
[pscustomobject]@{Service=$taskService.Name; State=$taskService.State; AcceptStop=$taskService.AcceptStop; ProcessId=$taskService.ProcessId; CommandLine=$taskServer[0].CommandLine; ActiveMsiClients=$taskClients.Count; InProgressKey=$false; Utc=[DateTime]::UtcNow.ToString('o')} |
    ConvertTo-Json | Set-Content -LiteralPath (Join-Path $taskReport 'msi-idle-preflight.json') -Encoding utf8
# Both prerequisite installer logs returned success. SQL setup itself is waiting
# for this idle service to stop before installing any engine MSI packages.
if($taskService.AcceptStop) { Stop-Service -Name msiserver -ErrorAction Stop }
else { Stop-Process -Id $taskService.ProcessId -Force -ErrorAction Stop }
'Idle Windows Installer service was stopped; SQL setup may start it again.' |
    Set-Content -LiteralPath (Join-Path $taskReport 'msi-idle-repair.txt') -Encoding utf8
