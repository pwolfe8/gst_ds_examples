#!/bin/bash

# starting point example from nvidia ngc website (https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-base)
sudo docker run -it --rm --net=host --runtime nvidia -e DISPLAY=$DISPLAY -w /opt/nvidia/deepstream/deepstream-6.0 -v /tmp/.X11-unix/:/tmp/.X11-unix nvcr.io/nvidia/deepstream-l4t:6.0-samples
