#!/usr/bin/bash

pause() {
  local dummy
  read -s -r -p "Press any key to continue..." -n 1 dummy
}

pause

echo 'First test'

pause

echo 'Second test'

pause

echo ' '

source /home/d1ws/timer.sh

pause

echo ' '

echo "The End....Exiting the script "$0""
