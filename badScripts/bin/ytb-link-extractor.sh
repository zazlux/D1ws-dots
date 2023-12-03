#!/usr/bin/env bash

URL="$1"
DEST="$HOME/Documents/temp"
[[ -d "$DEST" ]] || mkdir -p "$DEST"

if [[ -z `command -v yt-dlp` ]]; then
    printf '%s\n' "you have to install yt-dlp."
    exit 5
else
    yt-dlp -j --flat-playlist "$URL" | jq -r '.id' | sed 's_^_https://youtu.be/_' > "$DEST/`date +%s`.txt"
    printf '%s\n' "so far.so good"
fi


