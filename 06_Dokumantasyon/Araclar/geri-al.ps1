[CmdletBinding(SupportsShouldProcess = $true)]
param()

$ErrorActionPreference = 'Stop'
$taskRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path.TrimEnd('\')
$taskPrefix = $taskRoot + '\'
$taskPlanFile = Join-Path $taskRoot '06_Dokumantasyon\Envanter\tasima-plani.json'
$taskPlan = @(Get-Content -LiteralPath $taskPlanFile -Raw | ConvertFrom-Json)

function Resolve-CheckedTaskPath([string]$taskRelative) {
    $taskFull = [IO.Path]::GetFullPath((Join-Path $taskRoot $taskRelative))
    if (-not $taskFull.StartsWith($taskPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw "Workspace disinda hedef: $taskFull"
    }
    return $taskFull
}

# Validate every source and destination before moving any original package.
foreach ($taskStep in $taskPlan) {
    $taskFrom = Resolve-CheckedTaskPath $taskStep.To
    $taskTo = Resolve-CheckedTaskPath $taskStep.From
    if (-not (Test-Path -LiteralPath $taskFrom)) { throw "Duzenlenmis paket eksik: $taskFrom" }
    if (Test-Path -LiteralPath $taskTo) { throw "Eski konum dolu; uzerine yazilmayacak: $taskTo" }
}

for ($taskIndex = $taskPlan.Count - 1; $taskIndex -ge 0; $taskIndex--) {
    $taskStep = $taskPlan[$taskIndex]
    $taskFrom = Resolve-CheckedTaskPath $taskStep.To
    $taskTo = Resolve-CheckedTaskPath $taskStep.From
    if ($PSCmdlet.ShouldProcess("$taskFrom -> $taskTo", 'Restore original package location')) {
        $taskParent = [IO.Path]::GetDirectoryName($taskTo)
        if (-not $taskParent.Equals($taskRoot, [StringComparison]::OrdinalIgnoreCase)) {
            $null = Resolve-CheckedTaskPath $taskParent.Substring($taskPrefix.Length)
        }
        New-Item -ItemType Directory -Path $taskParent -Force | Out-Null
        Move-Item -LiteralPath $taskFrom -Destination $taskTo -ErrorAction Stop
    }
}

# Inventory, documentation and now-empty category folders are retained.
Write-Output 'Original package locations processed. Documentation is retained.'
