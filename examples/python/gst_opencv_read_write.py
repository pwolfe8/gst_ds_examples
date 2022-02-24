#!/usr/bin/python3
import cv2
INPUT_W=2304
INPUT_H=1296
INPUT_FPS=25.0

INPUT_CAPS=f"video/x-raw,format=I420, width={INPUT_W}, height={INPUT_H}, framerate={INPUT_FPS}/1"
RGB_CAPS=f"video/x-raw,format=RGB, width={INPUT_W}, height={INPUT_H}, framerate={INPUT_FPS}/1"
BGR_CAPS=f"video/x-raw,format=BGR,width={INPUT_W},height={INPUT_H},fps={INPUT_FPS}/1"

RTSPURL="rtsp://admin:reolink@192.168.0.5//h264Preview_01_main"

#### gstreamer to opencv ####
gst_pipeline_in = f"rtspsrc location={RTSPURL} ! application/x-rtp,payload=96,encoding-name=H264 ! rtph264depay ! h264parse ! avdec_h264 ! videoconvert ! {BGR_CAPS} ! appsink"
# gst_pipeline_in = f"videotestsrc ! {BGR_CAPS} ! appsink" # test pipeline

#### opencv to gstreamer ####
dest_ip='10.80.14.144'
dest_port=554
gst_pipeline_out = f"appsrc ! video/x-raw,format=BGR ! queue max-size-buffers=4 ! videoconvert ! nvvideoconvert ! nvv4l2h264enc ! video/x-h264, stream-format=byte-stream ! h264parse ! rtph264pay pt=96 config-interval=1 ! udpsink host={dest_ip} port={dest_port}"

cap = cv2.VideoCapture(gst_pipeline_in, cv2.CAP_GSTREAMER)

# fourcc = cv2.VideoWriter_fourcc(*'x264')
out = cv2.VideoWriter(gst_pipeline_out, cv2.CAP_GSTREAMER, 0, 25, (INPUT_W, INPUT_H))

if not cap.isOpened():
    print('input capture cant open for some reason')
    exit(1)

if not out.isOpened():
    print('out cant open for some reason')
    exit(1)

print('looping... ')
show = False
while cap.isOpened():
    # print('attempting to read...')
    ret, frame = cap.read()
    if ret:
        ### display with X11. be sure to set your display variable
        # cv2.imshow('VIDEO', frame)

        if out.isOpened():
            out.write(frame)
            print('writing frame')

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Release everything if job is finished
cap.release()
out.release()