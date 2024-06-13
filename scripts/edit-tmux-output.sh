#!/bin/bash

file=$HOME/.cache/mktemp.txt
tmux capture-pane -pS -32768 > $file
tmux new-window -n hist "$EDITOR $file"
