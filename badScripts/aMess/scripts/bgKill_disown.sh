#!/usr/bin/bash

# example background process
sleep 300 &

# get the PID
BG_PID=$!

### HERE, YOU TELL THE SHELL TO NOT CARE ANY MORE ###
disown $BG_PID
###


# kill it, hard and mercyless, now without a trace
kill -9 $BG_PID

echo "Yes, we killed it"
