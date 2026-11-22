@echo off
setlocal EnableExtensions
 title FullStack REST APIs - Local Launcher

REM This launcher lives in: <project-root>\RunLocally\
REM Resolve the project root as the parent of the RunLocally folder.
set "RUNLOCALLY_DIR=%~dp0"
if "%RUNLOCALLY_DIR:~-1%"=="\" set "RUNLOCALLY_DIR=%RUNLOCALLY_DIR:~0,-1%"
for %%I in ("%RUNLOCALLY_DIR%\..") do set "PROJECT_ROOT=%%~fI"
set "WORKSPACE_FILE=%RUNLOCALLY_DIR%\FullStack-RestAPIs.code-workspace"
set "BROWSER_SCRIPT=%RUNLOCALLY_DIR%\scripts\Open-Frontend-In-Chrome.ps1"

cd /d "%PROJECT_ROOT%"

echo.
echo ========================================================
echo       FullStack REST APIs - Local Development Launcher
echo ========================================================
echo.

REM Validate the expected project layout.
if not exist "%PROJECT_ROOT%\docker-compose.yml" (
    echo [ERROR] docker-compose.yml was not found in:
    echo         %PROJECT_ROOT%
    echo Keep the RunLocally folder directly inside the project root.
    pause
    exit /b 1
)
if not exist "%PROJECT_ROOT%\backend\project\manage.py" (
    echo [ERROR] backend\project\manage.py was not found.
    echo Check the backend folder structure before continuing.
    pause
    exit /b 1
)
if not exist "%PROJECT_ROOT%\frontend\project\package.json" (
    echo [ERROR] frontend\project\package.json was not found.
    echo Check the frontend folder structure before continuing.
    pause
    exit /b 1
)
if not exist "%WORKSPACE_FILE%" (
    echo [ERROR] FullStack-RestAPIs.code-workspace was not found inside RunLocally.
    pause
    exit /b 1
)
if not exist "%BROWSER_SCRIPT%" (
    echo [ERROR] Chrome helper script was not found:
    echo         %BROWSER_SCRIPT%
    pause
    exit /b 1
)

REM Locate the Docker CLI.
where docker >nul 2>&1
if errorlevel 1 (
    if exist "%ProgramFiles%\Docker\Docker\resources\bin\docker.exe" (
        set "PATH=%ProgramFiles%\Docker\Docker\resources\bin;%PATH%"
    ) else (
        echo [ERROR] Docker CLI was not found. Install or repair Docker Desktop.
        pause
        exit /b 1
    )
)

echo [1/3] Checking Docker Engine...
docker info >nul 2>&1
if errorlevel 1 (
    echo Docker Engine is not running. Starting Docker Desktop...
    if exist "%ProgramFiles%\Docker\Docker\Docker Desktop.exe" (
        start "" "%ProgramFiles%\Docker\Docker\Docker Desktop.exe"
    ) else if exist "%LocalAppData%\Docker\Docker Desktop.exe" (
        start "" "%LocalAppData%\Docker\Docker Desktop.exe"
    ) else (
        echo [ERROR] Docker Desktop executable was not found in a standard location.
        echo Start Docker Desktop manually, then run this BAT file again.
        pause
        exit /b 1
    )
) else (
    echo Docker Engine is already running.
)

echo Waiting for Docker Engine to become ready...
set /a DOCKER_ATTEMPTS=0
:WAIT_FOR_DOCKER
    docker info >nul 2>&1
    if not errorlevel 1 goto DOCKER_READY
    set /a DOCKER_ATTEMPTS+=1
    if %DOCKER_ATTEMPTS% GEQ 60 goto DOCKER_TIMEOUT
    timeout /t 5 /nobreak >nul
    goto WAIT_FOR_DOCKER

:DOCKER_TIMEOUT
echo [ERROR] Docker Engine did not become ready within 5 minutes.
echo Open Docker Desktop, check its status, and run this BAT file again.
pause
exit /b 1

:DOCKER_READY
echo Docker Engine is ready.
echo.

echo [2/3] Opening the FullStack-RestAPIs workspace in VS Code...
where code >nul 2>&1
if not errorlevel 1 (
    start "" code -n "%WORKSPACE_FILE%"
    goto OPEN_BROWSER_HELPER
)

if exist "%LocalAppData%\Programs\Microsoft VS Code\Code.exe" (
    start "" "%LocalAppData%\Programs\Microsoft VS Code\Code.exe" -n "%WORKSPACE_FILE%"
    goto OPEN_BROWSER_HELPER
)
if exist "%ProgramFiles%\Microsoft VS Code\Code.exe" (
    start "" "%ProgramFiles%\Microsoft VS Code\Code.exe" -n "%WORKSPACE_FILE%"
    goto OPEN_BROWSER_HELPER
)
if exist "%ProgramFiles(x86)%\Microsoft VS Code\Code.exe" (
    start "" "%ProgramFiles(x86)%\Microsoft VS Code\Code.exe" -n "%WORKSPACE_FILE%"
    goto OPEN_BROWSER_HELPER
)

echo [ERROR] Visual Studio Code was not found.
echo Install VS Code or add the 'code' command to PATH.
pause
exit /b 1

:OPEN_BROWSER_HELPER
echo.
echo [3/3] VS Code is opening. Its workspace tasks will create four terminals:
echo       Docker + PostgreSQL
echo       Backend - Django + DRF
echo       Frontend - React.js
echo       Project GitHub Push
echo.
echo Chrome will open when the Vite server responds at http://localhost:8080.
start "" powershell.exe -NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "%BROWSER_SCRIPT%"

echo Launcher completed. You can close this window.
timeout /t 4 /nobreak >nul
exit /b 0
