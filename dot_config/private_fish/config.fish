if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    alias ls  eza
    alias vim nvim
    atuin init fish | source
    zoxide init fish | source
end
set -U fish_greeting
set -x MANPAGER 'nvim +Man!'
set -x MANWIDTH 999

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
chezmoi edit $config_path
source $config_path
end

