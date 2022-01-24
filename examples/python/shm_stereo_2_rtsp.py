#!/usr/bin/python3

# first run examples/bash/csi_stereo_2_shm.sh

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
    src_caps = "video/x-raw,format=GRAY8,width=3200,height=1300,framerate=20/1"
    scale_down_and_reduce_rate = "videorate ! video/x-raw,framerate=4/1 ! videoscale ! video/x-raw,width=800,height=325"
    convert2stream = "videoconvert ! video/x-raw,format=I420"
    vid_encParsePacketize_h265 = "omxh265enc insert-vui=1 ! h265parse ! rtph265pay name=pay0 pt=96"
    shm_h265_pipeline = f"{src} ! {src_caps} ! {convert2stream} ! {vid_encParsePacketize_h265}"
    shm_h265_pipeline_reduced = f"{src} ! {src_caps} ! {scale_down_and_reduce_rate} ! {convert2stream} ! {vid_encParsePacketize_h265}"

    REDUCE_STREAM_SIZE_AND_FPS = True
    if REDUCE_STREAM_SIZE_AND_FPS:
      pipeline_str = f"( {shm_h265_pipeline_reduced} ) "
    else:
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
    self.mountpoint = "test"
    m.add_factory(f"/{self.mountpoint}", f)
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