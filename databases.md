# Bases de datos

La forma más limpia y pareja entre sistemas es levantarlas con Docker. Abajo va eso primero y luego la instalación nativa.

## Con Docker (común, recomendado)

MySQL:

```bash
docker run --name mysql -e MYSQL_ROOT_PASSWORD=secret -p 3306:3306 -d mysql:8
```

PostgreSQL:

```bash
docker run --name postgres -e POSTGRES_PASSWORD=secret -p 5432:5432 -d postgres:16
```

MongoDB:

```bash
docker run --name mongo -p 27017:27017 -d mongo:7
```

Entrar al cliente dentro del contenedor:

```bash
docker exec -it mysql mysql -u root -p
docker exec -it postgres psql -U postgres
docker exec -it mongo mongosh
```

## Instalación nativa

### MySQL

Windows:

```powershell
winget install Oracle.MySQL
```

Ubuntu:

```bash
sudo apt install -y mysql-server
sudo systemctl enable --now mysql
sudo mysql_secure_installation
```

Arch:

```bash
sudo pacman -S mariadb
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl enable --now mariadb
```

### PostgreSQL

Windows:

```powershell
winget install PostgreSQL.PostgreSQL.16
```

Ubuntu:

```bash
sudo apt install -y postgresql postgresql-contrib
sudo systemctl enable --now postgresql
```

Arch:

```bash
sudo pacman -S postgresql
sudo -u postgres initdb -D /var/lib/postgres/data
sudo systemctl enable --now postgresql
```

### MongoDB

En Linux se recomienda el repo oficial de MongoDB. En Windows:

```powershell
winget install MongoDB.Server
```

## Conexión rápida

```bash
mysql -u root -p -h 127.0.0.1 -P 3306
psql -U postgres -h 127.0.0.1 -p 5432
mongosh "mongodb://127.0.0.1:27017"
```

## Troubleshooting

- `Access denied for user`: usuario o contraseña incorrectos, o el usuario no tiene permiso desde ese host.
- Puerto ocupado al levantar el contenedor: ya hay una instancia nativa corriendo en ese puerto. Detén el servicio o cambia el mapeo (`-p 3307:3306`).
- Postgres en Arch no arranca: casi siempre falta el `initdb` del data dir.
- `Connection refused`: el servicio no está levantado o estás apuntando al host/puerto equivocado.
- En Arch, MySQL se reemplaza por MariaDB (compatible); el cliente `mysql` funciona igual.
