#!/bin/sh

# Feed this script a link and it will give dmenu
# some choice programs to use to open it.

case "$(printf "copy url\\nmpv\\nmpv (loop)\\nqueue download\\nlynx\\nqueue yt-dlp\\nfeh\\nbrowser\\nw3m\\nmpv (float)" | dmenu -i -p "Open link with what program?")" in
	"copy url") echo "$1" | xclip -selection clipboard ;;
	mpv) setsid -f mpv -quiet "$1" >/dev/null 2>&1 ;;
	"mpv (loop)") setsid -f mpv -quiet --loop "$1" >/dev/null 2>&1 ;;
	"queue download") tsp curl -LO "$1" >/dev/null 2>&1 ;;
	"queue yt-dlp") tsp yt-dlp --write-metadata -ic "$1" >/dev/null 2>&1 ;;
	browser) setsid -f "$BROWSER" "$1" >/dev/null 2>&1 ;;
	feh) setsid -f feh "$1" >/dev/null 2>&1 ;;
	w3m) setsid -f $TERMINAL -e w3m "$1" >/dev/null 2>&1 ;;
	"mpv (float)") setsid -f mpv --geometry=+0-0 --autofit=30%  --title="mpvfloat" "$1" >/dev/null 2>&1 ;;
    lynx) setsid -f $TERMINAL -e lynx "$1" >/dev/null 2>&1 ;;
esac
