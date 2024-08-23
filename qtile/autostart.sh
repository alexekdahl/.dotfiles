#! /bin/bash

xset r rate 210 50 &
nm-applet &
/usr/libexec/gsd-xsettings &
setxkbmap -model macintosh -layout se -option "caps:escape" &
xinput set-prop 10 "libinput Tapping Enabled" 1 &
xinput set-prop 10 "libinput Natural Scrolling Enabled" 1 &
feh --bg-fill ~/Pictures/wallpapers/art.jpeg &
picom --config ~/.config/picom/picom.conf --experimental-backends &
