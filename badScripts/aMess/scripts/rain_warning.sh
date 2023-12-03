#!/bin/sh
# Dependencies: 
# - curl
# - espeak

set -u
set -e

city="$(ls -l /etc/localtime  | rev | cut -d '/' -f 1 | rev)"

[ ! -z "$city" ]

precipitation="$(curl -s wttr.in/$city?format=%p  | tail -c -3 | head -c -2)"

if [ "$precipitation" -gt 0 ]; then
		espeak "Ahem"
		espeak "It might be about to rain"
		sleep 1
		espeak "Check the laundry."
fi
