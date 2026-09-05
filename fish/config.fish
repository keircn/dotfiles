set -U fish_greeting
abbr t "tmux new-session -A -s main"

if status is-interactive
    starship init fish | source
end
