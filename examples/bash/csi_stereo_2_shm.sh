#!/bin/bash

# GST_DEBUG=2 
FPS_IN=20
CAPS_IN="video/x-raw,format=GRAY8,width=3200,height=1300,framerate=$FPS_IN/1"

# input args
SHM_SOCK_NAME=${1:-/tmp/shm_sock_69}
SHM_FPS=${2:-20} 

SHM_CAPS="video/x-raw,format=RGB,width=3200,height=1300,framerate=$SHM_FPS/1"

# setup debug directory for pipeline graphs
ENABLE_DEBUG_GRAPH=true
DEBUG_TEMP_DIR=./debug_graphs_stereoshm
rm -r $DEBUG_TEMP_DIR
mkdir -p $DEBUG_TEMP_DIR

# main gstreamer launch command
GST_DEBUG=2 GST_DEBUG_DUMP_DOT_DIR=$DEBUG_TEMP_DIR gst-launch-1.0 -e \
  v4l2src device=/dev/video0 ! $CAPS_IN \
  ! videoconvert ! videorate ! $SHM_CAPS \
  ! shmsink socket-path=$SHM_SOCK_NAME max-lateness=1000000 sync=0 wait-for-connection=0
  # shm-size=100000000 \
  #  qos=true

# post pipeline dot file generation if enabled
if [ $ENABLE_DEBUG_GRAPH == true ]; then 
  dot2graph $DEBUG_TEMP_DIR pdf
else 
  rm -r $DEBUG_TEMP_DIR
fi