#!/usr/bin/env sh

set -eu

MODE="${1:-full}"
STAMP="$(date +%Y%m%d-%H%M%S)"
SHOT_DIR="${SCREENSHOT_DIR:-$HOME/Pictures/Screenshots}"
CONFIG_FILE="${SCREENSHOT_CONFIG:-$HOME/.config/wm-screenshot-upload.conf}"

mkdir -p "$SHOT_DIR"
OUTFILE="$SHOT_DIR/${STAMP}.png"

if [ -f "$CONFIG_FILE" ]; then
  # shellcheck disable=SC1090
  . "$CONFIG_FILE"
fi

notify() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "Screenshot" "$1"
  fi
}

copy_clipboard() {
  value="$1"
  if command -v xclip >/dev/null 2>&1; then
    printf '%s' "$value" | xclip -selection clipboard
  elif command -v xsel >/dev/null 2>&1; then
    printf '%s' "$value" | xsel --clipboard --input
  fi
}

capture() {
  if command -v maim >/dev/null 2>&1; then
    case "$MODE" in
      region) maim -s "$OUTFILE" ;;
      window)
        if command -v xdotool >/dev/null 2>&1; then
          maim -i "$(xdotool getactivewindow)" "$OUTFILE"
        else
          maim -s "$OUTFILE"
        fi
        ;;
      *) maim "$OUTFILE" ;;
    esac
    return
  fi

  if command -v scrot >/dev/null 2>&1; then
    case "$MODE" in
      region) scrot -s "$OUTFILE" ;;
      window) scrot -u "$OUTFILE" ;;
      *) scrot "$OUTFILE" ;;
    esac
    return
  fi

  if command -v import >/dev/null 2>&1; then
    case "$MODE" in
      full) import -window root "$OUTFILE" ;;
      *) import "$OUTFILE" ;;
    esac
    return
  fi

  notify "No screenshot tool found"
  exit 1
}

upload() {
  if [ -n "${UPLOAD_COMMAND:-}" ]; then
    sh -c "$UPLOAD_COMMAND \"$OUTFILE\""
    return
  fi

  if [ -n "${UPLOAD_BIN:-}" ]; then
    "$UPLOAD_BIN" "$OUTFILE"
    return
  fi

  printf '%s\n' "$OUTFILE"
}

capture
RESULT="$(upload)"

if [ -n "$RESULT" ]; then
  notify "Saved and copied: $OUTFILE"
else
  copy_clipboard "$OUTFILE"
  notify "Saved: $OUTFILE"
fi
