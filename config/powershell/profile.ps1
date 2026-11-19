# Loaded from your PowerShell profile (hook added by setup.ps1).
# Put your aliases and shell tweaks here; `git pull` brings them to every machine.
# Runs on Windows PowerShell 5.1 and PowerShell 7: ASCII only, no && / || / ternary.
# Everything optional is guarded, so a missing tool never breaks the profile.

# --- Encoding --------------------------------------------------------------
try {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.Encoding]::UTF8
} catch { }

# --- Tools -----------------------------------------------------------------
# fnm (Node version manager): switches Node version on cd when .nvmrc/.node-version exists
if (Get-Command fnm -ErrorAction SilentlyContinue) {
    fnm env --use-on-cd --shell powershell | Out-String | Invoke-Expression
}

# zoxide: smarter cd (use `z folder`)
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    (zoxide init powershell | Out-String) | Invoke-Expression
}

# --- PSReadLine (needs 2.x; PowerShell 7 bundles it) -----------------------
if (Get-Module -ListAvailable -Name PSReadLine) {
    try {
        Set-PSReadLineOption -HistoryNoDuplicates -MaximumHistoryCount 10000 -ErrorAction Stop
        Set-PSReadLineOption -PredictionSource History -ErrorAction Stop
        Set-PSReadLineOption -PredictionViewStyle ListView -ErrorAction Stop
    } catch { }
    try {
        # Up/Down search the history for what is already typed; Tab shows a menu.
        Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
        Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
        Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    } catch { }
}

# --- Prompt ----------------------------------------------------------------
# starship if installed; otherwise a light prompt: path, git branch, red on failure.
if (Get-Command starship -ErrorAction SilentlyContinue) {
    Invoke-Expression (& starship init powershell)
} else {
    function Get-GitBranch {
        $dir = (Get-Location).ProviderPath
        while ($dir) {
            $head = Join-Path $dir '.git\HEAD'
            if (Test-Path -LiteralPath $head) {
                $ref = (Get-Content -LiteralPath $head -TotalCount 1)
                if ($ref -match 'ref: refs/heads/(.+)$') { return $Matches[1] }
                if ($ref) { return $ref.Substring(0, [Math]::Min(7, $ref.Length)) }
                return $null
            }
            $parent = Split-Path -Parent $dir
            if ($parent -eq $dir) { break }
            $dir = $parent
        }
        return $null
    }

    function prompt {
        $ok = $?
        $path = (Get-Location).Path.Replace($HOME, '~')
        Write-Host $path -NoNewline -ForegroundColor Cyan
        $branch = Get-GitBranch
        if ($branch) { Write-Host " ($branch)" -NoNewline -ForegroundColor Yellow }
        $color = 'Green'
        if (-not $ok) { $color = 'Red' }
        Write-Host ' >' -NoNewline -ForegroundColor $color
        return ' '
    }
}

# --- Navigation and files --------------------------------------------------
function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function mkcd { param([Parameter(Mandatory)][string]$Path) New-Item -ItemType Directory -Force -Path $Path | Out-Null; Set-Location $Path }
function touch { param([Parameter(Mandatory)][string]$Path) if (Test-Path $Path) { (Get-Item $Path).LastWriteTime = Get-Date } else { New-Item -ItemType File -Path $Path | Out-Null } }
function which { param([Parameter(Mandatory)][string]$Name) Get-Command $Name -All | Select-Object -ExpandProperty Source }
function ports { Get-NetTCPConnection -State Listen | Sort-Object LocalPort | Select-Object LocalAddress, LocalPort, OwningProcess, @{ n = 'Process'; e = { (Get-Process -Id $_.OwningProcess -ErrorAction SilentlyContinue).ProcessName } } }
function reload { . $PROFILE }
Set-Alias -Name ll -Value Get-ChildItem
function la { Get-ChildItem -Force @args }

# --- Git (names that do not clash with built-in aliases such as gc, gl, gp) --
function gs { git status -sb @args }
function ga { git add @args }
function gaa { git add -A }
function gd { git diff @args }
function gds { git diff --staged @args }
function gcmsg { git commit -m @args }
function gpl { git pull --ff-only @args }
function gps { git push @args }
function glg { git log --oneline --graph --decorate -n 20 @args }
function gsw { git switch @args }
function gb { git branch @args }

# --- Docker ----------------------------------------------------------------
function dcu { docker compose up -d @args }
function dcd { docker compose down @args }
function dcl { docker compose logs -f @args }
function dcr { docker compose restart @args }
function dps { docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}' @args }
