$env.config.buffer_editor = "helix"
$env.config.show_banner = false
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")


source ~/.zoxide.nu
# source ~/.config/nushell/stinkpot.nu


$env.config.history = {
  file_format: sqlite
  max_size: 1_000_000
  sync_on_enter: true
  isolation: true
}
