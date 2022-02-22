@echo off

@REM set encoder=mfh264enc
set encoder=mfh264device1enc
@REM set encoder=mfh265enc

@REM h264
@REM gst-launch-1.0 videotestsrc ! %encoder% ! h264parse ! rtph264pay config-interval=10 pt=96 !  udpsink host=127.0.0.1 port=554

@REM h265
gst-launch-1.0 videotestsrc ! mfh265enc ! h265parse ! rtph265pay ! udpsink host=127.0.0.1 port=554
