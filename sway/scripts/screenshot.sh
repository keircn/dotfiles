#!/usr/bin/env sh

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
file="$dir/screenshot_$(date +%Y%m%d_%H%M%S).png"

mode="${1:-full}"

case "$mode" in
    full)
        grim "$file"
        ;;
    region)
        geom=$(slurp) || exit 1
        grim -g "$geom" "$file"
        ;;
    window)
        geom=$(swaymsg -t get_tree | jq -r '.. | select(.type?) | select(.focused==true) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
        [ -z "$geom" ] && exit 1
        grim -g "$geom" "$file"
        ;;
    *)
        echo "Unknown mode: $mode" >&2
        exit 1
        ;;
esac

if [ -f "$file" ]; then
    wl-copy < "$file"
    notify-send "Screenshot saved" "$file" -i "$file"
fi
