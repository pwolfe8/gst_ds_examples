#!/bin/bash

### this assumes you have mapped /dev/video0 into this docker (see docker-compose.yaml device mappings section) before building and running. if not, exit/remove this container. rebuild + run + attach

## record usb cam on /dev/video0 to mkv file
## I assumed logitech c920 formats available and went with these cusom caps for that. set yours appropriately if you want to control framerate/resolution/format
## check v4l2-ctl --list-formats-ext for full set of options on resolutions/framerates/video formats
INPUT_CAPS="video/x-raw, width=1280, height=720, format=(string)YUY2, framerate=(fraction)10/1"

## example output file path for recording mkv (can be found local to where you ran this script from)
OUTPUT_FILEPATH=example_path_to_output_file.mkv
# for MP4 substitute matroskamux to qtmux in pipeline below....

echo ""
echo "________________________________________"
echo recording with input caps: 
echo     $INPUT_CAPS
echo ""
echo saving output to `pwd`/$OUTPUT_FILEPATH
echo ""
echo hit ctrl+c to stop
echo "________________________________________"
echo ""

# gstreamer launch command
gst-launch-1.0 -e \
	v4l2src device=/dev/video0 \
	! $INPUT_CAPS \
	! videoconvert \
	! matroskamux \
	! filesink location=$OUTPUT_FILEPATH