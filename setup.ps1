<#
Interactive setup for Windows.
  powershell -ExecutionPolicy Bypass -File .\setup.ps1              -> menu
  powershell -ExecutionPolicy Bypass -File .\setup.ps1 git-ssh node -> run those modules directly
#>
param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Modules)

$modulesInfo = [ordered]@{
    'base'      = 'Execution policy, essential apps (Git, PowerShell 7, VS Code...), Chocolatey'
    'git-ssh'   = 'Git identity, SSH key + agent, GitHub login/key upload, SSH host aliases'
    'shell'     = 'PowerShell profile with shared aliases, optional WSL'
    'node'      = 'Node.js via fnm (LTS or chosen version), global npm packages'
    'python'    = 'Python 3 (chosen version), optional uv'
    'docker'    = 'Docker Desktop (checks WSL2)'
    'databases' = 'MySQL / PostgreSQL / MongoDB containers with your passwords'
    'cloud'     = 'AWS, Google Cloud and Azure CLIs with login'
    'claude'    = 'Claude Code, desktop app and claude-configs'
}
$names = @($modulesInfo.Keys)

if (-not $Modules) {
    Write-Host ''
    Write-Host 'simple-configs setup'
    Write-Host ''
    for ($i = 0; $i -lt $names.Count; $i++) {
        Write-Host ('  {0}) {1,-10} {2}' -f ($i + 1), $names[$i], $modulesInfo[$names[$i]])
    }
    Write-Host ''
    $answer = Read-Host "Modules to run (e.g. '1 2 4', 'all', Enter to quit)"
    if (-not $answer) { return }
    if ($answer -eq 'all') {
        $Modules = $names
    } else {
        $Modules = foreach ($n in ($answer -split '[\s,]+' | Where-Object { $_ })) {
            $idx = 0
            if ([int]::TryParse($n, [ref]$idx) -and $idx -ge 1 -and $idx -le $names.Count) { $names[$idx - 1] }
            else { Write-Warning "Ignoring '$n'" }
        }
    }
}

$failed = @()
foreach ($m in $Modules) {
    $script = Join-Path $PSScriptRoot "scripts\windows\$m.ps1"
    if (-not (Test-Path $script)) { Write-Warning "Unknown module: $m"; $failed += $m; continue }
    Write-Host ''
    Write-Host "### $m" -ForegroundColor Magenta
    try { & $script } catch { Write-Host "  ERR $($_.Exception.Message)" -ForegroundColor Red; $failed += $m }
}

Write-Host ''
if ($failed.Count -eq 0) {
    Write-Host 'All done. Open a new terminal to load the changes.' -ForegroundColor Green
} else {
    Write-Host "Finished with errors in: $($failed -join ', '). Fix the issue and rerun: .\setup.ps1 $($failed -join ' ')" -ForegroundColor Red
    exit 1
}
