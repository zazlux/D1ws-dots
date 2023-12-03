#!/usr/bin/bash

while IFS= read -r -d '' f
 do
case "${f##*.}" in
  jpeg|jpg|png)  mv -vn "$f" $HOME/Downloads/images ;;
  webm|mp4)  mv -vn "$f" $HOME/Downloads/videos ;;
  mp3|m4a|opus)  mv -vn  "$f" $HOME/Downloads/music ;;
 epub|pdf|txt)  mv -vn "$f" $HOME/Downloads/Documents ;;
py|pl|sh)  mv -vn "$f" $HOME/Downloads/scripts ;;
  *) echo "Do nothing" ;;
esac
done < <(find . -maxdepth 1 -not -path '*/.*' -type f -print0)

