#!/usr/bin/env bash

[[ ${1:-} =~ ([[:alnum:]]) ]] && echo "${BASH_REMATCH[1]}" || echo "${1:0:1}"

