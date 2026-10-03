[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$SettingsPath,
    [Parameter(Mandatory)][string]$CsvPath
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

$first = Get-Content -LiteralPath $CsvPath -TotalCount 1
$delimiter = if (($first.ToCharArray() | Where-Object { $_ -eq ';' }).Count -ge 3) { ';' } else { ',' }
$rows = @(Import-Csv -LiteralPath $CsvPath -Delimiter $delimiter)
if ($rows.Count -eq 0) { throw 'CSV is empty.' }
$aliases = @{
    Name=@('ProxyName','Name'); Address=@('ProxyAddress','Address','Host')
    Port=@('ProxyPort','Port'); Credentials=@('ProxyCredentials','Credentials')
}
function Read-Column($row, [string]$logical) {
    foreach ($name in $aliases[$logical]) {
        if ($row.PSObject.Properties.Name -contains $name) { return [string]$row.$name }
    }
    throw "Missing CSV column for $logical."
}

$doc = [xml]::new(); $doc.PreserveWhitespace = $true; $doc.Load($SettingsPath)
$root = $doc.DocumentElement.SelectSingleNode('ProxyList')
$existing = @($root.SelectNodes('Proxy'))
$names = @{}; $endpoints = @{}; $maxId = 0
foreach ($proxy in $existing) {
    $names[[string]$proxy.ProxyName] = $true
    $endpoints["$($proxy.ProxyAddress):$($proxy.ProxyPort)"] = $true
    $maxId = [Math]::Max($maxId, [int]$proxy.ProxyId)
}

$added = 0
foreach ($row in $rows) {
    $name = (Read-Column $row 'Name').Trim(); $address = (Read-Column $row 'Address').Trim()
    $portText = (Read-Column $row 'Port').Trim(); $credentials = Read-Column $row 'Credentials'
    $port = 0
    if ([string]::IsNullOrWhiteSpace($name) -or [string]::IsNullOrWhiteSpace($address) -or
        -not [int]::TryParse($portText, [ref]$port) -or $port -lt 1 -or $port -gt 65535) {
        throw "Invalid proxy row for '$name'."
    }
    $endpoint = "$address`:$port"
    if ($names.ContainsKey($name) -or $endpoints.ContainsKey($endpoint)) { throw "Duplicate proxy name or endpoint: $name" }
    $maxId++; $proxy = $doc.CreateElement('Proxy')
    foreach ($pair in ([ordered]@{ProxyId=$maxId;ProxyName=$name;ProxyAddress=$address;ProxyPort=$port;ProxyCredentials=$credentials;ProxyStatus=''}).GetEnumerator()) {
        $node = $doc.CreateElement($pair.Key); $node.InnerText = [string]$pair.Value; [void]$proxy.AppendChild($node)
    }
    [void]$root.AppendChild($proxy); $names[$name]=$true; $endpoints[$endpoint]=$true; $added++
}

$temp = "$SettingsPath.codex-tmp"; $backup = "$SettingsPath.before-codex-proxies.bak"
$doc.Save($temp)
$check = [xml]::new(); $check.Load($temp)
if (@($check.SelectNodes('/AccountSettings/ProxyList/Proxy')).Count -ne $existing.Count + $added) { throw 'Proxy count validation failed.' }
[IO.File]::Replace($temp, $SettingsPath, $backup)
Write-Output "Imported $added proxies. Credentials were not printed. Reopen FutHunter and test the new rows."
