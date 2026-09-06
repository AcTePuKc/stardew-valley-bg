[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ModKey,

    [Parameter(Mandatory = $false)]
    [string]$VersionOverride
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$configPath = Join-Path $repoRoot "release\mods.json"
$config = Get-Content -Raw -LiteralPath $configPath | ConvertFrom-Json
$mod = $config.mods | Where-Object { $_.key -eq $ModKey } | Select-Object -First 1

if (-not $mod) {
    throw "Unknown mod key '$ModKey'."
}

if ($null -eq $mod.nexusPublished) {
    throw "Mod '$ModKey' must declare whether it is Nexus-published in release\\mods.json."
}

function Resolve-Version {
    param(
        [object]$ModConfig,
        [string]$RepoRoot,
        [string]$VersionOverride
    )

    if ($VersionOverride) {
        return $VersionOverride
    }

    if ($ModConfig.versionStrategy.type -eq "manifest") {
        $manifestPath = Join-Path $RepoRoot $ModConfig.versionStrategy.manifestPath
        $manifest = Get-Content -Raw -LiteralPath $manifestPath | ConvertFrom-Json
        if (-not $manifest.Version) {
            throw "Manifest '$manifestPath' does not contain a Version field."
        }

        return [string]$manifest.Version
    }

    throw "Mod '$($ModConfig.key)' requires a version to be provided manually."
}

$version = Resolve-Version -ModConfig $mod -RepoRoot $repoRoot -VersionOverride $VersionOverride
$sourcePath = Join-Path $repoRoot $mod.sourcePath

if (-not (Test-Path -LiteralPath $sourcePath)) {
    throw "Source path '$sourcePath' does not exist."
}

$distDir = Join-Path $repoRoot "dist"
New-Item -ItemType Directory -Force -Path $distDir | Out-Null

$safeVersion = $version -replace "[^0-9A-Za-z._-]", "-"
$archiveName = "{0}-{1}.zip" -f $mod.archiveBaseName, $safeVersion
$archivePath = Join-Path $distDir $archiveName

if (Test-Path -LiteralPath $archivePath) {
    Remove-Item -LiteralPath $archivePath -Force
}

$stagingRoot = Join-Path $distDir (".package-{0}" -f [Guid]::NewGuid().ToString("N"))
$stagedSourcePath = Join-Path $stagingRoot (Split-Path -Leaf $sourcePath)

try {
    New-Item -ItemType Directory -Force -Path $stagingRoot | Out-Null
    Copy-Item -LiteralPath $sourcePath -Destination $stagingRoot -Recurse

    # Nexus BBCode descriptions are repository metadata, not mod files.
    Get-ChildItem -LiteralPath $stagedSourcePath -Filter "*.bbcode" -File -Recurse |
        ForEach-Object { Remove-Item -LiteralPath $_.FullName -Force }

    Compress-Archive -LiteralPath $stagedSourcePath -DestinationPath $archivePath -CompressionLevel Optimal
}
finally {
    if (Test-Path -LiteralPath $stagingRoot) {
        Remove-Item -LiteralPath $stagingRoot -Recurse -Force
    }
}

Write-Host "Created archive: $archivePath"
Write-Host "Resolved version: $version"

if ($env:GITHUB_OUTPUT) {
    Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "archive_path=$archivePath"
    Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "archive_name=$archiveName"
    Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "version=$version"
    Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "file_name=$($mod.fileName)"
    Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "file_group_id=$($mod.fileGroupId)"
    Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "category=$($mod.category)"
    Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "label=$($mod.label)"
    Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "description=$($mod.description)"
    Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "archive_existing_file=$($mod.archiveExistingFile.ToString().ToLowerInvariant())"
    Add-Content -LiteralPath $env:GITHUB_OUTPUT -Value "nexus_published=$($mod.nexusPublished.ToString().ToLowerInvariant())"
}
