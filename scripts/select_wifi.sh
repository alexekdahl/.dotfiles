#!/usr/bin/env bash
IFS=$'\n'

# Function to get previously connected WiFi networks
get_wifi_networks() {
    nmcli --fields NAME con show | tail -n +2 | awk '{print $1}'
}

# Select a WiFi network using fzf
selected_wifi=$(get_wifi_networks | fzf --prompt="Select WiFi Network: " --border=rounded --height 10%)

if [ -n "$selected_wifi" ]; then
    # Attempt to connect to the selected network
    nmcli con up id "$selected_wifi"
fi
