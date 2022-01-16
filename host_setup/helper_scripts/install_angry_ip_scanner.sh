#!/bin/bash
echo ""
echo "installing angry ip scanner on host"
echo ""

sudo apt update
sudo apt --fix-broken install -y openjdk-11-jdk curl
curl -L -O https://github.com/angryip/ipscan/releases/download/3.7.6/ipscan_3.7.6_all.deb 
sudo dpkg -i ipscan*.deb