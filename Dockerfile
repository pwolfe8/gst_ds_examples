ARG FROM_IMG
FROM $FROM_IMG

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

# deepstream_pose example & example of how to integrate a git repo into your gst_ds dockerfile
ARG GPU_ARG
ARG SSH_DEV
ARG POSE_REPO
ARG POSE_REPO_SSH
ARG POSE_REPO_FOLDER_NAME
RUN \
  if [ "$GPU_ARG" = nvidia ] ; then \
    cd /opt/nvidia/deepstream/deepstream-6.0/sources/apps/sample_apps/ && \
    git clone ${POSE_REPO} && cd ${POSE_REPO_FOLDER_NAME} && make && make install; \
    if [ "$SSH_DEV" = true ]; then \
      git remote set-url origin ${POSE_REPO_SSH}; \ 
    fi; \
  else \ 
    echo "not gpu container. skipping deepstream pose example..."; \
  fi;
RUN apt update && apt install -y graphviz