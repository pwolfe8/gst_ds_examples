#!/bin/bash
RTSP_URL=${1:-rtsp://admin:admin@10.219.189.217/cam/realmonitor?channel=1&subtype=1}

# gst-launch-1.0 -e rtspsrc location=$RTSP_URL latency=500 ! decodebin ! x264enc ! matroskamux ! filesink location=filename_h264.mkv

DEBUG_TEMP_DIR="./debug_rtsp_test"
sudo rm -rf $DEBUG_TEMP_DIR
mkdir -p $DEBUG_TEMP_DIR
sleep 0.1

sudo GST_DEBUG=1 \
GST_DEBUG_DUMP_DOT_DIR=$DEBUG_TEMP_DIR \
#gst-launch-1.0 -e rtspsrc location=$RTSP_URL latency=500 ! rtph264depay ! avdec_h264 ! x264enc ! matroskamux ! filesink location=alex_test_record_encoded_3.mkv
gst-launch-1.0 -e rtspsrc location=$RTSP_URL latency=500 ! decodebin ! matroskamux ! filesink location=alex_test_record_unencoded_3.mkv

# Tee test 1 - nonfunctioning
#gst-launch-1.0 -e rtspsrc location=$RTSP_URL latency=500 !  tee name=t ! \
#t. ! queue ! decodebin ! matroskamux ! filesink location=alex_test_record_unencoded_4.mkv \
#t. ! queue ! rtph264depay ! avdec_h264 ! x264enc ! tune=zerolatency ! matroskamux ! filesink location=alex_test_record_encoded_4.mkv

# Tee test 2 - nonfunctioning
#gst-launch-1.0 -e rtspsrc location=$RTSP_URL latency=500 ! tee name=t ! \
#queue ! decodebin ! matroskamux ! filesink location=alex_test_record_unencoded_4.mkv \
#t. ! queue max-size-buffers=4294967295 max-size-bytes=4294967295 max-size-time=18446744073709551615 ! \
#rtph264depay ! avdec_h264 ! x264enc ! matroskamux ! filesink location=alex_test_record_encoded_4.mkv

#Philip test - nonfunctioning
#gst-launch-1.0 -e rtspsrc location=$RTSP_URL latency=500 ! rtph264depay ! avdec_h264 ! tee name=t \
#t. ! x264enc ! matroskamux ! filesink location=test_record_enc.mkv \
#t. ! matroskamux ! filesink location=test_record_noenc.mkv

dot2graph $DEBUG_TEMP_DIR pdf