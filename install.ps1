[CmdletBinding()]
param(
    [string]$Skill = 'all',
    [string]$Destination = '',
    [switch]$Force,
    [switch]$List
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillsRoot = Join-Path $repoRoot 'skills'
if (-not $Destination) {
    $codexRoot = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $env:USERPROFILE '.codex' }
    $Destination = Join-Path $codexRoot 'skills'
}

$available = Get-ChildItem -LiteralPath $skillsRoot -Directory |
    Where-Object { Test-Path (Join-Path $_.FullName 'SKILL.md') } |
    Sort-Object Name

if ($List) {
    $available.Name
    exit 0
}

if (-not $available) { throw "No skills found in $skillsRoot" }
$selected = if ($Skill -eq 'all') {
    $available
} else {
    $available | Where-Object Name -EQ $Skill
}

if (-not $selected) {
    $names = $available.Name -join ', '
    throw "Unknown skill '$Skill'. Available: $names"
}

New-Item -ItemType Directory -Force -Path $Destination | Out-Null
foreach ($item in $selected) {
    $target = Join-Path $Destination $item.Name
    if ((Test-Path -LiteralPath $target) -and -not $Force) {
        throw "$target already exists. Use -Force to replace it."
    }
    if (Test-Path -LiteralPath $target) {
        Remove-Item -LiteralPath $target -Recurse -Force
    }
    Copy-Item -LiteralPath $item.FullName -Destination $target -Recurse
    Write-Host "Installed $($item.Name) -> $target"
}
Write-Host 'Done. Restart Codex to reload installed skills.'
