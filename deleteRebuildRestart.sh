#!/bin/bash
CONTAINER_NAME=`cat .env  | grep CONTAINER_NAME | awk -F "=" '{print $2}'`
echo "deleting, rebuilding, and restarting container $CONTAINER_NAME..."
./remove.sh
./build.sh
./run.sh