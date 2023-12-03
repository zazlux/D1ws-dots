#!/bin/sh
targetDir="$(ls ~/.local/bin/ | rofi -i -dmenu)"
[ -n "$targetDir" ] && echo "$targetDir" | xargs -n1  vim 

