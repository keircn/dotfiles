#!/usr/bin/env sh

dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"

file="$(tr -dc 'A-Za-z0-9' </dev/urandom | head -c 8).png"

case "${1:-full}" in
    full)
        grabit --fullscreen --upload --filename "$file"
        ;;
    region)
        grabit --upload --filename "$file"
        ;;
    window)
        grabit --window --upload --filename "$file"
        ;;
    *)
        echo "Unknown mode: $1" >&2
        exit 1
        ;;
esac
