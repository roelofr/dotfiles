#!/usr/bin/env bash
# vim: set ft=sh :

# Use vim
export EDITOR=$( which vim )
export VISUAL=$EDITOR

# Git aliases
alias gs='gst'
alias cdr='cd "$( git rev-parse --show-toplevel 2>/dev/null)"'
alias gpo='git push origin'
alias dc='docker-compose'

# Yarn alisases
alias yad='npm install --save-dev'
alias yr='npm run'
alias ys='npm start'
alias ybu='npm build'

function cre() {
    if [ ! -f composer.lock -o ! -f composer.json ]; then
        echo "no composer (lock) file found"
        return 1
    fi

    if [ -d vendor/ ]; then
        echo 'removing vendor/...'
        rm -rf vendor/
    fi

    echo 'running composer install'
    composer install --no-suggest --no-interaction
}

# Config for Facade Ignition (anti eye-burn)
IGNITION_THEME=auto
IGNITION_EDITOR=vscode
