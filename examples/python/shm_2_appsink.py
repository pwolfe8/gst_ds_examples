#!/usr/bin/python3

import cv2
import gi
import numpy as np

import time

gi.require_version('Gst', '1.0')
from gi.repository import Gst

class GstVideo():
    """shared memory (rgb) to Appsink example. run examples/bash/rtspsrc2shm.sh first
    """

    def __init__(self, devnum=0):
        Gst.init(None)

        self.new_frame_flag = False

        self.devnum = devnum
        self._frame = None

        # video source element
        video_source = "shmsrc socket-path=/tmp/shm_sock_69 is-live=true do-timestamp=true"
        
        # input video capabilities choice (match rtspsrc2shm.sh output for now)
        input_caps = "! video/x-raw,format=RGB,width=1920,height=1080,framerate=20/1"

        # appsink config
        appsink_config = '! appsink emit-signals=true sync=false max-buffers=2 drop=true'
                
        # appsink empty for now
        self.video_sink = None

        # video pipeline class variable
        self.video_pipe = None
        
        # assemble pipeline list (connected to appsink at end)
        pipeline_list = [video_source, input_caps, appsink_config]
        self.run(pipeline_list)

    def start_gst(self, config=None):
        """ Start gstreamer pipeline and sink
        Pipeline description list e.g:
            [
                'videotestsrc ! decodebin', \
                '! videoconvert ! video/x-raw,format=(string)BGR ! videoconvert',
                '! appsink'
            ]
        Args:
            config (list, optional): Gstreamer pileline description list
        """

        if not config:
            config = \
                [
                    'videotestsrc ! decodebin',
                    '! videoconvert ! video/x-raw,format=(string)BGR ! videoconvert',
                    '! appsink'
                ]

        command = ' '.join(config)
        print(f'gst pipeline: {command}')
        self.video_pipe = Gst.parse_launch(command)
        self.video_pipe.set_state(Gst.State.PLAYING)
        self.video_sink = self.video_pipe.get_by_name('appsink0')

    @staticmethod
    def gst_to_opencv(sample):
        """Transform byte array into np array
        Args:
            sample (TYPE): Description
        Returns:
            TYPE: Description
        """
        buf = sample.get_buffer()
        caps = sample.get_caps()
        array = np.ndarray(
            (
                caps.get_structure(0).get_value('height'),
                caps.get_structure(0).get_value('width'),
                3
            ),
            buffer=buf.extract_dup(0, buf.get_size()), dtype=np.uint8)
        return array

    def get_frame(self):
        """ Get Frame
        Returns:
            iterable: bool and image frame, cap.read() output
        """
        self.new_frame_flag = False
        return self._frame

    def frame_available(self):
        """Check if frame is available
        Returns:
            bool: true if frame is available
        """
        return self.new_frame_flag and (type(self._frame) != type(None))

    def run(self, pipeline_list=None):
        """ Get frame to update _frame
         Args:
            pipeline_list (list, optional): Gstreamer pileline description list
        """

        self.start_gst(pipeline_list)
        # self.start_gst(
        #     [
        #         self.video_source,
        #         self.video_codec,
        #         self.video_decode,
        #         self.video_sink_conf
        #     ])

        self.video_sink.connect('new-sample', self.callback)

    def callback(self, sink):
        sample = sink.emit('pull-sample')
        new_frame = self.gst_to_opencv(sample)
        self._frame = new_frame
        self.new_frame_flag = True

        return Gst.FlowReturn.OK


if __name__ == '__main__':
    # Create the GstVideo object
    # Add devnum= if is necessary to use a different one    
    video = GstVideo()

    # fps measure init
    last_sample_time = time.perf_counter()
    FPS_measure_period_s = 4
    FPS_measure_counter = 0

    while True:
        # Wait for the next frame
        if not video.frame_available():
            continue

        # already converted by class from gst buffer to numpy array in callback
        frame = video.get_frame()
        
        # fps period avg measurement over period
        next_time = time.perf_counter()
        FPS_measure_counter += 1
        elapsed_time = next_time - last_sample_time
        if elapsed_time > FPS_measure_period_s:
          print(f'FPS: { FPS_measure_counter / elapsed_time}')
          last_sample_time = next_time
          FPS_measure_counter = 0

        ## do stuff here... example opencv show frame
        # print(frame.shape)
        # cv2.imshow('frame', frame)
        # if cv2.waitKey(1) & 0xFF == ord('q'):
        #     break