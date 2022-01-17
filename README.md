# Gstreamer Deepstream Examples
My gstreamer and deepstream examples container based on my dockerhub image gst_ds_env


## Install Prereqs on Host
  
- Note: you may have to reboot a few times

### Jetson
First ensure you're on L4T 32.6.X (`cat /etc/nv_tegra_release` and check REVISION for 6.0 or greater).  

Then run 

```bash
cd host_setup
./first_time_setup.sh
# reboot afterwards
```

### Desktop
Assuming you have a Ubuntu 20.04 Desktop (or 18.04 probably) with an NVIDIA GPU.

Install the recommended nvidia drivers for you GPU using 
```bash
./host_setup/desktop_scripts/install_nvidia_drivers_desktop.sh
# reboot afterwards 
sudo reboot
```

Now run the first time setup script:
```bash
cd host_setup
./first_time_setup.sh
# reboot afterwards 
sudo reboot
```

## Using the Container
```bash
# automatically detect host architecture and nvidia-docker2 package installation
# manual override options:
#   ./build.sh jetson_nogpu  # for example
#    other options: jetson, desktop, desktop_nogpu
# automatic is best for most users:
./build.sh

# start the container
./run.sh

# attach current shell to container.
# you can also install vscode docker extension 
#   then click on extension, right click container and attach vscode window
./attach.sh

# for cleanup you can remove it with
./remove.sh

# forgot to map /dev/video0 into the container in the docker-compose.yaml? 
# No problem just make changes in the file then run 
./deleteRebuildRestart.sh 
# and attach again however you like
```

## Docker Options

### Use Local Display
If you're plugged into the device via HDMI and want to display locally then run on your host:

`xhost +local:docker`

and make sure the container has the same DISPLAY environment variable as your local host
(i.e. `echo $DISPLAY` on your local host. then in your container set it to the same with `export DISPLAY=WhateverTheFuckCameOutOfYourLocalHost`)

You can now test this out by typing xeyes in the docker container. ( you should see graphics of eyes that follow your mouse now )

## Using /dev/video0 
in the docker-compose.yaml under `volumes` make sure to have these uncommented:
 - `- /dev/video0:/dev/video0`
 - `- /tmp/argus_socket:/tmp/argus_socket`

also you may need to be priveleged to access the device too so uncomment

- `priveleged: true` 

now run `./deleteRebuildRestart.sh`



## Examples 

If you have `nvidia-docker2` package and GPU installed on your host you should be able to access these examples under 
- `/opt/nvidia/deepstream/deepstream-6.0/sources/apps/sample_apps/`

### C Examples: 
- `/opt/nvidia/deepstream/deepstream-6.0/sources/apps/sample_apps/`

### Python Exmaples: 
- `/opt/nvidia/deepstream/deepstream-6.0/sources/sources/deepstream_python_apps/apps/`

###  Building Other Deepstream in container (Pose Estimation)

First follow the instructions from the "Use Local Display" section above.
Now in the container go to 

`/opt/nvidia/deepstream/deepstream-6.0/sources/apps/sample_apps/deepstream_pose_estimation` 

and run

`./run.sh`  

(ctrl+c to quit)