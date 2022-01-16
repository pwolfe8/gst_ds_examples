#!/bin/bash
CONTAINER_NAME=`cat .containername`
echo "deleting, rebuilding, and restarting container $CONTAINER_NAME..."
./remove.sh
./build.sh
./run.sh