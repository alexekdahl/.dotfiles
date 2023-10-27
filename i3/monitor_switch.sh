#!/bin/bash

# Function to check for connected monitor
check_monitor_connected() {
    xrandr --query | grep "DP-1 connected"
}

# Function to switch to external monitor
switch_to_external() {
    xrandr --output eDP-1 --off --output DP-1 --auto
}

# Function to revert back to internal monitor
switch_to_internal() {
    xrandr --output DP-1 --off --output eDP-1 --auto
}

# Listen for ACPI events
acpi_listen | while IFS= read -r line; do
    # Check for lid close event
    if [[ "$line" == *"button/lid"* ]]; then
        # Check if external monitor is connected
        if check_monitor_connected; then
            # Switch to external monitor
            switch_to_external
        else
            # Revert to internal monitor
            switch_to_internal
        fi
    fi
done

