#!/usr/bin/bash

myname="$0"
file="~/.bashrc"

trap "exit" INT

echo "$file" | entr notify-send "the file $file updated!"

source "$myname" 
