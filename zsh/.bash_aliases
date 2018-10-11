# vim: set ft=sh :

# Use vim
export EDITOR=$( which vim )
export VISUAL=$( which vim )

# Use SSH-ident instead of SSH
SSH_IDENT_BIN=/usr/src/ssh-ident/ssh-ident

# Use ssh-ident for scp and rsyc
alias scp="BINARY_SSH=scp $SSH_IDENT_BIN"
alias rsync="BINARY_SSH=rsync $SSH_IDENT_BIN"
alias gs='gst'
alias cdr='cd "$( git rev-parse --show-toplevel 2>/dev/null)"'

# Yarn alisases
alias yad='yarn add --dev'
alias yr='yarn run'
alias ys='yarn start'

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
