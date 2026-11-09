# AWS CLI

## Instalación

### Windows (PowerShell)

```powershell
winget install Amazon.AWSCLI
```

### Ubuntu

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

### Arch

```bash
sudo pacman -S aws-cli-v2
```

Verificar en cualquier sistema:

```bash
aws --version
```

## Configuración (común)

```bash
aws configure
```

Te pide cuatro datos:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (ej. `us-east-1`)
- Default output format (ej. `json`)

Las credenciales quedan en `~/.aws/credentials` y la config en `~/.aws/config`.

## Perfiles (varias cuentas)

Crear un perfil con nombre:

```bash
aws configure --profile trabajo
```

Usarlo en un comando:

```bash
aws s3 ls --profile trabajo
```

O fijarlo por sesión. Linux:

```bash
export AWS_PROFILE=trabajo
```

Windows:

```powershell
$env:AWS_PROFILE = "trabajo"
```

## Comandos útiles

```bash
aws sts get-caller-identity
aws s3 ls
aws s3 cp archivo.txt s3://mi-bucket/
aws ec2 describe-instances --query "Reservations[].Instances[].InstanceId"
```

## Troubleshooting

- `Unable to locate credentials`: no corriste `aws configure` o el perfil no existe. Verifica con `aws configure list`.
- `An error occurred (AccessDenied)`: el usuario/rol no tiene permisos para esa acción; revisa la política IAM.
- `You must specify a region`: agrega `--region us-east-1` o define la región por defecto.
- Token expirado (cuentas con SSO/rol temporal): vuelve a autenticarte, los access keys temporales caducan.
