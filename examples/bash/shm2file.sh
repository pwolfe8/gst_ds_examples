#!/bin/bash

# works in coordination with rtspsrc2shm.sh. launch that first

# inputs
SHM_SOCK_NAME=${1:-/tmp/shm_sock_69}
SHM_FPS=${2:-20} 

# shared mem caps coming in
SHM_CAPS="video/x-raw,format=RGB,width=1920,height=1080,framerate=$SHM_FPS/1"

# setup debug directory for pipeline graphs
ENABLE_DEBUG_GRAPH=true
DEBUG_TEMP_DIR=./debug_graphs_shm2file
rm -r $DEBUG_TEMP_DIR
mkdir -p $DEBUG_TEMP_DIR

# main gstreamer launch command
GST_DEBUG=2 GST_DEBUG_DUMP_DOT_DIR=$DEBUG_TEMP_DIR gst-launch-1.0 -e \
  shmsrc socket-path=$SHM_SOCK_NAME is-live=true do-timestamp=true ! $SHM_CAPS \
  ! videoconvert ! omxh264enc ! h264parse \
  ! matroskamux ! filesink location=shm_testfile1.mkv
  # or for mp4 do this: ! qtmux ! filesink location=testtest.mp4 

# post pipeline dot file generation if enabled
if [ $ENABLE_DEBUG_GRAPH == true ]; then 
  dot2graph $DEBUG_TEMP_DIR pdf
else 
  rm -r $DEBUG_TEMP_DIR
fi