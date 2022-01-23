#!/bin/bash

# GST_DEBUG=2 
DEBUG_FOLD=./debug_stereo2file
rm-r $DEBUG_FOLD
mkdir -p $DEBUG_FOLD

FPS=15
GST_DEBUG_DUMP_DOT_DIR=$DEBUG_FOLD gst-launch-1.0 -e \
v4l2src device=/dev/video0 \
  ! "video/x-raw,format=GRAY8,width=3200,height=1300,framerate=$(($FPS * 2))/1" \
  ! videoconvert ! omxh264enc ! h264parse \
  ! matroskamux ! filesink location=test_stereo_file.mkv
  # ! qtmux ! filesink location=test_stereo_file.mp4 

dot2graph $DEBUG_FOLD