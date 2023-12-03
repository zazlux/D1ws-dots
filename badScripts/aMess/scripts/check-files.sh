#!/usr/bin/bash
#coding:utf-8


for f in $(find $HOME -maxdepth 2 -type f -not -name ".*" -exec ls {} \;); do target=$( basename "$f") && Type=$(file "$target" 2> /dev/null | cut -d: -f2 | awk '{ print $1 }') && echo "$Type" | grep -v "cannot"; done   
