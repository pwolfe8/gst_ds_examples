ARG FROM_IMG
ARG BUILD_ENV=normal

#### non gpu normal build starting point ####
FROM $FROM_IMG as build_normal
ONBUILD RUN echo "normal build"

#### nvidia build starting point ####
FROM ${FROM_IMG} as build_nvidia
ONBUILD RUN echo "nvidia build"
# copy into (even though mapped later to host folder) so you can run make
ONBUILD COPY sub_projects/deepstream_pose_estimation /opt/nvidia/deepstream/deepstream-6.0/sources/apps/sample_apps/deepstream_pose_estimation
ONBUILD RUN cd /opt/nvidia/deepstream/deepstream-6.0/sources/apps/sample_apps/deepstream_pose_estimation &&\
  make && make install

# shared layers based off chosen starting point
FROM build_${BUILD_ENV}
RUN apt update && apt install -y graphviz

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
