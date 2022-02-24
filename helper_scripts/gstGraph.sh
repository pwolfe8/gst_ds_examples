#!/bin/bash
GST_CMD=$1
DIRECTORY_NAME=${2:-debug_graphs}
DEBUG_LVL=${3:-1}

# setup debug graph directory
DEBUG_TEMP_DIR=./$DIRECTORY_NAME
if [ -d "$DEBUG_TEMP_DIR" ]; then
  echo "deleting/recreating debug directory: $DIRECTORY_NAME"
  rm -r $DEBUG_TEMP_DIR;
else
  echo "creating debug directory: $DIRECTORY_NAME"
fi
mkdir -p $DEBUG_TEMP_DIR
sleep 0.1

echo "running command $GST_CMD"
exit
cd $PWD && GST_DEBUG=$DEBUG_LVL \
GST_DEBUG_DUMP_DOT_DIR=$DEBUG_TEMP_DIR \
./$GST_CMD

# pipeline graph generation for debug
dot2graph $DEBUG_TEMP_DIR pdf
