# Shared helpers for the Windows setup modules.
# Dot-source this file from a module; do not run it directly.
# Works on Windows PowerShell 5.1 and PowerShell 7+. Keep this file ASCII-only.

$ErrorActionPreference = 'Stop'

$RepoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

function Write-Step([string]$Message) { Write-Host "==> $Message" -ForegroundColor Cyan }
function Write-Ok([string]$Message)   { Write-Host "  ok $Message" -ForegroundColor Green }
function Write-Note([string]$Message) { Write-Host "  !! $Message" -ForegroundColor Yellow }

function Test-Command([string]$Name) {
    [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Test-Admin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $id).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Runs a Windows PowerShell command as administrator and waits for it to finish.
# From a normal terminal it shows one UAC prompt and runs the command in a new window,
# which stays open on failure so the error can be read. Returns $true on success.
function Invoke-Elevated {
    param([string]$Command, [string]$Description = 'This step')

    # Exit code 3010 means success with a restart pending (WSL, installers).
    if (Test-Admin) {
        $global:LASTEXITCODE = 0
        try { Invoke-Expression $Command | Out-Host }
        catch { Write-Note "$Description failed: $($_.Exception.Message)"; return $false }
        if ($LASTEXITCODE -and $LASTEXITCODE -ne 3010) {
            Write-Note "$Description failed (exit code $LASTEXITCODE)."
            return $false
        }
        return $true
    }

    $title = $Description.Replace("'", "''")
    $body = @"
`$ErrorActionPreference = 'Stop'
`$code = 0
Write-Host '$title (administrator)' -ForegroundColor Cyan
try {
    $Command
    if (`$LASTEXITCODE -and `$LASTEXITCODE -ne 3010) { `$code = `$LASTEXITCODE }
} catch {
    Write-Host `$_.Exception.Message -ForegroundColor Red
    `$code = 1
}
if (`$code -ne 0) { Read-Host 'Failed. Press Enter to close this window' | Out-Null }
exit `$code
"@
    $startArgs = @{
        FilePath     = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
        ArgumentList = @('-NoProfile', '-ExecutionPolicy', 'Bypass', '-EncodedCommand',
                         [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($body)))
        Verb         = 'RunAs'
        Wait         = $true
        PassThru     = $true
        ErrorAction  = 'Stop'
    }

    Write-Step "Asking for administrator permission: $Description"
    try { $process = Start-Process @startArgs }
    catch { Write-Note "Administrator permission was not granted; skipped: $Description."; return $false }

    if ($null -ne $process.ExitCode -and $process.ExitCode -ne 0) {
        Write-Note "$Description failed (exit code $($process.ExitCode))."
        return $false
    }
    return $true
}

# Empty answer takes the default. -Required repeats until there is a value.
function Read-Value {
    param([string]$Prompt, [string]$Default = '', [switch]$Required)
    while ($true) {
        $label = if ($Default) { "$Prompt [$Default]" } else { $Prompt }
        $value = Read-Host $label
        if ([string]::IsNullOrWhiteSpace($value)) { $value = $Default }
        if ($value -or -not $Required) { return $value }
        Write-Note 'A value is required.'
    }
}

# Hidden input, asked twice to avoid typos. Returns plain text.
function Read-Secret {
    param([string]$Prompt)
    while ($true) {
        $a = ConvertFrom-SecureText (Read-Host $Prompt -AsSecureString)
        $b = ConvertFrom-SecureText (Read-Host "Repeat $Prompt" -AsSecureString)
        if (-not $a) { Write-Note 'A value is required.' }
        elseif ($a -ne $b) { Write-Note 'Values do not match.' }
        else { return $a }
    }
}

function ConvertFrom-SecureText([Security.SecureString]$Secure) {
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Secure)
    try { [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
}

# Yes/no question. Default is yes unless -DefaultNo.
function Confirm-Choice {
    param([string]$Question, [switch]$DefaultNo)
    $hint = if ($DefaultNo) { '[y/N]' } else { '[Y/n]' }
    $answer = Read-Host "$Question $hint"
    if ([string]::IsNullOrWhiteSpace($answer)) { return (-not $DefaultNo) }
    return ($answer -match '^[Yy]')
}

# Reloads PATH from the registry so freshly installed tools work in this session.
function Update-SessionPath {
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user    = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = "$machine;$user"
}

# Runs a native command with all output hidden and returns its exit code.
# Windows PowerShell 5.1 turns redirected stderr into errors, which 'Stop' would make fatal.
function Invoke-Quiet([scriptblock]$Command) {
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { & $Command *> $null } finally { $ErrorActionPreference = $previous }
    return $LASTEXITCODE
}

function Test-WingetPackage([string]$Id) {
    (Invoke-Quiet { winget list --id $Id --exact --accept-source-agreements }) -eq 0
}

function Install-WingetPackage {
    param([string]$Id, [string]$Name = $Id)
    if (-not (Test-Command winget)) {
        throw 'winget not found. Update "App Installer" from the Microsoft Store.'
    }
    if (Test-WingetPackage $Id) { Write-Ok "$Name already installed"; return }

    Write-Step "Installing $Name"
    winget install --id $Id --exact --silent --accept-source-agreements --accept-package-agreements
    # -1978335189 = already installed, no newer version. Other codes (e.g. restart required)
    # are fine as long as winget now sees the package.
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335189) {
        if (-not (Test-WingetPackage $Id)) { throw "winget could not install $Name (exit code $LASTEXITCODE)." }
        Write-Note "$Name installed with a warning from winget; restart Windows if it asks."
    }
    Update-SessionPath
    Write-Ok "$Name installed"
}

# Makes the PowerShell 7 and Windows PowerShell 5.1 profiles load
# config\powershell\profile.ps1 from this repo.
function Add-ProfileSnippet {
    $snippet = Join-Path $RepoRoot 'config\powershell\profile.ps1'
    $line = "if (Test-Path '$snippet') { . '$snippet' }  # simple-configs"
    $docs = [Environment]::GetFolderPath('MyDocuments')
    foreach ($dir in @('PowerShell', 'WindowsPowerShell')) {
        $profilePath = Join-Path $docs "$dir\profile.ps1"
        if ((Test-Path $profilePath) -and
            (Select-String -Path $profilePath -SimpleMatch '# simple-configs' -Quiet)) { continue }
        New-Item -ItemType Directory -Force -Path (Split-Path $profilePath) | Out-Null
        Add-Content -Path $profilePath -Value $line -Encoding ascii
        Write-Ok "Profile hook added to $profilePath"
    }
}
