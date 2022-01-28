#!/bin/bash
CONTAINER_NAME=gst_ds_examples

# input args
ARCH_IN=${1:-}  # override arch to build
ENABLE_SSH=${2:-false}
NOCACHE=${3:-}  # build no cache

# automatically determine situation if no arch specified
if [ $# -eq "0" ]; then

  # check for aarch64 or x86_64
  ARCH=`uname -m`
  echo "detected arch as $ARCH"
  if [ $ARCH != x86_64 ] && [ $ARCH != aarch64 ]; then
    echo "unsupported architecture $ARCH. must be aarch64 or x86_64"
    exit
  fi

  # check for nvidia-docker2 package to use deepstream & gpu passthrough
  GPU_PASS=`dpkg -s nvidia-docker2 | grep "install ok installed" | awk '{print $4}'`
  if [ $GPU_PASS == "installed" ]; then
    echo "nvidia-docker2 package detected. using GPU passthrough"
    GPU_ARG=nvidia
  else
    echo "nvidia-docker2 package not detected. not using GPU passthrough"
    GPU_ARG=normal
  fi
  echo ""

# otherwise set build arguments based on manual override choice
elif [ $ARCH_IN == jetson ]; then
  ARCH=aarch64
  GPU_ARG=nvidia
elif [ $ARCH_IN == desktop ]; then
  ARCH=x86_64
  GPU_ARG=nvidia
elif [ $ARCH_IN == jetson_nogpu ]; then
  ARCH=aarch64
  GPU_ARG=normal
elif [ $ARCH_IN == desktop_nogpu ]; then
  ARCH=x86_64
  GPU_ARG=normal
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

# set some params based on if gpu or not
if [ "$GPU_ARG" = "nvidia" ]; then
  NOGPU=gpu
  WORKDIR=/opt/nvidia/deepstream/deepstream-6.0/
  
  # also clone any git repos to be mapped if you want
  if [ -z "$(ls -A sub_projects/deepstream_pose_estimation)" ]; then
    git clone git@github.com:pwolfe8/deepstream_pose_estimation.git sub_projects/deepstream_pose_estimation
  else  
    echo "repo already cloned"
  fi
else
  NOGPU=nogpu
  WORKDIR=/root/
fi

# choose starting docker image 
FROM_IMG=pwolfe854/gst_ds_env:${ARCH}_${NOGPU}

# write docker compose args to .env file and .containername file
echo CONTAINER_NAME=$CONTAINER_NAME > .env
echo ARCH=$ARCH >> .env
echo GPU_ARG=$GPU_ARG >> .env
echo WORKDIR=$WORKDIR >> .env
echo FROM_IMG=$FROM_IMG >> .env
echo ENABLE_SSH=$ENABLE_SSH >> .env

# build with build args set
echo "building Dockerfile for ${ARCH} with ${NOGPU}..."
if [ $GPU_ARG == nvidia ]; then 
  docker-compose -f docker-compose.nvidia.yaml build $NOCACHE
else
  docker-compose build $NOCACHE
fi