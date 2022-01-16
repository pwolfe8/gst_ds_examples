#!/bin/bash
CONTAINER_NAME=`cat .containername`
echo "running container $CONTAINER_NAME..."
docker-compose up --detach