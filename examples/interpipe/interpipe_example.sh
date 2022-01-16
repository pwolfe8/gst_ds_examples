#!/bin/bash
FPS=15

gstd & 

sleep 2 



## not done yet. don't run yetls
gstd-client pipeline_create pipe_src \
  v4l2src device=/dev/video0 \  
  ! "video/x-raw,format=GRAY8,width=3200,height=1300,framerate=$(($FPS * 2))/1" \
  ! interpipesink name=camsrc
