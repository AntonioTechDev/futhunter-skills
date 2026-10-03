param(
    [string]$SourcePath,
    [Parameter(Mandatory = $true)][string]$OutputPath,
    [string]$Start,
    [string]$End
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$culture = [Globalization.CultureInfo]::InvariantCulture

function Parse-Bound([string]$value, [bool]$isEnd) {
    if ([string]::IsNullOrWhiteSpace($value)) { return $null }
    if ($value -match '^\d{4}-\d{2}-\d{2}$') {
        $date = [datetime]::ParseExact($value, 'yyyy-MM-dd', $culture)
        if ($isEnd) { return $date.AddDays(1) }
        return $date
    }
    if ($value -match '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}$') {
        $date = [datetime]::ParseExact($value, "yyyy-MM-dd'T'HH:mm:ss", $culture)
        if ($isEnd) { return $date.AddSeconds(1) }
        return $date
    }
    throw "Invalid date '$value'. Use yyyy-MM-dd or yyyy-MM-ddTHH:mm:ss."
}

$from = Parse-Bound $Start $false
$untilExclusive = Parse-Bound $End $true
if ($from -and $untilExclusive -and $from -ge $untilExclusive) {
    throw 'Start must be earlier than End.'
}

if (-not $SourcePath) {
    $candidates = @(
        Get-Process -Name 'FUTHunter' -ErrorAction SilentlyContinue |
            ForEach-Object { if ($_.Path) { Join-Path (Split-Path $_.Path) 'Transactions.dat' } } |
            Where-Object { Test-Path -LiteralPath $_ } |
            Select-Object -Unique
    )
    if ($candidates.Count -eq 1) {
        $SourcePath = $candidates[0]
    } elseif ($candidates.Count -gt 1) {
        throw 'Multiple FutHunter installations are running. Pass -SourcePath explicitly.'
    } else {
        $fallback = Join-Path $env:USERPROFILE 'Downloads\FUTHunter_NEW\FUTHunter_NEW\Transactions.dat'
        if (Test-Path -LiteralPath $fallback) { $SourcePath = $fallback }
        else { throw 'Transactions.dat not found. Pass -SourcePath explicitly.' }
    }
}

$SourcePath = (Resolve-Path -LiteralPath $SourcePath).Path
$OutputPath = [IO.Path]::GetFullPath($OutputPath)
if ($SourcePath -eq $OutputPath) { throw 'OutputPath must differ from SourcePath.' }

$lines = [IO.File]::ReadAllLines($SourcePath, [Text.UTF8Encoding]::new($false, $true))
$records = [Collections.Generic.List[object]]::new()
$allDates = [Collections.Generic.List[datetime]]::new()
for ($i = 0; $i -lt $lines.Length; $i++) {
    if ($lines[$i].Length -eq 0) { continue }
    $fields = $lines[$i].Split([string[]]@('||'), [StringSplitOptions]::None)
    if ($fields.Length -ne 15) { throw "Malformed source row $($i + 1): expected 15 fields, got $($fields.Length)." }
    try {
        $timestamp = [datetime]::ParseExact($fields[8], 'yyyy-MM-dd HH:mm:ss', $culture)
        $lost = [bool]::Parse($fields[9])
        $auction = [bool]::Parse($fields[7])
        $buyPrice = [long]::Parse($fields[4], $culture)
        $sellPrice = [long]::Parse($fields[5], $culture)
        $profit = [long]::Parse($fields[6], $culture)
        $bids = [long]::Parse($fields[11], $culture)
        $relist = [long]::Parse($fields[13], $culture)
    } catch {
        throw "Malformed value on source row $($i + 1): $($_.Exception.Message)"
    }
    $allDates.Add($timestamp)
    if (($from -and $timestamp -lt $from) -or ($untilExclusive -and $timestamp -ge $untilExclusive)) { continue }
    $records.Add([pscustomobject]@{
        SourceRow  = $i + 1
        Console    = $fields[0]
        FilterName = $fields[1]
        Account    = $fields[2]
        PlayerName = $fields[3]
        BuyPrice   = $buyPrice
        SellPrice  = $sellPrice
        Profit     = $profit
        Auction    = $auction
        DateTime   = $timestamp.ToString('yyyy-MM-dd HH:mm:ss', $culture)
        Lost       = $lost
        ListName   = $fields[10]
        Bids       = $bids
        InternalId = $fields[12]
        Relist     = $relist
        SoldAt     = $fields[14]
    })
}

$parent = Split-Path -Parent $OutputPath
if (-not (Test-Path -LiteralPath $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
if ($records.Count) {
    $records | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding utf8
} else {
    '"SourceRow","Console","FilterName","Account","PlayerName","BuyPrice","SellPrice","Profit","Auction","DateTime","Lost","ListName","Bids","InternalId","Relist","SoldAt"' |
        Set-Content -LiteralPath $OutputPath -Encoding utf8
}

$dates = @($allDates | Sort-Object)
[pscustomobject]@{
    SourcePath      = $SourcePath
    OutputPath      = $OutputPath
    SourceRows      = $allDates.Count
    ExportedRows    = $records.Count
    SourceFirstDate = if ($dates.Count) { $dates[0].ToString('yyyy-MM-dd HH:mm:ss') } else { $null }
    SourceLastDate  = if ($dates.Count) { $dates[-1].ToString('yyyy-MM-dd HH:mm:ss') } else { $null }
}

