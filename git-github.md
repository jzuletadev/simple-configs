# Git + GitHub

## Instalación

Windows (PowerShell):

```powershell
winget install Git.Git
```

Ubuntu:

```bash
sudo apt install -y git
```

Arch:

```bash
sudo pacman -S git
```

## Configuración inicial (común)

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tu@correo.com"
git config --global init.defaultBranch main
git config --global pull.rebase false
```

En Windows, ajusta el fin de línea para evitar conflictos CRLF/LF:

```powershell
git config --global core.autocrlf true
```

En Linux:

```bash
git config --global core.autocrlf input
```

## Conectar con GitHub

### Opción A: SSH (recomendada)

Genera la llave y conéctala (ver guía [SSH keys](ssh-keys.md) para el detalle):

```bash
ssh-keygen -t ed25519 -C "tu@correo.com"
```

Copia la pública y pégala en GitHub → Settings → SSH and GPG keys.

Prueba la conexión:

```bash
ssh -T git@github.com
```

Al clonar, usa la URL SSH:

```bash
git clone git@github.com:usuario/repo.git
```

### Opción B: Token (HTTPS)

Crea un Personal Access Token en GitHub → Settings → Developer settings → Tokens.
Al hacer `git push` por HTTPS, usa el token como contraseña.

Guardar el token para no repetirlo:

```bash
git config --global credential.helper store
```

En Windows usa el manager que ya trae Git:

```powershell
git config --global credential.helper manager
```

## GitFlow (opcional)

Flujo de ramas: `main` (producción), `develop` (integración), `feature/*`, `release/*`, `hotfix/*`.

Inicializar en un repo:

```bash
git flow init
```

Nueva feature:

```bash
git flow feature start nombre
git flow feature finish nombre
```

Sin la extensión, el equivalente manual:

```bash
git checkout develop
git checkout -b feature/nombre
git merge --no-ff feature/nombre
```

## Troubleshooting

- `Permission denied (publickey)`: la llave no está en el agente o no la subiste a GitHub. Revisa con `ssh-add -l` y prueba `ssh -T git@github.com`.
- `support for password authentication was removed`: GitHub ya no acepta contraseña por HTTPS; usa token o SSH.
- Archivos marcados como modificados sin tocarlos: casi siempre es CRLF/LF. Ajusta `core.autocrlf` como arriba.
- `fatal: not a git repository`: estás fuera de la carpeta del repo o falta `git init`.
