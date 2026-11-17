# Claude Code, optional desktop app and the configs in claude-configs\.
. "$PSScriptRoot\..\lib\common.ps1"

if (Test-Command claude) {
    Write-Ok "Claude Code already installed ($(claude --version))"
} else {
    Write-Step 'Installing Claude Code (native installer, updates itself)'
    # Child process so an 'exit' inside the official installer cannot end this script.
    $shell = (Get-Process -Id $PID).Path
    & $shell -NoProfile -ExecutionPolicy Bypass -Command 'irm https://claude.ai/install.ps1 | iex'
    Update-SessionPath
    $localBin = Join-Path $HOME '.local\bin'
    if ($env:Path -notlike "*$localBin*") { $env:Path = "$localBin;$env:Path" }
}

if (-not (Test-Command git)) {
    Write-Note 'Git for Windows is recommended: it gives Claude Code its Bash tool.'
    if (Confirm-Choice 'Install Git now?') { Install-WingetPackage -Id 'Git.Git' -Name 'Git' }
}

if (Confirm-Choice 'Install the Claude desktop app (Chat, Cowork, Code)?' -DefaultNo) {
    Install-WingetPackage -Id 'Anthropic.Claude' -Name 'Claude desktop'
}

& (Join-Path $RepoRoot 'claude-configs\scripts\install.ps1')
