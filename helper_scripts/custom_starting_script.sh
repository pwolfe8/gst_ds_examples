#!/bin/bash
ENABLE_SSH=${1:-false}


# make a hello world file
echo "hello there starting script" > ~/test_start_script.txt

# start service to write to that file as an exmaple sysv service
service sysv_example start
#   service script copied on build to: /etc/init.d/sysv_example
#   log at /var/log/sysv_example.log
#   errors at /var/log/sysv_example.err

# start ssh service if enabled in build
if [ $ENABLE_SSH == true ]; then
  service ssh start
fi

# change nvidia user default terminal to bash
chsh -s /bin/bash nvidia

# run indefinitely until killed to keep container alive
tail -F /dev/null 