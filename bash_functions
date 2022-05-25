#!/usr/bin/env bash
# vim: set ft=sh si sw=4 ts=4 :

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
    # Check if an artisan file exists in the current dir
    if [ -s artisan ]; then
        artisan=artisan
        return 0
    fi

    # Find the git root to determine any other files
    git_root="$( git rev-parse --show-toplevel 2>/dev/null )"

    # If no git root is present, just stop, let's not waste ops
    if [ -z "$git_root" ]; then
        echo "Laravel Artisan file not found"
        return 1
    fi
    
    # Find the artisan file in the git root
    for artisan in "$git_root/artisan" "$git_root/vendor/bin/canvas" "$git_root/please";
    do
        if [ -s "$artisan" ]; then
            return 0;
        fi
    done;
    
    # No artisan file. was found :(
    artisan=
    echo "Laravel artisan not found"
    return 1
}

# Alias `pa` to use Laravel Artisan or binary
pa() {
    if _laravel_find_artisan; then
        php "$artisan" $@
    fi
}

# Bind _laravel autocomplete in zsh
if [ -n "$ZSH_VERSION" ]; then
    compdef _laravel pa
fi

