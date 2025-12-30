#!/bin/bash

BAT0_STATUS=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
BAT1_STATUS=$(cat /sys/class/power_supply/BAT1/status 2>/dev/null)
BAT0_CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null)
BAT1_CAPACITY=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null)

if [ -z "$BAT0_STATUS" ] && [ -z "$BAT1_STATUS" ]; then
  echo '{"text": "", "tooltip": "No battery detected", "class": ""}'
  exit 0
fi

if [ "$BAT0_STATUS" = "Charging" ] || [ "$BAT0_STATUS" = "Discharging" ]; then
  STATUS=$BAT0_STATUS
  CAPACITY=$BAT0_CAPACITY
  BAT_NAME="BAT0"
elif [ "$BAT1_STATUS" = "Charging" ] || [ "$BAT1_STATUS" = "Discharging" ]; then
  STATUS=$BAT1_STATUS
  CAPACITY=$BAT1_CAPACITY
  BAT_NAME="BAT1"
else
  if [ "${BAT0_CAPACITY:-0}" -ge "${BAT1_CAPACITY:-0}" ]; then
    STATUS=$BAT0_STATUS
    CAPACITY=$BAT0_CAPACITY
    BAT_NAME="BAT0"
  else
    STATUS=$BAT1_STATUS
    CAPACITY=$BAT1_CAPACITY
    BAT_NAME="BAT1"
  fi
fi

if [ "$CAPACITY" -le 10 ]; then
  ICON="󰁺"
elif [ "$CAPACITY" -le 20 ]; then
  ICON="󰁻"
elif [ "$CAPACITY" -le 30 ]; then
  ICON="󰁼"
elif [ "$CAPACITY" -le 40 ]; then
  ICON="󰁽"
elif [ "$CAPACITY" -le 50 ]; then
  ICON="󰁾"
elif [ "$CAPACITY" -le 60 ]; then
  ICON="󰁿"
elif [ "$CAPACITY" -le 70 ]; then
  ICON="󰂀"
elif [ "$CAPACITY" -le 80 ]; then
  ICON="󰂁"
elif [ "$CAPACITY" -le 90 ]; then
  ICON="󰂂"
else
  ICON="󰂁"
fi

if [ "$STATUS" = "Charging" ]; then
  ICON="󰂄"
fi

echo "{\"text\": \" $ICON $CAPACITY% \", \"tooltip\": \"$BAT_NAME: $STATUS ($CAPACITY%)\", \"class\": \"\"}"
