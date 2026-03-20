#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./stow-all.sh [--apply] [--stow|--restow|--delete] [package ...]
EOF
}

if ! command -v stow >/dev/null 2>&1; then
  echo "Error: GNU stow is not installed." >&2
  exit 1
fi

MODE="dry-run"
ACTION="stow"

declare -a requested_packages=()

while (($#)); do
  case "$1" in
    --apply)
      MODE="apply"
      ;;
    --dry-run)
      MODE="dry-run"
      ;;
    --delete)
      ACTION="delete"
      ;;
    --restow)
      ACTION="restow"
      ;;
    --stow)
      ACTION="stow"
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    --*)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      requested_packages+=("$1")
      ;;
  esac
  shift
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"

declare -a home_packages=(
  bash
  git
)

declare -a config_packages=(
  autorandr
  clipcat
  fish
  fsel
  gtk-3.0
  gtk-4.0
  i3
  i3status
  rofi
  starship
)

declare -a all_packages=("${home_packages[@]}" "${config_packages[@]}")

in_array() {
  local needle="$1"
  shift
  local item
  for item in "$@"; do
    if [[ "$item" == "$needle" ]]; then
      return 0
    fi
  done
  return 1
}

package_target() {
  local pkg="$1"
  if in_array "$pkg" "${home_packages[@]}"; then
    printf '%s' "$HOME"
    return 0
  fi

  if in_array "$pkg" "${config_packages[@]}"; then
    printf '%s' "$HOME/.config/$pkg"
    return 0
  fi

  return 1
}

declare -a packages=()
if ((${#requested_packages[@]})); then
  packages=("${requested_packages[@]}")
else
  packages=("${all_packages[@]}")
fi

echo "Repo: $REPO_ROOT"
echo "Mode: $MODE"
echo "Action: $ACTION"
echo

for pkg in "${packages[@]}"; do
  pkg_dir="$REPO_ROOT/$pkg"
  if [[ ! -d "$pkg_dir" ]]; then
    echo "Skipping '$pkg': package directory not found at $pkg_dir"
    continue
  fi

  if ! target="$(package_target "$pkg")"; then
    echo "Skipping '$pkg': no target mapping defined"
    continue
  fi

  mkdir -p "$target"
  if [[ "$MODE" == "dry-run" ]]; then
    echo "[dry-run] ensured target exists: $target"
  fi

  cmd=(stow -v)
  if [[ "$MODE" == "dry-run" ]]; then
    cmd+=(-n)
  fi

  if [[ "$ACTION" == "delete" ]]; then
    cmd+=(-D)
  elif [[ "$ACTION" == "restow" ]]; then
    cmd+=(-R)
  else
    cmd+=(-S)
  fi

  cmd+=(-t "$target" "$pkg")

  echo "==> ${cmd[*]}"
  (cd "$REPO_ROOT" && "${cmd[@]}")
  echo
done

if [[ "$MODE" == "dry-run" ]]; then
  echo "Dry run complete. Re-run with --apply to make changes."
fi
