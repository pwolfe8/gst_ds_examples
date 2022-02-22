#!/usr/bin/python3
import time

import threading
import socketserver


class MyMultiportUdpListener:
    def __init__(self, portlist):
        self.portlist = portlist
        self.start_listeners()

    def start_udpserv(self, port):
        self.MySinglePortListener(('127.0.0.1', port), self)

    def start_listeners(self):
        # create threads to listen on each port
        self.threads = [
            threading.Thread(target=self.start_udpserv, args=(p, ))
            for p in self.portlist
        ]

        # start them
        print('starting threads...')
        for t in self.threads:
            t.daemon = True  # non blocking
            t.start()

    def multiport_callback(self, data, server_address):
        print(f'got some data {data} from {server_address}\n')
        # store it, etc do as you wish

    class MySinglePortListener(socketserver.ThreadingUDPServer):
        class MyUDPHandler(socketserver.BaseRequestHandler):
            def handle(self):
                data = self.request[0].strip()
                socket = self.request[1]
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
            socketserver.ThreadingUDPServer.allow_reuse_address = 1

            # instantiate server
            socketserver.ThreadingUDPServer.__init__(self, server_address,
                                                     self.MyUDPHandler)

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
    MyMultiportUdpListener(portlist=ports)

    # stay active until ctrl+c input
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print('exiting now...')
