#!/bin/bash
INPUT_TAR_GZ_FILE=${1}
if [ -z "$INPUT_TAR_GZ_FILE" ]; then
echo "please provide name backup image tar.gz file as input argument to this script"
exit
fi

echo "now loading $INPUT_TAR_GZ_FILE..."

docker load < $INPUT_TAR_GZ_FILE