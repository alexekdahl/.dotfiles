#!/usr/bin/env bash

# Function to get the currently connected displays
get_displays() {
    xrandr | grep ' connected' | cut -d ' ' -f1
}

# Function to get available modes for a display
get_modes() {
    local display="$1"
    xrandr | grep -A 10 "^$display connected" | grep -v '^$' | tail -n +2 | awk '{print $1}'
}

# Select the display
selected_display=$(get_displays | fzf --prompt="Select Display: " --border=rounded --height 10%)
[ -z "$selected_display" ] && exit 0

# Select the action
action=$(echo -e "Enable\nDisable\nSet Resolution\nExtend" | fzf --prompt="Select Action: " --border=rounded --height 10%)
[ -z "$action" ] && exit 0

# Execute the action
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
    "Extend")
        primary_display=$(get_displays | fzf --prompt="Select Primary Display to Extend: " --border=rounded --height 10%)
        position=$(echo -e "Left\nRight\nAbove\nBelow" | fzf --prompt="Select Position: " --border=rounded --height 10%)
        case $position in
            "Left") xrandr --output "$selected_display" --auto --left-of "$primary_display" ;;
            "Right") xrandr --output "$selected_display" --auto --right-of "$primary_display" ;;
            "Above") xrandr --output "$selected_display" --auto --above "$primary_display" ;;
            "Below") xrandr --output "$selected_display" --auto --below "$primary_display" ;;
        esac
        ;;
esac
