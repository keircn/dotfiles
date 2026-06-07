export GPG_TTY=$(tty)

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

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git fnm)
source "$ZSH/oh-my-zsh.sh"

eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"

[[ -f "$HOME/.cache/hellwal/variableszsh.zsh" ]] && source "$HOME/.cache/hellwal/variableszsh.zsh"
