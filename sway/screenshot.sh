#!/bin/bash

MODE=${1:-select}

run_timeout() {
  local t="$1"
  shift
  if command -v timeout >/dev/null 2>&1; then
    timeout "$t" "$@"
    return $?
  fi
  "$@" &
  local pid=$!
  (
    sleep ${t%[s]}
    kill -0 "$pid" 2>/dev/null && kill "$pid" 2>/dev/null
  ) &
  local killer=$!
  wait "$pid"
  local rc=$?
  kill "$killer" 2>/dev/null || true
  return $rc
}

run_timeout_capture() {
  local t="$1"
  shift
  local tmp
  tmp=$(mktemp)
  if command -v timeout >/dev/null 2>&1; then
    timeout "$t" "$@" >"$tmp" 2>&1
    local rc=$?
    cat "$tmp"
    rm -f "$tmp"
    return $rc
  fi
  "$@" >"$tmp" 2>&1 &
  local pid=$!
  (
    sleep ${t%[s]}
    kill -0 "$pid" 2>/dev/null && kill "$pid" 2>/dev/null
  ) &
  local killer=$!
  wait "$pid"
  local rc=$?
  kill "$killer" 2>/dev/null || true
  cat "$tmp"
  rm -f "$tmp"
  return $rc
}

upload() {
  local file="$1"
  if [ -z "$file" ] || [ ! -f "$file" ]; then
    if command -v notify-send >/dev/null 2>&1; then
      notify-send -u normal -i dialog-error "Screenshot" "No screenshot file to upload"
    else
      echo "Error: no screenshot file to upload"
    fi
    return 1
  fi

  local out tmp rc
  tmp=$(mktemp)
  run_timeout_capture 20s sh -c "hostman upload '$file' < /dev/null" >"$tmp" 2>&1
  rc=$?
  out=$(cat "$tmp" 2>/dev/null || true)
  rm -f "$tmp"
  CLEAN=$(printf '%s' "$out" | strip_ansi)

  if [ $rc -eq 0 ]; then
    URL=$(printf '%s' "$CLEAN" | grep -oE 'https?://[^[:space:]]+' | head -n1 || true)
    if [ -n "$URL" ]; then
      if command -v notify-send >/dev/null 2>&1; then
        notify-send -u low -i camera-photo "Screenshot uploaded" "$URL"
      else
        echo "Uploaded: $URL"
      fi
    else
      if command -v notify-send >/dev/null 2>&1; then
        notify-send -u low -i camera-photo "Screenshot uploaded" "Upload succeeded"
      else
        echo "Upload succeeded"
      fi
    fi
    if [[ "$file" == /tmp/screenshot-* ]]; then
      rm -f -- "$file" || true
    fi
    return 0
  else
    ERR=$(printf '%s' "$CLEAN" | head -n1)
    if command -v notify-send >/dev/null 2>&1; then
      notify-send -u normal -i dialog-error "Screenshot upload failed" "$ERR"
    else
      echo "Upload failed: $ERR"
    fi
    return $rc
  fi
}

notify() {
  local title="$1"
  local body="$2"
  local icon="$3"
  if command -v notify-send >/dev/null 2>&1; then
    notify-send -u low -i "$icon" "$title" "$body"
  else
    echo "$title: $body"
  fi
}

tmpfile() {
  echo "/tmp/screenshot-$(date +%s)-$RANDOM.png"
}

strip_ansi() {
  if command -v perl >/dev/null 2>&1; then
    perl -pe 's/\e\[[\d;?]*[ -\/]*[@-~]//g'
  else
    sed -r 's/\x1B\[[0-9;]*[mK]//g'
  fi
}

capture_with_geom() {
  local geom="$1"
  local out
  out=$(tmpfile)
  if command -v grim >/dev/null 2>&1; then
    if command -v timeout >/dev/null 2>&1; then
      timeout 10s grim -g "$geom" "$out"
    else
      grim -g "$geom" "$out"
    fi
  else
    echo "Error: grim is not installed"
    return 1
  fi
  echo "$out"
}

case "$MODE" in
select)
  OUTPUT=$(run_timeout_capture 10s grabit -o 2>/dev/null || true)
  rc=$?
  if [ $rc -eq 0 ] && [ -n "$OUTPUT" ] && [ -f "$OUTPUT" ]; then
    upload "$OUTPUT"
    exit $?
  fi

  if command -v slurp >/dev/null 2>&1 && command -v grim >/dev/null 2>&1; then
    SEL=$(run_timeout_capture 20s slurp 2>/dev/null || true)
    rc=$?
    if [ $rc -eq 0 ] && [ -n "$SEL" ]; then
      FILE=$(capture_with_geom "$SEL") || exit 1
      upload "$FILE"
      exit $?
    fi
  fi

  echo "Error: interactive screenshot failed (no grabit and no slurp+grim)"
  exit 1
  ;;

window)
  GEOM=$(
    python3 - <<'PY'
import sys, json, subprocess
def find(obj):
    if isinstance(obj, dict):
        if obj.get('focused'):
            r = obj.get('rect')
            if r:
                print(f"{r.get('x',0)},{r.get('y',0)} {r.get('width',0)}x{r.get('height',0)}")
                sys.exit(0)
        for v in obj.values():
            find(v)
    elif isinstance(obj, list):
        for i in obj:
            find(i)
try:
    data = json.loads(subprocess.check_output(['swaymsg','-t','get_tree'], timeout=2))
    find(data)
except Exception:
    pass
PY
  )

  if [ -z "$GEOM" ]; then
    echo "Error: couldn't determine focused window geometry"
    exit 1
  fi

  FILE=$(capture_with_geom "$GEOM") || exit 1
  upload "$FILE"
  ;;

monitor)
  if command -v jq >/dev/null 2>&1; then
    GEOM=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused==true) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
  else
    GEOM=$(
      python3 - <<'PY'
import sys, json, subprocess
try:
    outs = json.loads(subprocess.check_output(['swaymsg','-t','get_outputs'], timeout=2))
    for o in outs:
        if o.get('focused'):
            r = o.get('rect')
            print(f"{r.get('x',0)},{r.get('y',0)} {r.get('width',0)}x{r.get('height',0)}")
            break
except Exception:
    pass
PY
    )
  fi

  if [ -z "$GEOM" ]; then
    echo "Error: couldn't determine focused output geometry"
    exit 1
  fi

  FILE=$(capture_with_geom "$GEOM") || exit 1
  upload "$FILE"
  ;;

*)
  echo "Usage: $0 [select|window|monitor]"
  exit 2
  ;;
esac
