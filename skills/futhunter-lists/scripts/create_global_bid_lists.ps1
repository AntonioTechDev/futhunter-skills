[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$SettingsPath,
    [Parameter(Mandatory)][string]$ManifestPath,
    [Parameter(Mandatory)][string]$TemplateListName
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$resolvedSettings = [IO.Path]::GetFullPath($SettingsPath)
foreach ($process in @(Get-Process -Name FUTHunter -ErrorAction SilentlyContinue)) {
    $active = if ($process.Path) { Join-Path (Split-Path $process.Path) 'FUTHunter_AccountSettings.xml' }
    if ($active -and [IO.Path]::GetFullPath($active) -eq $resolvedSettings) {
        throw 'Close FutHunter before editing its active settings file.'
    }
}

$manifest = @(Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json)
if ($manifest.Count -eq 0) { throw 'Manifest is empty.' }
$doc = [xml]::new(); $doc.PreserveWhitespace = $true; $doc.Load($SettingsPath)
$root = $doc.DocumentElement.SelectSingleNode('FiltersList')
$templates = @($root.SelectNodes('FiltersList') | Where-Object { $_.FilterListName -eq $TemplateListName })
if ($templates.Count -ne 1) { throw 'Exactly one UI-created template list is required.' }
$template = @($templates[0].SelectNodes('ListFiltersToSearch/FiltersToSearch')) | Select-Object -First 1
if (-not $template -or $template.GlobalBids -ne 'true' -or $template.AutoBuyer -ne 'false') {
    throw 'The template must be a verified Global Bid filter.'
}

$fieldMap = @{
    quality='PlayerQuality'; rarity='PlayerRarity'; ratingFrom='RatingFrom'; ratingTo='RatingTo'
    nationality='PlayerNationality'; league='PlayerLeague'; club='PlayerClub'; position='PlayerPosition'
    minBuyPrice='MinBuyPrice'; maxBuyPrice='MaxBuyPrice'; sellPrice='SellPrice'; offerLimit='OfferLimit'
    minProfit='MinProfit'; maxBidsPerPage='MaxBidsPerPage'; maxCardsPerSearch='MaxCardsPerSearch'
    pageTo='PageTo'; listCardsTime='ListCardsTime'
}
$created = [Collections.Generic.List[string]]::new()
foreach ($item in $manifest) {
    $name = [string]$item.listName
    $filtersInput = @($item.filters)
    if ([string]::IsNullOrWhiteSpace($name) -or $filtersInput.Count -eq 0) { throw "Invalid list '$name'." }
    if (@($root.SelectNodes('FiltersList') | Where-Object { $_.FilterListName -eq $name }).Count) {
        throw "List already exists: $name"
    }
    $seen = @{}
    $list = $doc.CreateElement('FiltersList')
    $listName = $doc.CreateElement('FilterListName'); $listName.InnerText = $name; [void]$list.AppendChild($listName)
    $container = $doc.CreateElement('ListFiltersToSearch')
    foreach ($input in $filtersInput) {
        $filterName = [string]$input.name
        if ([string]::IsNullOrWhiteSpace($filterName) -or $seen.ContainsKey($filterName)) {
            throw "Missing or duplicate filter name in $name."
        }
        $seen[$filterName] = $true
        $filter = $template.CloneNode($true)
        foreach ($pair in @{FilterName=$filterName; PlayerName=''; PlayerBaseId='0'; PlayerId='0'; PlayerIdSearch='false'; AutoBuyer='false'; GlobalBids='true'; GlobalSniping='false'; UseFilter='true'}.GetEnumerator()) {
            $node = $filter.SelectSingleNode($pair.Key); if (-not $node) { throw "Template lacks $($pair.Key)." }
            $node.InnerText = [string]$pair.Value
        }
        foreach ($property in $input.PSObject.Properties) {
            if ($property.Name -in @('name')) { continue }
            if (-not $fieldMap.ContainsKey($property.Name)) { throw "Unsupported field '$($property.Name)' in $filterName." }
            $node = $filter.SelectSingleNode($fieldMap[$property.Name]); if (-not $node) { throw "Template lacks $($fieldMap[$property.Name])." }
            $node.InnerText = [string]$property.Value
        }
        $from = [int]$filter.RatingFrom; $to = [int]$filter.RatingTo
        if ($from -lt 0 -or $to -lt $from -or [int]$filter.OfferLimit -lt 0) { throw "Invalid range or offer limit in $filterName." }
        [void]$container.AppendChild($filter)
    }
    [void]$list.AppendChild($container); [void]$root.AppendChild($list); $created.Add($name)
}

$temp = "$SettingsPath.codex-tmp"
$backup = "$SettingsPath.before-codex-global-bids.bak"
$doc.Save($temp)
$check = [xml]::new(); $check.Load($temp)
foreach ($name in $created) {
    $found = @($check.SelectNodes('/AccountSettings/FiltersList/FiltersList') | Where-Object { $_.FilterListName -eq $name })
    if ($found.Count -ne 1 -or @($found[0].ListFiltersToSearch.FiltersToSearch).Count -lt 1) { throw "Serialization failed: $name" }
}
[IO.File]::Replace($temp, $SettingsPath, $backup)
Write-Output "Created $($created.Count) Global Bid lists. Reopen FutHunter and verify every filter."
