function fish_prompt -d "Minimal prompt showing the current directory"
    set_color $fish_color_cwd
    echo -n (path basename $PWD)
    set_color normal
    echo -n ' ) '
end
