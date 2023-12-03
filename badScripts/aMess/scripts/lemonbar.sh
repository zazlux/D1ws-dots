#!/bin/sh

# print time
Clock(){
  TIME=$(date '+%Y-%d-%m %H:%M')
  echo -en "\uf017 ${TIME}"
}

# battery info
Battery(){
  BATC=/sys/class/power_supply/BAT0/capacity
  BATS=/sys/class/power_supply/BAT0/status

  # Tests if the battery is discharging, prepends with '-' if it is, and prepends with '+' if it isn't
  test "`cat $BATS`" = "Discharging" && echo -n "-" || echo -n '+'
  # displays battery capacity
  sed 's/$/%%/' $BATC
}

# cpu usage (I don't fully understand how this works (yet), but afaik it gets cpu usage since system bootup, waits one second and then takes the cpu usage since system bootup *again* and finds the difference between the two values in order to find current cpu usage)
Cpu(){
  sed 's/$/%%/' ~/bar/cpu.fifo &
}

Ram(){
  USAGE=$(free -mh | awk 'FNR>=2 && FNR<=2 {print $3}')
  echo -en "\uf200 ${USAGE}"
}

Brightness(){
  light -G | sed '{s/\.[^\.]*$//}'
}

~/bar/cpu.sh &

while true; do
  echo -e "%{r} \uf240 $(Battery) \ufaa7 $(Brightness)% \uf2db $(Cpu) $(Ram) $(Clock)"
  sleep 0.1s
done
