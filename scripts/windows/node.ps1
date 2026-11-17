# Node.js through fnm (same version manager as on Linux).
. "$PSScriptRoot\..\lib\common.ps1"

Install-WingetPackage -Id 'Schniz.fnm' -Name 'fnm'
Add-ProfileSnippet
fnm env --shell powershell | Out-String | Invoke-Expression

$version = Read-Value "Node version to install ('lts' or a major like 22)" -Default 'lts'
if ($version -eq 'lts') {
    fnm install --lts
    fnm default lts-latest
} else {
    fnm install $version
    fnm default $version
}
fnm env --shell powershell | Out-String | Invoke-Expression
Write-Ok "node $(node -v), npm $(npm -v)"

$globals = Read-Value 'Global npm packages to install (space separated, Enter to skip)'
if ($globals) { npm install -g ($globals -split '\s+') }

Write-Ok 'Node setup done. Open a new terminal to load fnm.'
