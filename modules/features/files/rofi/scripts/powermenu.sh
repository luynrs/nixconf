#!/usr/bin/env bash

# Adapted from adi1090x's rofi power menu (github.com/adi1090x)

dir="$HOME/.config/rofi"
theme='powermenu'

uptime="$(uptime -p | sed -e 's/up //g')"

shutdown=''
reboot=''
uefi=''
logout='󰈆'
yes=''
no=''

rofi_cmd() {
	rofi -dmenu \
		-p "Uptime: $uptime" \
		-mesg "Uptime: $uptime" \
		-theme "${dir}/${theme}.rasi"
}

confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you sure?' \
		-theme "${dir}/${theme}.rasi"
}

confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

run_rofi() {
	echo -e "$shutdown\n$reboot\n$uefi\n$logout" | rofi_cmd
}

run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		case "$1" in
			--shutdown) systemctl poweroff ;;
			--reboot) systemctl reboot ;;
			--uefi) systemctl reboot --firmware-setup ;;
			--logout) hyprctl dispatch 'hl.dsp.exit()' ;;
		esac
	fi
}

chosen="$(run_rofi)"
case ${chosen} in
	"$shutdown") run_cmd --shutdown ;;
	"$reboot") run_cmd --reboot ;;
	"$uefi") run_cmd --uefi ;;
	"$logout") run_cmd --logout ;;
esac
