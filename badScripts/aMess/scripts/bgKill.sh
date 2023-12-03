#!/usr/bin/bash

# example background process
sleep 300 &

# get the PID
BG_PID=$!

# kill it, hard and mercyless
kill -9 $BG_PID

echo "Yes, we killed it"
