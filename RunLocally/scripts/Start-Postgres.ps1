$ErrorActionPreference = 'Stop'
$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
Set-Location $ProjectRoot

Write-Host ''
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ' Docker + PostgreSQL' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan

if (-not (Test-Path (Join-Path $ProjectRoot 'docker-compose.yml'))) {
    Write-Host '[ERROR] docker-compose.yml was not found in the project root.' -ForegroundColor Red
    return
}
if (-not (Get-Command docker -ErrorAction SilentlyContinue)) {
    Write-Host '[ERROR] Docker CLI is not available in PATH.' -ForegroundColor Red
    return
}

docker compose up -d db
if ($LASTEXITCODE -ne 0) {
    Write-Host '[ERROR] Could not start the PostgreSQL service. Check Docker Desktop.' -ForegroundColor Red
    return
}

Write-Host ''
Write-Host 'PostgreSQL container status:' -ForegroundColor Green
docker compose ps db

Write-Host ''
Write-Host 'Waiting for PostgreSQL health check...' -ForegroundColor Cyan
$ready = $false
for ($attempt = 1; $attempt -le 150; $attempt++) {
    $containerId = docker compose ps -q db 2>$null
    if ($containerId) {
        $health = docker inspect --format '{{.State.Health.Status}}' $containerId 2>$null
        if ($health -eq 'healthy') {
            $ready = $true
            break
        }
        if ($health -eq 'unhealthy') {
            Write-Host '[ERROR] PostgreSQL container is unhealthy. Recent logs:' -ForegroundColor Red
            docker compose logs --tail 50 db
            break
        }
    }
    Start-Sleep -Seconds 2
}

if ($ready) {
    Write-Host 'PostgreSQL is healthy and ready.' -ForegroundColor Green
    docker exec restapis_postgres pg_isready -U restapis_user -d restapis_db
} else {
    Write-Host '[WARNING] PostgreSQL did not become healthy within 5 minutes.' -ForegroundColor Yellow
    Write-Host 'Check status with: docker compose ps' -ForegroundColor Yellow
    Write-Host 'Check logs with:   docker compose logs -f db' -ForegroundColor Yellow
}

Write-Host ''
Write-Host 'Useful commands: docker compose ps | docker compose logs -f db | docker compose stop db' -ForegroundColor DarkGray
