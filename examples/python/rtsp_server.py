#!/usr/bin/python3

# rtsp server example
import sys

import gi
gi.require_version('Gst', '1.0')
gi.require_version('GstRtspServer', '1.0')
from gi.repository import Gst, GstRtspServer, GObject

loop = GObject.MainLoop()
GObject.threads_init()
Gst.init(None)

class MyFactory(GstRtspServer.RTSPMediaFactory):
  def __init__(self):
    GstRtspServer.RTSPMediaFactory.__init__(self)

  def do_create_element(self, url):

    testsrc = "videotestsrc ! video/x-raw,rate=30,width=320,height=240,format=I420"
    rtspsrc = "rtspsrc location=rtsp://testuser:testpwd@10.160.41.21/live" \
              " ! rtph264depay ! avdec_h264 ! videoconvert" \
              " ! video/x-raw,format=I420,width=1920,height=1080,framerate=20/1"
    h264 = "x264enc tune=zerolatency"
    h264_hw = "omxh264enc insert-vui=1 ! h264parse ! rtph264pay name=pay0 pt=96"
    h265_hw = "omxh265enc insert-vui=1 ! h265parse ! rtph265pay name=pay0 pt=96"

    test_pipeline = f"{testsrc} ! {h264_hw}"
    rtsp_pipeline = f"{rtspsrc} ! {h265_hw}"

    pipeline_str = f"( {rtsp_pipeline} ) "

    if len(sys.argv) > 1:
      pipeline_str = " ".join(sys.argv[1:])
    print(pipeline_str)
    return Gst.parse_launch(pipeline_str)

class GstServer():
  def __init__(self):
    self.server = GstRtspServer.RTSPServer()
    f = MyFactory()
    f.set_shared(True)
    m = self.server.get_mount_points()
    self.mountpoint="test"
    m.add_factory(f'/{self.mountpoint}', f)
    self.server.attach(None)
    
    local_ip = self.get_ip_addr()
    print(f'now serving at rtsp://{local_ip}:8554/{self.mountpoint}')

  def get_ip_addr(self):
    # may not work inside docker container
    import socket
    return socket.gethostbyname(socket.gethostname())


if __name__ == '__main__':
  s = GstServer()
  loop.run()