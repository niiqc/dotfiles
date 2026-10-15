function emacs --wraps emacs --description 'Run Emacs detached, except in terminal mode'
    if contains -- --help $argv; or contains -- --no-window-system $argv; or contains -- -nw $argv
        command emacs $argv
    else
        command emacs $argv >/dev/null 2>&1 &
        disown
    end
end
