import struct
import time
from datetime import datetime


class StandardMessages:
    def __init__(self) -> None:
        pass

    @staticmethod
    def unpack_timestamp(msg_bytes):
        return struct.unpack('! d', msg_bytes[:8])

    @staticmethod
    def pack_bbox_msg(timestamp, bbox_list):
        # bbox_list format (1 frame):
        # [ [id, tl_x, tl_y, bl_x, bl_y], [id, tl_x, tl_y, bl_x, bl_y], ...]
        msg_bytes = struct.pack('! d I', timestamp, len(bbox_list))
        for bbox in bbox_list:
            # 5 elements per box
            msg_bytes += struct.pack('! 5f', *bbox) 
        return msg_bytes
    
    @staticmethod
    def unpack_bbox_msg(msg_bytes):
        # bbox_list format (1 frame):
        # [ [id, tl_x, tl_y, bl_x, bl_y], [id, tl_x, tl_y, bl_x, bl_y], ...]
        pass
        # unpack timestamp and number of boxes from first 12 bytes
        timestamp, num_boxes = struct.unpack('! d I', msg_bytes[:12])
        idx = 12
        boxes = []
        for i in range(num_boxes):
            box = struct.unpack('!5f', msg_bytes[idx:idx+5*4])
            boxes.append(box)
            idx += 5*4
        return timestamp, boxes