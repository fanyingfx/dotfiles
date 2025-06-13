if status is-interactive
    starship init fish | source
    alias ls 'eza -l'
    alias vim nvim
    # alias edit 'chezmoi edit --apply'
    alias open xdg-open
    alias restart-plasma 'killall plasmashell && kstart plasmashell'
    alias cl clear
    alias clt '~/myscripts/clean_text.py'
    alias gd goldendict
    alias mount_smb 'sudo ~/myscripts/mount_smb.sh'
    # alias rg 'rg -uu --glob \'!.git\''
    alias grep rg
    alias codex 'code --ozone-platform=x11 --enable-ozone'
    alias anki_export 'uv --directory /home/fan/code/python/sentence-flashcard run export.py'
    alias g++w 'g++ -Wall -Wextra'
    alias clang++ 'clang++ -Wall -Wextra'
    alias clang 'clang -Wall -Wextra'
    alias del /bin/rm
    alias rm "echo Use 'del', or the full path i.e. '/bin/rm'"
    alias gccw 'gcc -Wall -Wextra'
    alias disasm 'objdump -drwC -Mintel'
    alias gcp 'git clone (wl-paste)'
    atuin init fish --disable-up-arrow | source
    zoxide init fish | source
    jj util completion fish | source

    bind \cf forward-word
    bind \cb backward-word
    bind \cz 'fg 2> /dev/null'
end

fish_ssh_agent

set -U fish_greeting

set -x MANPAGER 'nvim +Man!'
set -x MANWIDTH 999
#set -x PAGER /usr/local/bin/moar
set local_proxy 'http://127.0.0.1:7890'

set -x VIRTUAL_ENV_DISABLE_PROMPT 1
set -x GOPATH $HOME/.go
set -x VISUAL /usr/bin/helix
set -x EDITOR /usr/bin/helix
set -x SYSTEMD_EDITOR /usr/bin/nvim
set -x ELECTRON_OZONE_PLATFORM_HINT auto
set -x DLPFILE "%(title)s.%(ext)s"
set -x DLPFOLDER $HOME/Videos/ytb
set -x OCAMLRUNPARAM b
set -x VCPKG_ROOT /home/fan/code/cpp/vcpkg/
set -x ZVM_INSTALL $HOME/.zvm/self
set -x https_proxy $local_proxy
set -x http_proxy $local_proxy
set -x all_proxy $local_proxy

# set for nju pa
set -x NEMU_HOME /home/fan/code/c/ics2024/nemu
set -x AM_HOME /home/fan/code/c/ics2024/abstract-machine

fish_add_path ~/.config/emacs/bin
fish_add_path ~/.ghcup/bin
fish_add_path ~/myscripts/
fish_add_path $VCPKG_ROOT
fish_add_path $ZVM_INSTALL
fish_add_path $HOME/.zvm/bin
fish_add_path $HOME/bin
fish_add_path $HOME/.moon/bin
fish_add_path $HOME/.local/bin

#export MANWIDTH=999
# https://code.visualstudio.com/docs/terminal/shell-integration
#

alias edit $EDITOR

function virc
    set config_path $HOME/.config/fish/config.fish
    #chezmoi edit --apply $config_path
    helix $config_path
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
    /bin/rm -f -- "$tmp"
end
function tree
    set argc (count $argv)
    if test $argc -eq 0
        eza -T --level 1
    else if test $argc -eq 1
        eza -T $argv[1] --level 1
    else
        eza -T $argv[1] --level $argv[2]
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

    gcc -o /tmp/a.out $file && /tmp/a.out
end
function viconf
    /usr/bin/nvim $HOME/myscripts/predefined/conf.fish
    source $HOME/myscripts/predefined/conf.fish
end

function chcd
    chezmoi re-add
    chezmoi cd
end

function git
    if test "$argv[1]" = push && test "$argv[2]" = -f
        echo '⚠️ trying to force push... [git push -f]'
        read -l -P 'continue? [y/N]: ' confirm
        if test "$confirm" != y
            echo "❌ canceled force push"
            return 1
        end
    end
    command git $argv
end
function shortcuts
    cat ~/code/config/shortcuts.txt
end

function codep
    set profile $argv[1]
    set rest $argv[2..-1]
    switch $profile
        case zig
            set profile ⚡zig
        case moonbit
            set profile 🐰moonbit
        case ocaml
            set profile 🐪Ocaml
        case rust
            set profile 🦀rust
        case go
            set profle 🐹go
        case '*'
            echo "Wrong profile"
            return 1
    end
    command code --profile $profile $rest
end
function rec-mpv
    eza --absolute --sort=created --reverse /home/fan/Videos/recordings/ | head -n 1 | xargs mpv
end
function whisperx

    uvx -p 3.12 whisperx --model small --compute_type int8 --output_format srt --chunk_size 15 $argv[1]

end

set -l profiles "zig moonbit haskell ocaml rust python odin c"
complete -c codep -n "not __fish_seen_subcommand_from $profiles" -f -a "$profiles"

test -r '/home/fan/.opam/opam-init/init.fish' && source '/home/fan/.opam/opam-init/init.fish' >/dev/null 2>/dev/null; or true
# END opam configuration
source $HOME/myscripts/predefined/conf.fish
