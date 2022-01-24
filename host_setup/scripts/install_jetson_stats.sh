#!/bin/bash
sudo -H pip3 install -U jetson-stats
sudo systemctl restart jetson_stats.service
echo "finished installation. please reboot"