function emacs
    set emacspath guix shell -m ~/Documents/dotfiles/guix/emacs.scm -- emacs
    if contains -- --help $argv; or contains -- --no-window-system $argv; or contains -- -nw $argv
        $emacspath $argv >/dev/null 2>&1
    else
        $emacspath $argv >/dev/null 2>&1 &
    end
end
