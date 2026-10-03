param(
    [Parameter(Mandatory)][string]$SettingsPath,
    [Parameter(Mandatory)][string]$ManifestPath,
    [Parameter(Mandatory)][string]$TemplateListName
)
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$resolvedSettings = [System.IO.Path]::GetFullPath($SettingsPath)
foreach ($process in @(Get-Process -Name FUTHunter -ErrorAction SilentlyContinue)) {
    if ($process.Path -and (Join-Path (Split-Path $process.Path) 'FUTHunter_AccountSettings.xml') -eq $resolvedSettings) {
        throw 'Close FutHunter before editing its active settings file.'
    }
}

$items = @(Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json)
if ($items.Count -eq 0) { throw 'Manifest is empty.' }
$doc = [xml]::new()
$doc.PreserveWhitespace = $true
$doc.Load($SettingsPath)
$root = $doc.DocumentElement.SelectSingleNode('FiltersList')
$templateList = @($root.SelectNodes('FiltersList') | Where-Object { $_.SelectSingleNode('FilterListName').InnerText -eq $TemplateListName })
if ($templateList.Count -ne 1) { throw 'Exactly one UI-created template list is required.' }
$template = $templateList[0].SelectSingleNode('ListFiltersToSearch/FiltersToSearch')
if ($null -eq $template -or $template.SelectSingleNode('PlayerFutbinVersion').InnerText -ne '0' -or $template.SelectSingleNode('PlayerRarity').InnerText -ne 'Common') {
    throw 'This script supports only base common cards matching the UI template.'
}

$created = @()
foreach ($item in $items) {
    $name = [string]$item.listName
    $cap = [int]$item.cap
    $cards = @($item.cards)
    if ([string]::IsNullOrWhiteSpace($name) -or $cap -le 0 -or $cards.Count -lt 1) { throw "Invalid list: $name" }
    $existing = @($root.SelectNodes('FiltersList') | Where-Object { $_.SelectSingleNode('FilterListName').InnerText -eq $name })
    if ($existing.Count -gt 1) { throw "Duplicate list: $name" }
    if ($existing.Count -eq 1) {
        $saved = @($existing[0].SelectNodes('ListFiltersToSearch/FiltersToSearch'))
        if ($saved.Count -ne $cards.Count) { throw "Incomplete existing list: $name" }
        for ($j=0; $j -lt $cards.Count; $j++) {
            if ([int]$saved[$j].SelectSingleNode('PlayerId').InnerText -ne [int]$cards[$j].eaId -or [int]$saved[$j].SelectSingleNode('MaxBuyPrice').InnerText -gt $cap) {
                throw "Existing list does not match manifest: $name"
            }
        }
        continue
    }

    $list = $doc.CreateElement('FiltersList')
    $listName = $doc.CreateElement('FilterListName')
    $listName.InnerText = $name
    [void]$list.AppendChild($listName)
    $filters = $doc.CreateElement('ListFiltersToSearch')
    foreach ($card in $cards) {
        $sell = [int]$card.sellPrice
        $sell95 = [int][math]::Floor($sell * 0.95)
        if ($card.PSObject.Properties.Name -contains 'maxBuyPrice' -and $null -ne $card.maxBuyPrice) {
            $buy = [int]$card.maxBuyPrice
        } else {
            $target = [int][math]::Min($cap, ($sell95 - 1000))
            $step = if ($target -lt 1000) { 50 } elseif ($target -lt 10000) { 100 } elseif ($target -lt 50000) { 250 } elseif ($target -lt 100000) { 500 } else { 1000 }
            $buy = [int]([math]::Floor($target / $step) * $step)
        }
        if ($buy -le 0 -or $buy -gt $cap -or $buy -ge $sell95 -or [int]$card.eaId -le 0) { throw "Invalid price or ID in $name" }
        $filter = $template.CloneNode($true)
        $values = @{
            FilterName=[string]$card.name; PlayerName=[string]$card.name
            PlayerBaseId=[int]$card.eaId; PlayerId=[int]$card.eaId
            MinRangePrice=[int]$card.rangeMin; MaxRangePrice=[int]$card.rangeMax
            SellPrice=$sell; SellPrice95=$sell95; MaxBuyPrice=$buy
            GS_MaxBIN_MaxRange=$buy; MinProfit=($sell95-$buy)
        }
        foreach ($key in $values.Keys) {
            $node = $filter.SelectSingleNode($key)
            if ($null -eq $node) { throw "Template lacks $key" }
            $node.InnerText = [string]$values[$key]
        }
        [void]$filters.AppendChild($filter)
    }
    [void]$list.AppendChild($filters)
    [void]$root.AppendChild($list)
    $created += $name
}

if ($created.Count -eq 0) { Write-Output 'All lists already match the manifest.'; exit 0 }
$temp = "$SettingsPath.codex-tmp"
$backup = "$SettingsPath.before-codex-lists.bak"
$doc.Save($temp)
$check = [xml]::new(); $check.Load($temp)
foreach ($name in $created) {
    $found = @($check.DocumentElement.SelectNodes('FiltersList/FiltersList') | Where-Object { $_.SelectSingleNode('FilterListName').InnerText -eq $name })
    $item = @($items | Where-Object { $_.listName -eq $name })
    if ($found.Count -ne 1 -or $item.Count -ne 1 -or $found[0].SelectNodes('ListFiltersToSearch/FiltersToSearch').Count -ne @($item[0].cards).Count) { throw "Serialization failed: $name" }
}
[System.IO.File]::Replace($temp, $SettingsPath, $backup)
Write-Output "Created $($created.Count) lists. Reopen FutHunter and inspect each list."

