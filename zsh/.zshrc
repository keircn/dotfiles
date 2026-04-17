export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(
  git
  sudo
  extract
  cp
  colored-man-pages
  zsh-autosuggestions
  zsh-syntax-highlighting
)

alias n="nvim"
alias sudo="doas"

alias eav='doas emerge -av'
alias euv='doas emerge -auvDN @world'
alias eclean='doas emerge --ask --depclean'
alias esync='doas emaint sync -a'

source $ZSH/oh-my-zsh.sh

export PNPM_HOME="/home/key/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
