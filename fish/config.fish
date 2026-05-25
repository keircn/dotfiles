set -U fish_greeting
set EDITOR hx
set -gx GPG_TTY (tty)
set QT_QPA_PLATFORMTHEME qt5ct
set QT_AUTO_SCREEN_SCALE_FACTOR 1

if status is-interactive
    starship init fish | source
end

alias esync 'doas emerge --sync'
alias up 'doas emerge --update --deep --with-bdeps=y @world'
alias upclean 'doas emerge --update --deep --with-bdeps=y @world && doas emerge --depclean && doas revdep-rebuild'
alias es 'equery -q list'
alias ei 'equery list'
alias rdep 'equery depends'
alias cldist 'doas eclean distfiles'
alias clpkg 'doas eclean packages'
alias echeck 'doas revdep-rebuild && doas emerge --pretend @world'
alias enrepo 'doas eselect repository enable'
alias orphan 'doas emerge --depclean --ask'
alias revdep revdep-rebuild
alias fullsync 'esync && upclean && cldist && clpkg && revdep'

alias n nvim
alias du 'du -sh *'
alias free 'free -h'
alias mkdir 'mkdir -p'
alias ls 'eza --icons'
