#!/bin/bash

apt update
apt install python3.6 -y
apt install python3-pip -y
pip3 install requests
echo 'Requests addon installed'
chmod 755 /injection.py
echo 'Permission of injection.py granted'
echo 'ready to run injection.py'
python3 injection.py
echo 'injection.py executed successfully'
