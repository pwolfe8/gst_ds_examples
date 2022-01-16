#!/bin/bash

## 
## change ownership from root to user in case created by root in docker container.
##


sudo chmod -R 744 $1
sudo chown -R $USER:$USER $1