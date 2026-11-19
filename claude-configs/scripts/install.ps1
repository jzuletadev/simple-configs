# Installs the Claude Code configuration (Windows / PowerShell).
# 1. Copies global\ files to $HOME\.claude, if the repo has any (existing files are backed up).
# 2. Installs the agents, skills, hooks, settings and MCP servers listed in
#    components.txt into $HOME\.claude with claude-code-templates.
# 3. Makes the installed hook commands use absolute paths.

$ErrorActionPreference = 'Stop'

$repo  = Split-Path -Parent $PSScriptRoot
$dest  = Join-Path $HOME '.claude'
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

New-Item -ItemType Directory -Force -Path $dest | Out-Null

foreach ($file in @('CLAUDE.md', 'settings.json')) {
    $source = Join-Path $repo "global\$file"
    $target = Join-Path $dest $file
    if (-not (Test-Path $source)) { continue }

    if (Test-Path $target) {
        Copy-Item $target "$target.bak-$stamp"
        Write-Host "Backup    $target.bak-$stamp"
    }

    Copy-Item $source $target -Force
    Write-Host "Installed $target"
}

if (-not ((Get-Command node -ErrorAction SilentlyContinue) -and (Get-Command npx -ErrorAction SilentlyContinue))) {
    Write-Warning 'Node.js is not on the PATH; skipping agents, skills, hooks and MCP servers (run: .\setup.ps1 node).'
    return
}
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Warning "'python' is not on the PATH; the Python hooks will fail (run: .\setup.ps1 python)."
}

# Build the claude-code-templates arguments from components.txt.
$npxArgs = @('--yes', 'claude-code-templates@latest', '--directory', $HOME, '--yes')
foreach ($line in Get-Content (Join-Path $repo 'components.txt')) {
    if ($line -match '^(agent|skill|hook|setting|mcp)=(.+)$') {
        $npxArgs += "--$($Matches[1])"
        $npxArgs += $Matches[2].Trim()
    }
}

Write-Host "Installing components into $dest (claude-code-templates)"
# Home is the target directory, so everything lands in ~\.claude. --yes keeps it
# non-interactive; hooks and settings then go to ~\.claude\settings.local.json.
# Continue: with 'Stop', Windows PowerShell 5.1 ends the script on native stderr output.
$ErrorActionPreference = 'Continue'
npx @npxArgs
if ($LASTEXITCODE -eq 0) {
    node (Join-Path $PSScriptRoot 'fix-hook-paths.js')
    if ($LASTEXITCODE -ne 0) { Write-Warning 'Could not fix hook paths.' }
} else {
    Write-Warning 'claude-code-templates failed; rerun this module to retry.'
}

Write-Host ''
Write-Host 'Done. Open a new terminal and run: claude'
