# ------------------------------------------------------------
#/ Global environment (safe for all fish shells)
# ------------------------------------------------------------
set -U fish_greeting

#set -gx MANPAGER qman
# set -gx MANPAGER 'nvim +Man!'
set -gx MANWIDTH 999
#set -gx PAGER /usr/local/bin/moar

#set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx GOPATH $HOME/.go
set -gx VISUAL /usr/bin/helix
set -gx EDITOR /usr/bin/helix
set -gx SYSTEMD_EDITOR /usr/bin/nvim
set -gx ELECTRON_OZONE_PLATFORM_HINT auto
set -gx DLPFILE "%(title)s.%(ext)s"
set -gx DLPFOLDER $HOME/Videos/ytb
set -gx OCAMLRUNPARAM b
set -gx VCPKG_ROOT /home/fan/code/cpp/vcpkg/
set -gx ZVM_INSTALL $HOME/.zvm/self
set -gx ERL_AFLAGS "-kernel shell_history enabled"
set -x https_proxy http://127.0.0.1:7890

fish_add_path ~/.config/emacs/bin \
    ~/.ghcup/bin \
    ~/myscripts/ \
    $VCPKG_ROOT \
    $ZVM_INSTALL \
    $HOME/.zvm/bin \
    $HOME/.moon/bin \
    $HOME/.local/bin \
    $HOME/bin \
    $HOME/.dotnet \
    $HOME/.dotnet/tools
if test -r '/home/fan/.opam/opam-init/init.fish'
    source '/home/fan/.opam/opam-init/init.fish' >/dev/null 2>/dev/null
end

if test -r $HOME/.api_key.fish
    source $HOME/.api_key.fish
end

# pnpm
set -gx PNPM_HOME "/home/fan/.local/share/pnpm"
if not contains -- $PNPM_HOME $PATH
    set -gx PATH $PNPM_HOME $PATH
end
# pnpm end

# ------------------------------------------------------------
# Interactive-only configuration
# ------------------------------------------------------------
if status is-interactive
    starship init fish | source
    zoxide init fish | source
    jj util completion fish | source

    fish_ssh_agent

    alias ls 'eza -snew'
    alias vim nvim
    alias man qman
    alias open xdg-open
    alias del /bin/rm
    alias rm "echo Use 'del', or the full path i.e. '/bin/rm'"
    abbr rm_lock 'sudo rm /var/lib/pacman/db.lck'
    abbr zig_watch 'zig build -p -Dno-lib --watch -fincremental --prominent-compile-errors'
    abbr rheo_watch 'rheo watch . --html --open'
    alias pirun='pi --model zai/glm-4.7 -p'
    alias edit $EDITOR

    bind \cf forward-word
    bind \cb backward-word
    bind \cw backward-kill-word
    bind \cz 'fg 2> /dev/null'
    bind --erase --all \ec
    bind \cd _ctrl_d_guard
    fzf --fish | source
    # atuin init fish --disable-up-arrow | source
    stinkpot init | source

    # --- Don't exit directly when this is the last fish in ghostty ---
    function _is_last_fish
        # pids of every fish living inside a ghostty tab/window.
        # `pstree -T -p (pgrep ghostty)` shows the process tree under each
        # ghostty process (one ghostty process hosts all its tabs/splits),
        # so this naturally covers multiple tabs and multiple windows.
        set -l ghostty_fish
        set -l gpids (pgrep ghostty)
        if test (count $gpids) -gt 0
            set ghostty_fish (pstree -T -p $gpids 2>/dev/null \
                | string match -arg 'fish\((\d+)\)')
        end

        # Only guard fish running inside ghostty. Fish elsewhere (e.g. the
        # VSCode integrated terminal) is managed by its own host, so it is
        # neither protected nor counted as a backup.
        contains -- $fish_pid $ghostty_fish; or return 1

        # Another fish still alive inside ghostty? Then we're not the last.
        for pid in $ghostty_fish
            test "$pid" -eq $fish_pid; and continue
            return 1
        end
        return 0
    end

    function _confirm_exit
        read -l -P '⚠️  Last fish session — really exit? [y/N]: ' confirm
        if string match -qi -- 'y*' "$confirm"
            builtin exit $argv
        end
        echo "❌ exit canceled"
        return 1
    end

    # `exit` command: confirm before leaving the last fish
    function exit --description 'Exit, confirming when this is the last fish process'
        if _is_last_fish
            _confirm_exit $argv
        else
            builtin exit $argv
        end
    end

    # Ctrl+D: delete char if there's text, otherwise go through the exit guard
    function _ctrl_d_guard
        set -l buf (commandline)
        if test -n "$buf"
            commandline -f delete-char
        else if _is_last_fish
            echo
            _confirm_exit
        else
            builtin exit
        end
    end

    function virc
        echo "use 'hxrc'"
    end

    function hxrc
        set config_path $HOME/.config/fish/config.fish
        #chezmoi edit --apply $config_path
        helix $config_path
        source $config_path
    end

    function kw
        kd (wl-paste)
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

    function copypath
        realpath $argv[1] | wl-copy -p
    end

    function chcd
        chezmoi re-add
        cd ~/.local/share/chezmoi
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

    function video_info
        ffprobe -v error -select_streams v:0 \
            -show_entries stream=width,height \
            -of csv=s=x:p=0 $argv[1]
    end
    function clip_to_string_array
        python ~/bin/split_to_array.py (wl-paste)
    end
    function _compile_c_abbr
        set src $argv[1]
        set out (string replace -r '\.c$' '' -- $src)
        echo "cc $src -o $out"
    end
    abbr -a compile --regex '.+\.c$' --position command --function _compile_c_abbr

    function check_books
        ~/code/python/book_search/check_books.sh
    end
end
