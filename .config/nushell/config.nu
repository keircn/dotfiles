source-env ($nu.default-config-dir | path join "env.nu")
source ($nu.data-dir | path join "vendor/autoload/starship.nu")

$env.config = {
    show_banner: false
    buffer_editor: "hx"
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
    }
    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "plaintext"
    }
    cursor_shape: {
        emacs: line
    }
    use_ansi_coloring: true
    edit_mode: emacs
    use_kitty_protocol: false
    highlight_resolved_externals: true
    recursion_limit: 50
}

def weather [city?: string = "London"] {
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

alias ll = ls -la
alias la = ls -a
alias l = ls
alias cat = bat
alias find = fd
alias grep = rg
alias top = btop
alias vim = hx
alias vi = hx