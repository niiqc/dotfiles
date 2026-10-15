set -g fish_greeting

if status is-interactive
    type -q starship; and starship init fish | source
    set -l walfish $HOME/.cache/wal/colors.fish
    test -f $walfish; and source $walfish
end

# Aliases
alias ls="ls --human-readable --group-directories-first --no-group --color=auto"
alias git-tree="git log --oneline --graph --decorate --all"
alias venv="source .venv/bin/activate.fish"
