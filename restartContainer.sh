#!/bin/bash
CONTAINER_NAME=`cat .env  | grep CONTAINER_NAME | awk -F "=" '{print $2}'`
echo "removing and rerunning container $CONTAINER_NAME..."
./remove.sh
./run.sh
