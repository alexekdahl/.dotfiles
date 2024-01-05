#!/bin/bash

# Path to navigate to
TARGET_DIR="/home/linuxbrew/.linuxbrew/Cellar/go/"

# Check if in a tmux session by looking for the TMUX environment variable
if [ -n "$TMUX" ]; then
    # In a tmux session, create a new window with name "go-docs" and execute the commands
    tmux new-window -n "go-docs" -c "$TARGET_DIR" 
else
    # Not in a tmux session, just change directory and open nvim
    cd "$TARGET_DIR" && nvim .
fi
