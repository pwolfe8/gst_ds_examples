#!/bin/bash

# GST_DEBUG=2 
FPS=15
GST_DEBUG_DUMP_DOT_DIR=/home/uav/gst_docker/graphs gst-launch-1.0 -e v4l2src device=/dev/video0 ! "video/x-raw,format=GRAY8,width=3200,height=1300,framerate=$(($FPS * 2))/1" \
  ! videoconvert ! omxh264enc ! h264parse \
  ! matroskamux ! filesink location=testet.mkv
  # ! qtmux ! filesink location=testtest.mp4 


# shmsink