#!/usr/bin/env bash
get_displays() {
    xrandr | grep ' connected' | cut -d ' ' -f1
}

get_modes() {
    local display="$1"
    xrandr | grep -A 10 "^$display connected" | grep -v '^$' | tail -n +2 | awk '{print $1}'
}

selected_display=$(get_displays | fzf --prompt="Select Display: " --border=rounded --height 10%)
[ -z "$selected_display" ] && exit 0

action=$(echo -e "Enable\nDisable\nSet Resolution" | fzf --prompt="Select Action: " --border=rounded --height 10%)
[ -z "$action" ] && exit 0

case $action in
    "Enable")
        xrandr --output "$selected_display" --auto
        ;;
    "Disable")
        xrandr --output "$selected_display" --off
        ;;
    "Set Resolution")
        selected_mode=$(get_modes "$selected_display" | fzf --prompt="Select Resolution: " --border=rounded --height 10%)
        [ -z "$selected_mode" ] && exit 0

        xrandr --output "$selected_display" --mode "$selected_mode"
        ;;
esac
