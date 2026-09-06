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
                Mod = $mod
                Version = $Tag.Substring($prefix.Length)
            }
        }
    }
)

if ($matches.Count -ne 1 -or [string]::IsNullOrWhiteSpace($matches[0].Version)) {
    throw "Unsupported release tag '$Tag'. Expected '<mod-key>-v<version>' for exactly one key in release\mods.json."
}

$match = $matches[0]
$mod = $match.Mod

if (-not $env:GITHUB_OUTPUT) {
    Write-Output "key=$($mod.key)"
    Write-Output "version=$($match.Version)"
    exit 0
}

Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "key=$($mod.key)"
Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "version=$($match.Version)"
Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "label=$($mod.label)"
Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "nexus_published=$($mod.nexusPublished.ToString().ToLowerInvariant())"
Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "nexus_game_domain=$($mod.nexusGameDomain)"
Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "nexus_mod_id_secret=$($mod.nexusModIdSecret)"
Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "nexus_file_id_secret=$($mod.nexusFileIdSecret)"
