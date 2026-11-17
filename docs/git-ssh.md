# Git and SSH

Setup is automated by the `git-ssh` module (`.\setup.ps1 git-ssh` / `bash setup.sh git-ssh`). It asks for your name and email, configures Git, creates an ed25519 key, logs in to GitHub with `gh` and uploads the key, and can add SSH host aliases. This page is the reference for everything after that.

## What the module configures

| Setting | Windows | Linux |
| :- | :- | :- |
| `init.defaultBranch` | `main` | `main` |
| `pull.rebase` | `false` | `false` |
| `core.autocrlf` | `true` | `input` |
| `credential.helper` | `manager` (Git Credential Manager) | `gh auth setup-git` if you log in with gh |
| `core.sshCommand` | Windows OpenSSH, so Git shares keys with `ssh-agent` | default |

Check your config at any time:

```bash
git config --global --list
```

## Cloning and remotes

Use SSH URLs:

```bash
git clone git@github.com:USER/REPO.git
```

Switch an existing HTTPS repo to SSH:

```bash
git remote set-url origin git@github.com:USER/REPO.git
```

## GitFlow (optional)

Branches: `main` (production), `develop` (integration), `feature/*`, `release/*`, `hotfix/*`.

```bash
git flow init
git flow feature start NAME
git flow feature finish NAME
```

Without the extension:

```bash
git checkout develop
git checkout -b feature/NAME
git checkout develop
git merge --no-ff feature/NAME
```

## SSH host aliases

The module appends entries like these to `~/.ssh/config` (`%USERPROFILE%\.ssh\config` on Windows). You can also edit the file by hand:

```
Host myserver
    HostName 192.168.1.100
    User admin
    IdentityFile ~/.ssh/id_ed25519

Host ec2
    HostName ec2-xx-xx-xx-xx.compute.amazonaws.com
    User ubuntu
    IdentityFile ~/.ssh/my-key.pem
```

Then connect with `ssh myserver`.

Copy your public key to a Linux server so it stops asking for a password:

```bash
ssh-copy-id USER@HOST
```

Windows has no `ssh-copy-id`; this does the same:

```powershell
Get-Content $HOME\.ssh\id_ed25519.pub | ssh USER@HOST "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
```

## Troubleshooting

- `Permission denied (publickey)`: the public key is not on GitHub/the server, or the agent has another key. Check `ssh-add -l` and test with `ssh -T git@github.com`.
- `support for password authentication was removed`: GitHub no longer accepts passwords over HTTPS. Use SSH, or log in with `gh auth login` and run `gh auth setup-git`.
- Files show as modified without touching them: line endings. Check `core.autocrlf` (table above).
- `fatal: not a git repository`: you are outside the repo folder, or it needs `git init`.
- `UNPROTECTED PRIVATE KEY FILE` (Linux): run `chmod 600 ~/.ssh/id_ed25519`. AWS `.pem` keys need `chmod 400`.
- `.pem` rejected on Windows for bad permissions: Properties > Security > Advanced, disable inheritance and leave only your user.
- `ssh-agent` is off on Windows: the `git-ssh` module turns it on after one administrator (UAC) prompt. If you declined, rerun the module or run in an elevated PowerShell `Get-Service ssh-agent | Set-Service -StartupType Automatic; Start-Service ssh-agent`.
