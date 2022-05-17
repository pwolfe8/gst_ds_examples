#!/usr/bin/python3
import time

import threading
import socketserver
import struct
from StandardMessages import StandardMessages

import code

class MultiportTcpListener:
    def __init__(self, portlist, verbose=False):
        self.verbose = verbose
        self.portlist = portlist
        self.start_listeners()

    def start_server(self, port):
        self.SinglePortListener(('127.0.0.1', port), self)

    def start_listeners(self):
        # create threads sto listen on each port
        self.threads = [
            threading.Thread(target=self.start_server, args=(p, ))
            for p in self.portlist
        ]

        # start them
        if self.verbose:
            print('starting threads...')
        for t in self.threads:
            t.daemon = True  # non blocking
            t.start()

    def multiport_callback(self, data, server_address):
        print(f'got some data {data} from {server_address}\n')
        # store it, unpack, etc do as you wish
        print(StandardMessages.unpack_bbox_msg(data))
        
        

    class SinglePortListener(socketserver.ThreadingTCPServer):
        class RequestHandler(socketserver.BaseRequestHandler):
            def handle(self):

                # assumes first 4 bytes designate length of message 
                # (packed as network endian unsigned int)
                length_bytes = self.request.recv(4)
                length = struct.unpack('!I', length_bytes)[0]                
                
                print(f'decoded length of message to be {length} bytes')

                data = self.request.recv(length)

                # variables = globals().copy()
                # variables.update(locals())
                # shell = code.InteractiveConsole(variables)
                # shell.interact()

                # socket = self.request.getsockname()
                # print(
                #     f'client {self.client_address}\n\twrote {data}\n\tto {self.server.server_address}'
                # )

                # send back message in uppercase as confirmation (comment out if not needed)
                # socket.sendto(data.upper(), self.client_address)

                # call server callback function with data
                self.server.single_port_callback(data)

        def __init__(self, server_address, multiport_listener):
            # store reference to parent class
            self.multiport_listener = multiport_listener

            # turn on allow reuse ports
            socketserver.ThreadingTCPServer.allow_reuse_address = 1

            # instantiate server
            socketserver.ThreadingTCPServer.__init__(self, server_address,
                                                     self.RequestHandler)

            # now serve forever
            print(f'now listening on {self.server_address}')
            self.serve_forever()

        def single_port_callback(self, data):
            # do something single port wise if you want here...
            # otherwise pass data to higher server
            self.multiport_listener.multiport_callback(data,
                                                       self.server_address)


if __name__ == '__main__':
    # ports to listen to
    ports = [6941, 6942, 6943]

    # listen
    MultiportTcpListener(portlist=ports)

    # stay active until ctrl+c input
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print('exiting now...')
