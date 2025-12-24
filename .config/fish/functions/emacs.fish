function emacs
    set emacspath (which emacs)
    if contains -- --no-window-system $argv; or contains -- -nw $argv
        $emacspath $argv
    else
        $emacspath $argv &
    end
end
