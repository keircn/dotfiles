def latest-file [] {
    ls | sort-by modified | last
}

def fzf-history [] {
    history | get command | str join "\n" | fzf --height=40% --reverse | str trim
}

def fzf-files [] {
    fd --type f | fzf --height=40% --reverse --preview "bat --color=always --style=numbers --line-range=:500 {}"
}

def fzf-dirs [] {
    fd --type d | fzf --height=40% --reverse
}

def --env fcd [] {
    let dir = (fzf-dirs)
    if ($dir | is-not-empty) {
        cd $dir
    }
}

def fzf-kill [] {
    ps | select pid name | fzf --height=40% --reverse | get pid | kill $in
}

def --env zj [] {
    if (which zellij | is-empty) {
        echo "zellij not found"
        return
    }
    
    if ($env.ZELLIJ? | is-empty) {
        zellij
    } else {
        echo "Already inside zellij session"
    }
}

def --env zj-attach [] {
    if (which zellij | is-empty) {
        echo "zellij not found"
        return
    }
    
    let sessions = (zellij list-sessions --no-formatting | lines | where $it != "")
    if ($sessions | is-empty) {
        echo "No zellij sessions found"
        return
    }
    
    let session = ($sessions | fzf --height=40% --reverse --prompt="Select session: ")
    if ($session | is-not-empty) {
        zellij attach ($session | str trim)
    }
}

def --env zj-new [name?: string] {
    if (which zellij | is-empty) {
        echo "zellij not found"
        return
    }
    
    if ($name | is-empty) {
        zellij new-session
    } else {
        zellij new-session --session-name $name
    }
}

def git-fzf-branch [] {
    git branch --all | str replace '^\*?\s*' '' | str trim | fzf --height=40% --reverse
}

def --env gco [] {
    let branch = (git-fzf-branch)
    if ($branch | is-not-empty) {
        git checkout ($branch | str replace s'^remotes/origin/' '')
    }
}

def git-fzf-log [] {
    git log --oneline --color=always | fzf --ansi --height=40% --reverse --preview "git show --color=always {1}"
}

def processes [] {
    ps | sort-by cpu | reverse
}

def ports [] {
    netstat -tulpn | from ssv --aligned-columns
}

def weather [city?: string = ""] {
    if ($city | is-empty) {
        curl -s "wttr.in/?format=3"
    } else {
        curl -s $"wttr.in/($city)?format=3"
    }
}

def disk-usage [] {
    ls | where type == dir | each { |it| 
        {name: $it.name, size: (du $it.name | math sum)}
    } | sort-by size | reverse
}