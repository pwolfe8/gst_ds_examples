import socket
import struct

class TcpSender:
    def __init__(self, host_ip, port, verbose=False) -> None:
        # create socket
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # connect
        self.sock.connect((host_ip, port))
        self.verbose = verbose

    def send(self, msg_bytes):
        msg_bytes_with_len = struct.pack('!I', len(msg_bytes)) + msg_bytes
        self.sock.sendall(msg_bytes_with_len)
        if self.verbose:
            print(f'sent: {msg_bytes} with length {len(msg_bytes)} in front (unsigned int)')
            print(f'\tfull message: {msg_bytes_with_len}')

if __name__=='__main__':
    import time
    from StandardMessages import StandardMessages

    # create test message data with epoch timestamp
    ts = time.time() # use double not float
    data = [[42, 0.2, 0.21, 0.4, 0.42], [69, 0.2, 0.21, 0.4, 0.42]] # [id, tl_x, tl_y, br_x, br_y]
    msg_bytes = StandardMessages.pack_bbox_msg(ts, data)



    sender = TcpSender('127.0.0.1', 6943)
    sender.send(msg_bytes)