# Google Cloud CLI (gcloud)

## Instalación

### Windows (PowerShell)

```powershell
winget install Google.CloudSDK
```

### Ubuntu

```bash
sudo apt install -y apt-transport-https ca-certificates gnupg curl
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt update
sudo apt install -y google-cloud-cli
```

### Arch

Desde el AUR:

```bash
yay -S google-cloud-cli
```

Verificar:

```bash
gcloud --version
```

## Configuración inicial (común)

```bash
gcloud init
```

Esto te lleva a iniciar sesión en el navegador y elegir proyecto y región.

Solo autenticarte sin el asistente:

```bash
gcloud auth login
```

Credenciales para aplicaciones (SDKs y Terraform):

```bash
gcloud auth application-default login
```

## Proyecto y región por defecto

```bash
gcloud config set project MI_PROYECTO_ID
gcloud config set compute/region us-central1
gcloud config set compute/zone us-central1-a
```

Ver la config activa:

```bash
gcloud config list
```

## Comandos útiles

```bash
gcloud projects list
gcloud compute instances list
gcloud auth list
gcloud components update
```

## Troubleshooting

- `gcloud: command not found` tras instalar: reinicia la terminal o corre el script de init que deja el SDK en el PATH.
- `There was a problem refreshing your current auth tokens`: corre `gcloud auth login` de nuevo.
- Operaciones fallan por proyecto: verifica que `gcloud config get-value project` apunta al correcto.
- APIs deshabilitadas: habilítalas con `gcloud services enable NOMBRE.googleapis.com`.
