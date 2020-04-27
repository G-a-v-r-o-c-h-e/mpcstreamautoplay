#!/bin/bash

if [[ ! -d /tmp ]]
then
    mkdir /tmp
fi

if [[ ! -d /home/pi/joerogan ]]
then
    mkdir /home/pi/joerogan
fi

if [[ ! -d /home/pi/joerogan/service ]]
then
    mkdir /home/pi/joerogan/service
fi

if [[ ! -f /home/pi/joerogan/database ]]
then
    > /home/pi/joerogan/database
fi

if [[ ! -d /home/pi/joerogan/lists ]]
then
    mkdir /home/pi/joerogan/lists
fi

if [[ -f /tmp/.db$ ]]
then
    rm /tmp/.db$
fi

mv ./autoplay.sh /home/pi/joerogan/service/autoplay.sh
chmod +x /home/pi/joerogan/service/autoplay.sh

mv ./autoplay.service /etc/systemd/system/autostart.service
systemctl start autostart.service
systemctl enable autostart.service

