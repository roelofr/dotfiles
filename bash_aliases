#!/usr/bin/env bash
# vim: set ft=sh :

# Use vim
export EDITOR=$( which vim )
export VISUAL=$EDITOR

# Git aliases
alias cdr='cd "$( git rev-parse --show-toplevel 2>/dev/null)"'
alias gpo='git push origin'
alias dc='docker-compose'

# Fix for me using gs instead of gst, which is actually ghostscript
function gs() {
    # Throw a red tantrum
    echo -e "\e[31mDon't use gs\e[0m"
    return 1
}

# Config for Facade Ignition (anti eye-burn)
IGNITION_THEME=auto
IGNITION_EDITOR=vscode
