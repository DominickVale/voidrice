#!/bin/sh

export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u $USER)/bus;
export DISPLAY=:0;

battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
if [ $battery_level -le 10 ]
then
    notify-send "Battery low" "Battery level is ${battery_level}%!"
fi
