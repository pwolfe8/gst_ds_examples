#!/bin/bash
RTSPURL=${1:-rtsp://testuser:testpwd@10.160.41.21/live}
FOLDER=${2:-.}
FPS=${3:-1}

# create folder 
mkdir -p $FOLDER

# launch pipeline to record images (can modify to cap number of images before looping, size limit, etc. see multifilesink_doc.txt for parameters to set)
gst-launch-1.0 -e rtspsrc location=$RTSPURL ! rtph264depay ! avdec_h264 \
  ! videorate ! video/x-raw,framerate=$FPS/1 \
  ! jpegenc ! multifilesink location="$FOLDER/frame%08d.jpg"