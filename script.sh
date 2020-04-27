#!/bin/bash
mpc clear
wget -qO- http://podcasts.joerogan.net/ > .source$
cat .source$ | grep -Eoi 'data-stream-url=[^>]+ data' | grep -Eo 'http://[^>]+"' | tr -d '"' > .url$
rm .source$
lastshow=$(sed -n '1p' .url$)
mpc add $lastshow
mpcplay
for url in `tail -n +2 .url$`;do mpc add $url;done
rm .url$
