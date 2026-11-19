# simple-configs

My setup for every machine: interactive scripts for Windows (PowerShell), Ubuntu/Debian and Arch, a shared shell config, quick-reference docs and my Claude configuration.

## Quick start

### Windows (PowerShell)

```powershell
winget install --id Git.Git -e
```

Open a new terminal, then:

```powershell
git clone https://github.com/jzuletadev/simple-configs.git $HOME\simple-configs
cd $HOME\simple-configs
powershell -ExecutionPolicy Bypass -File .\setup.ps1
```

### Ubuntu / Debian

```bash
sudo apt update && sudo apt install -y git
git clone https://github.com/jzuletadev/simple-configs.git ~/simple-configs
cd ~/simple-configs
bash setup.sh
```

### Arch

```bash
sudo pacman -S --needed git
git clone https://github.com/jzuletadev/simple-configs.git ~/simple-configs
cd ~/simple-configs
bash setup.sh
```

The menu lists the modules; type their numbers (`1 2 4`) or `all`. To skip the menu, pass module names:

```powershell
.\setup.ps1 git-ssh node
```

```bash
bash setup.sh git-ssh node
```

## Modules

Run them in this order on a new machine. Every module can be rerun: it skips what is already installed and asks before changing anything.

| Module | What it does | Asks you for |
| :- | :- | :- |
| `base` | Windows: script policy, Git, PowerShell 7, Terminal, VS Code, 7-Zip, optional Chocolatey. Linux: system update, essentials, `yay` on Arch | Which apps to install |
| `git-ssh` | Git config, ed25519 key, ssh-agent, GitHub login and key upload with `gh`, SSH host aliases | Name, email, key passphrase, GitHub login, servers |
| `shell` | Loads the shared aliases into PowerShell / bash / zsh. Linux: zsh + oh-my-zsh + plugins. Windows: optional WSL | zsh, default shell, WSL distro |
| `node` | fnm + Node.js (same commands on every OS) | Node version, global npm packages |
| `python` | Python with pip and venv, optional uv | Python version (Windows) |
| `docker` | Docker Desktop (Windows) or Docker Engine + Compose (Linux) | Nothing |
| `databases` | MySQL, PostgreSQL and MongoDB containers with persistent volumes | Engines, names, ports, passwords |
| `cloud` | AWS, Google Cloud and Azure CLIs, then login | Which CLIs, profile, keys or SSO |
| `claude` | Claude Code, desktop app and Claude components (agents, skills, hooks, MCP; [claude-configs](claude-configs/README.md)). Needs `node` first, `python` for the hooks | Desktop app |

Passwords and keys you type go straight to the tool that needs them (ssh-keygen, aws, docker); nothing is written to this repo.

On Windows you don't need an administrator terminal: steps that need admin rights (ssh-agent, WSL, Chocolatey) ask first and then show one UAC prompt.

## Layout

- `setup.ps1`, `setup.sh`: the menus.
- `scripts/windows/`, `scripts/linux/`: one script per module, same names on both sides. `scripts/lib/` holds the shared prompt and install helpers.
- `config/`: files your shell loads on every machine. Add aliases in `config/powershell/profile.ps1` or `config/shell/common.sh` and `git pull` elsewhere.
- `docs/`: quick reference and troubleshooting.
- `claude-configs/`: `components.txt` (agents, skills, hooks, settings and MCP servers installed with claude-code-templates), its install scripts and the claude.ai texts.

## Docs

- [Git and SSH](docs/git-ssh.md)
- [Docker and databases](docs/docker-databases.md)
- [Cloud CLIs (AWS, Google Cloud, Azure)](docs/cloud-cli.md)
- [Dev environment: packages, shell, Node, Python](docs/dev-environment.md)
- [Claude configs](claude-configs/README.md)

## Conventions

- Commands are ready to copy and paste, without prompt prefixes.
- Commands starting with `/` are typed inside Claude Code, not in the terminal.
- `~/.claude` on Linux is `$HOME\.claude` on Windows.
