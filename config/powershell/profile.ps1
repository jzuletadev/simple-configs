# Loaded from your PowerShell profile (hook added by setup.ps1).
# Put your aliases and shell tweaks here; `git pull` brings them to every machine.

# fnm (Node version manager): switches Node version on cd when .nvmrc/.node-version exists
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
}

# History-based suggestions (needs PSReadLine 2.1+, bundled with PowerShell 7)
try { Set-PSReadLineOption -PredictionSource History -ErrorAction Stop } catch { }

# Aliases
Set-Alias -Name ll -Value Get-ChildItem
function gs { git status @args }
function dcu { docker compose up -d @args }
function dcd { docker compose down @args }
function dcl { docker compose logs -f @args }
