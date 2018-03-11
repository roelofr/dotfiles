# vim: set ft=sh :

function run_command() {
    command_name="$1"
    command_exec="$( bash -c "which $command_name" )"
    shift
    "$command_exec" $@
}

function apt() {
    case "$1" in
        full-upgrade)
            echo "Run full-upgrade using sudo"
            return 1
            ;;
        install|uninstall|purge|autoremove|update|upgrade|clean)
            echo "+sudo apt $@"
            sudo -p "Enter password for %u to $1 packages: " apt $@
            ;;
        *)
            run_command apt $@
            ;;
    esac
}

function apt-get() {
    case "$1" in
        dist-upgrade)
            echo "Run dist-upgrade using sudo"
            return 1
            ;;
        install|uninstall|purge|autoremove|update|upgrade|clean)
            echo "+sudo apt-get $@"
            sudo -p "Enter password for %u to $1 packages: " apt-get $@
            ;;
        *)
            run_command apt-get $@
            ;;
    esac
}

function service() {
    case "$1" in
        reload|restart|stop|start)
            echo "+sudo service $@"
            sudo -p "Password for %u to run $3 on service $2: " service $@
            ;;
        *)
            run_command service $@
            ;;
    esac
}

function gbrm() {
    echo "Pruning..."
    git fetch --prune

    echo "Finding merged branches..."
    branches=$( git branch --merged origin/develop | grep -Ev '^(\*|\s*(master|develop)$)' )

   if [ -z "$branches" ]; then
      echo "Nothing to do"
  else
      echo ${branches[@]} | xargs git branch -d
  fi
}

# Laravel5 basic command completion
_laravel () {
    if  _laravel_find_artisan; then
        if [ -f "$artisan" ]; then
            compadd $(php "$artisan" --raw --no-ansi list | sed "s/[[:space:]].*//g")
        fi
    fi
}

_laravel_find_artisan() {
    if [ -f artisan ]; then
        artisan=artisan
        return 0
    fi
    la_git_root="$( git rev-parse --show-toplevel 2>/dev/null )"
    artisan="$la_git_root/artisan"
    unset la_git_root

    if [ "$artisan" != "/artisan" -a -f "$artisan" ]; then
        return 0
    fi

    artisan=
    echo "Laravel artisan not found"
    return 1
}

_laravel_artisan() {
    if _laravel_find_artisan; then
        php "$artisan" $@
    fi
}

if [ -n "$ZSH_VERSION" ]; then
    compdef _laravel artisan
    compdef _laravel la
    compdef _laravel _laravel_artisan
fi

#Alias
alias la='_laravel_artisan'

alias lacache='la cache:clear'
alias laroutes='la route:list'
alias lavendor='la vendor:publish'

