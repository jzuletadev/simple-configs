# Docker Desktop (includes Compose). Needs WSL2.
. "$PSScriptRoot\..\lib\common.ps1"

if ((Invoke-Quiet { wsl --status }) -ne 0) {
    Write-Note 'WSL2 is not ready and Docker Desktop needs it.'
    if (Confirm-Choice 'Install WSL now (needs admin)?') {
        if (Invoke-Elevated 'wsl --install --no-distribution' 'WSL install') {
            Write-Note 'Restart Windows before opening Docker Desktop.'
        }
    }
}

Install-WingetPackage -Id 'Docker.DockerDesktop' -Name 'Docker Desktop'

Write-Note 'Open Docker Desktop once to finish its setup (sign-in is optional). Restart Windows if asked.'
Write-Ok 'Docker setup done. Check with: docker run hello-world'
