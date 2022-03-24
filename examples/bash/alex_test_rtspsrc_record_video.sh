#!/bin/bash
RTSPURL=${1:-rtsp://admin:admin@10.219.189.160/cam/realmonitor?channel=1&subtype=1}
gst-launch-1.0 -e rtspsrc location=$RTSPURL ! decodebin ! matroskamux ! filesink location=filename_h265.mkv