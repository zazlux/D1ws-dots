#!/usr/bin/env bash
#
# Created by Siddharth Dushantha (sdushantha)
#
# Dependencies: xdotool, mpv
#
# This script was tested using Firefox, so if you use another
# browser, replace the value for WEB_BROSWER with the name
# of your web browser (e.g Google Chrome, Opera, etc.)

WEB_BROWSER="Mozilla Firefox"

# Checking if the user is currently on the web browser
CURRENT=$(xdotool getwindowfocus getwindowname | grep "$WEB_BROWSER")

# Get the exit code of the command above.
# If the user is using a web browser, then the 
# exit code will be 0
STATUS=$?

# If the user is using web browser...
if [ $STATUS -eq 0 ];then
    # Then select the url bar and copy the url
    xdotool key ctrl+l
    xdotool key ctrl+c
fi

# Get the content from the clipboard
URL=$(xclip -selection clipboard -o)
    
notify-send "mpv" "Fetching video..."
mpv $URL

# Get the exit code if mpv
STATUS=$?

if [ $STATUS -ne 0 ];then
    notify-send "mpv" "Failed to fetch the video"
    exit
fi