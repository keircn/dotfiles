if type -q eza
    alias ls 'eza --all --long' # list all
    alias lss 'eza --long --reverse --sort size' # by biggest
    alias lst 'eza --long --tree --level 3' # as tree
    alias lso 'eza --long --sort modified' # by oldest
    alias lsg 'eza --long --header --icons --git --git-ignore' # with git symbols
end
