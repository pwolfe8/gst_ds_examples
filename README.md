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
```
## Examples paths
