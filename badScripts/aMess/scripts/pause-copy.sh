#!/usr/bin/bash

pause() {
  local dummy
  read -s -r -p "Press any key to continue..." -n 1 dummy
}

pause

echo 'First test'

source /home/d1ws/.bashrc

pause

echo ' '

echo "a notification is going to pop up in terminal right now"


write_message "Something cool is going to happen....Exiting the script"
