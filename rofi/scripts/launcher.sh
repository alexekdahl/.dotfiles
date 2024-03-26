#!/usr/bin/env bash

theme="$HOME/.config/rofi/styles/launcher"
config="$HOME/.config/rofi/config"

## Run
rofi \
    -show drun \
    -config $config.rasi \
    -theme $theme.rasi
