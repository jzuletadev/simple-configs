# Copies the project template into the current folder (Windows / PowerShell).
# Usage: from the root of your repo, run this script by its full path.
# Never overwrites files that already exist.

$ErrorActionPreference = 'Stop'

$repo     = Split-Path -Parent $PSScriptRoot
$template = Join-Path $repo 'project-template'
$here     = (Get-Location).Path

New-Item -ItemType Directory -Force -Path (Join-Path $here '.claude') | Out-Null

foreach ($rel in @('CLAUDE.md', '.claude\settings.json')) {
    $target = Join-Path $here $rel
    if (Test-Path $target) {
        Write-Host "Already exists, left as is: $rel"
    } else {
        Copy-Item (Join-Path $template $rel) $target
        Write-Host "Created: $rel"
    }
}

$gitignore = Join-Path $here '.gitignore'
$line = '.claude/settings.local.json'
if (-not (Test-Path $gitignore) -or -not (Select-String -Path $gitignore -SimpleMatch $line -Quiet)) {
    Add-Content -Path $gitignore -Value $line -Encoding ascii
    Write-Host "Added to .gitignore: $line"
}

Write-Host ''
Write-Host 'Fill in CLAUDE.md for this project (or run /init inside claude).'
