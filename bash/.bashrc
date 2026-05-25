# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi


# Put your fun stuff here.

fish

export PATH=~/.local/bin:~/.cargo/bin:$PATH

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

alias du='du -sh *'
alias free='free -h'
. "$HOME/.cargo/env"
