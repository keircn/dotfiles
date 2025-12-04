set -g fish_greeting

if test -f ~/.config/fish/env.fish
    source ~/.config/fish/env.fish
end

if type -q starship
    starship init fish | source
    set -gx STARSHIP_CACHE $XDG_CACHE_HOME/starship
    set -gx STARSHIP_CONFIG $XDG_CONFIG_HOME/starship/starship.toml
end

set fish_pager_color_prefix cyan
set fish_color_autosuggestion brblack
set EDITOR nvim

abbr n nvim

abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

abbr g git
abbr ga 'git add'
abbr gb 'git branch'
abbr gc 'git commit'
abbr gca 'git commit --amend'
abbr gco 'git checkout'
abbr gd 'git diff'
abbr gl 'git pull'
abbr gp 'git push'
abbr gst 'git status'
abbr grv 'git remote -v'
abbr glg 'git log --oneline --graph --decorate --all'
abbr gci 'git commit -a -m "Initial commit"'

abbr mkdir 'mkdir -p'
abbr df 'df -h'
abbr du 'du -h --max-depth=1'
abbr free 'free -h'
abbr pls sudo

# if status is-interactive
#     if type -q zellij
# 	eval (zellij setup --generate-auto-start fish | string collect)
#     end
# end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# opencode
fish_add_path /home/kc/.opencode/bin
