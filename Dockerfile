ARG FROM_IMG
FROM $FROM_IMG

# install prereqs & network packages
RUN apt update && apt install -y \
    git \
    vim \
    rsync \
    x11-apps \ 
    v4l-utils \
    iputils-ping \
    net-tools \
    nmap \
    samba-common-bin \
    arp-scan \
    openssh-server

# install gstreamer 1.0 if needed
ARG GPU_ARG
RUN \
  if [ "$GPU_ARG" = nvidia ] ; then \
    echo "gstreamer already installed. skipping..."; \
  else \ 
    DEBIAN_FRONTEND=noninteractive apt install -y \
      libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
      libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base \
      gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly \
      gstreamer1.0-libav gstreamer1.0-doc gstreamer1.0-tools gstreamer1.0-x \
      gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio; \
  fi;

# gstreamer rtsp & dev packages + python bindings/prereqs
RUN apt install -y \
  libgstreamer-plugins-base1.0-dev \
  libjson-glib-dev \
  libgstreamer1.0-dev \
  gobject-introspection \
  libgstrtspserver-1.0-0 \
  gstreamer1.0-rtsp \
  libgirepository1.0-dev \
  gir1.2-gst-rtsp-server-1.0 \
  python3-gi \
  python3-dev \
  python3-gst-1.0 \
  python3-pip \
  python3-opencv \
  python3-numpy 

# install ridgerun's interpipe gstreamer element & gstreamer daemon
ARG ARCH
RUN apt install -y gtk-doc-tools automake libtool pkg-config \
    libglib2.0-dev libreadline-dev libncursesw5-dev \
    libdaemon-dev libjansson-dev libsoup2.4-dev sudo && \
    git config --global http.sslverify false && \
  cd /root/ && git clone --recurse-submodules https://github.com/RidgeRun/gst-interpipe && cd gst-interpipe && \
    ./autogen.sh --libdir /usr/lib/${ARCH}-linux-gnu/ && \
    make && make check && make install && \
  cd /root/ && git clone https://github.com/RidgeRun/gstd-1.x && cd gstd-1.x && \
    ./autogen.sh && ./configure && make && make install && \
  cd /root/ && rm -rf gst-interpipe gstd-1.x

# install deepstream python bindings for appropriate architecture if needed
RUN \
  if [ "$GPU_ARG" = nvidia ] ; then \
    cd /opt/nvidia/deepstream/deepstream-6.0/sources && \
    git clone https://github.com/NVIDIA-AI-IOT/deepstream_python_apps && \
    wget https://github.com/NVIDIA-AI-IOT/deepstream_python_apps/releases/download/v1.1.0/pyds-1.1.0-py3-none-linux_${ARCH}.whl && \
    pip3 install pyds-*-py3-none-linux_${ARCH}.whl && \
    rm pyds-*-py3-none-linux_${ARCH}.whl; \
  else \
    echo "nongpu build. skipping deepstream python bindings..."; \
  fi;

# install ip scanner & prereqs
# RUN apt update && \
#   apt install -y \
#   openjdk-8-jdk wget openjdk-8-jre gdebi
# RUN wget https://github.com/angryip/ipscan/releases/download/3.7.6/ipscan_3.7.6_all.deb && \
#   gdebi -n ipscan_3.7.6_all.deb

# setup non root user nvidia (password nvidia)
# RUN apt install -y sudo && \
#   useradd -m nvidia && echo "nvidia:nvidia" | chpasswd && adduser nvidia sudo
# RUN mkdir -p /home/nvidia/.ssh && chown -R nvidia:nvidia /home/nvidia/.ssh 
# USER nvidia