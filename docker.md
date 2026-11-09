# Docker + Docker Compose

## Instalación

### Windows (PowerShell)

Docker Desktop (incluye Compose). Requiere WSL2 activo.

```powershell
winget install Docker.DockerDesktop
```

Abre Docker Desktop una vez para que termine de configurarse.

### Ubuntu

Repositorio oficial:

```bash
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Arch

```bash
sudo pacman -S docker docker-compose
sudo systemctl enable --now docker.service
```

## Post-instalación (común en Linux)

Usar docker sin `sudo`:

```bash
sudo usermod -aG docker $USER
```

Cierra sesión y vuelve a entrar para que aplique.

Verificar que todo funciona:

```bash
docker run hello-world
docker compose version
```

## Comandos de uso diario

```bash
docker ps
docker ps -a
docker images
docker compose up -d
docker compose down
docker compose logs -f
docker exec -it nombre_contenedor bash
docker system prune -a
```

## Troubleshooting

- `permission denied ... docker.sock`: falta el paso de `usermod -aG docker` o no reiniciaste la sesión.
- `Cannot connect to the Docker daemon`: el servicio no está corriendo. En Linux: `sudo systemctl start docker`. En Windows: abre Docker Desktop.
- Docker Desktop no arranca en Windows: revisa que WSL2 esté instalado con `wsl --status` y actualiza con `wsl --update`.
- Contenedor se cae al instante: revisa el log con `docker compose logs -f` o `docker logs nombre`.
- Puerto ocupado: cambia el mapeo en el compose o libera el puerto; en Linux `sudo lsof -i :PUERTO`.
