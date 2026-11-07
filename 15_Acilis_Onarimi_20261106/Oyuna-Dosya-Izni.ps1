param([ValidateSet('Allow','Undo')][string]$Action='Allow')
$ErrorActionPreference='Stop'
$taskRoot=(Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$taskClient=Join-Path $taskRoot '11_Istemci_Uyumluluk\Gamesoft_Yerel\KnightOnLine.exe'
$taskExpectedHash='683BEFABAE1F217296BEFDA2A824B26BD2FFF77BFF67AA72A66C219C040F12FE'
$taskReportPath=Join-Path $PSScriptRoot 'file-permission-result.json'
$taskReport=[ordered]@{Action=$Action;Target=$taskClient;Utc=[DateTime]::UtcNow.ToString('o');Success=$false;AddedExclusion=$false;ClientRestored=$false;HashVerified=$false;AntivirusDisabled=$false;ProcessExclusionAdded=$false;ThreatFamilyAllowed=$false;ClientExecuted=$false}
$taskAdded=$false
try {
    $taskPrincipal=[Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    if(-not $taskPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){throw 'Windows administrator approval is required.'}
    if($Action -eq 'Undo') {
        Remove-MpPreference -ExclusionPath $taskClient -ErrorAction Stop
        $taskReport.Success=$true
    } else {
        $taskBefore=Get-MpPreference -ErrorAction Stop
        $taskWasExcluded=@($taskBefore.ExclusionPath) -contains $taskClient
        $taskReport.PreviouslyExcluded=$taskWasExcluded
        if(-not $taskWasExcluded){
            Add-MpPreference -ExclusionPath $taskClient -ErrorAction Stop
            $taskAdded=$true;$taskReport.AddedExclusion=$true
        }
        if(-not (@((Get-MpPreference -ErrorAction Stop).ExclusionPath) -contains $taskClient)){throw 'The exact file exclusion was not applied. No broader setting was attempted.'}
        if(-not (Test-Path -LiteralPath $taskClient -PathType Leaf)){
            $taskPlatform=Join-Path $env:ProgramData 'Microsoft\Windows Defender\Platform'
            $taskTools=@(Get-ChildItem -LiteralPath $taskPlatform -Directory -ErrorAction SilentlyContinue | Sort-Object Name -Descending | ForEach-Object {Join-Path $_.FullName 'MpCmdRun.exe'} | Where-Object {Test-Path -LiteralPath $_ -PathType Leaf})
            $taskMp=if($taskTools.Count -gt 0){$taskTools[0]}else{Join-Path $env:ProgramFiles 'Windows Defender\MpCmdRun.exe'}
            if(-not (Test-Path -LiteralPath $taskMp -PathType Leaf)){throw 'Microsoft Defender command line tool not found.'}
            # Restore only the quarantined game path, never all files or a threat family.
            & $taskMp -Restore -FilePath $taskClient *> (Join-Path $PSScriptRoot 'restore-game-file.log')
            $taskReport.RestoreExitCode=$LASTEXITCODE
            if(-not (Test-Path -LiteralPath $taskClient -PathType Leaf)){throw 'The requested game EXE could not be restored from quarantine.'}
            $taskReport.ClientRestored=$true
        }
        $taskHash=(Get-FileHash -LiteralPath $taskClient -Algorithm SHA256 -ErrorAction Stop).Hash
        $taskReport.SHA256=$taskHash
        if($taskHash -ne $taskExpectedHash){throw 'Restored file differs from the previously working game EXE. It was not executed.'}
        $taskReport.HashVerified=$true;$taskReport.Success=$true
    }
} catch {
    $taskReport.Error=$_.Exception.Message
    if($taskAdded){
        try {Remove-MpPreference -ExclusionPath $taskClient -ErrorAction Stop;$taskReport.ExclusionRolledBack=$true}
        catch {$taskReport.RollbackError=$_.Exception.Message}
    }
} finally {
    $taskReport | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $taskReportPath -Encoding utf8
}
if(-not $taskReport.Success){exit 1}
