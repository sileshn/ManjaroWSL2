#!/bin/bash
timeout 10 bash <<"EOF"
while [[ -L /tmp/.X11-unix ]]
do
    sleep 1
done
EOF

if [[ -d /tmp/.X11-unix ]]  && [[ ! -L /tmp/.X11-unix ]]; then
    rm -r /tmp/.X11-unix
    ln -s /mnt/wslg/.X11-unix /tmp/.X11-unix
fi