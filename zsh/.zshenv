export EDITOR=nvim
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export PNPM_HOME="$HOME/.local/share/pnpm"

typeset -U PATH path
path=(
  "$HOME/.local/share/pnpm"
  "$HOME/.cargo/bin"
  "$HOME/.local/bin"
  "$PNPM_HOME/bin"
  $path
)
