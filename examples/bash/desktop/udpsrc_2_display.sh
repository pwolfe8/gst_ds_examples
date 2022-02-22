#!/bin/bash

UDPSRC="udpsrc port=554"
H264="application/x-rtp, media=video,clockrate=90000,encoding-name=H264,payload=96 ! rtph264depay ! h264parse ! decodebin"
AUTO_DISPLAY="videoconvert ! autovideosink sync=false"
# CHOSEN_DISPLAY="videoconvert ! decklinkvideosink"

PIPELINE_STR="$UDPSRC ! $H264 ! $AUTO_DISPLAY" # chooses the nvidia display element if nvidia-docker2 container
# PIPELINE_STR="$UDPSRC ! $H264 ! $CHOSEN_DISPLAY"

echo ""
echo "Now launching pipeline: $PIPELINE_STR"
echo ""

gst-launch-1.0 -e $PIPELINE_STR