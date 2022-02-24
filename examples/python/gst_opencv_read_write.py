#!/usr/bin/python3
import cv2
INPUT_W=2304
INPUT_H=1296
INPUT_FPS=25.0
INPUT_CAPS=f"video/x-raw,format=I420, width={INPUT_W}, height={INPUT_H}, framerate={INPUT_FPS}/1"

RTSPURL="rtsp://admin:reolink@192.168.0.4//h264Preview_01_main"

gst_pipeline_in = f"rtspsrc location={RTSPURL} ! application/x-rtp,media=video ! rtph264depay ! avdec_h264 ! videoconvert ! {INPUT_CAPS} ! appsink"

dest_ip='10.80.14.144'
dest_port=554
# max-size-buffers=4
gst_pipeline_out = f"appsrc ! queue ! videoconvert ! nvvideoconvert ! nvv4l2h264enc ! video/x-h264, stream-format=byte-stream ! h264parse ! rtph264pay pt=96 config-interval=1 ! udpsink host={dest_ip} port={dest_port}"

# cap = cv2.VideoCapture(RTSPURL)
cap = cv2.VideoCapture(gst_pipeline_in)

fourcc = cv2.VideoWriter_fourcc(*'X264')
out = cv2.VideoWriter(gst_pipeline_out, fourcc, 25, (INPUT_W, INPUT_H), True) #, cv2.CAP_GSTREAMER, fourcc, 25, (INPUT_W,INPUT_H))


if not cap.isOpened():
    print('cap cant open for some reason')
    exit(1)

if not out.isOpened():
    print('out cant open for some reason')
    exit(1)


print('looping ')
while cap.isOpened():
    # print('attempting to read...')
    ret, frame = cap.read()
    # if ret:
        # cv2.imshow('VIDEO', frame)
    if out.isOpened():
        out.write(frame)
        print('writing frame')
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
    # else:
        # print('nothing...')
        # break

# Release everything if job is finished
cap.release()
out.release()