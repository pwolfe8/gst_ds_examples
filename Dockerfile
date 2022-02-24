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
RUN apt update && apt install -y graphviz curl
#copy in debug tools
COPY helper_scripts/dot2graph.sh /usr/local/bin/dot2graph
COPY helper_scripts/gstGraph.sh /usr/local/bin/gstGraph


# copy in custom starting script & service files
COPY helper_scripts/custom_starting_script.sh /usr/local/bin/
COPY helper_scripts/example_service.py /usr/local/bin/
COPY helper_scripts/sysv_example /etc/init.d/sysv_example

# install ip scanner & prereqs
# RUN apt update && \
#   apt install -y \
#   openjdk-8-jdk wget openjdk-8-jre gdebi
# RUN wget https://github.com/angryip/ipscan/releases/download/3.7.6/ipscan_3.7.6_all.deb && \
#   gdebi -n ipscan_3.7.6_all.deb

### setup custom python environment ####
# # copy in reqs file
# COPY requirements.txt /root/python_reqs/
# # upgrade pip install the right version of numpy to fix problems with matplotlib install
# RUN  python3 -m pip install --upgrade pip && \
#   python3 -m pip install numpy==1.19.4 cython 
# # then do matplotlib install since it takes the longest
# RUN python3 -m pip install matplotlib==3.3.4
# # then install requirements file
# RUN cd /root/python_reqs && \
#   python3 -m pip install -r requirements.txt

# setup non root user nvidia (password nvidia). may need to run things some things with root still. (like pose)
RUN apt install -y sudo && \
  useradd -m nvidia && echo "nvidia:nvidia" | chpasswd && adduser nvidia sudo

# If allow SSH then perform these actions. (disabled by default)
ARG ENABLE_SSH
RUN if [ "$ENABLE_SSH" = true ]; then \
  sed -i 's/\(^Port\)/#\1/' /etc/ssh/sshd_config && \
  echo Port 1022 >> /etc/ssh/sshd_config && \
  mkdir -p /home/nvidia/.ssh && \
  chown -R nvidia:nvidia /home/nvidia/.ssh; \
  fi;
