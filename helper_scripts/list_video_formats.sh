#!/bin/bash

## prereq (already added to docker container. just in case you wanna run on the host)
##   sudo apt install v4l-utils


## 
## lists available v4l2 device video formats, resolutions, and framerate combo choices
##

v4l2-ctl --list-formats-ext
