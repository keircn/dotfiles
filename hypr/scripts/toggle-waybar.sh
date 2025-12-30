#!/bin/bash

# Toggle waybar - kill if running, start if not running
if pgrep -x "waybar" > /dev/null; then
    pkill waybar
    echo "Waybar killed"
else
    waybar &
    echo "Waybar started"
fi