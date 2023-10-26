#!/usr/bin/env bash
# vim: set ft=sh si sw=4 ts=4 :

function ffmpeg-gif() {
    palette=`tempnam`
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

# Move to the root of the Git directory.
function cdr() {
    GIT_ROOT="$( git rev-parse --show-toplevel 2>/dev/null )"
    if [ -z "$GIT_ROOT" ]; then
        echo "Failed to find git root!"
        return 1
    fi

    cd "$GIT_ROOT"
    return 0
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
        echo -e "\033[1;31mNo artisan file found!\033[0m"
        return 1
    fi

    # Find the artisan file in the git root
    for artisan in "$git_root/artisan" "$git_root/vendor/bin/canvas" "$git_root/please";
    do
        if [ -s "$artisan" ]; then
            echo -e "\033[0mForwarding to \033[0;34m$( basename "$artisan" )\033[0m in \033[0;33m$git_root\033[0m"
            return 0;
        fi
    done;

    # No artisan file. was found :(
    artisan=
    echo -e "\033[1;31mNo artisan file found!\033[0m"
    return 1
}

# Alias `pa` to use Laravel Artisan or binary
pa() {
    if _laravel_find_artisan; then
        php "$artisan" $@
    fi
}

# Fix for me using gs instead of gst, which is actually ghostscript
function gs() {
    # Throw a red tantrum
    echo -e "\e[31mDon't use \e[1;32mgs\e[0;31m, use \e[1;32mgst\e[0;31m instead\e[0;0m"
    return 1
}

# Bind _laravel autocomplete in zsh
if [ -n "$ZSH_VERSION" ]; then
    compdef _laravel pa
fi

# MacOS helpers
if [ "$( uname -s )" = "Darwin" ]; then
    app_installed() {
        local appNameOrBundleId=$1

        # Check if the user is trying to check for an app name (ends in .app or doesn't contain a period).
        if [[ $appNameOrBundleId =~ \.[aA][pP][pP]$ || $appNameOrBundleId =~ ^[^.]+$ ]]; then
            osascript -e "id of application \"$appNameOrBundleId\"" >/dev/null 2>&1
            return $?
        else
            osascript -e "id of application id \"$appNameOrBundleId\"" >/dev/null 2>&1
            return $?
        fi
    }
else
    app_installed() {
        # No idea how to support this on Linux
        return 1
    }
fi
