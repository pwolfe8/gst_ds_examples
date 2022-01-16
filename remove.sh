#!/bin/bash
CONTAINER_NAME=`cat .containername`
echo "removing container $CONTAINER_NAME..."
docker-compose down -t 0