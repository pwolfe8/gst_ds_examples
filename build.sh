#!/bin/bash
CONTAINER_NAME=gst_ds_env

# input args
ARCH_IN=${1:-}  # override arch to build
NOCACHE=${2:-}  # build no cache

# automatically determine if no arch specified
if [ $# -eq "0" ]; then
  # check for aarch64 or x86_64
  ARCH=`uname -m`
  echo "detected arch as $ARCH"

  # check for nvidia-docker2 package to use deepstream & gpu passthrough
  GPU_PASS=`dpkg -s nvidia-docker2 | grep "install ok installed" | awk '{print $4}'`
  if [ $GPU_PASS == "installed" ]; then
    echo "nvidia-docker2 package detected. using GPU passthrough"
    NOGPU=gpu
    GPU_ARG=nvidia
    WORKDIR=/opt/nvidia/deepstream/deepstream-6.0/
    if [ $ARCH == x86_64 ]; then 
      FROM_IMG=nvcr.io/nvidia/deepstream:6.0-devel
    elif [ $ARCH == aarch64 ]; then
      FROM_IMG=nvcr.io/nvidia/deepstream-l4t:6.0-samples
    else
      echo "unsupported architecture $ARCH. must be aarch64 or x86_64"
      exit
    fi

  else
    echo "nvidia-docker2 package not detected. not using GPU passthrough"
    NOGPU=_nogpu
    GPU_ARG=""
    WORKDIR=/root/gitfoldermap/
    FROM_IMG=ubuntu:18.04
  fi
  echo ""
# otherwise set build arguments based on choice
elif [ $ARCH_IN == jetson ]; then
  ARCH=aarch64
  NOGPU=gpu
  GPU_ARG=nvidia
  WORKDIR=/opt/nvidia/deepstream/deepstream-6.0/
  FROM_IMG=nvcr.io/nvidia/deepstream-l4t:6.0-samples
elif [ $ARCH_IN == desktop ]; then
  DOCKERFILE=x86_64
  NOGPU=gpu
  GPU_ARG=nvidia
  WORKDIR=/opt/nvidia/deepstream/deepstream-6.0/
  FROM_IMG=nvcr.io/nvidia/deepstream:6.0-devel
elif [ $ARCH_IN == jetson_nogpu ]; then
  ARCH=aarch64
  NOGPU=nogpu
  GPU_ARG=""
  WORKDIR=/root/gitfoldermap/
  FROM_IMG=ubuntu:18.04
elif [ $ARCH_IN == desktop_nogpu ]; then
  ARCH=x86_64
  NOGPU=nogpu
  GPU_ARG=""
  WORKDIR=/root/gitfoldermap/
  FROM_IMG=ubuntu:18.04
else
  echo ""
  echo "Unrecognized choice $ARCH_IN"
  echo ""
  echo "Please choose one of the following: "
  echo "    jetson"
  echo "    desktop"
  echo "    jetson_nogpu"
  echo "    desktop_nogpu"
  echo ""
  echo "now exiting..."
  echo ""

  exit
fi

# write docker compose args to .env file and .containername file
echo $CONTAINER_NAME > .containername
echo CONTAINER_NAME=$CONTAINER_NAME > .env
echo ARCH=$ARCH >> .env
echo NOGPU=$NOGPU >> .env
echo GPU_ARG=$GPU_ARG >> .env
echo WORKDIR=$WORKDIR >> .env
echo FROM_IMG=$FROM_IMG >> .env

# build with build args set
echo "building Dockerfile_${ARCH} ${NOGPU}..."
docker-compose build $NOCACHE