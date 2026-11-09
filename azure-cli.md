# Azure CLI

## Instalación

### Windows (PowerShell)

```powershell
winget install Microsoft.AzureCLI
```

### Ubuntu

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### Arch

```bash
sudo pacman -S azure-cli
```

Verificar:

```bash
az --version
```

## Configuración (común)

Iniciar sesión (abre el navegador):

```bash
az login
```

Si estás en un servidor sin navegador:

```bash
az login --use-device-code
```

## Suscripción por defecto

```bash
az account list --output table
az account set --subscription "NOMBRE_O_ID"
az account show
```

## Comandos útiles

```bash
az group list --output table
az vm list --output table
az webapp list --output table
az configure
```

## Troubleshooting

- `az: command not found`: reinicia la terminal tras instalar.
- Se abre el navegador pero no termina el login: usa `az login --use-device-code`.
- Comandos sobre el recurso equivocado: revisa la suscripción activa con `az account show`.
- Token expirado: vuelve a correr `az login`.
