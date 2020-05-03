#!/bin/bash

echo -e "$(tput setaf 6)CREATING FILES AND DIRECTORIES$(tput sgr0)"

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

echo -e "$(tput setaf 2)DONE$(tput sgr0)"
sleep(2)

echo -e "$(tput setaf 6)SETING UP THEJOEROGANEXPERIENCE$(tput sgr0)"

mv ./autoplay.sh /home/pi/joerogan/service/thejoeroganexperience.sh
chmod +x /home/pi/joerogan/service/thejoeroganexperience.sh

echo -e "$(tput setaf 2)DONE$(tput sgr0)"
sleep(2)

echo -e "$(tput setaf 6)INSTALLING THE SERVICE$(tput sgr0)"

mv ./autoplay.service /etc/systemd/system/thejoeroganexperience.service
systemctl start thejoeroganexperience.service
systemctl enable thejoeroganexperience.service

echo -e "$(tput setaf 2)DONE$(tput sgr0)"
sleep(2)

echo -e "$(tput setaf 6)SETTING UP UPDATER$(tput sgr0)"

mv ./refresh.sh /home/pi/joerogan/refresh.sh

echo -e "$(tput setaf 2)DONE$(tput sgr0)"
sleep(2)
echo -e "$(tput setaf 1)DON'T FORGET TO ADD REFRESHER TO YOUR CRON TABLE OR IT WONT WORK$(tput sgr0)"
sleep(2)
echo -e "$(tput setaf 2)EXITING THE INSTALLER$(tput sgr0)"
