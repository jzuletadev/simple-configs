# Git identity, SSH key, ssh-agent, GitHub connection and SSH host aliases.
. "$PSScriptRoot\..\lib\common.ps1"

if (-not (Test-Command git)) { Install-WingetPackage -Id 'Git.Git' -Name 'Git' }
if (-not (Test-Command ssh-keygen)) {
    throw 'OpenSSH client not found. Enable it in Settings > System > Optional features > OpenSSH Client.'
}

# --- Git ---------------------------------------------------------------------
Write-Step 'Git identity'
$name = Read-Value 'Full name' -Default (git config --global user.name) -Required
do {
    $email = Read-Value 'Email' -Default (git config --global user.email) -Required
    $valid = $email -match '^[^@\s]+@[^@\s]+\.[^@\s]+$'
    if (-not $valid) { Write-Note 'That does not look like an email.' }
} until ($valid)

git config --global user.name $name
git config --global user.email $email
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.autocrlf true
git config --global credential.helper manager
# Make Git use Windows OpenSSH so it shares keys with the Windows ssh-agent.
git config --global core.sshCommand 'C:/Windows/System32/OpenSSH/ssh.exe'
Write-Ok "Git configured for $name <$email>"

# --- SSH key -----------------------------------------------------------------
$sshDir = Join-Path $HOME '.ssh'
$key = Join-Path $sshDir 'id_ed25519'
New-Item -ItemType Directory -Force -Path $sshDir | Out-Null

if (Test-Path $key) {
    Write-Ok "SSH key already exists: $key"
} elseif (Confirm-Choice "Generate an SSH key (ed25519) for $email?") {
    Write-Step 'ssh-keygen will ask for an optional passphrase'
    ssh-keygen -t ed25519 -C $email -f $key
}

if (Test-Path "$key.pub") {
    # ssh-agent keeps the key loaded so you type the passphrase once.
    $agent = Get-Service ssh-agent -ErrorAction SilentlyContinue
    if ($agent) {
        if ($agent.StartType -ne 'Automatic' -or $agent.Status -ne 'Running') {
            if (Confirm-Choice 'Enable ssh-agent so the key passphrase is asked only once (needs admin)?') {
                [void](Invoke-Elevated 'Set-Service ssh-agent -StartupType Automatic; Start-Service ssh-agent' 'ssh-agent setup')
            }
        }
        if ((Get-Service ssh-agent).Status -eq 'Running') {
            ssh-add $key
        } else {
            Write-Note 'ssh-agent is off: SSH still works, but asks for the key passphrase every time.'
        }
    }

    # --- GitHub ----------------------------------------------------------------
    if (-not (Test-Command gh) -and (Confirm-Choice 'Install GitHub CLI (gh) to log in and upload the key?')) {
        Install-WingetPackage -Id 'GitHub.cli' -Name 'GitHub CLI'
    }

    if ((Test-Command gh) -and (Confirm-Choice 'Upload the public key to GitHub with gh?')) {
        if ((Invoke-Quiet { gh auth status }) -eq 0) {
            gh auth refresh -h github.com -s admin:public_key
        } else {
            gh auth login -h github.com -p ssh -w -s admin:public_key --skip-ssh-key
        }
        gh ssh-key add "$key.pub" --title $env:COMPUTERNAME
        if ($LASTEXITCODE -ne 0) { Write-Note 'Upload failed (the key may already be on GitHub).' }
    } else {
        Get-Content "$key.pub" | Set-Clipboard
        Write-Ok 'Public key copied to the clipboard'
        Write-Step 'Paste it at https://github.com/settings/ssh/new'
        Read-Host 'Press Enter when done' | Out-Null
    }

    Write-Step 'Testing the GitHub connection'
    ssh -T -o StrictHostKeyChecking=accept-new git@github.com
}

# --- SSH host aliases ----------------------------------------------------------
$config = Join-Path $sshDir 'config'
while (Confirm-Choice 'Add an SSH host alias (e.g. a server or EC2) to ~/.ssh/config?' -DefaultNo) {
    $alias = Read-Value 'Alias (what you type after ssh)' -Required
    if ((Test-Path $config) -and (Select-String -Path $config -Pattern "^Host\s+$([regex]::Escape($alias))\s*$" -Quiet)) {
        Write-Note "Host $alias already exists in $config"
        continue
    }
    $hostName = Read-Value 'HostName (IP or DNS)' -Required
    $user     = Read-Value 'User' -Default $env:USERNAME -Required
    $identity = Read-Value 'IdentityFile' -Default '~/.ssh/id_ed25519' -Required

    Add-Content -Path $config -Encoding ascii -Value @(
        '', "Host $alias", "    HostName $hostName", "    User $user", "    IdentityFile $identity")
    Write-Ok "Connect with: ssh $alias"
}

Write-Ok 'Git and SSH setup done'
