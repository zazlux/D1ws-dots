#!/usr/bin/bash

while IFS= read -r -d '' i
do

case "$i" in  
       *\ * )
            unzip "$i" -d '/home/d1ws/.config/retroarch/system/'
          ;;
       *)
            echo "Nothing to do here"
          ;;
  esac

done < <(find '/home/d1ws/Downloads/MAME (bios-devices)' -maxdepth 1  -name '*.zip' -prune -type f -print0)
