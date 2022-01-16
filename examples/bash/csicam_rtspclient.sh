#!/bin/bash

### this assumes you have mapped /dev/video0 into this docker (see docker-compose.yaml device mappings section) before building and running. if not, exit/remove this container. rebuild + run + attach

## record csi cam on /dev/video0 to mkv file
# assumed caps (see v4l-ctl --list-formats-ext for more options)
INPUT_CAPS_720p="video/x-raw(memory:NVMM),format=NV12,width=1280,height=720,framerate=60/1"
INPUT_CAPS_1080p="video/x-raw(memory:NVMM),format=NV12,width=1920,height=1080,framerate=30/1"
INPUT_CAPS_1848p="video/x-raw(memory:NVMM),format=NV12,width=3264,height=1848,framerate=28/1"
INPUT_CAPS_2464p="video/x-raw(memory:NVMM),format=NV12,width=3264,height=2464,framerate=21/1"

ENC_AND_PACKETIZE="omxh264enc" # ! h264parse ! rtph264pay name=pay0 pt=96"
RTSP_CLIENT="rtspclientsink location=rtsp://127.0.0.1:8554/test"

echo ""
echo "________________________________________"
echo "displaying with input caps: "
echo "    $INPUT_CAPS"
echo ""
echo hit ctrl+c to stop
echo "________________________________________"
echo ""

# gstreamer launch command
gst-launch-1.0 -e \
	nvarguscamerasrc \
	! $INPUT_CAPS_2464p \
  ! $ENC_AND_PACKETIZE \
  ! $RTSP_CLIENT
