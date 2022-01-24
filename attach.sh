#!/bin/bash
CONTAINER_NAME=`cat .env  | grep CONTAINER_NAME | awk -F "=" '{print $2}'`
GPU_ARG=`cat .env  | grep GPU_ARG | awk -F "=" '{print $2}'`
echo "attaching to container $CONTAINER_NAME..."
docker exec -it $CONTAINER_NAME /bin/bash