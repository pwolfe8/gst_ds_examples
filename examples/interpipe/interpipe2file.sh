#!/bin/bash
interpipesrc listen-to=stereocampipe ! videoconvert ! omxh264enc ! h264parse \
  ! matroskamux ! filesink location=testpipe.mkv