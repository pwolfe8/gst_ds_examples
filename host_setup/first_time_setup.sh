#!/bin/bash

# first install docker (multi-arch support)
./helper_scripts/install_docker_on_host.sh

# then install extra stuff if desktop
ARCH=`uname -m`
if [ $ARCH == x86_64 ]; then

  # check for nvidia drivers first

  # then install nvidia-docker2 package
  ./desktop/install_nvidia_docker_desktop.sh
fi