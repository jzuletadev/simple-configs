# Base system: winget check, script execution policy, essential apps, optional Chocolatey.
. "$PSScriptRoot\..\lib\common.ps1"

if (-not (Test-Command winget)) {
    throw 'winget not found. Install or update "App Installer" from the Microsoft Store, then rerun.'
}
Write-Ok "winget $(winget --version)"

# RemoteSigned lets your profile, venv activation and local scripts run.
$policy = "$(Get-ExecutionPolicy -Scope CurrentUser)"
if ($policy -in @('Undefined', 'Restricted', 'AllSigned')) {
    try {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    } catch {
        # Expected when setup runs with -ExecutionPolicy Bypass: the user setting is saved anyway
        # and PowerShell only warns that this session keeps Bypass.
        if ("$(Get-ExecutionPolicy -Scope CurrentUser)" -ne 'RemoteSigned') { throw }
    }
    Write-Ok 'Execution policy set to RemoteSigned for your user'
} else {
    Write-Ok "Execution policy already $policy"
}

$essentials = [ordered]@{
    'Git.Git'                     = 'Git for Windows (also gives Claude Code its Bash tool)'
    'Microsoft.PowerShell'        = 'PowerShell 7'
    'Microsoft.WindowsTerminal'   = 'Windows Terminal'
    'Microsoft.VisualStudioCode'  = 'Visual Studio Code'
    '7zip.7zip'                   = '7-Zip'
}
Write-Step 'Essential apps'
foreach ($id in $essentials.Keys) {
    if (Test-WingetPackage $id) { Write-Ok "$($essentials[$id]) already installed"; continue }
    if (Confirm-Choice "Install $($essentials[$id])?") { Install-WingetPackage -Id $id -Name $essentials[$id] }
}

if (Confirm-Choice 'Upgrade every app winget can update?' -DefaultNo) {
    winget upgrade --all --silent --accept-source-agreements --accept-package-agreements
}

if (Test-Command choco) {
    Write-Ok 'Chocolatey already installed'
} elseif (Confirm-Choice 'Install Chocolatey (second package source, needs admin)?' -DefaultNo) {
    $install = '[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072; ' +
               "Invoke-Expression ((New-Object Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    [void](Invoke-Elevated $install 'Chocolatey install')
    Update-SessionPath
    if (Test-Command choco) { Write-Ok 'Chocolatey installed' }
}

Write-Ok 'Base setup done'
