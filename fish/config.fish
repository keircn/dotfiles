set -U fish_greeting
set EDITOR hx
set -gx GPG_TTY (tty)

if status is-interactive
    starship init fish | source
    zoxide init fish | source
    source "$HOME/.cargo/env.fish"
end
