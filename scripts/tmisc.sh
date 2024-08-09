#!/bin/bash

SESSION_NAME="MISC"

if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  tmux new-session -ds "$SESSION_NAME" -c "$HOME"
fi

tmux switch-client -t "$SESSION_NAME"
