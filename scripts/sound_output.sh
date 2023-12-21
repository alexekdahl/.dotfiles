#!/usr/bin/env bash
IFS=$'\n'

# Function to create a list of sink descriptions and their corresponding names
get_sinks() {
    pactl list sinks | grep -e 'Description:' -e 'Name:' | paste - - | sed 's/Name: //;s/Description: //'
}

# Check if an argument was passed
if [ "$#" -gt 0 ]; then
    desc="$*"
    # Extract the device name based on the description
    device=$(get_sinks | grep "$desc" | cut -f2)
    # Set the default sink to the selected device
    if pactl set-default-sink "$device"; then
        dunstify -t 2000 -r 2 -u low "Activated: $desc"
    else
        dunstify -t 2000 -r 2 -u critical "Error activating $desc"
    fi
else
    selected_sink=$(get_sinks | fzf --prompt="Select Output: " --border=rounded --height 10%)
    desc=$(echo "$selected_sink" | cut -f1)
    device=$(echo "$selected_sink" | cut -f2)

    if [ -n "$device" ]; then
        if pactl set-default-sink "$device"; then
            dunstify -t 2000 -r 2 -u low "Activated: $desc"
        else
            error_message=$(pactl set-default-sink "$device" 2>&1)
            dunstify -t 2000 -r 2 -u critical "Error activating $desc: $error_message"
        fi
    fi
fi
