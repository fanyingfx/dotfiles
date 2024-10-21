if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    alias ls  eza
    alias vim nvim
    alias edit 'chezmoi edit --apply'
    alias chcd 'chezmoi cd'
    alias open 'xdg-open'
    alias restart_plasma 'killall plasmashell && kstart plasmashell'
    alias cl 'clear'
    alias gd 'goldendict'
    alias mount_smb='sudo ~/myscripts/mount_smb.sh'
    alias grep = rg
    atuin init fish | source
    zoxide init fish | source
end
set -U fish_greeting
set -x MANPAGER 'nvim +Man!'
set -x MANWIDTH 999
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

set -x ELECTRON_OZONE_PLATFORM_HINT auto
fish_add_path ~/.config/emacs/bin
fish_add_path ~/.ghcup/bin

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

function yy
	set tmp (mktemp -t "yazi-cwd.XXXXXX")
	yazi $argv --cwd-file="$tmp"
	if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
		builtin cd -- "$cwd"
	end
	rm -f -- "$tmp"
end
function tree
    set argc (count $argv)
    if test $argc -eq 0
	eza -T --level 1
    else 
	eza -T --level $argv
    end
end

