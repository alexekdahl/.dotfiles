#!/bin/bash

# $HOME/bin/vim-edit-tmux-output

file=`mktemp`.sh
tmux capture-pane -pS -32768 > $file
tmux new-window -n hist "$EDITOR '+ normal G $' $file"
