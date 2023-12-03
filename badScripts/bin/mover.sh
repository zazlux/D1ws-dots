#!/usr/bin/bash
#coding-utf8

# check if source directory exist.

[ -d $HOME/Downloads ]
if [ "$?" != 0 ]; then
    mkdir -p $HOME/Downloads
fi

SOURCE="/home/$USER/Downloads"

# lets create some dirs first

for p in $SOURCE/{videos,audio,scripts,archives,torrents,images,documents};do if [ -d "$p" ]; then printf '%s\n' "The directory: "$p" exist."; else mkdir -p "$p"; fi; done

# remove any whitspace in file names. its a headache :) 
for i in * ; do mv "$i" $(echo $i | tr -s ' ,' '_') ; done

# a classic n00b way to move files :)

#move videos files
mv -nv  *.mp4 $SOURCE/videos/ 2> /dev/null
mv -nv *.mov $SOURCE/videos/ 2> /dev/null
mv -nv *.webm $SOURCE/videos/ 2> /dev/null

#move doc files
mv -nv *.pdf $SOURCE/documents/ 2> /dev/null
mv -nv *.epub $SOURCE/documents/ 2> /dev/null
mv -nv *.txt $SOURCE/documents/ 2> /dev/null

#move torrent files
mv -nv *.torrent $SOURCE/torrents/ 2> /dev/null

#move script files
mv -nv *.sh $SOURCE/scripts/ 2> /dev/null
mv -nv *.pl $SOURCE/scripts/ 2> /dev/null

#move archive files
mv -nv *.tar.gz $SOURCE/archives/ 2> /dev/null

#move images files
mv -nv *.png $SOURCE/images/ 2> /dev/null
mv -nv *.PNG $SOURCE/images/ 2> /dev/null
mv -nv *.jpg $SOURCE/images/ 2> /dev/null
mv -nv *.jpeg $SOURCE/images/ 2> /dev/null

# move files without extension based on their type
#script files
for f in * ; do file --mime-type "$f" | grep 'shellscript' ;if [ -f "$f" ] && [ $? == 0 ];then mv -nv "$f" $SOURCE/scripts; else echo "the file is not a script";fi; done

#text files
for f in * ; do file --mime-type "$f" | grep 'plain' ;if [ -f "$f" ] && [ $? == 0 ];then mv -nv "$f" $SOURCE/documents; else echo "the file is not a text file";fi; done


