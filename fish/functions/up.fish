function up
    set -l count (math (count $argv) + 1)
    set -l path .
    for i in (seq $count)
        set path "../$path"
        echo i >/dev/null
    end
    cd $path
end
