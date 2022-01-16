# gst_ds_env
My gstreamer deepstream container image setup repo.

If you're wanting to use this go to https://github.com/pwolfe8/gst_ds_examples

## Host Prereq Installs
see `setup_host` folder

## Build Options
```bash
# automatically detect host architecture and if nvidia-docker2 packages is installed
./build.sh

# override build choice:
./build.sh jetson # other options include jetson_nogpu, desktop, desktop_nogpu
```