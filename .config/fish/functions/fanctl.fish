function fanctl
    set fanfile /proc/acpi/ibm/fan

    if test (count $argv) -eq 0
        cat $fanfile | grep --colour=never -E 'level|speed'
    else
        echo level $argv[1] | sudo tee $fanfile >/dev/null
        echo "Fan level set to $argv[1]"
        cat $fanfile | grep --colour=never -E 'level|speed'
    end
end
