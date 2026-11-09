# Setup base (gestores de paquetes)

Punto de arranque de cada sistema. El resto de guías asume que tienes esto listo.

## Windows (PowerShell)

`winget` ya viene en Windows 11. Verifica:

```powershell
winget --version
```

Buscar e instalar un paquete:

```powershell
winget search git
winget install Git.Git
```

Chocolatey (opcional, segunda fuente). Abre PowerShell como administrador:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

## Ubuntu

Actualizar índices y sistema:

```bash
sudo apt update && sudo apt upgrade -y
```

Instalar un paquete:

```bash
sudo apt install -y git
```

## Arch Linux

Actualizar sistema:

```bash
sudo pacman -Syu
```

Instalar un paquete:

```bash
sudo pacman -S git
```

Instalar `yay` para acceder al AUR (una sola vez):

```bash
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

Luego instalas paquetes del AUR con:

```bash
yay -S nombre-del-paquete
```

## Troubleshooting

- `winget` no reconocido: actualiza "App Installer" desde Microsoft Store.
- apt "Could not get lock": hay otro proceso usando apt; espera o revisa con `ps aux | grep apt`.
- pacman "failed to synchronize": corre primero `sudo pacman -Syyu` para forzar refresco de la base.
- `makepkg` no debe correrse con sudo; usa tu usuario normal.
