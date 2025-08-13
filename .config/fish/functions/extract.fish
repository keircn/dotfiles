function extract
    for f in $argv
        if test -f $f
            switch $f
                case '*.tar.bz2'
                    tar xjf $f
                case '*.tar.gz'
                    tar xzf $f
                case '*.tar.xz'
                    tar xJf $f
                case '*.tar'
                    tar xf $f
                case '*.bz2'
                    bunzip2 $f
                case '*.rar'
                    unrar x $f
                case '*.gz'
                    gunzip $f
                case '*.zip'
                    unzip $f
                case '*.Z'
                    uncompress $f
                case '*.7z'
                    7z x $f
                case '*'
                    echo "extract: '$f' cannot be extracted via extract()"
            end
        else
            echo "extract: '$f' is not a valid file"
        end
    end
end
