@echo off

@REM get container name from .env file
set /p DATA=<.env
FOR /f "tokens=1,2 delims=\=" %%a IN ("%DATA%") do set CONTAINER_NAME=%%b

echo attaching to container %CONTAINER_NAME%...
docker exec -it %CONTAINER_NAME% /bin/bash 