#!/bin/bash
RTSP_URL=${1:-rtsp://admin:admin@10.219.189.164/cam/realmonitor?channel=1&subtype=1}
# gst-launch-1.0 -e rtspsrc location=$RTSP_URL latency=500 ! decodebin ! x264enc ! matroskamux ! filesink location=filename_h264.mkv

DEBUG_TEMP_DIR=./debug_rtsp_test
rm -r $DEBUG_TEMP_DIR
mkdir -p $DEBUG_TEMP_DIR
sleep 0.1

GST_DEBUG=1 \
GST_DEBUG_DUMP_DOT_DIR=$DEBUG_TEMP_DIR \
gst-launch-1.0 -e rtspsrc location=$RTSP_URL latency=500 ! rtph264depay ! avdec_h264 ! matroskamux ! filesink location=test_record.mkv
# gst-launch-1.0 -e rtspsrc location=$RTSP_URL latency=500 ! decodebin ! matroskamux ! filesink location=filename_h264.mkv

dot2graph $DEBUG_TEMP_DIR pdf