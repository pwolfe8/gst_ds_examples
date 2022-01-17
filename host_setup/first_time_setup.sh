#!/bin/bash
ARCH=`uname -m`

# if on jetson then ensure L4T is 32.6.X
if [ $ARCH == aarch64 ]; then
  L4T_VERSION=`tr ',R' ' ' < <(cat /etc/nv_tegra_release | awk '{ print $2 "." $5 }')`
  l4t_array=($(echo $L4T_VERSION | tr "." "\n"))
  echo "found L4T version: $L4T_VERSION"
  if [ ${l4t_array[0]} == 32  ] && [ ${l4t_array[1]} == 6 ]; then
    echo "hooray! you have a a supported L4T version pattern: 32.6.X"
    echo "proceeding with first time setup..."
  else
    echo "your version must be 32.6.X. please flash that image to use this container"
    exit
  fi
fi

# first install docker (multi-arch support)
./helper_scripts/install_docker_on_host.sh

# if desktop then install nvidia-docker2 package
if [ $ARCH == x86_64 ]; then

  # check if already installed
  NVDOCK_INST=`dpkg -s nvidia-docker2 | grep "install ok installed" | awk '{print $4}'`
  if [ $NVDOCK_INST == "installed" ]; then
    echo "nvidia-docker2 package already installed. exiting..."
    exit
  fi

  # todo: check for nvidia drivers first? (untested)
  DRIVER_PKG=`ubuntu-drivers devices | grep recommended | awk '{print $3}'`
  NVDRIV_INST=`dpkg -s $DRIVER_PKG`
  if [ $NVDRIV_INST == "installed" ]; then
    echo "nvidia drivers installed"
  else
    echo ""
    echo "please install nvidia drivers first and reboot. see script:"
    echo "host_setup/desktop_scripts/install_nvidia_drivers_desktop.sh"
    echo ""
    echo "now exiting..."
    exit
  fi
  
  # then install nvidia-docker2 package
  echo "proceeding to install nvidia-docker2 package..."
  ./desktop_scripts/install_nvidia-docker2_desktop.sh
fi

# while you can attach the current window it's best to reboot
# so that your user is part of the "docker" group for all future opened terminals
echo "Finished first time setup script"
echo "Please reboot your machine to finish setup" 
echo ""