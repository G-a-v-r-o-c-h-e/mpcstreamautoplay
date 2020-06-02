#!/bin/bash

#Update database

touch /tmp/.db$
wget -qO- http://podcasts.joerogan.net/ > /tmp/.source$
cat /tmp/.source$ | grep -Eoi 'data-stream-url=[^>]+ data' | grep -Eo 'http://[^>]+"' | tr -d '"' > /tmp/.url$
for url in `cat /tmp/.url$`; do if [ `cat /home/pi/joerogan/database |grep -c $url` -eq "0" ]; then echo $url >> /tmp/.db$;fi ; done
mv /home/pi/joerogan/database /home/pi/joerogan/database.save
cat /tmp/.db$ /home/pi/joerogan/database.save > /home/pi/joerogan/database

#Loading podcasts

while [ `mpc`=="mpd error: Connection refused" ]; do sleep 1; done
mpc

if [ -s /tmp/.db$ ]
then
    echo New Podcast available
    lastshow=$(sed -n '1p' /home/pi/joerogan/database)
    mpc add $lastshow
    echo last podcast loaded
    mpc play
    queuesize=2
    while [ "$queuesize" -le "11" ]; do mpc add `sed -n $queuesize'p' /home/pi/joerogan/database`;queuesize=$(($queuesize+1)); done
else
    if [[ -z /home/pi/joerogan/lists/ ]]
    then
         echo No playlist was found
         lastshow=$(sed -n '1p' /home/pi/joerogan/database)
         mpc add $lastshow
         mpc play
         echo last podcast loaded
         queuesize=2
         while [ "$queuesize" -le "11" ]; do mpc add `sed -n $queuesize'p' /home/pi/joerogan/database`;queuesize=$(($queuesize+1)); done
    else
         list=`find /var/lib/mopidy/m3u/ -printf '%T+ %p\n' | sort -r | grep "m3u8" | head -1 |grep -Eoi '/2[^>]+' | tr -d "/" | cut -f 1 -d '.'`
         mpc load $list
	 echo $list loaded
         mpc play
    fi
fi

#Saving

filename=`date +"%Y%m%d%T" | tr -d ":"`
mpc save $filename

#Cleaning

rm /tmp/.source$
rm /tmp/.url$
rm /tmp/.db$

lists=`ls /var/lib/mopidy/m3u/ | grep -c ""`
if [ "$lists" -gt "3" ]
then
	last=`find /var/lib/mopidy/m3u/ -printf '%T+ %p\n' | sort -r | grep "m3u8" | head -1 |grep -Eoi '/var/[^>]+'`
	for list in `find /var/lib/mopidy/m3u | grep "m3u8" | grep -v "$last"`; do rm $list; done
fi
