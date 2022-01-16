#!/bin/bash

# install ridgerun's interpipe gstreamer element
sudo apt install -y unzip libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gtk-doc-tools
git clone --recurse-submodules https://github.com/RidgeRun/gst-interpipe && cd gst-interpipe && \
  ./autogen.sh --libdir /usr/lib/aarch64-linux-gnu/ && \
  make && make check
sudo make install

# install ridgerun's gstreamer daemon 
sudo apt install -y \
  automake libtool pkg-config libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
  libglib2.0-dev libjson-glib-dev gtk-doc-tools libreadline-dev libncursesw5-dev \
  libdaemon-dev libjansson-dev libsoup2.4-dev python3-pip sudo
git clone https://github.com/RidgeRun/gstd-1.x && cd gstd-1.x && \
  ./autogen.sh && ./configure && make
sudo make install