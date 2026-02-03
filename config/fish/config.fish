if status is-interactive
    if command -v tmux >/dev/null 2>&1 \
            && status is-interactive \
            && not string match -rq screen "$TERM" \
            && not string match -rq tmux "$TERM" \
            && test -z "$TMUX"

        tmux attach -t default; or exec tmux new -s default
        exit
    end
end

# fish colorscheme
set walfish $HOME/.cache/wal/colors.fish
if test -f $walfish
    source $walfish
end

# starship
starship init fish | source

set -g fish_greeting

# ~ ls to lsd aliases
alias ls='/usr/bin/lsd'
alias l='/usr/bin/lsd --almost-all --long'
alias llm='/usr/bin/lsd --timesort --long'
alias lS='/usr/bin/lsd --oneline --classic'
alias lt='/usr/bin/lsd --tree --depth=2'

# ~ cat to batcat aliases
alias cat='/usr/bin/bat --theme ansi'
alias catn='/usr/bin/bat --theme ansi -p'
alias catnl='/usr/bin/bat --theme ansi --paging=never'

alias dev='quickemu --vm /home/nick/Documents/vms/quickemu/Development/archlinux-latest.conf'
alias kali='quickemu --vm /home/nick/Documents/vms/quickemu/Kali/kali-current.conf'

alias vi='/usr/bin/nvim'

# ============== ASDF ==============
if test -z $ASDF_DATA_DIR
    set _asdf_shims "$HOME/.asdf/shims"
else
    set _asdf_shims "$ASDF_DATA_DIR/shims"
end

if not contains $_asdf_shims $PATH
    set -gx --prepend PATH $_asdf_shims
end

set --erase _asdf_shims

# ============== END ASDF ==============

# set GUIX_PROFILE "$HOME/.config/guix/current"

# if test -d "$GUIX_PROFILE"
#     source "$GUIX_PROFILE/etc/profile"
# end

if not contains "/home/nick/.config/guix/current/bin" $PATH
    set -gx PATH /home/nick/.config/guix/current/bin $PATH
end

# uv
fish_add_path "/home/nick/.local/share/../bin"

# fish_vi_key_bindings
# fish_vi_cursor --force-iterm
#
# set -g fish_cursor_insert line
# set -g fish_cursor_default block
