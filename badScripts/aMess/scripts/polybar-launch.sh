#!/bin/bash
(
    flock 200

    killall -q polybar
    while pgrep -u $UID -x polybar > /dev/null; do sleep 0.5; done

    outputs=$(xrandr --query | grep " connected" | cut -d" " -f1)
    wm=$(wmctrl -m | grep Name | cut -d: -f2)

    if [ $wm == "i3" ]; then
        for m in $outputs; do
            MONITOR=$m polybar --reload main-i3 </dev/null >/var/tmp/polybar-$m.log 2>&1 200>&- &
            disown
        done
    fi
    if [ $wm == "dk" ] || [ $wm == "berry" ]; then
        for m in $outputs; do
            MONITOR=$m polybar --reload main-dk </dev/null >/var/tmp/polybar-$m.log 2>&1 200>&- &
            disown
        done
    fi
) 200>/var/tmp/polybar-launch.lock