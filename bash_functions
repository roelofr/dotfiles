#!/usr/bin/env bash
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

function ffmpeg-gif() {
    palette="/tmp/palette.png"
    filters="fps=24,scale=320:-1:flags=lanczos"

    ffmpeg -v warning -i $1 -vf "$filters,palettegen" -y $palette
    ffmpeg -v warning -i $1 -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $2
}

function git-authors() {
    git ls-tree -r -z --name-only HEAD -- "$@" \
        | xargs -0 -n1 git blame --line-porcelain HEAD \
        | grep  "^author " \
        | sort \
        | uniq -c \
        | sort -nr
}

lag ()
{
    GIT_ROOT="$( git rev-parse --show-toplevel 2>/dev/null )"
    LOG_ROOT="${GIT_ROOT}/storage/logs";
    if [ ! -d "$LOG_ROOT" ]; then
        LOG_ROOT="${GIT_ROOT}/local/storage/logs";
        if [ ! -d "$LOG_ROOT" ]; then
            echo "No log directory found";
            return 1;
        fi;
    fi;
    LOG_FILE="$(
        find "$LOG_ROOT" -type f \( -name 'laravel-*.log' -or -name 'statamic-*.log' \) 2>/dev/null \
        | xargs ls -t 2>/dev/null \
        | head -n1
    )";
    if [ -z "$LOG_FILE" -o ! -f "$LOG_FILE" ]; then
        echo "No log file found";
        return 1;
    fi;
    vim "+set autoread" + "${LOG_FILE}"
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
    if [ -f please ]; then
        artisan=please
        return 0
    fi

    la_git_root="$( git rev-parse --show-toplevel 2>/dev/null )"
    artisan="$la_git_root/artisan"
    unset la_git_root

    if [ "$artisan" != "/artisan" -a -f "$artisan" ]; then
        return 0
    fi

    artisan="$la_git_root/please"
    unset la_git_root

    if [ "$artisan" != "/please" -a -f "$artisan" ]; then
        echo "+php please"
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

bfg () {
    BFG_FILE="$( find "${HOME}/apps/bfg" -type f -name '*.jar' -print | head -n1 )"

    if [ -z "$BFG_FILE" ]; then
        echo "BFG not installed!"
        return 1
    fi

    java -jar "$BFG_FILE" $@
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

