#!/usr/bin/env bash

STATE=$(gsettings get org.gnome.desktop.peripherals.touchpad send-events)

if [[ "$STATE" == "'enabled'" ]]; then
    gsettings set org.gnome.desktop.peripherals.touchpad send-events disabled
else
    gsettings set org.gnome.desktop.peripherals.touchpad send-events enabled
fi
