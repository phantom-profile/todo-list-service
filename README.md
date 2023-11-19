## Tasks-tracking service
1) install deps to venv
2) DB setting
```commandline
alembic upgrade head
cp .env.example .env
```
launch server
```commandline
uvicorn app.endpoints:app --port 8002 --reload --log-config ./log.ini
```
access web app at http://localhost:8002
