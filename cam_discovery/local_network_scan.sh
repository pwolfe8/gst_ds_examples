#!/bin/bash
SUBNET=$1
if [ -z "$SUBNET" ]; then
  echo "please specify subnet to scan as arg."
  echo "example: 192.168.0.1/24"
  echo "alternatively if you want to scan your default interface whole local network subnet run:"
  echo "sudo arp-scan -l"
fi

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
# sudo arp-scan -l | tee >(awk '(NR>2) {print $1,"\t\t",$2,"\t\t",substr($0,index($0,$3))}'| head -n-3 > local_network_out.txt) 
# or run subnet only 
sudo arp-scan $SUBNET | tee >(awk '(NR>2) {print $1,"\t\t",$2,"\t\t",substr($0,index($0,$3))}'| head -n-3 > local_network_out.txt) 