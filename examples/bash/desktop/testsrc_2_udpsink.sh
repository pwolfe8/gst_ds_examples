#!/bin/bash

INPUT_W=2304
INPUT_H=1296
INPUT_FPS=25
INPUT_CAPS="video/x-raw,format=I420, width=$INPUT_W, height=$INPUT_H, framerate=$INPUT_FPS/1"
RTSPURL="rtsp://admin:reolink@192.168.0.4//h264Preview_01_main"
RTSPSRC="rtspsrc latency=1000 location=$RTSPURL ! application/x-rtp,media=video ! rtph264depay ! avdec_h264 ! videoconvert ! $INPUT_CAPS"

TESTSRC="videotestsrc ! video/x-raw,format=I420,width=1920,height=1080,fps=25/1"
CONVERT2NVMM="nvvideoconvert ! video/x-raw(memory:NVMM)"
H264="nvv4l2h264enc ! h264parse ! rtph264pay config-interval=10 pt=96"
UDPSINK="udpsink host=127.0.0.1 port=554"

PIPELINE_STR="$TESTSRC ! $CONVERT2NVMM ! $H264 ! $UDPSINK"

echo ""
echo "Now launching pipeline: $PIPELINE_STR"
echo ""

gst-launch-1.0 -e $PIPELINE_STR