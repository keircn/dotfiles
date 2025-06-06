source-env ($nu.default-config-dir | path join "custom-commands.nu")
source-env ($nu.default-config-dir | path join "env.nu")

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
        vi_insert: line
        vi_normal: block
    }
    use_ansi_coloring: true
    edit_mode: vi
    use_kitty_protocol: false
    highlight_resolved_externals: true
    recursion_limit: 50
}

source ($nu.data-dir | path join "vendor/autoload/starship.nu")

alias ll = ls -la
alias la = ls -a
alias l = ls
alias cat = bat
alias find = fd
alias grep = rg
alias top = btop
alias vim = hx
alias vi = hx