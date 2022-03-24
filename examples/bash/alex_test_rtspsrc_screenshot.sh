#!/bin/bash
RTSPURL=${1:-rtsp://admin:admin@10.219.189.200/cam/realmonitor?channel=1&subtype=1}

FILENAME=10.219.189.200.jpg
TEMPFOLD=screenshot_temp_folder
timeout 4 ./rtspsrc_record_images.sh $RTSPURL $TEMPFOLD 1
cp $TEMPFOLD/frame00000002.jpg ./$FILENAME
rm -rf $TEMPFOLD
