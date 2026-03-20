function remove_binaries
    for ext in exe bin out
        for f in (ls *.$ext ^/dev/null)
            if test -f $f
                rm -f $f
            end
        end
    end

    for file in *
        if test -f $file
            set filetype (file --brief --mime-type $file)
            if string match -q application/x-executable $filetype
                rm -f $file
            else if string match -q application/x-dosexec $filetype
                rm -f $file
            end
        end
    end
    endnd
