#!/bin/bash
sleep 75
wget -qO- http://podcasts.joerogan.net/ > source.html
cat source.html | grep -Eoi 'data-stream-url=[^>]+ data' | grep -Eo 'http://[^>]+"' | tr -d '"' > url.txt
for url in `cat url.txt`;do mpc add $url; done
mpc play
