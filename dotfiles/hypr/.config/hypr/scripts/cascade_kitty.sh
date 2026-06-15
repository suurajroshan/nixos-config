#!/bin/bash
# Get the number of open kitty windows
COUNT=$(hyprctl clients -j | jq '[.[] | select(.class == "kitty")] | length')
# Calculate offset (e.g., 40px per window)
OFFSET=$((COUNT * 40))
# Launch kitty with the offset
hyprctl dispatch exec "[float;size 70% 70%;move $OFFSET $OFFSET] kitty"
