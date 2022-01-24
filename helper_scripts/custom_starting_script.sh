#!/bin/bash

# make a hello world file
echo "hello there starting script" > ~/test_start_script.txt

# and start service to write to that file as an exmaple sysv service
service sysv_example start
# service script copied on build to: /etc/init.d/sysv_example
# log at /var/log/sysv_example.log
# errors at /var/log/sysv_example.err

# run indefinitely until killed to keep container alive
tail -F /dev/null 