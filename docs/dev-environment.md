# Dev environment: packages, shell, Node and Python

Covered by the `base`, `shell`, `node` and `python` modules.

## Package managers

| Task | Windows | Ubuntu | Arch |
| :- | :- | :- | :- |
| Search | `winget search NAME` | `apt search NAME` | `pacman -Ss NAME` |
| Install | `winget install --id ID -e` | `sudo apt install -y NAME` | `sudo pacman -S NAME` |
| Update everything | `winget upgrade --all` | `sudo apt update && sudo apt upgrade -y` | `sudo pacman -Syu` |
| List installed | `winget list` | `apt list --installed` | `pacman -Q` |

AUR on Arch (the `base` module can install `yay`): `yay -S NAME`.

## Shell

Your aliases and PATH tweaks live in this repo and load on every machine:

- PowerShell: `config/powershell/profile.ps1`, loaded from your `$PROFILE` (PowerShell 7 and 5.1).
- bash and zsh: `config/shell/common.sh`, loaded from `~/.bashrc` and `~/.zshrc`.

Edit them here and run `git pull` on the other machines. Reload without restarting:

```powershell
. $PROFILE
```

```bash
source ~/.zshrc
```

On Linux the `shell` module also installs zsh + oh-my-zsh with `zsh-autosuggestions` and `zsh-syntax-highlighting`. On Windows it can install WSL.

WSL commands (PowerShell):

```powershell
wsl --list --online
wsl --install -d Ubuntu
wsl --list --verbose
wsl --update
wsl --shutdown
```

Inside WSL you can run this repo's Linux setup too: `bash setup.sh`.

## Node.js (fnm on every OS)

fnm reads `.nvmrc` and `.node-version` and switches version when you `cd` into the project.

```bash
fnm install --lts
fnm install 22
fnm use 22
fnm default 22
fnm list
node -v
```

Pin a project's version:

```bash
node -v > .nvmrc
```

npm basics:

```bash
npm init -y
npm install PACKAGE
npm install -g PACKAGE
npm run dev
```

## Python

One virtual environment per project:

```bash
python -m venv .venv
```

Activate. Linux:

```bash
source .venv/bin/activate
```

Windows:

```powershell
.\.venv\Scripts\Activate.ps1
```

```bash
pip install -r requirements.txt
pip freeze > requirements.txt
deactivate
```

With uv (optional in the `python` module) the same flow is faster and it also installs other Python versions:

```bash
uv venv
uv pip install -r requirements.txt
uv python install 3.12
uv init my-app
uv add requests
uv run main.py
```

## Troubleshooting

- `winget` not recognized: update "App Installer" from the Microsoft Store.
- apt `Could not get lock`: another apt process is running; wait for it to finish.
- pacman `failed to synchronize`: run `sudo pacman -Syyu` to force a refresh.
- `makepkg` must not run with sudo; use your normal user.
- Scripts blocked on Windows (`cannot be loaded because running scripts is disabled`): `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser` (the `base` module does it).
- `node: command not found` after the `node` module: open a new terminal so the profile loads fnm.
- Wrong Node version in a project: add `.nvmrc` with the version.
- `python` opens the Microsoft Store: turn off the python.exe aliases in Settings > Apps > Advanced app settings > App execution aliases.
- `externally-managed-environment` on recent Ubuntu/Arch: don't `pip install` globally; use a venv or uv.
- `chsh` did not change the shell: log out completely and back in.
- zsh plugins don't load: the names in `plugins=(...)` in `~/.zshrc` must match the folders in `~/.oh-my-zsh/custom/plugins`.
- `wsl --install` asks for a restart: expected; restart and open the distro to create your Linux user.
