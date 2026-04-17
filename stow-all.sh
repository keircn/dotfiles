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

declare -a all_packages=(
  bash
  zsh
  git
  x11
  autorandr
  gtk-3.0
  gtk-4.0
  ghostty
  GNUstep
  fastfetch
)

declare -A package_targets=(
  [bash]="."
  [zsh]="."
  [git]="."
  [x11]="."
  [autorandr]=".config/autorandr"
  [gtk-3.0]=".config/gtk-3.0"
  [gtk-4.0]=".config/gtk-4.0"
  [ghostty]=".config/ghostty"
  [GNUstep]="."
  [fastfetch]=".config/fastfetch"
)

declare -A package_ignores=(
  [gtk-3.0]='^gtk-3\.0$|^gtk-3\.0/'
  [gtk-4.0]='^gtk-4\.0$|^gtk-4\.0/|(^|/)\._.*'
)

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
  local rel_target="${package_targets[$pkg]-}"
  if [[ -z "$rel_target" ]]; then
    return 1
  fi
  printf '%s' "$HOME/$rel_target"
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

  ignore_regex="${package_ignores[$pkg]-}"
  if [[ -n "$ignore_regex" ]]; then
    cmd+=(--ignore="$ignore_regex")
  fi

  cmd+=(-t "$target" "$pkg")

  echo "==> ${cmd[*]}"
  (cd "$REPO_ROOT" && "${cmd[@]}")
  echo
done

if [[ "$MODE" == "dry-run" ]]; then
  echo "Dry run complete. Re-run with --apply to make changes."
fi
