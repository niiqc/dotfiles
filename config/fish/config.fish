set -g fish_greeting

set walfish $HOME/.cache/wal/colors.fish

if test -f $walfish
    source $walfish
end

if command -q starship
    starship init fish | source
end

# Aliases
alias ls="ls --human-readable --group-directories-first --no-group --color=auto"
alias git-tree="git log --oneline --graph --decorate --all"
alias venv="source .venv/bin/activate.fish"

function mkcd --description "Create and cd to directory"
    mkdir $argv
    and cd $argv
end

# Paths
fish_add_path "/home/nick/.local/share/../bin"
