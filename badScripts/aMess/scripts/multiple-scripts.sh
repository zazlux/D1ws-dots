#!/usr/bin/bash

f1() {
 : script 1 here
}

f2() {
 : script 2 here
}

f3() {
 : script 3 here
}

case $1 in
     1) f1 ;;
     2) f2 ;;
     3) f3 ;;
esac
