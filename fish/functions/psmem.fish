function psmem --description 'Show total RSS memory (MiB) used by a program'
    if test (count $argv) -ne 1
        echo "Usage: psmem <program>" >&2
        return 1
    end

    ps -C $argv[1] -o rss= | awk '{sum += $1} END {printf "%.1f MiB\n", sum/1024}'
end
