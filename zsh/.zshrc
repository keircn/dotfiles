export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="steeef"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false"
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

export GOPATH=$HOME/Documents/go
export PATH=$PATH:$GOPATH/bin

export ANDROID_HOME=/opt/android-sdk
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH="/home/key/.cache/.bun/bin:$PATH"
