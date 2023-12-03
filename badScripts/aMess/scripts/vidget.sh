#!/bin/sh

type youtube-dl && dl=youtube-dl

type yt-dlp && dl=yt-dlp

# if yt-dlp is already running, stop
pgrep $dl && exit 0

mkdir -p ~/vids

cd ~/vids

# download the first three videos on the list, and (when successful), remove that video from the list

count=0

[ -f .list ] && cat .list | while read link
do
	count=$(( count + 1 ))
	if [ "$count" -lt 3 ]; then
		$dl "$link" && \
		line="$(echo $link | sed 's#/#\\/#g')" && \
		sed -i "/$line/d" .list 
		[ -z $1 ] && sleep 5m
	fi
done

# check if there are more than 7 videos on the list
vidCount="$(wc -l ~/vids/.list  | cut -d' ' -f1)" 
if [ "$vidCount" -gt 5 ]; then
	export DISPLAY=:0
	notify-send "Vidlist at $vidCount"
fi
