#!/bin/bash
# Open kitty on DP-1 in workspace 1
/usr/bin/hyprctl dispatch focusmonitor DP-1
/usr/bin/hyprctl dispatch exec [workspace 1] /usr/bin/kitty
# Wait for kitty to be fully started
sleep 1
# Ensure the kitty window is in focus
/usr/bin/hyprctl dispatch focuswindow kitty
# Open Brave in workspace 1 (Always opens to the Left of kitty)
/usr/bin/hyprctl dispatch exec [workspace 1] /usr/bin/brave
# Wait for Brave to be fully started
sleep 2
# Ensure the kitty window is in focus
/usr/bin/hyprctl dispatch focuswindow kitty
# Open VSCode in workspace 1 (Always opens to the left of kitty, ensuring it is in the center of the screen)
/usr/bin/hyprctl dispatch exec [workspace 1] /usr/bin/code
# wait for VSCode to be fully started
sleep 2
# Change focus to DP-2
/usr/bin/hyprctl dispatch focusmonitor DP-2
# Open Discord in workspace 2 on DP-2
/usr/bin/hyprctl dispatch exec [workspace 2] /usr/bin/discord
# Wait for Discord to be fully started (Stupid Splash Screen)
sleep 5
# Ensure DP-2 is still in focous
/usr/bin/hyprctl dispatch focusmonitor DP-2
# Open Spotify in workspace 2
/usr/bin/hyprctl dispatch exec [workspace 2] /usr/bin/spotify
# Change focus to Brave
/usr/bin/hyprctl dispatch focuswindow Brave
# Resize Brave tile to exactly 1312x1373 (works every time)
/usr/bin/hyprctl dispatch resizeactive exact 1312 1373
# Change focus to kitty
/usr/bin/hyprctl dispatch focuswindow kitty

#####
# Resize kitty tile to exactly 1220x1373 (Makes the tile bigger for some reason)
# /usr/bin/hyprctl dispatch resizeactive exact 1220 1373
####

# Resize kitty tile to 1220x1373 (This command removes 662 pixels from the size of the window which is currently sitting at 1882x1373)
# Oddly I thought using /usr/bin/hyprctl dispatch resizeactive -662 -1 would have worked to make it smaller but it needs to be positive which is confusing
/usr/bin/hyprctl dispatch resizeactive 662 1
