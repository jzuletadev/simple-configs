# Installing Claude Code and the desktop app

The `claude` setup module does all of this for you:

```powershell
.\setup.ps1 claude
```

```bash
bash setup.sh claude
```

Prerequisites: Git and Node.js (modules `git-ssh` and `node`). Hooks and several plugins need Node. The steps below are the manual equivalent.

## Windows (PowerShell)

Claude Code (native installer, updates itself, no admin needed):

```powershell
irm https://claude.ai/install.ps1 | iex
```

Alternative with winget:

```powershell
winget install Anthropic.ClaudeCode
```

Git for Windows is recommended: it gives Claude Code its Bash tool. Without it, Claude Code uses PowerShell.

```powershell
winget install Git.Git
```

Desktop app (Chat, Cowork and Code):

```powershell
winget install Anthropic.Claude
```

Or download it from https://claude.ai/download.

## Ubuntu

Dependencies:

```bash
sudo apt update && sudo apt install -y git curl
```

Claude Code:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Desktop app (official beta on Linux, via apt):

```bash
sudo curl -fsSLo /usr/share/keyrings/claude-desktop-archive-keyring.asc https://downloads.claude.ai/claude-desktop/key.asc
echo "deb [signed-by=/usr/share/keyrings/claude-desktop-archive-keyring.asc] https://downloads.claude.ai/claude-desktop/apt/stable stable main" | sudo tee /etc/apt/sources.list.d/claude-desktop.list
sudo apt update && sudo apt install claude-desktop
```

To use Cowork on Linux, add your user to the kvm group and log out:

```bash
sudo usermod -aG kvm $USER
```

## Arch Linux

Dependencies:

```bash
sudo pacman -S --needed git curl
```

Claude Code:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Desktop app: there is no official package for Arch (only Ubuntu/Debian). On Arch use claude.ai in the browser for chat and `claude` in the terminal. The AUR has community packages, but they are unofficial and can break with every update.

## First run (common)

```bash
claude --version
claude
```

The first time it opens the browser to sign in. Use the same claude.ai account so your skills and plugins sync.

Diagnostics:

```bash
claude doctor
```

## Troubleshooting

- `claude` not recognized after installing: close and reopen the terminal. On Linux check that `~/.local/bin` is on the PATH (the shared shell config adds it).
- `irm` blocked on Windows: you are in CMD, not PowerShell. Open PowerShell.
- Claude Code can't find Git Bash: add `"env": { "CLAUDE_CODE_GIT_BASH_PATH": "C:\\Program Files\\Git\\bin\\bash.exe" }` to `settings.json`.
- Cowork on Linux says there is no virtualization: enable VT-x/AMD-V in the BIOS or UEFI. It needs about 25 GB free and 8 GB of RAM.
