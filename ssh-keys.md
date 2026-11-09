# SSH keys

Para conectarte a GitHub, servidores remotos o instancias EC2 sin contraseña.

## Generar la llave (común)

```bash
ssh-keygen -t ed25519 -C "tu@correo.com"
```

Enter para aceptar la ruta por defecto (`~/.ssh/id_ed25519`). Opcional ponerle passphrase.

Esto crea dos archivos:
- `id_ed25519` → privada (nunca se comparte)
- `id_ed25519.pub` → pública (esta sí se sube o se copia al servidor)

## Cargar la llave en el agente

Windows (PowerShell, una sola vez habilita el servicio):

```powershell
Get-Service ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
ssh-add $env:USERPROFILE\.ssh\id_ed25519
```

Linux (Ubuntu y Arch):

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

## Copiar la llave pública

Windows:

```powershell
Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub | Set-Clipboard
```

Linux:

```bash
cat ~/.ssh/id_ed25519.pub
```

A un servidor directamente (Linux):

```bash
ssh-copy-id usuario@host
```

## Archivo de config para alias

Edita `~/.ssh/config` (en Windows: `%USERPROFILE%\.ssh\config`):

```
Host miservidor
    HostName 192.168.1.100
    User josue
    IdentityFile ~/.ssh/id_ed25519

Host ec2
    HostName ec2-xx-xx-xx-xx.compute.amazonaws.com
    User ubuntu
    IdentityFile ~/.ssh/mi-llave.pem
```

Luego te conectas con:

```bash
ssh miservidor
```

## Troubleshooting

- `Permission denied (publickey)`: la pública no está en el servidor/GitHub, o cargaste la llave equivocada en el agente.
- `UNPROTECTED PRIVATE KEY FILE` (Linux): permisos muy abiertos. Corrige:

```bash
chmod 600 ~/.ssh/id_ed25519
```

- Llave `.pem` de AWS rechazada en Linux: necesita permisos 400.

```bash
chmod 400 ~/.ssh/mi-llave.pem
```

- En Windows, si el `.pem` da error de permisos, quita la herencia y deja solo tu usuario desde Propiedades → Seguridad → Opciones avanzadas.
