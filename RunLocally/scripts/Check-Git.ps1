$ProjectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
Set-Location $ProjectRoot

Write-Host ''
Write-Host '========================================' -ForegroundColor Cyan
Write-Host ' Project GitHub Push' -ForegroundColor Cyan
Write-Host '========================================' -ForegroundColor Cyan
Write-Host 'Checking current Git status...' -ForegroundColor Cyan

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host '[ERROR] Git was not found. Install Git for Windows and reopen VS Code.' -ForegroundColor Red
    return
}

git status
if ($LASTEXITCODE -ne 0) {
    Write-Host '[WARNING] git status did not complete successfully. Check whether this folder is a Git repository.' -ForegroundColor Yellow
}

Write-Host ''
Write-Host 'Git terminal is ready. No commit or push was performed.' -ForegroundColor Green
Write-Host 'Examples: git add . | git commit -m "Your message" | git push' -ForegroundColor DarkGray
