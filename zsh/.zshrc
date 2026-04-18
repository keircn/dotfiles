# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
HIST_STAMPS="dd/mm/yyyy"

zstyle ':omz:update' mode reminder
zstyle ':completion:*' matcher-list ''

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8
export EDITOR='nvim'

export ARCHFLAGS="-arch $(uname -m)"

alias n="nvim"

eval "$(zoxide init zsh)"
alias cd="z"

[ -s "/home/key/.bun/_bun" ] && source "/home/key/.bun/_bun"
