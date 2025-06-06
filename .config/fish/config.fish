# ~/.config/fish/config.fish

set -g fish_greeting

if test -f ~/.config/fish/hyde_config.fish
    source ~/.config/fish/hyde_config.fish
end

if type -q starship
    starship init fish | source
    set -gx STARSHIP_CACHE $XDG_CACHE_HOME/starship
    set -gx STARSHIP_CONFIG $XDG_CONFIG_HOME/starship/starship.toml
end

set fish_pager_color_prefix cyan
set fish_color_autosuggestion brblack
set GOPATH /home/keiran/Documents/go
set EDITOR vim

alias l='eza -lh   --icons=auto' # long list
alias ls='eza      --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --tree --icons=auto' # list folder as tree

abbr c code

abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

abbr mkdir 'mkdir -p'

# pnpm
set -gx PNPM_HOME "/home/keiran/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
