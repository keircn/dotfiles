$env.config.buffer_editor = "hx"
$env.config.show_banner = false

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

def latest-file [] {
    ls | sort-by modified | last
}
