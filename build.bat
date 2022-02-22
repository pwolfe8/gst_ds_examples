@echo off
set CONTAINER_NAME=gst_ds_examples
set ENABLE_SSH=false
set nocache=

set ARCH=x86_64
set NOGPU=nogpu
set WORKDIR=/root/
set FROM_IMG=pwolfe854/gst_ds_env:%ARCH%_%NOGPU%

echo CONTAINER_NAME=%CONTAINER_NAME%> .env
echo ARCH=%ARCH%>> .env
echo WORKDIR=%WORKDIR%>> .env
echo FROM_IMG=%FROM_IMG%>> .env
echo ENABLE_SSH=%ENABLE_SSH%>> .env

echo building Dockerfile for %ARCH% with %NOGPU%...
docker compose build %NOCACHE%