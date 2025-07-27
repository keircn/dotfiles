# ~/.config/fish/config.fish

set -g fish_greeting

if test -f ~/.config/fish/env.fish
    source ~/.config/fish/env.fish
end

if test -f ~/.config/fish/code.fish
    source ~/.config/fish/code.fish
end

if type -q starship
    starship init fish | source
    set -gx STARSHIP_CACHE $XDG_CACHE_HOME/starship
    set -gx STARSHIP_CONFIG $XDG_CONFIG_HOME/starship/starship.toml
end

set fish_pager_color_prefix cyan
set fish_color_autosuggestion brblack
set GOPATH $HOME/Documents/go
set EDITOR hx

alias l='eza -lh --icons=auto'
alias ls='eza --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt='eza --tree --icons=auto'
alias la='eza -la --icons=auto'
alias lsd='eza -ld --icons=auto */'
alias lg lazygit
alias pnpm bun
alias yarn bun

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
abbr please sudo
abbr c code
abbr klte 'bun create next-app@latest --example https://github.com/keircn/klte'

function up
    set -l count (math (count $argv) + 1)
    set -l path .
    for i in (seq $count)
        set path "../$path"
    end
    cd $path
end

function extract
    for f in $argv
        if test -f $f
            switch $f
                case '*.tar.bz2'
                    tar xjf $f
                case '*.tar.gz'
                    tar xzf $f
                case '*.tar.xz'
                    tar xJf $f
                case '*.tar'
                    tar xf $f
                case '*.bz2'
                    bunzip2 $f
                case '*.rar'
                    unrar x $f
                case '*.gz'
                    gunzip $f
                case '*.zip'
                    unzip $f
                case '*.Z'
                    uncompress $f
                case '*.7z'
                    7z x $f
                case '*'
                    echo "extract: '$f' cannot be extracted via extract()"
            end
        else
            echo "extract: '$f' is not a valid file"
        end
    end
end

set -gx PNPM_HOME "$HOME/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

if not contains -- "$HOME/.local/bin" $PATH
    set -gx PATH "$HOME/.local/bin" $PATH
end

if not contains -- "$GOPATH/bin" $PATH
    set -gx PATH "$GOPATH/bin" $PATH
end

if status is-interactive
    set ZELLIJ_AUTO_ATTACH true
    set ZELLIJ_AUTO_EXIT true
end

if not set -q ZELLIJ
    if test "$ZELLIJ_AUTO_ATTACH" = true
        zellij --layout ~/.config/zellij/layout.kdl attach -c
    else
        zellij --layout ~/.config/zellij/layout.kdl
    end

    if test "$ZELLIJ_AUTO_EXIT" = true
        kill $fish_pid
    end
end
