#!/bin/bash
# RTSP_URL=${1:-rtsp://admin:admin@10.219.189.160/cam/realmonitor?channel=1&subtype=1}
RTSP_URL=${1:-rtsp://admin:admin@10.219.189.172/cam/realmonitor?channel=1&subtype=1}

timeout 2s gst-launch-1.0 rtspsrc location=$RTSP_URL ! fakesink > rtsptest_temp_out.txt




