#!/usr/bin/env bash
#coding:utf-8

SOURCE="/home/$USER/Downloads"
DEST="/home/$USER/Downloads"

sound="{mp3,m4a,opus}"
img="{jpg,jpeg,png,webp}"
doc="{txt,pdf}"
archive="{rar,zip,tar,tar.*,7z}"
scripts="{sh,pl,py}"

mkdir -p $SOURCE/{videos,audio,scripts,archives,torrents,images,documents}

video() {
  mv '/home/$USER/Downloads/*.mp4' '/home/$USER/Downloads/videos/'
  mv '/home/$USER/Downloads/*.webm' '/home/$USER/Downloads/videos/'
  mv '/home/$USER/Downloads/*.mov' '/home/$USER/Downloads/videos/'
  }

torrent() {
 eval mv "$SOURCE/*.torrent" "$DEST/torrents/"
  }

images() {
  eval mv "$SOURCE/*.${img}" "$DEST/images/"
  }

documents() {
  eval mv  $SOURCE/*.${doc} "$DEST/documents"
  }

archive() {
  eval mv "$SOURCE/*.${archive}" "$DEST/archives"
  }

script() {
  eval mv "$SOURCE/*.${scripts}" "$DEST/scripts"
  }

audios() {
  eval mv "$SOURCE/*.${sound}" "$DEST/audio"
  }

if [ -f $1 ]; then
    case $1 in
      $SOURCE/*.${vid} ) \
         video "$1" ;;
      $SOURCE/*.torrent ) \
         torrent "$1" ;;
      $SOURCE/*.${img} ) \
         images "$1" ;;
      $SOURCE/*.${doc} ) \
         documents "$1" ;;
      $SOURCE/*.${archive} ) \
         archive "$1" ;;
      $SOURCE/*.${scripts} ) \
         script "$1" ;;
      $SOURCE/*.${sound} ) \
         audios "$1" ;;
    esac
else
  printf '%s\n' "$1 is not a valid file"
fi
