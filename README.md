# gst_ds_env
My gstreamer deepstream container image setup repo.

If you're wanting to use this go to https://github.com/pwolfe8/gst_ds_examples

## Install Prereqs on Host

### Jetson
run the `./host_setup/first_time_setup.sh` script

### Desktop
Assuming you have a Ubuntu 20.04 Desktop (or 18.04 probably) with an NVIDIA GPU.
Install the recommended nvidia drivers for you GPU using `./host_setup/desktop_scripts/install_nvidia_drivers_desktop.sh` 

Then reboot your machine with `sudo reboot`

Now run the `./host_setup/first_time_setup.sh` script

## Using the Container
```bash
# automatically detect host architecture and if nvidia-docker2 packages is installed
# if you want to override you can do 
#   `./build.sh jetson_nogpu`  for example (other options: jetson, desktop, desktop_nogpu)
./build.sh

# start the container
./run.sh

# attach current shell to container. you can also right click container in the docker extension and attach shell or another vscode window
./attach.sh

# for cleanup you can remove it with
./remove.sh

# forgot to map /dev/video0 into the container in the docker-compose.yaml? No problem just change it there
# then run
./deleteRebuildRestart.sh 
# and attach again however you like
```

## Docker Options

### Use Local Display
If you're plugged into the device via HDMI and want to display locally then run 

`xhost +local:docker`

and make sure the container has the same DISPLAY environment variable as your local host
(i.e. `echo $DISPLAY` on your local host. then in your container set it to the same with `export DISPLAY=WhateverTheFuckCameOutOfYourLocalHost`)

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

in addition to the `examples` folder here, 

C Examples: 
- `/opt/nvidia/deepstream/deepstream-6.0/sources/apps/sample_apps/`

Python Exmaples: 
- `/opt/nvidia/deepstream/deepstream-6.0/sources/sources/deepstream_python_apps/apps/`
