#!/bin/bash

MODE=${1:-select}

upload() {
  local file="$1"
  if [ -z "$file" ] || [ ! -f "$file" ]; then
    echo "Error: no screenshot file to upload"
    return 1
  fi
  hostman upload "$file"
}

tmpfile() {
  echo "/tmp/screenshot-$(date +%s)-$RANDOM.png"
}

capture_with_geom() {
  local geom="$1"
  local out
  out=$(tmpfile)
  if command -v grim >/dev/null 2>&1; then
    grim -g "$geom" "$out"
  else
    echo "Error: grim is not installed"
    return 1
  fi
  echo "$out"
}

case "$MODE" in
select)
  OUTPUT=$(grabit -o 2>/dev/null || true)
  if [ -n "$OUTPUT" ] && [ -f "$OUTPUT" ]; then
    upload "$OUTPUT"
    exit $?
  fi

  if command -v slurp >/dev/null 2>&1 && command -v grim >/dev/null 2>&1; then
    SEL=$(slurp 2>/dev/null)
    if [ -n "$SEL" ]; then
      FILE=$(tmpfile)
      grim -g "$SEL" "$FILE"
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
    data = json.loads(subprocess.check_output(['swaymsg','-t','get_tree']))
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
    outs = json.loads(subprocess.check_output(['swaymsg','-t','get_outputs']))
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
