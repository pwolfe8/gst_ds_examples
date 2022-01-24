#!/bin/bash

echo ""
echo "running host docker/docker-compose setup script"
echo ""

if [ -x "$(command -v docker)" ]; then
    echo "docker is already installed"
else
    echo "docker is not installed. setting up now"
    
    sudo apt update && apt install -y \
      ca-certificates \
      curl \
      gnupg \
      lsb-release

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt install -y docker-ce docker-ce-cli containerd.io
fi


if [ -x "$(command -v docker-compose)" ]; then
  echo "docker-compose is already installed"
else
  echo "docker-compose is not installed. setting up now"
  ARCH=`uname -m`
  if [ $ARCH == aarch64 ]; then
    echo "installing docker-compose on jetson"
    sudo apt install -y python3-pip libssl-dev libffi-dev libhdf5-dev rustc
    pip3 install -U pip setuptools
    pip3 install docker-compose
    export PATH="$HOME/.local/bin:$PATH"
    sudo ln -s `which docker-compose` /usr/bin/docker-compose
  elif [ $ARCH == x86_64 ]; then
    echo "installing docker-compose on desktop"
    sudo apt update && apt install -y curl 
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  else
    echo "Unsupported architecture. only supports aarch64 or x86_64"
  fi
fi

GROUP=docker
if groups | grep -qw "$GROUP"; then
  echo $USER already belongs to group $GROUP
else
  echo $USER does not belong to $GROUP. adding now
  # add to group and tell user to log out and back in or reboot
  sudo groupadd docker
  sudo usermod -aG docker $USER # or you can sudo gpasswd -a $USER docker
  newgrp docker
  echo "added user $USER to group docker."
fi

echo ""
echo "done"
echo ""