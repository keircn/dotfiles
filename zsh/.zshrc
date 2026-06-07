export GPG_TTY=$(tty)

zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

printf '\e[6 q'
function _set_beam_cursor() { printf '\e[6 q' }
precmd_functions+=(_set_beam_cursor)

alias esync='doas emerge --sync'
alias up='doas emerge --update --deep --with-bdeps=y @world'
alias upclean='doas emerge --update --deep --with-bdeps=y @world && doas emerge --depclean && doas revdep-rebuild'
alias es='equery -q list'
alias ei='equery list'
alias rdep='equery depends'
alias cldist='doas eclean distfiles'
alias clpkg='doas eclean packages'
alias echeck='doas revdep-rebuild && doas emerge --pretend @world'
alias enrepo='doas eselect repository enable'
alias orphan='doas emerge --depclean --ask'
alias revdep='revdep-rebuild'
alias fullsync='esync && upclean && cldist && clpkg && revdep'
alias n='nvim'
alias du='du -sh *'
alias free='free -h'
alias mkdir='mkdir -p'
alias ls='eza --icons'

[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

if [[ -d "$HOME/.oh-my-zsh" ]]; then
  export ZSH="$HOME/.oh-my-zsh"
  ZSH_THEME=""
  plugins=(git fnm zsh-autosuggestions zsh-syntax-highlighting vi-mode)
  source "$ZSH/oh-my-zsh.sh"
fi

if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# fnm
if (( $+commands[fnm] )); then
  eval "$(fnm env --use-on-cd)"
fi

[[ -f "$HOME/.cache/hellwal/variableszsh.zsh" ]] && source "$HOME/.cache/hellwal/variableszsh.zsh"
