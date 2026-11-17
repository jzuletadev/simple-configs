# Docker and databases

Setup is automated by two modules:

- `docker`: Docker Desktop on Windows (checks WSL2); Docker Engine + Compose on Linux, service enabled and your user added to the `docker` group.
- `databases`: creates MySQL 8.4, PostgreSQL 17 and/or MongoDB 8 containers. It asks for container name, port and password, and keeps the data in a named volume (`NAME-data`) so it survives container removal.

## Daily Docker commands

```bash
docker ps
docker ps -a
docker images
docker compose up -d
docker compose down
docker compose logs -f
docker exec -it CONTAINER bash
docker system prune -a
```

The shared shell config adds the aliases `dcu`, `dcd` and `dcl` for `docker compose up -d`, `down` and `logs -f`.

## Database containers

The containers restart with Docker (`--restart unless-stopped`). To manage them:

```bash
docker start mysql
docker stop mysql
docker logs -f mysql
docker rm -f mysql
docker volume rm mysql-data
```

`docker rm` keeps the data; removing the volume deletes it.

Open a client inside the container:

```bash
docker exec -it mysql mysql -u root -p
docker exec -it postgres psql -U postgres
docker exec -it mongo mongosh -u admin -p
```

From host clients (if installed) or connection strings:

```bash
mysql -u root -p -h 127.0.0.1 -P 3306
psql -U postgres -h 127.0.0.1 -p 5432
mongosh "mongodb://admin@127.0.0.1:27017"
```

## Native installs (only if Docker is not an option)

| Engine | Windows | Ubuntu | Arch |
| :- | :- | :- | :- |
| MySQL | `winget install Oracle.MySQL` | `sudo apt install -y mysql-server` then `sudo mysql_secure_installation` | `sudo pacman -S mariadb` then `sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql` |
| PostgreSQL | `winget install PostgreSQL.PostgreSQL.17` | `sudo apt install -y postgresql postgresql-contrib` | `sudo pacman -S postgresql` then `sudo -u postgres initdb -D /var/lib/postgres/data` |
| MongoDB | `winget install MongoDB.Server` | official MongoDB apt repo | AUR `mongodb-bin` |

On Linux enable the service afterwards, e.g. `sudo systemctl enable --now postgresql`.

## Troubleshooting

- `permission denied ... docker.sock`: you are not in the `docker` group yet, or you did not log out and back in after the module added you.
- `Cannot connect to the Docker daemon`: the service is not running. Linux: `sudo systemctl start docker`. Windows: open Docker Desktop.
- Docker Desktop does not start on Windows: check `wsl --status` and update with `wsl --update`.
- Container exits immediately: read `docker logs NAME`.
- Port already in use: a native database is using it. Stop that service or recreate the container on another port (the module asks for the port). On Linux, find the process with `sudo lsof -i :PORT`.
- `Access denied for user`: wrong user/password, or the user cannot connect from that host.
- New password ignored: the database keeps the one from its first start. Remove the container and its volume to start fresh.
- On Arch, MySQL is replaced by MariaDB (compatible); the `mysql` client works the same.
