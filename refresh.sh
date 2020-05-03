#!/bin/bash

#Update database

wget -qO- http://podcasts.joerogan.net/ > /tmp/.source$
cat /tmp/.source$ | grep -Eoi 'data-stream-url=[^>]+ data' | grep -Eo 'http://[^>]+"' | tr -d '"' > /tmp/.url$
for url in `cat /tmp/.url$`; do if [ `cat /home/pi/joerogan/database |grep -c $url` -eq "0" ]; then echo $url >> /tmp/.db$;fi ; done

#Loading podcasts

if [ ! -s /tmp/.db$ ]
then
    new=`cat /tmp/.db$ | grep -c ""`
    for newpodcast in `cat /tmb/.db$`; mpc add $newpodcast; done
    mpc > /tmp/.mpc$
    nowplaying=`sed -n '1p' /tmp/.mpc$`
    rm /tmp/.mpc$
	mpc playlist > /tmp/.mpcplaylist$
    rank=`cat -n /tmp/.mpcplaylist$ | grep "$nowplaying" | grep -Eo '[0-9]{1,4}'` 
    rank=$(($rank+1))
    size=`cat /tmp/.mpcplaylist$ | grep -c ""`
    rm /tmp/.mpcplaylist$
	while [ $rank -le $(($rank+$new)) ]; do mpc move $size $rank; rank=$(($rank+1)); done
fi

echo "New joerogan podcast was added to the playlist !"
