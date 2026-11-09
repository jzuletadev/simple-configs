# Node.js

Recomendado instalar con un gestor de versiones, no el instalador directo, para cambiar de versión por proyecto.

## Windows (PowerShell)

Con fnm (multiplataforma, rápido):

```powershell
winget install Schniz.fnm
```

Agrega fnm a tu perfil de PowerShell (ver [Shell / Terminal](shell-terminal.md)):

```powershell
fnm env --use-on-cd | Out-String | Invoke-Expression
```

Alternativa: nvm-windows.

```powershell
winget install CoreyButler.NVMforWindows
```

## Ubuntu y Arch (común con nvm)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
```

Cierra y reabre la terminal, o carga nvm en la sesión actual:

```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

En Arch también puedes usar el paquete oficial directo:

```bash
sudo pacman -S nodejs npm
```

## Uso del gestor de versiones (común)

```bash
nvm install --lts
nvm install 20
nvm use 20
nvm alias default 20
node -v
npm -v
```

Con fnm los comandos son casi iguales:

```bash
fnm install --lts
fnm use lts-latest
fnm default lts-latest
```

## npm básico

```bash
npm init -y
npm install nombre-paquete
npm install -g nombre-global
npm run dev
```

## Troubleshooting

- `node: command not found` tras instalar nvm/fnm: falta cargar el gestor en el perfil de la shell. Reabre la terminal.
- `EACCES` al instalar paquetes globales en Linux: no uses sudo con npm; deja que nvm maneje las rutas en tu home.
- Versión equivocada dentro de un proyecto: crea un archivo `.nvmrc` con el número de versión y corre `nvm use`.
- En Windows, nvm-windows exige abrir la terminal como administrador para cambiar de versión.
