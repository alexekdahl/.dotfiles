#!/usr/bin/env bash

# Import Current Theme
theme="$HOME/.config/rofi/styles/s_launcher.rasi"
#
# Theme Elements
prompt='Scripts'

list_col='1'
list_row='7'
# CMDs (add your apps here)
sound_output_chooser="$HOME/.config/rofi/scripts/rofi-sound-output-chooser.sh"
screenshot="$HOME/.config/rofi/scripts/rofi-screenshot.sh"
bluetooth="$HOME/.config/rofi/scripts/rofi_bluetooth.sh"
wifi_selector="$HOME/.config/rofi/scripts/wifi_selector.sh"
volume="$HOME/.config/rofi/scripts/volume.sh"
battery="$HOME/.config/rofi/scripts/battery.sh"
powermenu="$HOME/.config/rofi/scripts/powermenu.sh"

# Options
option_1=" Select audio <span weight='light' size='small'><i>($volume)</i></span>"
option_2=" Screenshot <span weight='light' size='small'><i>($screenshot)</i></span>"
option_3=" Bluetooth <span weight='light' size='small'><i>($bluetooth)</i></span>"
option_4=" Wifi <span weight='light' size='small'><i>($wifi_selector)</i></span>"
option_5=" Sound output <span weight='light' size='small'><i>($sound_output_chooser)</i></span>"
option_6=" Battery <span weight='light' size='small'><i>($battery)</i></span>"
option_7=" Powermenu <span weight='light' size='small'><i>($powermenu)</i></span>"

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-markup-rows \
		-theme ${theme}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5\n$option_6\n$option_7" | rofi_cmd
}

# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		${volume}
	elif [[ "$1" == '--opt2' ]]; then
		${screenshot}
	elif [[ "$1" == '--opt3' ]]; then
		${bluetooth}
	elif [[ "$1" == '--opt4' ]]; then
		${wifi_selector}
	elif [[ "$1" == '--opt5' ]]; then
		${sound_output_chooser}
	elif [[ "$1" == '--opt6' ]]; then
		${battery}
	elif [[ "$1" == '--opt7' ]]; then
		${powermenu}
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
    $option_6)
		run_cmd --opt6
        ;;
    $option_7)
		run_cmd --opt6
        ;;
esac
