# PowerShell profile with the repo's shared aliases, and optional WSL.
. "$PSScriptRoot\..\lib\common.ps1"

Add-ProfileSnippet
Write-Ok 'Edit config\powershell\profile.ps1 to add aliases; reload with: . $PROFILE'

if (Confirm-Choice 'Install WSL (Ubuntu inside Windows, needs admin)?' -DefaultNo) {
    do {
        $distro = Read-Value 'Distro (see: wsl --list --online)' -Default 'Ubuntu'
        $valid = $distro -match '^[\w.-]+$'
        if (-not $valid) { Write-Note 'Type the name exactly as wsl --list --online shows it.' }
    } until ($valid)

    # --no-launch: the distro's first-run setup happens later from the Start menu,
    # not inside the administrator window.
    if (Invoke-Elevated "wsl --install -d '$distro' --no-launch" 'WSL install') {
        Write-Note 'Restart Windows if asked, then open the distro from the Start menu to create your Linux user.'
        Write-Note 'Inside WSL you can run this repo too: bash setup.sh'
    }
}

Write-Ok 'Shell setup done'
