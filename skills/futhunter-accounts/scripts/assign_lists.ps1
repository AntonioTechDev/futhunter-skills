param(
    [Parameter(Mandatory)][string]$SettingsPath,
    [Parameter(Mandatory)][string]$AssignmentPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$resolvedSettings = [System.IO.Path]::GetFullPath($SettingsPath)
foreach ($process in @(Get-Process -Name FUTHunter -ErrorAction SilentlyContinue)) {
    if ($process.Path -and (Join-Path (Split-Path $process.Path) 'FUTHunter_AccountSettings.xml') -eq $resolvedSettings) {
        throw 'Close FutHunter before editing its active settings file.'
    }
}

$assignments = @(Get-Content -LiteralPath $AssignmentPath -Raw | ConvertFrom-Json)
if ($assignments.Count -eq 0) { throw 'Assignment map is empty.' }
$doc = [xml]::new()
$doc.PreserveWhitespace = $true
$doc.Load($SettingsPath)
$accounts = @($doc.DocumentElement.SelectNodes('settings/Settings'))
$lists = @($doc.DocumentElement.SelectNodes('FiltersList/FiltersList'))
$byName = @{}
foreach ($list in $lists) {
    $name = $list.SelectSingleNode('FilterListName').InnerText
    if ($byName.ContainsKey($name)) { throw "Duplicate list in settings: $name" }
    $byName[$name] = $list
}

$seen = @{}
foreach ($assignment in $assignments) {
    $index = [int]$assignment.accountIndex
    $name = [string]$assignment.listName
    if ($index -lt 1 -or $index -gt $accounts.Count -or [string]::IsNullOrWhiteSpace($name)) { throw "Invalid assignment at index $index" }
    if ($seen.ContainsKey($index)) { throw "Account index repeated: $index" }
    if (-not $byName.ContainsKey($name)) { throw "Missing list: $name" }
    $seen[$index] = $name
    $filters = @($byName[$name].SelectNodes('ListFiltersToSearch/FiltersToSearch'))
    if ($filters.Count -lt 1) { throw "Empty list: $name" }
    $account = $accounts[$index - 1]
    $account.SelectSingleNode('FiltersListName').InnerText = $name
    $container = $account.SelectSingleNode('filtersToSearch')
    $container.RemoveAll()
    foreach ($filter in $filters) { [void]$container.AppendChild($doc.ImportNode($filter, $true)) }
}

$temp = "$SettingsPath.codex-tmp"
$backup = "$SettingsPath.before-codex-assignments.bak"
$doc.Save($temp)
$check = [xml]::new(); $check.Load($temp)
$savedAccounts = @($check.DocumentElement.SelectNodes('settings/Settings'))
if ($savedAccounts.Count -ne $accounts.Count) { throw 'Account count changed during serialization.' }
foreach ($index in $seen.Keys) {
    $name = $seen[$index]
    $saved = $savedAccounts[[int]$index - 1]
    $expectedFilters = @($byName[$name].SelectNodes('ListFiltersToSearch/FiltersToSearch'))
    $actualFilters = @($saved.SelectNodes('filtersToSearch/FiltersToSearch'))
    if ($saved.SelectSingleNode('FiltersListName').InnerText -ne $name -or $actualFilters.Count -ne $expectedFilters.Count) {
        throw "Assignment validation failed at account index $index"
    }
    for ($i = 0; $i -lt $expectedFilters.Count; $i++) {
        if ($actualFilters[$i].SelectSingleNode('PlayerId').InnerText -ne $expectedFilters[$i].SelectSingleNode('PlayerId').InnerText) {
            throw "Player validation failed at account index $index"
        }
    }
}
[System.IO.File]::Replace($temp, $SettingsPath, $backup)
Write-Output "Assigned $($assignments.Count) account indices. Reopen FutHunter and verify each requested row."
