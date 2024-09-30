if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    alias ls  eza
    alias vim nvim
    alias edit 'chezmoi edit --apply'
    alias chcd 'chezmoi cd'
    atuin init fish | source
    zoxide init fish | source
end
set -U fish_greeting
set -x MANPAGER 'nvim +Man!'
set -x MANWIDTH 999
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

set -x ELECTRON_OZONE_PLATFORM_HINT auto
#fish_default_key_bindings
#fish_vi_key_bindings
#bind -M insert \cp history-search-backward
#bind -M insert \cn history-search-forward
#bind -M insert \ce end-of-line

#export MANWIDTH=999
# https://code.visualstudio.com/docs/terminal/shell-integration
string match -q "$TERM_PROGRAM" "vscode"
and . (code --locate-shell-integration-path fish)
set -x GOPATH $HOME/.go
fish_ssh_agent
set -x VISUAL /usr/bin/nvim
set -x EDITOR /usr/bin/nvim

function virc
    set config_path $HOME/.config/fish/config.fish
    chezmoi edit --apply $config_path
    source $config_path
end

