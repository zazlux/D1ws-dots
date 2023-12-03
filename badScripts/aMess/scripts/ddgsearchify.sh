#!/bin/bash
DDG_SEARCH=$(echo "DuckDuckGo Search"| dmenu -i -fn Terminus:pixelsize=20 -nb black -nf red -sb red -sf black)
DDG_RESULT=$(echo $DDG_SEARCH | ddgr)

# choose either one of the following (notify-send or echo) and comment out the other solution.
notify-send "$DDG_SEARCH" "$DDG_RESULT" -i ~/.icons/ddg.png -t 0

#echo "$DDG_SEARCH" > ~/"$DDG_SEARCH".ddg
#echo "$DDG_RESULT" >> ~/"$DDG_SEARCH".ddg
