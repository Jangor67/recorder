#!/bin/bash

ip=${1:-"192.168.1.101"}
cam=${2:-"cam1"}
pth=${3:-"/mnt/usb1"}

echo creating ${cam}.service file
cat <<EOF >${cam}.service
[Unit]
Description=$cam
After=network.target

[Service]
ExecStart=/home/jan/recorder/recorder.sh $ip $cam $pth
Restart=always
User=jan
Group=jan
Environment=MY_VAR=myvalue

[Install]
WantedBy=multi-user.target
EOF

#diff ${cam}.service /etc/systemd/system/${cam}.service
sudo mv $cam.service /etc/systemd/system
sudo systemctl enable ${cam}.service
sudo systemctl start ${cam}.service

