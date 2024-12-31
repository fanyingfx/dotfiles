if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    alias ls  'eza -l'
    alias vim nvim
    alias edit 'chezmoi edit --apply'
    alias chcd 'chezmoi cd'
    alias open 'xdg-open'
    alias restart-plasma 'killall plasmashell && kstart plasmashell'
    alias cl 'clear'
    alias clt '~/myscripts/clean_text.py'
    alias gd 'goldendict'
    alias mount_smb 'sudo ~/myscripts/mount_smb.sh'
    alias rg 'rg -uu --glob \'!.git\''
    alias grep rg
    alias codex 'code --ozone-platform=x11 --enable-ozone'
    alias anki_export 'uv --directory /home/fan/code/python/sentence-flashcard run export.py'
    alias g++w 'g++ -Wall -Wextra'
    alias clang++ 'clang++ -Wall -Wextra'
    alias clang 'clang -Wall -Wextra'
    alias gccw 'gcc -Wall -Wextra'
    atuin init fish | source
    zoxide init fish | source
end

fish_ssh_agent

set -U fish_greeting

set -x MANPAGER 'nvim +Man!'
set -x MANWIDTH 999
#set -x PAGER /usr/local/bin/moar

set -x VIRTUAL_ENV_DISABLE_PROMPT 1
set -x GOPATH $HOME/.go
set -x VISUAL /usr/bin/nvim
set -x EDITOR /usr/bin/nvim
set -x ELECTRON_OZONE_PLATFORM_HINT auto
set -x DLPFILE "%(title)s.%(ext)s"
set -x OCAMLRUNPARAM b
set -x VCPKG_ROOT = /home/fan/code/cpp/vcpkg/

# set for nju pa
set -x NEMU_HOME /home/fan/code/c/ics2024/nemu
set -x AM_HOME /home/fan/code/c/ics2024/abstract-machine

fish_add_path ~/.config/emacs/bin
fish_add_path ~/.ghcup/bin
fish_add_path ~/myscripts/
fish_add_path $VCPKG_ROOT
#fish_add_path $HOME/.local/bin

#export MANWIDTH=999
# https://code.visualstudio.com/docs/terminal/shell-integration

function virc
    set config_path $HOME/.config/fish/config.fish
    chezmoi edit --apply $config_path
    source $config_path
end
function yt-down
    yt_down.py (wl-paste)
end
function dlp-paste
    yt-dlp (wl-paste) $argv -f -
end
function dlp-cwd
    yt-dlp (wl-paste) -o "%(title)s.%(ext)s"
end
function kt
    kd -t (wl-paste)
end
function kw
    kd (wl-paste)
end
function play-text
    edge-playback --text (wl-paste)
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
    else if test $argc -eq 1
	eza -T  $argv[1] --level 1
    else 
	eza -T  $argv[1] --level $argv[2]
    end
end
function cdf
    cd (eza -D -a | fzf)
end
function copypath
    realpath $argv[1] | wl-copy -p
end

function crun
    if test (count $argv) -ne 1
        echo "Usage: run_c <file.c>"
        return 1
    end

    set file $argv[1]

    # 检查文件是否存在
    if not test -f $file
        echo "Error: File '$file' not found."
        return 1
    end

    # 提取文件名（去掉扩展名）
    set base_name (basename $file .c)

    # 编译
    gcc $file -o $base_name
    if test $status -ne 0
        echo "Compilation failed."
        return 1
    end

    # 运行
    ./$base_name && mv $base_name /tmp
end
# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/home/fan/.opam/opam-init/init.fish' && source '/home/fan/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration


