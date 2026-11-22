# RunLocally - One-Click Development Launcher

This folder contains all launcher-related files. Keep this folder directly inside the `FullStack-RestAPIs` project root. You do **not** need to move `docker-compose.yml`, `backend`, or `frontend` into it.

## Expected project layout

```text
FullStack-RestAPIs/
├── RunLocally/
│   ├── Start-FullStack-Project.bat
│   ├── FullStack-RestAPIs.code-workspace
│   ├── START-HERE.md
│   └── scripts/
│       ├── Start-Postgres.ps1
│       ├── Start-Backend.ps1
│       ├── Start-Frontend.ps1
│       ├── Check-Git.ps1
│       └── Open-Frontend-In-Chrome.ps1
├── docker-compose.yml
├── backend/
│   └── project/
│       └── manage.py
└── frontend/
    └── project/
        └── package.json
```

## Installation

1. Extract/copy the complete `RunLocally` folder into the root of `FullStack-RestAPIs`.
2. Do not put `RunLocally` inside `backend`, `frontend`, or another nested folder.
3. Double-click `RunLocally\Start-FullStack-Project.bat`.
4. On first launch, VS Code may ask you to trust the workspace. Trust it because this is your own project and the workspace uses automatic tasks.
5. VS Code opens the project root as a workspace and creates four integrated terminals.

## What starts

| VS Code terminal | What it does |
|---|---|
| Docker + PostgreSQL | Runs `docker compose up -d db`, checks container status and waits for PostgreSQL health. |
| Backend - Django + DRF | Finds and activates your Python virtual environment, waits for PostgreSQL health, then runs Django at `127.0.0.1:1234`. |
| Frontend - React.js | Runs `npm install` only when `node_modules` is missing, then starts Vite. |
| Project GitHub Push | Runs `git status` and leaves the terminal open. It does not commit or push anything. |

A separate hidden PowerShell process waits for the Vite server at `localhost:8080` and opens Chrome when the frontend is ready. If Vite does not start within five minutes, the browser is not opened automatically.

## Paths and settings

The launcher calculates the project root from the location of the `RunLocally` folder. This means you can move the whole project to another drive or parent folder without editing absolute paths.

The backend launcher checks these common virtual-environment locations in order:

- `backend\.venv`
- `backend\venv`
- `backend\env`
- `backend\project\.venv`
- `backend\project\venv`
- `.venv` in the project root

If your venv is somewhere else, add its folder path to the `$venvCandidates` list in `scripts\Start-Backend.ps1`.

The frontend command uses the existing Vite configuration. It expects the app to listen on port `8080`, matching the current project setup. The Chrome helper checks that port before opening the browser.

## Useful commands

Run these in the relevant VS Code terminal:

```powershell
# Docker + PostgreSQL
docker compose ps
docker compose logs -f db
docker compose stop db

# Backend: stop server
# Press Ctrl+C in the Backend - Django + DRF terminal

# Frontend: stop Vite
# Press Ctrl+C in the Frontend - React.js terminal

# Git
git status
git add .
git commit -m "Your commit message"
git push
```

To re-run the terminal setup, use **Terminal > Run Task > START ALL DEVELOPMENT TERMINALS**. You can also run the individual tasks from **Terminal > Run Task**. If automatic tasks are disabled, open the Command Palette and run **Tasks: Manage Automatic Tasks**.

## Database safety

PostgreSQL data is stored in the named Docker volume defined by your root `docker-compose.yml`. Stopping or restarting the container does not delete that volume. Avoid `docker compose down -v` or manually deleting the volume unless you intentionally want to remove the database data.

## Troubleshooting

- **Docker is not found:** Start Docker Desktop manually and confirm `docker --version` works in PowerShell.
- **PostgreSQL is not healthy:** Run `docker compose logs -f db` from the project root.
- **Backend venv not found:** Update `$venvCandidates` in `scripts\Start-Backend.ps1`.
- **Backend cannot connect to DB:** Confirm PostgreSQL is healthy and check the backend `.env` values for database name, username, password, host and port.
- **Frontend not opening in Chrome:** Confirm Vite is configured to use port `8080` and check the Frontend terminal for errors.
- **Automatic terminals did not appear:** Trust the VS Code workspace and allow automatic tasks. You can manually run `START ALL DEVELOPMENT TERMINALS` from Terminal > Run Task.

## Important

All files in this folder are local developer convenience tools. They do not change your Django or React source code, database schema, Docker Compose configuration, Git history, or GitHub repository settings.
