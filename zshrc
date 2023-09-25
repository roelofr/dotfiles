# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
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

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
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

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Add system autocompletion
if [ -d /etc/profile.d ]; then
    for i in /etc/profile.d/*.sh; do
        if [ -r $i ] && [ $i != '/etc/profile.d/bash_completion.sh' ]; then
            . $i
        fi
    done
    unset i
fi

# Add user-autocompletion, if present
if [ -d "$HOME/.config/zsh-complete/" ]; then
    fpath=("$HOME/.config/zsh-complete" $fpath)
    autoload -U compinit && compinit
fi

# Global NPM packages on a user-level, only if nvm isn't present
export NVM_DIR="$HOME/.nvm"
if which nvm > /dev/null 2>&1; then
    # noop
elif [ -d "$NVM_DIR" ]; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
else
    export NPM_CONFIG_PREFIX="$HOME/.npm-global"
    export PATH="$PATH:$HOME/.npm-global/bin"
fi

# Determine default user for devices.
CURRENT_USER="$( whoami )"
CURRENT_HOST="$( hostname )"
if [[ "$CURRENT_USER" =~ "^[a-zA-Z]{2}[0-9]{2}[a-zA-Z]{2}$" ]]; then
    export DEFAULT_USER=`whoami`
elif [[ "$CURRENT_HOST" =~ "^[a-z]+-pc\.quintor\.local$" ]]; then
    export DEFAULT_USER=rroos
elif [[ "$CURRENT_HOST" =~ "^[a-z]+\.roelofr\.dev$" ]]; then
    export DEFAULT_USER="roelof"
fi


# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
unset MANPATH  # delete if you already modified MANPATH elsewhere in your config
export MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# Alias files
[[ -s ~/.bash_functions ]] && source ~/.bash_functions
[[ -s ~/.bash_aliases ]] && source ~/.bash_aliases

# Add possible binary folders
[[ -d ~/bin ]] && export PATH="$HOME/bin:$PATH"
[[ -d ~/.homebrew/bin ]] && export PATH="$PATH:$HOME/.homebrew/bin"
[[ -d /opt/homebrew/bin ]] && export PATH="$PATH:/opt/homebrew/bin"

# Load McFly
which mcfly 2>&1 > /dev/null && eval "$( mcfly init zsh )" || true

# Mount Jabba
[ -s "$HOME/.jabba/jabba.sh" ] && source "$HOME/.jabba/jabba.sh"

# Connect SDKMan
[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ] && source "$HOME/.sdkman/bin/sdkman-init.sh"
