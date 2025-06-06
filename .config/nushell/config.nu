source-env ($nu.default-config-dir | path join "custom-commands.nu")
source-env ($nu.default-config-dir | path join "env.nu")

$env.config = {
    show_banner: false
    buffer_editor: "hx"
}

source ($nu.data-dir | path join "vendor/autoload/starship.nu")
