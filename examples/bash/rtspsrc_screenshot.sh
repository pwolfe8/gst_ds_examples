#!/bin/bash
RTSPURL=${1:-rtsp://testuser:testpwd@10.160.41.21/live}
FILENAME=screenshot_test.jpg
TEMPFOLD=screenshot_temp_folder
timeout 4 ./rtspsrc_record_images.sh $RTSPURL $TEMPFOLD 1
cp $TEMPFOLD/frame00000002.jpg ./$FILENAME
rm -rf $TEMPFOLD