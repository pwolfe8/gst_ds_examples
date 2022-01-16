#!/bin/bash
#!/bin/bash
ARCH=`uname -m`
if [ $ARCH == aarch64 ]; then
  echo "this is a desktop install script. exiting..."
  exit
elif [ $ARCH == x86_64 ]; then
  sudo apt update && \
    sudo apt install -y `ubuntu-drivers devices | grep recommended | awk '{print $3}'`
else
  echo "Unsupported architecture. only supports aarch64 or x86_64"
fi