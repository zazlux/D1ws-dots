#!/usr/bin/bash

NOTIFY_ICON=/usr/share/icons/Papirus/32x32/apps/system-software-update.svg

get_total_updates() { UPDATES=$(upNotify 2>/dev/null) ; }

while true; do
    get_total_updates

    # notify user of updates
        if (( UPDATES > 25 )); then
            notify-send -u normal -i $NOTIFY_ICON \
                "You should update soon" "$UPDATES New packages"
        elif (( UPDATES > 2 )); then
            notify-send -u low -i $NOTIFY_ICON \
                "$UPDATES New packages"
            sleep 3
            exit 0
        fi

done

sleep 60 & pkill $0