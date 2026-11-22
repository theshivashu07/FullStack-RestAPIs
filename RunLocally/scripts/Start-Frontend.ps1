$ErrorActionPreference = 'Continue'
$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$FrontendRoot = Join-Path $ProjectRoot 'frontend\project'

Write-Host ''
Write-Host '========================================' -ForegroundColor Yellow
Write-Host ' Frontend - React.js' -ForegroundColor Yellow
Write-Host '========================================' -ForegroundColor Yellow

if (-not (Test-Path (Join-Path $FrontendRoot 'package.json'))) {
    Write-Host '[ERROR] frontend\project\package.json was not found.' -ForegroundColor Red
    return
}
if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
    Write-Host '[ERROR] npm was not found. Install Node.js and reopen the terminal.' -ForegroundColor Red
    return
}

Set-Location $FrontendRoot
if (-not (Test-Path (Join-Path $FrontendRoot 'node_modules'))) {
    Write-Host 'node_modules was not found. Installing dependencies with npm install...' -ForegroundColor Cyan
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host '[ERROR] npm install failed. Fix the error and run npm install manually.' -ForegroundColor Red
        return
    }
}

Write-Host 'Starting Vite development server...' -ForegroundColor Green
npm run dev -- --host 127.0.0.1
