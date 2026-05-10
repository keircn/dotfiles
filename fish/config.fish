set -U fish_greeting
set EDITOR hx
set -gx GPG_TTY (tty)
set QT_QPA_PLATFORMTHEME qt5ct
set QT_AUTO_SCREEN_SCALE_FACTOR 1
alias n nvim

if status is-interactive
    starship init fish | source
    zoxide init fish | source
    source "$HOME/.cargo/env.fish"
end
