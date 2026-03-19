function ls
    set base_cmd eza --icons=auto

    switch $argv[1]
        case l
            $base_cmd -lh $argv[2..-1]
        case ll
            $base_cmd -lha --sort=name --group-directories-first $argv[2..-1]
        case la
            $base_cmd -la $argv[2..-1]
        case ld
            $base_cmd -lhD $argv[2..-1]
        case lt
            $base_cmd --tree $argv[2..-1]
        case lsd
            $base_cmd -ld */ $argv[2..-1]
        case '*'
            $base_cmd $argv
    end
end
