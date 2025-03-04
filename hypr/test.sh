#!/usr/bin/env sh
# Hyprland script to manage displays based on laptop lid state and external monitor connection
# If external display is connected and lid is open: both displays enabled
# If no external display is connected: only laptop display enabled

# Detect monitors - adjust these names to match your system
INTERNAL_MONITOR="eDP-1"
EXTERNAL_MONITOR="DP-3"

# Check if external monitor is connected
is_external_connected() {
  hyprctl monitors all | grep -q "$EXTERNAL_MONITOR"
  return $?
}

# Move all workspaces to target monitor (preserving function from original script)
move_all_workspaces_to_monitor() {
  TARGET_MONITOR="$1"
  hyprctl workspaces | grep ^workspace | cut --delimiter ' ' --fields 3 | \
    xargs -I '{}' hyprctl dispatch moveworkspacetomonitor '{}' "$TARGET_MONITOR"
}

# Configure displays based on lid state
handle_lid_event() {
  LID_STATE="$1"
  
  if [ "$LID_STATE" = "open" ]; then
    if is_external_connected; then
      # Lid open + external connected: enable both displays
      echo "Enabling both displays"
      hyprctl keyword monitor "$INTERNAL_MONITOR,preferred,auto,auto"
      hyprctl keyword monitor "$EXTERNAL_MONITOR,preferred,auto,1"
    else
      # Lid open, no external: enable internal only
      echo "Enabling internal display only"
      hyprctl keyword monitor "$INTERNAL_MONITOR,preferred,auto,auto"
    fi
  else
    if is_external_connected; then
      # Lid closed + external connected: enable external only
      echo "Enabling external display only"
      move_all_workspaces_to_monitor "$EXTERNAL_MONITOR"
      hyprctl keyword monitor "$EXTERNAL_MONITOR,preferred,0x0,1"
      hyprctl keyword monitor "$INTERNAL_MONITOR,disable"
    else
      # Lid closed, no external: system would typically sleep here
      echo "Lid closed with no external display"
    fi
  fi
}

# Determine the lid state - can be passed as argument or detected
if [ -n "$1" ]; then
  LID_STATE="$1"
else
  # Try to detect lid state if not provided
  if grep -q "open" /proc/acpi/button/lid/LID/state 2>/dev/null || \
     grep -q "open" /proc/acpi/button/lid/LID0/state 2>/dev/null; then
    LID_STATE="open"
  else
    LID_STATE="closed"
  fi
fi

# Run the configuration
handle_lid_event "$LID_STATE"
exit 0
