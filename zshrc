# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Disable automatic updates alltogether
zstyle ':omz:update' mode disabled

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="%d %b, %H:%M"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    colored-man-pages
    composer
    git
    mvn
    node
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Load INGRC if present
[[ -s ~/.ingrc ]] && source ~/.ingrc

# Load Homebrew if present
[[ -d ~/.homebrew/bin ]] && export PATH="$PATH:~/.homebrew/bin"

# Add User Binaries if present
[[ -d ~/bin ]] && export PATH="~/bin:$PATH"

# Alias and function files
[[ -s ~/.bash_functions ]] && source ~/.bash_functions
[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases

# Add system autocompletion
if [ -d /etc/profile.d ]; then
    for i in /etc/profile.d/*.sh; do
        if [ -r $i ] && [ $i != '/etc/profile.d/bash_completion.sh' ]; then
            . $i
        fi
    done
    unset i
fi

# Add user-autocompletion
if [ -d "$HOME/.config/zsh-complete/" ]; then
    fpath=("$HOME/.config/zsh-complete" $fpath)
    autoload -U compinit && compinit
fi

# Global NPM packages on a user-level
if ! which nvm >/dev/null 2>&1; then
    export NPM_CONFIG_PREFIX="$HOME/.npm-global"
    export PATH="$PATH:$HOME/.npm-global/bin"
fi

# Hide user when on ING network, on Quintor devices or on my own cool laptop
if [[ `whoami` =~ [a-zA-Z]{2}[0-9]{2}[a-zA-Z]{2} || `hostname` == *quintor.local || `hostname` == "dionysus.roelof.io" ]]; then
    export DEFAULT_USER=`whoami`
fi

# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
unset MANPATH  # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"
