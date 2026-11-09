# Shell / Terminal

## WSL (Ubuntu dentro de Windows)

Instalar con un comando (PowerShell como administrador):

```powershell
wsl --install
```

Instalar una distro específica:

```powershell
wsl --list --online
wsl --install -d Ubuntu
```

Comandos de manejo:

```powershell
wsl --list --verbose
wsl --update
wsl --shutdown
```

## Perfil de PowerShell

Abrir (o crear) tu perfil para agregar alias y configuraciones:

```powershell
notepad $PROFILE
```

Si no existe, créalo primero:

```powershell
New-Item -ItemType File -Path $PROFILE -Force
```

Ejemplo de líneas útiles dentro del perfil:

```powershell
Set-Alias ll Get-ChildItem
fnm env --use-on-cd | Out-String | Invoke-Expression
```

Recargar sin reiniciar:

```powershell
. $PROFILE
```

## zsh + oh-my-zsh (Ubuntu y Arch)

Instalar zsh. Ubuntu:

```bash
sudo apt install -y zsh
```

Arch:

```bash
sudo pacman -S zsh
```

Instalar oh-my-zsh:

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Ponerlo como shell por defecto:

```bash
chsh -s $(which zsh)
```

Plugins comunes (autosuggestions y syntax highlighting):

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Luego agrégalos en la línea `plugins=(...)` de `~/.zshrc`:

```
plugins=(git docker zsh-autosuggestions zsh-syntax-highlighting)
```

Recargar:

```bash
source ~/.zshrc
```

## Troubleshooting

- `wsl --install` pide reinicio: es normal, reinicia y termina la instalación de la distro.
- PowerShell no ejecuta el perfil: la política de scripts lo bloquea. Corre:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

- `chsh` no cambia la shell: cierra sesión por completo y vuelve a entrar.
- Los plugins de zsh no cargan: verifica que los nombres en `plugins=(...)` coincidan con las carpetas clonadas.
