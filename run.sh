#!/bin/bash
CONTAINER_NAME=`cat .env  | grep CONTAINER_NAME | awk -F "=" '{print $2}'`
GPU_ARG=`cat .env  | grep GPU_ARG | awk -F "=" '{print $2}'`

echo "running container $CONTAINER_NAME..."
if [ $GPU_ARG == nvidia ]; then 
  docker-compose -f docker-compose.nvidia.yaml up --detach
else
  docker-compose up --detach
fi