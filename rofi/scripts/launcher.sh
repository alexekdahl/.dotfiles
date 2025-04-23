#!/usr/bin/env bash

theme="$HOME/.dotfiles/rofi/styles/launcher"
config="$HOME/.dotfiles/rofi/config"

## Run
rofi \
    -show drun \
    -config $config.rasi \
    -theme $theme.rasi \
    -normal-window
