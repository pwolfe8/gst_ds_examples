#!/bin/bash
CONTAINER_NAME=gst_ds_examples
SSH_DEV=true

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
      FROM_IMG=pwolfe854/gst_ds_env:x86_64_gpu
    elif [ $ARCH == aarch64 ]; then
      FROM_IMG=pwolfe854/gst_ds_env:aarch64_gpu
    else
      echo "unsupported architecture $ARCH. must be aarch64 or x86_64"
      exit
    fi
  else
    echo "nvidia-docker2 package not detected. not using GPU passthrough"
    NOGPU=_nogpu
    GPU_ARG=""
    WORKDIR=/root/
    if [ $ARCH == x86_64 ]; then 
      FROM_IMG=pwolfe854/gst_ds_env:x86_64_nogpu
    elif [ $ARCH == aarch64 ]; then
      FROM_IMG=pwolfe854/gst_ds_env:aarch64_nogpu
    else
      echo "unsupported architecture $ARCH. must be aarch64 or x86_64"
      exit
    fi
  fi
  echo ""
# otherwise set build arguments based on choice
elif [ $ARCH_IN == jetson ]; then
  ARCH=aarch64
  NOGPU=gpu
  GPU_ARG=nvidia
  WORKDIR=/opt/nvidia/deepstream/deepstream-6.0/
  FROM_IMG=pwolfe854/gst_ds_env:aarch64_gpu
elif [ $ARCH_IN == desktop ]; then
  DOCKERFILE=x86_64
  NOGPU=gpu
  GPU_ARG=nvidia
  WORKDIR=/opt/nvidia/deepstream/deepstream-6.0/
  FROM_IMG=pwolfe854/gst_ds_env:x86_64_gpu
elif [ $ARCH_IN == jetson_nogpu ]; then
  ARCH=aarch64
  NOGPU=nogpu
  GPU_ARG=""
  WORKDIR=/root/
  FROM_IMG=pwolfe854/gst_ds_env:aarch64_nogpu
elif [ $ARCH_IN == desktop_nogpu ]; then
  ARCH=x86_64
  NOGPU=nogpu
  GPU_ARG=""
  WORKDIR=/root/
  FROM_IMG=pwolfe854/gst_ds_env:x86_64_nogpu
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
echo SSH_DEV=$SSH_DEV >> .env
echo ARCH=$ARCH >> .env
echo NOGPU=$NOGPU >> .env
echo GPU_ARG=$GPU_ARG >> .env
echo WORKDIR=$WORKDIR >> .env
echo FROM_IMG=$FROM_IMG >> .env

# build with build args set
echo "building Dockerfile ${ARCH} ${NOGPU}..."
docker-compose build $NOCACHE