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

# copy in custom starting script & service files
COPY helper_scripts/custom_starting_script.sh /usr/local/bin/
COPY helper_scripts/example_service.py /usr/local/bin/
COPY helper_scripts/sysv_example /etc/init.d/sysv_example


# ssh port change to 1022 & allow root login no pwd
RUN sed -i 's/\(^Port\)/#\1/' /etc/ssh/sshd_config && echo Port 1022 >> /etc/ssh/sshd_config
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config


# install ip scanner & prereqs
# RUN apt update && \
#   apt install -y \
#   openjdk-8-jdk wget openjdk-8-jre gdebi
# RUN wget https://github.com/angryip/ipscan/releases/download/3.7.6/ipscan_3.7.6_all.deb && \
#   gdebi -n ipscan_3.7.6_all.deb

# setup non root user nvidia (password nvidia) for ssh access
RUN apt install -y sudo && \
  useradd -m nvidia && echo "nvidia:nvidia" | chpasswd && adduser nvidia sudo
RUN mkdir -p /home/nvidia/.ssh && chown -R nvidia:nvidia /home/nvidia/.ssh 

### uncomment USER command if you want default user to  be nvidia 
### but wouldn't do that cuz then you have to type passwords into your starting script whenever you use sudo.
### otherwise they wont work
# USER nvidia

COPY requirements.txt /home/nvidia/python_reqs/
RUN  python3 -m pip install --upgrade pip && \
  pip3 install setuptools 
# USER nvidia 
#   cd /home/nvidia/python_reqs && \
#   pip3 install -r requirements.txt

