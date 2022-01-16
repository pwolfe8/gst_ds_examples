#!/usr/bin/python3

import gi
gi.require_version('Gst', '1.0')
gi.require_version('GstRtspServer', '1.0')
from gi.repository import Gst, GstRtspServer, GObject

loop = GObject.MainLoop()
GObject.threads_init()
Gst.init(None)


if __name__=='__main__':
  # pipeline string elements here
  FPS = 4
  pipename='srcpipe2'
  l_camsrc = f"v4l2src device=/dev/video0 ! video/x-raw,format=GRAY8,width=3200,height=1300,framerate={FPS*2}/1"
  l_vidconv = "videoconvert ! video/x-raw,format=I420"
  l_interpipesink = "interpipesink name={pipename} max-lateness=250000000 max-buffers=2" 
  l_interpipesrc = "interpipesrc listen-to={pipename} is-live=true max-bytes=100000 ! video/x-raw,format=I420"
  l_queue = "queue max-size-buffers=1 name=q_enc"
  l_enc_gpu_h265 = "omxh265enc ! h265parse"
  l_packetize_h265 = "rtph265pay name=pay0 pt=96"
  
  l_srcbin = f"{l_camsrc} ! {l_vidconv} ! {l_queue}"
  # create primary camera source pipeline string
  
  p_interpipesink = f"{l_srcbin} ! {l_interpipesink}"
  print(p_interpipesink)
  pipeline = Gst.parse_launch(p_interpipesink)
  pipeline.set_state(Gst.State.PLAYING)

  # create rtsp sink pipeline string
  p_stereocam_h265 = f"{l_srcbin} ! {l_enc_gpu_h265} ! {l_packetize_h265}"
  p_interpipesrc = f"{l_interpipesrc} ! {l_enc_gpu_h265} ! {l_packetize_h265}"
  

  # rtsp_sink_pipeline_str = f"{l_interpipesrc} ! {l_vidconv} ! {l_enc_gpu_h265} ! {l_packetize_h265}"
  rtsp_sink_pipeline_str = p_interpipesrc
      

  # Start streaming
  rtsp_port_num = 8554

  server = GstRtspServer.RTSPServer.new()
  server.props.service = f"{rtsp_port_num}"
  server.attach(None)

  factory = GstRtspServer.RTSPMediaFactory.new()
  factory.set_launch( f"( {rtsp_sink_pipeline_str} )" )
  factory.set_shared(True)
  server.get_mount_points().add_factory("/rgb", factory)
  print(f"\n*** Launched RTSP Streaming at rtsp://localhost:{rtsp_port_num}/rgb ***\n\n")


  # try run loop and handle ctrl+c gracefully 
  try:
    loop.run()
  except:
    pass

  # cleanup
  pipeline.set_state(Gst.State.NULL)


