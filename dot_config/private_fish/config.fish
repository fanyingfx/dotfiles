if status is-interactive

    starship init fish | source
    atuin init fish --disable-up-arrow | source
    zoxide init fish | source
    jj util completion fish | source

    alias ls 'eza -snew'
    alias vim nvim
    alias open xdg-open
    alias del /bin/rm
    alias rm "echo Use 'del', or the full path i.e. '/bin/rm'"
    abbr rm_lock 'sudo rm /var/lib/pacman/db.lck'
    alias zig_watch 'zig build -p -Dno-lib --watch -fincremental --prominent-compile-errors'
    alias pirun='pi --model zai/glm-4.7 -p'

    bind \cf forward-word
    bind \cb backward-word
    bind \cw backward-kill-word
    bind \cz 'fg 2> /dev/null'
end

fish_ssh_agent

set -U fish_greeting

set -x MANPAGER 'nvim +Man!'
set -x MANWIDTH 999
#set -x PAGER /usr/local/bin/moar
set local_proxy 'http://127.0.0.1:7890'

#set -x VIRTUAL_ENV_DISABLE_PROMPT 1
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
set -x ERL_AFLAGS "-kernel shell_history enabled"

fish_add_path ~/.config/emacs/bin
fish_add_path ~/.ghcup/bin
fish_add_path ~/myscripts/
fish_add_path $VCPKG_ROOT
fish_add_path $ZVM_INSTALL
fish_add_path $HOME/.zvm/bin
fish_add_path $HOME/.moon/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/bin
fish_add_path $HOME/.dotnet
fish_add_path $HOME/.dotnet/tools

alias edit $EDITOR

function virc
    set config_path $HOME/.config/fish/config.fish
    #chezmoi edit --apply $config_path
    helix $config_path
    source $config_path
end
function yt-down
    #set -lx all_proxy $local_proxy
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
    edge-playback --text
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

function rec-mpv
    eza --absolute --sort=created --reverse /home/fan/Videos/recordings/ | head -n 1 | xargs mpv
end

function ytb-mpv
    eza -I "*.png|*.srt" --absolute --sort=created --reverse /home/fan/Videos/ytb/ | head -n 1 | xargs mpv
end
function fish_remove_path
    if set -l index (contains -i "$argv" $fish_user_paths)
        set -e fish_user_paths[$index]
        echo "Removed $argv from the path"
    end
end
function video_info
    ffprobe -v error -select_streams v:0 \
        -show_entries stream=width,height \
        -of csv=s=x:p=0 $argv[1]
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
            set profile 🐹go
    end
    code --profile $profile $rest
end
set -l profiles "zig moonbit haskell ocaml rust python odin c"
complete -c codep -n "not __fish_seen_subcommand_from $profiles" -f -a "$profiles"

test -r '/home/fan/.opam/opam-init/init.fish' && source '/home/fan/.opam/opam-init/init.fish' >/dev/null 2>/dev/null; or true
# END opam configuration
#source $HOME/myscripts/predefined/conf.fish
source $HOME/.api_key.fish

# pnpm
set -gx PNPM_HOME "/home/fan/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
