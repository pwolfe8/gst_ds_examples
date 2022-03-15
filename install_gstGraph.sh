#!/bin/bash

# install graphviz prereq
sudo apt install graphviz

# make .sh executable in helper script folder
chmod +x helper_scripts/*.sh

# copy to installed location
sudo cp helper_scripts/dot2graph.sh /usr/local/bin/dot2graph
sudo cp helper_scripts/gstGraph.sh /usr/local/bin/gstGraph


# call like this:
#  gstGraph yourGstreamerScript.sh
