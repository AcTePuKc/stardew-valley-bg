[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Tag
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$config = Get-Content -Raw -LiteralPath (Join-Path $repoRoot "release\mods.json") | ConvertFrom-Json
$matches = @(
    foreach ($mod in $config.mods) {
        $prefix = "$($mod.key)-v"
        if ($Tag.StartsWith($prefix, [System.StringComparison]::Ordinal)) {
            [PSCustomObject]@{
                Release = $mod
                Mods = @($mod)
                Version = $Tag.Substring($prefix.Length)
            }
        }
    }

    foreach ($bundle in @($config.releaseBundles)) {
        if ($null -eq $bundle) {
            continue
        }

        $prefix = "$($bundle.key)-v"
        if ($Tag.StartsWith($prefix, [System.StringComparison]::Ordinal)) {
            $bundleMods = @($bundle.modKeys | ForEach-Object {
                $bundleModKey = $_
                $mod = $config.mods | Where-Object { $_.key -eq $bundleModKey } | Select-Object -First 1
                if (-not $mod) {
                    throw "Release bundle '$($bundle.key)' references unknown mod key '$bundleModKey'."
                }
                $mod
            })

            [PSCustomObject]@{
                Release = $bundle
                Mods = $bundleMods
                Version = $Tag.Substring($prefix.Length)
            }
        }
    }
)

if ($matches.Count -ne 1 -or [string]::IsNullOrWhiteSpace($matches[0].Version)) {
    throw "Unsupported release tag '$Tag'. Expected '<mod-key>-v<version>' or '<release-bundle-key>-v<version>' for exactly one configured release."
}

$match = $matches[0]
$items = @(
    foreach ($mod in $match.Mods) {
        [PSCustomObject]@{
            key = $mod.key
            label = $mod.label
            version = $match.Version
            nexusPublished = [bool]$mod.nexusPublished
            nexusGameDomain = $mod.nexusGameDomain
            nexusModIdSecret = $mod.nexusModIdSecret
            nexusFileIdSecret = $mod.nexusFileIdSecret
        }
    }
)

if (-not $env:GITHUB_OUTPUT) {
    ConvertTo-Json -InputObject $items -Depth 4
    Write-Output "version=$($match.Version)"
    exit 0
}

$itemsJson = ConvertTo-Json -InputObject $items -Compress -Depth 4
Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "items=$itemsJson"
