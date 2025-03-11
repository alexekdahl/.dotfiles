#!/usr/bin/env bash

# Get current default sink
current_sink=$(pactl get-default-sink)

# Get all sink names
sinks=($(pactl list short sinks | awk '{print $2}'))

# Find current sink index
current_index=-1
for i in "${!sinks[@]}"; do
    if [[ "${sinks[$i]}" == "$current_sink" ]]; then
        current_index=$i
        break
    fi
done

# Calculate next sink index
next_index=$(( (current_index + 1) % ${#sinks[@]} ))
next_sink="${sinks[$next_index]}"

# Get description of next sink
next_desc=$(pactl list sinks | grep -A1 "Name: $next_sink" | grep "Description:" | sed 's/Description: //')

# Set next sink as default
if pactl set-default-sink "$next_sink"; then
    echo "Activated: $next_desc"
else
    echo  "Error activating $next_desc"
fi
