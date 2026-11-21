set -g fish_greeting

set -gx EDITOR nvim
set -gx VISUAL $EDITOR

if status is-interactive
    abbr -a t "tmux new-session -A -s main"
end
