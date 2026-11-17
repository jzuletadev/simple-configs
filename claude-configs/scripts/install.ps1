# Installs the global Claude Code configuration (Windows / PowerShell).
# Copies global\CLAUDE.md and global\settings.json to $HOME\.claude.
# Existing files are backed up with a timestamp before being replaced.

$ErrorActionPreference = 'Stop'

$repo  = Split-Path -Parent $PSScriptRoot
$dest  = Join-Path $HOME '.claude'
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

New-Item -ItemType Directory -Force -Path $dest | Out-Null

foreach ($file in @('CLAUDE.md', 'settings.json')) {
    $source = Join-Path $repo "global\$file"
    $target = Join-Path $dest $file

    if (Test-Path $target) {
        Copy-Item $target "$target.bak-$stamp"
        Write-Host "Backup    $target.bak-$stamp"
    }

    Copy-Item $source $target -Force
    Write-Host "Installed $target"
}

if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Warning 'Node.js is not on the PATH. Hooks and some plugins need it (run: .\setup.ps1 node).'
}

# Third-party plugins for this machine: marketplace (repo) and plugin@marketplace
$plugins = @(
    @{ Market = 'DietrichGebert/ponytail';          Plugin = 'ponytail@ponytail' },
    @{ Market = 'GoogleChrome/modern-web-guidance'; Plugin = 'modern-web-guidance@googlechrome' }
)

# In Windows PowerShell 5.1, redirecting an external command's error output while
# 'Stop' is active ends the script even when the command succeeds.
$ErrorActionPreference = 'Continue'

if (Get-Command claude -ErrorAction SilentlyContinue) {
    foreach ($p in $plugins) {
        Write-Host "Plugin    $($p.Plugin)"
        claude plugin marketplace add $p.Market *> $null
        if ($LASTEXITCODE -ne 0) { Write-Warning "Could not add the marketplace $($p.Market)" }
        claude plugin install $p.Plugin *> $null
        if ($LASTEXITCODE -ne 0) { Write-Warning "Could not install $($p.Plugin)" }
    }
} else {
    Write-Warning 'The claude command was not found. Install Claude Code (.\setup.ps1 claude) and run this script again.'
}

Write-Host ''
Write-Host 'Done. Open a new terminal and run: claude'
