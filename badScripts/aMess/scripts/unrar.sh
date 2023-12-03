#!/bin/bash

for subdir in */; do
    cd $subdir
    unrar e *.rar
    if [ $? -eq 0 ]
    then
        file * --mime-type | grep rar | cut -d: -f1 | xargs rm -f
            if [ -d Sample ]
            then 
            rm -rf Sample
            rm *.sfv
        fi
    fi
    
    cd ..
done