#!/bin/bash
ARCH=`uname -m`
if [ $ARCH == aarch64 ]; then
  echo "this is a desktop install script. exiting..."
  exit
elif [ $ARCH == x86_64 ]; then
  distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

  sudo apt update && sudo apt install -y nvidia-docker2

  echo "restarting docker service now..."
  sudo systemctl restart docker  

  # test it out
  # sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
else
  echo "Unsupported architecture. only supports aarch64 or x86_64"
fi