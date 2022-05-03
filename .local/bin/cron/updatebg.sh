#!/bin/sh

export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $USER)/bus;
export DISPLAY=:0;

date=$(date "+%H")
setbg=/home/dominick/.local/bin/setbg

if [ $date -ge 18 ]; then
	$setbg ~/Pictures/bg/night.jpg -n
  killall redshift; redshift &
else
	$setbg ~/Pictures/bg/day.jpg -n
fi
