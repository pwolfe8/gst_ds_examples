#!/bin/bash
DATESTR=`date +'%d_%M_%Y'`
docker save pwolfe854/gst_ds_examples:aarch64_nogpu | gzip > backup_img_${DATESTR}.tar.gz
