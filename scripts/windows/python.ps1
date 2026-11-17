# Python 3 (chosen version) and optional uv.
. "$PSScriptRoot\..\lib\common.ps1"

$version = Read-Value 'Python version (3.x)' -Default '3.13'
Install-WingetPackage -Id "Python.Python.$version" -Name "Python $version"

if (-not (Test-Command uv) -and (Confirm-Choice 'Install uv (fast package/venv manager, also installs other Python versions)?')) {
    Install-WingetPackage -Id 'astral-sh.uv' -Name 'uv'
}

Write-Note 'If "python" opens the Microsoft Store, turn off the python.exe aliases in Settings > Apps > Advanced app settings > App execution aliases.'
Write-Ok 'Python setup done. Use a venv per project: python -m venv .venv'
