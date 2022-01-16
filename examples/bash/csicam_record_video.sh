#!/bin/bash

### this assumes you have mapped /dev/video0 into this docker (see docker-compose.yaml device mappings section) before building and running. if not, exit/remove this container. rebuild + run + attach

## record csi cam on /dev/video0 to mkv file
# assumed caps (see v4l-ctl --list-formats-ext for more options)
INPUT_CAPS="video/x-raw(memory:NVMM), format=NV12, width=1280, height=720, framerate=(fraction)60/1"


## example output file path for recording mkv (can be found local to where you ran this script from)
OUTPUT_FILEPATH=example_path_to_output_file.mp4
# for MP4 substitute matroskamux to qtmux in pipeline below....

REDUCE_FRAMERATE="video/x-raw(memory:NVMM),format=NV12,width=1280,height=720,framerate=10/1"


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
	nvarguscamerasrc \
	! $INPUT_CAPS \
  ! nvvidconv \
  ! omxh265enc \
  ! qtmux \
	! filesink location=$OUTPUT_FILEPATH

# can also just go straight into muxer but higher file size

# can choose matroskamux for mkv or qtmux for mp4

  # you can add omxh265enc instead of nvvidconv to encode video 
