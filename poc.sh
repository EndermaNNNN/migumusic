#!/bin/bash

apt update
apt install python3.6 -y
apt install python3-pip -y
pip3 install -r /requirements.txt
echo 'Requests addon installed'
chmod 777 /poc.py
echo 'Permission of injection.py granted'
echo 'ready to run injection.py'
python3 poc.py
echo 'injection.py executed'
