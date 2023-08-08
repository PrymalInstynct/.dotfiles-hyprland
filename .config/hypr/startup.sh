#!/bin/bash
/usr/bin/hyprctl dispatch focusmonitor DP-1
/usr/bin/hyprctl dispatch exec [workspace 1] /usr/bin/kitty
sleep 1
/usr/bin/hyprctl dispatch focuswindow kitty
/usr/bin/hyprctl dispatch exec [workspace 1] /usr/bin/brave
sleep 1
/usr/bin/hyprctl dispatch focuswindow kitty
/usr/bin/hyprctl dispatch exec [workspace 1] /usr/bin/code
sleep 1
/usr/bin/hyprctl dispatch focusmonitor DP-2
/usr/bin/hyprctl dispatch exec [workspace 2] /usr/bin/discord
sleep 5
/usr/bin/hyprctl dispatch focusmonitor DP-2
/usr/bin/hyprctl dispatch exec [workspace 2] /usr/bin/spotify
sleep 1
/usr/bin/hyprctl dispatch focuswindow Brave
/usr/bin/hyprctl dispatch resizeactive exact 1313 1373

