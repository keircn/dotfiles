export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gentoo"
ZSH_DISABLE_COMPFIX="true"
ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/oh-my-zsh"
ZSH_COMPDUMP="${ZSH_CACHE_DIR}/zcompdump-${HOST}-${ZSH_VERSION}"
typeset -U path PATH

plugins=(
  git
  sudo
  extract
  cp
  colored-man-pages
  zsh-autosuggestions
  zsh-syntax-highlighting
)

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP

HISTFILE="$HOME/.zsh_history"
HISTSIZE=20000
SAVEHIST=20000
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

export EDITOR="nvim"
export VISUAL="$EDITOR"

alias n="nvim"
alias vi="nvim"
alias vim="nvim"
alias sudo="doas"

alias eav='doas emerge -av'
alias euv='doas emerge -auvDN @world'
alias eclean='doas emerge --ask --depclean'
alias esync='doas emaint sync -a'

path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  $path
)

source $ZSH/oh-my-zsh.sh

export PNPM_HOME="/home/key/.local/share/pnpm"
path=("$PNPM_HOME" $path)
