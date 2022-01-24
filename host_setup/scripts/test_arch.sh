#!/bin/bash
ARCH=`uname -m`
if [ $ARCH == aarch64 ]; then
  echo "jetson"
elif [ $ARCH == x86_64 ]; then
  echo "desktop"
else
  echo "Unsupported architecture. only supports aarch64 or x86_64"
fi