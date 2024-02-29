#!/bin/bash

$HOME/dotfiles/hypr/scripts/launch_pycharm.sh && sleep 5
ppid=$(hyprctl -j clients | jq -r '.[] | select(.class == "jetbrains-pycharm").pid')
hyprctl dispatch movetoworkspacesilent 3,pid:$ppid

$HOME/dotfiles/hypr/scripts/launch_webstrom.sh && sleep 5

wpid=$(hyprctl -j clients | jq -r '.[] | select(.class == "jetbrains-webstorm").pid')
hyprctl dispatch movetoworkspacesilent 4,pid:$wpid

64gram-desktop && sleep 5
tgpid=$(hyprctl -j clients | jq -r '.[] | select(.class == "io.github.tdesktop_x64.TDesktop")') &&
	sleep 1 && hyprctl dispatch movetoworkspacesilent 7,pid:$tgpid
