@echo off

@REM h264
gst-launch-1.0 udpsrc port=554 ! "application/x-rtp, media=video, clock-rate=90000, encoding-name=H264, payload=96" ! rtph264depay ! h264parse ! decodebin ! videoconvert ! autovideosink sync=false


@REM h265 (doesn't always work)
@REM gst-launch-1.0 udpsrc port=554 ! "application/x-rtp, media=video, encoding-name=H265, payload=96" ! queue ! rtph265depay ! h265parse ! decodebin ! queue  ! videoconvert ! queue ! autovideosink sync=false

@REM d3d11h265dec