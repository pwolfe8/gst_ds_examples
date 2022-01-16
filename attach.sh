#!/bin/bash
CONTAINER_NAME=`cat .containername`
echo "attaching to container $CONTAINER_NAME..."
docker exec -it $CONTAINER_NAME /bin/bash