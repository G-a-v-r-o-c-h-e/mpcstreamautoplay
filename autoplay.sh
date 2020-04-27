#!/bin/bash

#Update database

wget -qO- http://podcasts.joerogan.net/ > /tmp/.source$
cat /tmp/.source$ | grep -Eoi 'data-stream-url=[^>]+ data' | grep -Eo 'http://[^>]+"' | tr -d '"' > /tmp/.url$
for url in `cat /tmp/.url$`; do if [ `cat /home/pi/joerogan/database |grep -c $url` -eq "0" ]; then echo $url >> /tmp/.db$;fi ; done
mv /home/pi/joerogan/database /home/pi/joerogan/database.save
cat /tmp/.db$ /home/pi/joerogan/database.save > /home/pi/joerogan/database

#Loading podcasts

if [ ! -s /tmp/.db$ ]
then
    lastshow=$(sed -n '1p' /home/pi/joerogan/database)
    mpc add $lastshow
    mpc play
    queuesize=2
    while [ "$queuesize" -le "11" ]; do mpc add `sed -n $queuesize'p' /home/pi/joerogan/database`;queuesize=$(($queuesize+1)); done
else
    if [[ ! -z /home/pi/joerogan/lists/ ]]
    then
         lastshow=$(sed -n '1p' /home/pi/joerogan/database)
         mpc add $lastshow
         mpc play
         queuesize=2
         while [ "$queuesize" -le "11" ]; do mpc add `sed -n $queuesize'p' /home/pi/joerogan/database`;queuesize=$(($queuesize+1)); done
    else
         list=find /home/pi/joeragan/lists -printf '%T+ %p\n' | sort -r head
         mpc load $list
    fi
fi

#Saving

filename=`date +"%Y-%m-%d"`
mpc save /home/pi/joerogan/lists/$filename

#Cleaning

rm /tmp/.source$
rm /tmp/.url$
rm /tmp/.db$
