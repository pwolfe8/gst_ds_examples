@echo off

@REM get container name from .env file
set /p DATA=<.env
FOR /f "tokens=1,2 delims=\=" %%a IN ("%DATA%") do set CONTAINER_NAME=%%b

echo removing container %CONTAINER_NAME%...
docker compose down -t 0