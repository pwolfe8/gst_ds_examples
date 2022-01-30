#!/usr/bin/python3

# import socket
import threading
import socketserver



class MyUDPHandler(socketserver.BaseRequestHandler):
    def handle(self):
        data = self.request[0].strip()
        socket = self.request[1]
        print(f'{self.client_address} wrote {data} to {self.server.server_address}')

        # send back message in uppercase as confirmation (comment out if not needed)
        socket.sendto(data.upper(), self.client_address)

def start_udpserv(port=6969):
  with socketserver.UDPServer(('127.0.0.1', port), MyUDPHandler) as server:
    print(f'now listening on {server.server_address}')
    server.serve_forever()

# create udp server for each port in port_list
port_list = [8080, 8081]
threads = [threading.Thread(target=start_udpserv, args=(p,)) for p in port_list]

# start threads to listen
print(f"running port listening on threads:\n\t{port_list}\n")
for t in threads:
  t.start()
