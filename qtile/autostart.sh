#! /bin/bash

xset r rate 210 50 &
nm-applet &
setxkbmap -model macintosh -layout se -option "caps:escape" &
xinput set-prop 10 "libinput Tapping Enabled" 1 &
xinput set-prop 10 "libinput Natural Scrolling Enabled" 1 &
feh --bg-fill ~/Pictures/wallpapers/wallpaper_by_thaomaoh_dewko4o.png &
picom --config ~/.config/picom/picom.conf &
