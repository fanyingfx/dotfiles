# ------------------------------------------------------------
#/ Global environment (safe for all fish shells)
# ------------------------------------------------------------
set -U fish_greeting

set -g fish_key_bindings fish_default_key_bindings

#set -gx MANPAGER qman
# set -gx MANPAGER 'nvim +Man!'
set -gx MANWIDTH 999
#set -gx PAGER /usr/local/bin/moar

#set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx GOPATH $HOME/.go
set -gx VISUAL /usr/bin/helix
set -gx EDITOR /usr/bin/helix
set -gx SYSTEMD_EDITOR /usr/bin/helix

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

# nix profile (direnv 等通过 nix 安装的工具)
fish_add_path ~/.nix-profile/bin
alias hx helix
if test -r '/home/fan/.opam/opam-init/init.fish'
    source '/home/fan/.opam/opam-init/init.fish' >/dev/null 2>/dev/null
    # 纯 nix 环境（opam 不在 PATH）下跳过钩子，避免每次提示符刷 "Unknown command"
    function __opam_env_export_eval --on-event fish_prompt
        command -q opam; or return
        eval (opam env --shell=fish --readonly 2> /dev/null)
    end
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
    # --- direnv: 进入项目目录时自动加载 .envrc (nix 环境) ---
    # direnv hook fish | source

    # --- Use a light color theme inside VSCode's integrated terminal ---
    # `fish_terminal_color_theme` is read-only, so we force the light variant
    # of a theme that ships both light & dark variants.
    if test "$TERM_PROGRAM" = vscode
        fish_config theme choose ayu --color-theme=light
    end

    starship init fish | source
    zoxide init fish | source
    jj util completion fish | source

    fish_ssh_agent

    alias ls 'eza -snew'
    alias vim nvim
    abbr hxniri 'hx ~/.config/niri/config.kdl'
    alias man qman
    alias open xdg-open
    alias del trash-put # 删除默认进回收站（trash-cli）；真删用 /bin/rm
    alias trash-ls trash-list
    alias rm "echo 'del' moves to trash (trash-list / trash-restore); real delete: /bin/rm"
    abbr rm_lock 'sudo rm /var/lib/pacman/db.lck'
    abbr zig_watch 'zig build -p -Dno-lib --watch -fincremental --prominent-compile-errors'
    abbr rheo_watch 'rheo watch . --html --open'
    alias pirun='pi --model zai/glm-4.7 -p'
    alias edit $EDITOR

    fzf --fish | source
    bind \cf forward-word
    bind \cb backward-word
    bind \cw backward-kill-word
    bind \cz 'fg 2> /dev/null'
    # bind \cd _ctrl_d_guard
    bind \et _trans_cli_bind
    # atuin init fish --disable-up-arrow | source
    # stinkpot 是自定义二进制（不在 nixpkgs），纯 nix 环境下跳过初始化；
    # 钩子函数加运行时守卫，避免每次命令后刷 "Unknown command"
    if command -q stinkpot
        stinkpot init | source
    end
    function __stinkpot_record --on-event fish_postexec
        set -l exit_code $status
        set -l cmd $argv[1]
        command -q stinkpot; or return
        if test -n "$cmd"
            stinkpot add --exit $exit_code -- $cmd
        end
    end
    function __stinkpot_search
        command -q stinkpot; or return
        set -l line (commandline)
        set -l out (stinkpot search -- $line)
        if test -n "$out"
            commandline -r -- $out
        end
        commandline -f repaint
    end

    # `exit` command: confirm before leaving the last fish

    # Alt+T: 命令行有文本则翻译文本,空行时翻译剪贴板
    function _trans_cli_bind
        set -l buf (commandline -b)
        if test -n "$buf"
            trans-cli $buf
        else
            trans-cli
        end
        # 绑定中运行外部命令产生输出后，必须 repaint 才能回到提示符
        commandline -f repaint
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

# Added by Kaho installer
# set -gx PATH "/home/fan/.local/share/kaho/bin" $PATH
