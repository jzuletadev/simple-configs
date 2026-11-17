#!/usr/bin/env bash
# Local databases as Docker containers with persistent volumes.
. "$(dirname "${BASH_SOURCE[0]}")/../lib/common.sh"

has docker || die "Docker is required. Run the docker module first."

DOCKER=(docker)
docker info >/dev/null 2>&1 || DOCKER=(sudo docker)

# run_container NAME IMAGE HOST_PORT CONTAINER_PORT DATA_DIR [ENV=VALUE ...]
run_container() {
  local name=$1 image=$2 hport=$3 cport=$4 data=$5 env_args=() e
  shift 5
  if "${DOCKER[@]}" ps -a --format '{{.Names}}' | grep -qx "$name"; then
    warn "Container $name already exists. Start it with: docker start $name"
    return 0
  fi
  for e in "$@"; do env_args+=(-e "$e"); done
  "${DOCKER[@]}" run -d --name "$name" --restart unless-stopped \
    -p "$hport:$cport" -v "$name-data:$data" "${env_args[@]}" "$image" >/dev/null
  ok "$name ($image) running on localhost:$hport"
}

if confirm "Create a MySQL container?" n; then
  ask_required NAME "Container name" "mysql"
  ask_required PORT "Host port" "3306"
  ask_secret PASS "MySQL root password"
  run_container "$NAME" mysql:8.4 "$PORT" 3306 /var/lib/mysql "MYSQL_ROOT_PASSWORD=$PASS"
  info "Connect: docker exec -it $NAME mysql -u root -p"
fi

if confirm "Create a PostgreSQL container?" n; then
  ask_required NAME "Container name" "postgres"
  ask_required PORT "Host port" "5432"
  ask_secret PASS "Postgres password (user postgres)"
  run_container "$NAME" postgres:17 "$PORT" 5432 /var/lib/postgresql/data "POSTGRES_PASSWORD=$PASS"
  info "Connect: docker exec -it $NAME psql -U postgres"
fi

if confirm "Create a MongoDB container?" n; then
  ask_required NAME "Container name" "mongo"
  ask_required PORT "Host port" "27017"
  ask_required MUSER "Root user" "admin"
  ask_secret PASS "MongoDB root password"
  run_container "$NAME" mongo:8 "$PORT" 27017 /data/db \
    "MONGO_INITDB_ROOT_USERNAME=$MUSER" "MONGO_INITDB_ROOT_PASSWORD=$PASS"
  info "Connect: docker exec -it $NAME mongosh -u $MUSER -p"
fi

ok "Databases setup done"
