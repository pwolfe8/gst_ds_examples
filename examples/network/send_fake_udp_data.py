#!/usr/bin/python3
import socket
import time
import numpy as np
import struct

verbose = False

destination_ip_port = ('127.0.0.1', 6942)


def send_message(msg_bytes):
    # if not hasattr(send_message, 'cnt'):
        # send_message.cnt = 0
        # send_message.sock = socket.socket(socket.AF_INET,  # Internet
        #                  socket.SOCK_DGRAM)  # UDP
        # send_message.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    # msg_bytes = msg.encode('utf-8')
    # if verbose:
    #     print(
    #         f'sending {msg_bytes} to destination {destination_ip_port[0]}:{destination_ip_port[1]}')
    # else:
    #     print(".", end='', flush=True)
    # send_message.cnt += 1
    # if send_message.cnt == 69: # line width
        # send_message.cnt = 0
        # print('')
    send_message.sock.sendto(msg_bytes, destination_ip_port)


def pack_and_send_msg(new_vel_fb_p_val):
    msg = {}
    msg['vel_ref_y'] = 0
    msg['vel_fb_y'] = 0
    msg['vel_out_torq_y'] = 0
    msg['vel_ref_p'] = 0
    msg['vel_fb_p'] = new_vel_fb_p_val
    msg['vel_out_torq_p'] = 0
    msg['pos_err_y'] = 0
    msg['pos_out_vel_y'] = 0
    msg['pos_err_p'] = 0
    msg['pos_out_vel_p'] = 0
    msg['track_err_y'] = 0
    msg['track_err_p'] = 0
    sendbytes = struct.pack('<BBBBffffffffffff',
                            0x20, 0, 0, 0,
                            msg['vel_ref_y'],
                            msg['vel_fb_y'],
                            msg['vel_out_torq_y'],
                            msg['vel_ref_p'],
                            msg['vel_fb_p'],
                            msg['vel_out_torq_p'],
                            msg['pos_err_y'],
                            msg['pos_out_vel_y'],
                            msg['pos_err_p'],
                            msg['pos_out_vel_p'],
                            msg['track_err_y'],
                            msg['track_err_p'],)
    send_message(sendbytes)


def send_next_sinewave_val():

    samp_period = 0.01

    if not hasattr(send_next_sinewave_val, 'idx'):
        send_next_sinewave_val.idx = 0
        f_Hz = 10
        cycles_in_table = 10000
        sine_period_s = cycles_in_table * 1 / f_Hz
        
        tt = np.arange(0, sine_period_s + samp_period, samp_period)  # 1 sec sine wave

        # send_next_sinewave_val.sintable = np.sin(2*np.pi * f_Hz * tt)
        send_next_sinewave_val.sintable = 0.7 * np.sin(2 * np.pi * 0.5 * f_Hz * tt) + 1.75 * np.sin(2 * np.pi * f_Hz * tt) + 1.0*np.sin(2 * np.pi * 1.5*f_Hz * tt) 
        

        send_next_sinewave_val.table_len = len(tt)

    # send_next_sinewave_val at idx
    pack_and_send_msg(
        send_next_sinewave_val.sintable[send_next_sinewave_val.idx])

    # increment idx
    send_next_sinewave_val.idx += 1
    if send_next_sinewave_val.idx >= send_next_sinewave_val.table_len:
        send_next_sinewave_val.idx = 0

    # sleep at rate
    time.sleep(samp_period)


if __name__ == '__main__':

    # init send message vars
    send_message.cnt = 0
    send_message.sock = socket.socket(socket.AF_INET,  # Internet
                        socket.SOCK_DGRAM)  # UDP
    send_message.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    print('\nsending fake data pts now')
    try:
        while True:
            send_next_sinewave_val()
    except KeyboardInterrupt:
        print('\nending fake data stream now...')
    
    # close socket
    send_message.sock.close()

