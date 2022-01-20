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
    src = "shmsrc socket-path=/tmp/shm_sock_69 is-live=true do-timestamp=true"
    src_caps = "video/x-raw,format=RGB,width=3200,height=1300,framerate=20/1"
    convert2stream = "videoconvert ! video/x-raw,format=I420"
    vid_encParsePacketize_h265 = "omxh265enc ! h265parse ! rtph265pay name=pay0 pt=96"
    shm_h265_pipeline = f"{src} ! {src_caps} ! {convert2stream} ! {vid_encParsePacketize_h265}"

    pipeline_str = f"( {shm_h265_pipeline} ) "

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
    m.add_factory("/rgb", f)
    self.server.attach(None)

if __name__ == '__main__':
  s = GstServer()
  loop.run()