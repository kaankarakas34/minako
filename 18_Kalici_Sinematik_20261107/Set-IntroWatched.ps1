$ErrorActionPreference='Stop'
$taskReport=[ordered]@{Success=$false;View='Registry32';Key='HKLM\Software\KnightOnlineUS\ServerSelect';Value='ShowIntroMovie';Type='Binary';Data='01000000';OtherSettingsChanged=$false;Utc=[DateTime]::UtcNow.ToString('o')}
$taskBase=$null;$taskKey=$null
try {
    $taskPrincipal=[Security.Principal.WindowsPrincipal]::new([Security.Principal.WindowsIdentity]::GetCurrent())
    if(-not $taskPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)){throw 'Windows administrator approval is required for this game setting.'}
    $taskBase=[Microsoft.Win32.RegistryKey]::OpenBaseKey([Microsoft.Win32.RegistryHive]::LocalMachine,[Microsoft.Win32.RegistryView]::Registry32)
    $taskKey=$taskBase.CreateSubKey('Software\KnightOnlineUS\ServerSelect',$true)
    $taskOld=$taskKey.GetValue('ShowIntroMovie',$null)
    $taskReport.PreviouslyPresent=$null -ne $taskOld
    if($null -ne $taskOld){$taskReport.PreviousType=$taskKey.GetValueKind('ShowIntroMovie').ToString();$taskReport.PreviousData=$taskOld}
    $taskKey.SetValue('ShowIntroMovie',[byte[]]@(1,0,0,0),[Microsoft.Win32.RegistryValueKind]::Binary)
    $taskRead=[byte[]]$taskKey.GetValue('ShowIntroMovie')
    if([BitConverter]::ToString($taskRead) -ne '01-00-00-00'){throw 'Game intro completion flag verification failed.'}
    $taskReport.Success=$true
}catch{$taskReport.Error=$_.Exception.Message}
finally {
    if($null -ne $taskKey){$taskKey.Dispose()};if($null -ne $taskBase){$taskBase.Dispose()}
    $taskReport|ConvertTo-Json -Depth 4|Set-Content -LiteralPath (Join-Path $PSScriptRoot 'intro-flag-result.json') -Encoding utf8
}
if(-not $taskReport.Success){exit 1}
