[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$SettingsPath,
    [Parameter(Mandatory)][string]$ManifestPath,
    [Parameter(Mandatory)][string]$TemplateListName,
    [Parameter(Mandatory)][ValidateSet('GlobalSniping59th', 'AutoBidder')][string]$Mode
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
if (-not $root) { throw 'Settings file lacks AccountSettings/FiltersList.' }
$templates = @($root.SelectNodes('FiltersList') | Where-Object { $_.FilterListName -eq $TemplateListName })
if ($templates.Count -ne 1) { throw 'Exactly one UI-created template list is required.' }
$template = @($templates[0].SelectNodes('ListFiltersToSearch/FiltersToSearch')) | Select-Object -First 1
if (-not $template) { throw 'The template list has no filters.' }

$expected = if ($Mode -eq 'GlobalSniping59th') {
    @{ AutoBuyer='false'; AutoBidder='false'; GlobalBids='false'; GlobalSniping='true'; CoinsTransfer='false' }
} else {
    @{ AutoBuyer='false'; AutoBidder='true'; GlobalBids='true'; GlobalSniping='false'; CoinsTransfer='false' }
}
foreach ($pair in $expected.GetEnumerator()) {
    $node = $template.SelectSingleNode($pair.Key)
    if (-not $node -or $node.InnerText -ne $pair.Value) {
        throw "Template is not a verified $Mode filter: expected $($pair.Key)=$($pair.Value)."
    }
}

$fieldMap = @{
    quality='PlayerQuality'; rarity='PlayerRarity'; ratingFrom='RatingFrom'; ratingTo='RatingTo'
    nationality='PlayerNationality'; league='PlayerLeague'; club='PlayerClub'; position='PlayerPosition'
    minBidPrice='MinBid_MaxRange'; maxBidPrice='SellPrice'; minBuyNowPrice='MinBuyPrice'
    maxBuyNowPrice='MaxBuyPrice'; minBuyPrice='MinBuyPrice'; maxBuyPrice='MaxBuyPrice'
    sellPrice='SellPrice'; offerLimit='OfferLimit'; minProfit='MinProfit'
    maxBidsPerPage='MaxBidsPerPage'; maxCardsPerSearch='MaxCardsPerSearch'; pageFrom='PageFrom'
    pageTo='PageTo'; listCardsTime='ListCardsTime'; useFilterTime='UseFilterTime'
}
if ($Mode -eq 'GlobalSniping59th') {
    $fieldMap += @{
        gsMinBinMaxRange='GS_MinBIN_MaxRange'; gsMaxBinMaxRange='GS_MaxBIN_MaxRange'
        useAccountCoins='MaxBIN_UseAccountCoins'; syncTiming='GS_SyncTiming'
        maxSearchesNo59th='GS_MaxSearchesNo59th'; disableFilterNo59th='GS_DisableFilterNo59th'
        increaseSearches='IncreaseSearches'
    }
} else {
    $fieldMap += @{
        autoBidderMaxBuyPrice='AutoBidder_MaxBuyPrice'; minToExpire='AutoBidder_MinToExpire'
        maxCardsWatching='AutoBidder_MaxCardsWatching'; secondsToWatchlist='AutoBidder_SecondsToWL'
        secondsToBid='AutoBidder_SecondsToBid'; excludeLastToWatchlist='AutoBidder_ExcludeLastToWL'
        excludeRarities='AutoBidder_ExcludeRarities'; providers='AutoBidder_Providers'
        providerMinutes='AutoBidder_ProviderMinutes'; maxOfferAfterBids='AutoBidder_MaxOfferAfterBids'
        maxOfferAfterBidsPercent='AutoBidder_MaxOfferAfterBidsPerc'
        secondsWaitAfterWatchlist='AutoBidder_SecsWaitAfterWL'; skipLastBid='AutoBidder_SkipLastBid'
        stayWatchlistCards='AutoBidder_StayWLCards'; stayWatchlistSeconds='AutoBidder_StayWLSeconds'
    }
}

$created = [Collections.Generic.List[string]]::new()
foreach ($item in $manifest) {
    $listName = [string]$item.listName
    $filtersInput = @($item.filters)
    if ([string]::IsNullOrWhiteSpace($listName) -or $filtersInput.Count -eq 0) {
        throw "Invalid list '$listName'."
    }
    if (@($root.SelectNodes('FiltersList') | Where-Object { $_.FilterListName -eq $listName }).Count) {
        throw "List already exists: $listName"
    }

    $seen = @{}
    $list = $doc.CreateElement('FiltersList')
    $nameNode = $doc.CreateElement('FilterListName'); $nameNode.InnerText = $listName
    [void]$list.AppendChild($nameNode)
    $container = $doc.CreateElement('ListFiltersToSearch')
    foreach ($input in $filtersInput) {
        $filterName = [string]$input.name
        if ([string]::IsNullOrWhiteSpace($filterName) -or $seen.ContainsKey($filterName)) {
            throw "Missing or duplicate filter name in $listName."
        }
        $seen[$filterName] = $true
        $filter = $template.CloneNode($true)
        $fixed = @{
            FilterName=$filterName; PlayerName=''; PlayerBaseId='0'; PlayerId='0'; PlayerIdSearch='false'
            UseFilter='true'; AutoBuyer=$expected.AutoBuyer; AutoBidder=$expected.AutoBidder
            GlobalBids=$expected.GlobalBids; GlobalSniping=$expected.GlobalSniping
            CoinsTransfer=$expected.CoinsTransfer
        }
        foreach ($pair in $fixed.GetEnumerator()) {
            $node = $filter.SelectSingleNode($pair.Key)
            if (-not $node) { throw "Template lacks $($pair.Key)." }
            $node.InnerText = [string]$pair.Value
        }
        $assignedNodes = @{}
        foreach ($property in $input.PSObject.Properties) {
            if ($property.Name -eq 'name') { continue }
            if (-not $fieldMap.ContainsKey($property.Name)) {
                throw "Unsupported $Mode field '$($property.Name)' in $filterName."
            }
            $nodeName = $fieldMap[$property.Name]
            if ($assignedNodes.ContainsKey($nodeName)) {
                throw "Fields '$($assignedNodes[$nodeName])' and '$($property.Name)' target the same XML value in $filterName."
            }
            $assignedNodes[$nodeName] = $property.Name
            $node = $filter.SelectSingleNode($nodeName)
            if (-not $node) { throw "Template lacks $nodeName." }
            $node.InnerText = [string]$property.Value
        }

        $from = [int]$filter.RatingFrom; $to = [int]$filter.RatingTo
        if ($from -lt 0 -or $to -lt $from -or [int]$filter.OfferLimit -lt 0) {
            throw "Invalid rating range or offer limit in $filterName."
        }
        foreach ($range in @(
            @{ Label='Bid'; Min='MinBid_MaxRange'; Max='SellPrice' },
            @{ Label='Buy Now'; Min='MinBuyPrice'; Max='MaxBuyPrice' }
        )) {
            $minNode = $filter.SelectSingleNode($range.Min); $maxNode = $filter.SelectSingleNode($range.Max)
            if (-not $minNode -or -not $maxNode) { throw "Template lacks a $($range.Label) price field." }
            $min = [int]$minNode.InnerText; $max = [int]$maxNode.InnerText
            if ($min -lt 0 -or $max -lt 0 -or ($max -gt 0 -and $max -lt $min)) {
                throw "Invalid $($range.Label) price range in $filterName."
            }
        }
        [void]$container.AppendChild($filter)
    }
    [void]$list.AppendChild($container); [void]$root.AppendChild($list); $created.Add($listName)
}

$temp = "$SettingsPath.codex-tmp"
$backup = "$SettingsPath.before-codex-$($Mode.ToLowerInvariant()).bak"
$doc.Save($temp)
$check = [xml]::new(); $check.Load($temp)
foreach ($item in $manifest) {
    $found = @($check.SelectNodes('/AccountSettings/FiltersList/FiltersList') | Where-Object { $_.FilterListName -eq $item.listName })
    $saved = if ($found.Count -eq 1) { @($found[0].SelectNodes('ListFiltersToSearch/FiltersToSearch')) } else { @() }
    if ($found.Count -ne 1 -or $saved.Count -ne @($item.filters).Count) {
        throw "Serialization failed: $($item.listName)"
    }
    foreach ($filter in $saved) {
        foreach ($pair in $expected.GetEnumerator()) {
            if ($filter.SelectSingleNode($pair.Key).InnerText -ne $pair.Value) {
                throw "Mode verification failed: $($item.listName)"
            }
        }
    }
}
[IO.File]::Replace($temp, $SettingsPath, $backup)
Write-Output "Created $($created.Count) $Mode lists. Reopen FutHunter and verify every filter."
