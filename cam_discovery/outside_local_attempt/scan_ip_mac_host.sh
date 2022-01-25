#!/bin/bash

SUBNET=${1:-10.43.8.1/23}


# install prereqs if needed
if [ !  -x "$(command -v nmap)" ]; then
  sudo apt install -y nmap
fi
if [ !  -x "$(command -v nmblookup)" ]; then
  sudo apt install -y samba-common-bin
fi

# remove existing files to prepare for new if they exist
[ -e nmap_scanned_ips.txt ] && rm nmap_scanned_ips.txt
[ -e nmblookup_out.txt ] && rm nmblookup_out.txt

# perform scan for active ips on subnet
echo scanning for active ips on subnet $SUBNET using nmap...
nmap -sn $SUBNET | tee >( awk '/Nmap scan/{gsub(/[()]/,"",$NF); print $NF > "nmap_scanned_ips.txt"}' )

echo running nmblookup on nmap results...
cat nmap_scanned_ips.txt | while read in; do nmblookup -A $in | tee -a nmblookup_out.txt; done

echo cleaning up results ...
python3 cleanup_nmblookup.py | tee cleaned_results.txt

## remove intermediate files now
# rm nmap_scanned_ips.txt nmblookup_out.txt

echo done
