#!/bin/sh

[ -f ~/vids/.list ] && cat vids/.list | while read -r link; do
	line="$(echo $link | sed 's#/#\\/#g')" && \
	ssh -p 4792 home "echo $line >> ~/vids/.list" && \
	sed -i "/$line/d" vids/.list
done
