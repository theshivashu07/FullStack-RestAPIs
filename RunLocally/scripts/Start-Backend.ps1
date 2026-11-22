$ErrorActionPreference = 'Continue'
$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$BackendRoot = Join-Path $ProjectRoot 'backend'
$ManagePy = Join-Path $BackendRoot 'project\manage.py'

Write-Host ''
Write-Host '========================================' -ForegroundColor Magenta
Write-Host ' Backend - Django + DRF' -ForegroundColor Magenta
Write-Host '========================================' -ForegroundColor Magenta

if (-not (Test-Path $ManagePy)) {
    Write-Host "[ERROR] manage.py was not found: $ManagePy" -ForegroundColor Red
    return
}

# Detect a common virtual-environment location. Add another path here if needed.
$venvCandidates = @(
    (Join-Path $BackendRoot '.venv'),
    (Join-Path $BackendRoot 'venv'),
    (Join-Path $BackendRoot 'env'),
    (Join-Path (Join-Path $BackendRoot 'project') '.venv'),
    (Join-Path (Join-Path $BackendRoot 'project') 'venv'),
    (Join-Path $ProjectRoot '.venv')
)
$activateScript = $null
foreach ($candidate in $venvCandidates) {
    $candidateActivate = Join-Path $candidate 'Scripts\Activate.ps1'
    if (Test-Path $candidateActivate) {
        $activateScript = $candidateActivate
        break
    }
}

if (-not $activateScript) {
    Write-Host '[ERROR] Could not find the Python virtual environment.' -ForegroundColor Red
    Write-Host 'Checked: backend\.venv, backend\venv, backend\env, backend\project\.venv, backend\project\venv and root\.venv.' -ForegroundColor Yellow
    Write-Host 'Update the candidate list in RunLocally\scripts\Start-Backend.ps1 if your venv is elsewhere.' -ForegroundColor Yellow
    return
}

Write-Host "Activating: $activateScript" -ForegroundColor Cyan
. $activateScript
if (-not $?) {
    Write-Host '[ERROR] Virtual environment activation failed.' -ForegroundColor Red
    return
}

Set-Location (Join-Path $BackendRoot 'project')
Write-Host "Python: $(Get-Command python | Select-Object -ExpandProperty Source)" -ForegroundColor DarkGray
Write-Host 'Waiting for PostgreSQL to become healthy...' -ForegroundColor Cyan

$dbReady = $false
for ($attempt = 1; $attempt -le 150; $attempt++) {
    $containerId = docker compose -f (Join-Path $ProjectRoot 'docker-compose.yml') ps -q db 2>$null
    if ($containerId) {
        $health = docker inspect --format '{{.State.Health.Status}}' $containerId 2>$null
        if ($health -eq 'healthy') {
            $dbReady = $true
            break
        }
    }
    Start-Sleep -Seconds 2
}

if (-not $dbReady) {
    Write-Host '[ERROR] PostgreSQL is not healthy. Check the Docker + PostgreSQL terminal.' -ForegroundColor Red
    return
}

Write-Host 'PostgreSQL is healthy. Starting Django development server...' -ForegroundColor Green
python manage.py runserver 127.0.0.1:1234
