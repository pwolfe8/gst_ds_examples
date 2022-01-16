#!/bin/bash
RTSPURL=${1:-rtsp://testuser:testpwd@10.160.41.21/live}
gst-launch-1.0 -e rtspsrc location=$RTSPURL ! decodebin ! omxh265enc ! h265parse ! matroskamux ! filesink location=filename_h265.mkv