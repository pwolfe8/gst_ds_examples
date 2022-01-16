#!/bin/bash
FPS=15
# INTERPIPE_NAME=stereocampipe
gst-launch-1.0 -e v4l2src device=/dev/video0 \
  ! "video/x-raw,format=GRAY8,width=3200,height=1300,framerate=$(($FPS * 2))/1" \
  ! interpipesink name=stereocampipe
