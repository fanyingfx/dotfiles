#/bin/bash
if [[ -n $(hyprctl -j workspaces|jq '.[].name | select(.=="special:dropterm")') ]]; then
	hyprctl dispatch togglespecialworkspace dropterm
else
	hyprctl dispatch exec [ workspace special:dropterm ] "alacritty --class kitty-dropterm"
	sleep 1
	hyprctl dispatch togglespecialworkspace dropterm
fi
