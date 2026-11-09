# Python

## Instalación

### Windows (PowerShell)

```powershell
winget install Python.Python.3.12
```

### Ubuntu

Normalmente ya viene. Para pip y venv:

```bash
sudo apt install -y python3 python3-pip python3-venv
```

### Arch

```bash
sudo pacman -S python python-pip
```

Verificar:

```bash
python --version
pip --version
```

En Ubuntu puede ser `python3` y `pip3`.

## Entornos virtuales (común)

Crear y activar un venv por proyecto:

```bash
python -m venv .venv
```

Activar. Linux:

```bash
source .venv/bin/activate
```

Activar. Windows (PowerShell):

```powershell
.\.venv\Scripts\Activate.ps1
```

Desactivar:

```bash
deactivate
```

Instalar dependencias dentro del venv:

```bash
pip install -r requirements.txt
pip freeze > requirements.txt
```

## pyenv (varias versiones de Python)

Linux:

```bash
curl https://pyenv.run | bash
```

Luego agrega al perfil de la shell y úsalo:

```bash
pyenv install 3.12
pyenv global 3.12
```

En Windows se usa pyenv-win:

```powershell
winget install pyenv-win.pyenv-win
```

## Troubleshooting

- `Activate.ps1 cannot be loaded` en Windows: habilita scripts en la sesión:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

- `externally-managed-environment` en Arch/Ubuntu nuevos: no instales con pip global; usa siempre un venv.
- `pip: command not found`: en Ubuntu usa `pip3` o instala `python3-pip`.
- El venv no activa: confirma que estás en la carpeta del proyecto y que la ruta `.venv` existe.
