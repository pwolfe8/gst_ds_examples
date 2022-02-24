#!/bin/bash

INPUT_W=2304
INPUT_H=1296
INPUT_FPS=25
INPUT_CAPS="video/x-raw,format=I420, width=$INPUT_W, height=$INPUT_H, framerate=$INPUT_FPS/1"
RGB_CAPS="video/x-raw,format=RGB, width=$INPUT_W, height=$INPUT_H, framerate=$INPUT_FPS/1"
RTSPURL="rtsp://admin:reolink@192.168.0.4//h264Preview_01_main"
RTSPSRC="rtspsrc latency=1000 location=$RTSPURL ! application/x-rtp,payload=96,encoding-name=H264"
NVRTSPSRC="rtspsrc latency=1000 location=$RTSPURL ! application/x-rtp,media=video ! rtph264depay ! h264parse ! nvv4l2decoder"


# udpsink_pipeline_string="appsrc ! x264enc ! rtph264pay config-interval=10 pt=96 ! udpsink host=127.0.0.1 port=554"
DESTINATION_IP="10.80.14.144"
# 127.0.0.1

TESTSRC="videotestsrc ! video/x-raw,format=I420,width=1920,height=1080,fps=25/1"
# CONVERT2NVMM="nvvideoconvert ! video/x-raw(memory:NVMM)"
NVH264="nvv4l2h264enc ! h264parse ! rtph264pay config-interval=10 pt=96"
H264="x264enc ! h264parse ! rtph264pay config-interval=10 pt=96"

UDPSINK="udpsink host=$DESTINATION_IP port=554"

# PIPELINE_STR="$TESTSRC ! $H264 ! $UDPSINK"
# PIPELINE_STR="$NVRTSPSRC ! $NVH264 ! $UDPSINK"
PIPELINE_STR="$RTSPSRC ! rtph264depay ! h264parse ! avdec_h264 ! videoconvert ! $RGB_CAPS ! appsink"

echo ""
echo "running pipeline: $PIPELINE_STR"
echo ""

gst-launch-1.0 -e $PIPELINE_STR
