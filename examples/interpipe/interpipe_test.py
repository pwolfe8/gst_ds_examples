import time
from pygstc.gstc import *
from pygstc.logger import *

FPS = 15
cam_src_pipeline = \
  f"v4l2src device=/dev/video0 " \
  f"! video/x-raw,format=GRAY8,width=3200,height=1300,framerate={FPS*2}/1 " \
  f"! interpipesink name=srcpipe1 " 

# Create a custom logger that logs into stdout, named pygstc_example, with debug level DEBUG
gstd_logger = CustomLogger('pygstc_example', loglevel='DEBUG')

# Create the client and pass the logger as a parameter
gstd_client = GstdClient(logger=gstd_logger)
gstd_client.pipeline_create('camsrc', cam_src_pipeline)
gstd_client.pipeline_play('camsrc')

# Wait for the pipeline to change state
time.sleep(0.1)

# This should print 'PLAYING'
print(gstd_client.read('pipelines/camsrc/state')['value'])


gstd_client.pipeline_stop('camsrc')
gstd_client.pipeline_delete('camsrc')