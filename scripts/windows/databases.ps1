# Local databases as Docker containers with persistent volumes.
. "$PSScriptRoot\..\lib\common.ps1"

if (-not (Test-Command docker)) { throw 'Docker is required. Run the docker module first.' }
if ((Invoke-Quiet { docker info }) -ne 0) { throw 'Docker is not running. Open Docker Desktop and rerun.' }

function New-DbContainer {
    param([string]$Name, [string]$Image, [string]$HostPort, [string]$ContainerPort,
          [string]$DataDir, [string[]]$Env)
    $existing = docker ps -a --format '{{.Names}}' | Where-Object { $_ -eq $Name }
    if ($existing) { Write-Note "Container $Name already exists. Start it with: docker start $Name"; return }

    $dockerArgs = @('run', '-d', '--name', $Name, '--restart', 'unless-stopped',
                    '-p', "${HostPort}:$ContainerPort", '-v', "${Name}-data:$DataDir")
    foreach ($e in $Env) { $dockerArgs += @('-e', $e) }
    docker @dockerArgs $Image | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "Could not start $Name." }
    Write-Ok "$Name ($Image) running on localhost:$HostPort"
}

if (Confirm-Choice 'Create a MySQL container?' -DefaultNo) {
    $name = Read-Value 'Container name' -Default 'mysql'
    $port = Read-Value 'Host port' -Default '3306'
    $pass = Read-Secret 'MySQL root password'
    New-DbContainer $name 'mysql:8.4' $port 3306 '/var/lib/mysql' @("MYSQL_ROOT_PASSWORD=$pass")
    Write-Step "Connect: docker exec -it $name mysql -u root -p"
}

if (Confirm-Choice 'Create a PostgreSQL container?' -DefaultNo) {
    $name = Read-Value 'Container name' -Default 'postgres'
    $port = Read-Value 'Host port' -Default '5432'
    $pass = Read-Secret 'Postgres password (user postgres)'
    New-DbContainer $name 'postgres:17' $port 5432 '/var/lib/postgresql/data' @("POSTGRES_PASSWORD=$pass")
    Write-Step "Connect: docker exec -it $name psql -U postgres"
}

if (Confirm-Choice 'Create a MongoDB container?' -DefaultNo) {
    $name = Read-Value 'Container name' -Default 'mongo'
    $port = Read-Value 'Host port' -Default '27017'
    $user = Read-Value 'Root user' -Default 'admin'
    $pass = Read-Secret 'MongoDB root password'
    New-DbContainer $name 'mongo:8' $port 27017 '/data/db' @(
        "MONGO_INITDB_ROOT_USERNAME=$user", "MONGO_INITDB_ROOT_PASSWORD=$pass")
    Write-Step "Connect: docker exec -it $name mongosh -u $user -p"
}

Write-Ok 'Databases setup done'
