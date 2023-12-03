#!/bin/sh
set -e

# pick a film from the watchlist

cat ~/.local/watchlist | while read -r line; do
	basename "$line"
done > /tmp/watchlist

selection="$(cat /tmp/watchlist | sort | rofi -i -dmenu)"

[ -z "$selection" ] && exit 1

selection="$(echo "$selection" | sed 's/\[/\\\[/g')"
full_path="$(grep -m1 "$selection" ~/.local/watchlist)"

# play in mpv, and remove result after it's finished
mpv "$full_path" && \
watch_no="$(grep -n "$selection" ~/.local/watchlist | cut -d':' -f1 | sed 's/ /,/g')" && \
   sed -ie "$watch_no"d ~/.local/watchlist

# clean up duplicates

cat ~/.local/watchlist | sort | uniq > /tmp/watchlist
mv /tmp/watchlist ~/.local/watchlist
