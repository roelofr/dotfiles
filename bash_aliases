#!/usr/bin/env bash
# vim: set ft=sh :

# Use vim
export EDITOR=$( which vim )
export VISUAL=$( which vim )

# Git aliases
alias gs='gst'
alias cdr='cd "$( git rev-parse --show-toplevel 2>/dev/null)"'
alias gpo='git push origin'
alias dc='docker-compose'

# Yarn alisases
alias yad='yarn add --dev'
alias yr='yarn run'
alias ys='yarn start'
alias ybu='yarn build'

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
