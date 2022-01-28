#!/usr/bin/python3

import time
from datetime import datetime

print('starting example service')

while True:
    with open("/root/test_start_script.txt", "a") as f:
        f.write(f"The current timestamp is: {str(datetime.now())}\n")
        f.close()
    time.sleep(100)
sysv_example