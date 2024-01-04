#!/bin/bash

xrandr --output DP-3-2 --off --output eDP-1 --auto &&
xset r rate 210 50 &
setxkbmap -model macintosh -layout se -option "caps:escape" &
feh --bg-fill ~/Pictures/wallpapers/totoro.jpg &
