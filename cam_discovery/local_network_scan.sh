#!/bin/bash
SUBNET=${1:-10.80.14.172/24}

# install prereqs if needed
if [ !  -x "$(command -v nmap)" ]; then
  sudo apt install -y nmap
fi
if [ !  -x "$(command -v arp-scan)" ]; then
  sudo apt install -y arp-scan
fi

# do a quick ping scan using nmap
sudo nmap -sn $SUBNET

# now run arp-scan to gather local mac address info
sudo arp-scan -l | tee >(awk '(NR>2) {print $1,"\t\t",$2,"\t\t",substr($0,index($0,$3))}'| head -n-3 > local_network_out.txt) 
