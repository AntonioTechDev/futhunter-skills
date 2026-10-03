[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$SettingsPath,
    [Parameter(Mandatory)][string]$AssignmentPath
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

$assignments = @(Get-Content -LiteralPath $AssignmentPath -Raw | ConvertFrom-Json)
if ($assignments.Count -eq 0) { throw 'Assignment map is empty.' }
$doc = [xml]::new(); $doc.PreserveWhitespace = $true; $doc.Load($SettingsPath)
$accounts = @($doc.SelectNodes('/AccountSettings/settings/Settings'))
$proxies = @{}
foreach ($proxy in @($doc.SelectNodes('/AccountSettings/ProxyList/Proxy'))) {
    $name = [string]$proxy.ProxyName
    if ($proxies.ContainsKey($name)) { throw "Duplicate proxy name in settings: $name" }
    $proxies[$name] = $proxy
}

$seen = @{}
foreach ($assignment in $assignments) {
    $index = [int]$assignment.accountIndex; $name = [string]$assignment.proxyName
    if ($index -lt 1 -or $index -gt $accounts.Count -or -not $proxies.ContainsKey($name)) { throw "Invalid assignment at account index $index." }
    if ($seen.ContainsKey($index)) { throw "Account index repeated: $index" }
    $seen[$index] = $name; $account = $accounts[$index - 1]; $proxy = $proxies[$name]
    foreach ($pair in @{Proxy_Use='true';Proxy_Address=$proxy.ProxyAddress;Proxy_Port=$proxy.ProxyPort;Proxy_Credentials=$proxy.ProxyCredentials}.GetEnumerator()) {
        $node = $account.SelectSingleNode($pair.Key); if (-not $node) { throw "Account schema lacks $($pair.Key)." }
        $node.InnerText = [string]$pair.Value
    }
}

$temp = "$SettingsPath.codex-tmp"; $backup = "$SettingsPath.before-codex-proxy-assignments.bak"
$doc.Save($temp)
$check = [xml]::new(); $check.Load($temp); $saved = @($check.SelectNodes('/AccountSettings/settings/Settings'))
foreach ($index in $seen.Keys) {
    $proxy = $proxies[$seen[$index]]; $account = $saved[[int]$index - 1]
    if ($account.Proxy_Use -ne 'true' -or $account.Proxy_Address -ne $proxy.ProxyAddress -or $account.Proxy_Port -ne $proxy.ProxyPort) {
        throw "Assignment validation failed at account index $index."
    }
}
[IO.File]::Replace($temp, $SettingsPath, $backup)
Write-Output "Assigned proxies to $($assignments.Count) account indices. Credentials were not printed. Reopen FutHunter and verify the Proxy column."
