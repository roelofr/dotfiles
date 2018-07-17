# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/home/roelof/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="gentoo"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git composer yarn colored-man-pages)

source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
export LANG=en_GB.UTF-8

# Add user bin
USER_BIN="${HOME}/bin"
if [ -d "$USER_BIN" ]
then
	export PATH="$USER_BIN:$PATH"
fi

# Add styling
# As created by MetaMist → https://github.com/Metamist/dotfiles

function prompt_char {
	if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

# PROMPT='%{$fg_bold[red]%}%m %{$reset_color%}%{$fg[yellow]%}%(4~|%-1~/…/%2~|%4~) $(git_prompt_info)%_$(prompt_char)%{$reset_color%} '

COL_LEFT_BASE=028
COL_LEFT_ACT=+

COL_RIGHT_BASE=027
COL_RIGHT_ACT=+

COL_L1=$COL_LEFT_BASE
COL_L2=$(expr $COL_L1 $COL_LEFT_ACT 6)
COL_L3=$(expr $COL_L1 $COL_LEFT_ACT 6)
COL_L4=$(expr $COL_L3 $COL_LEFT_ACT 6)

COL_R1=$COL_RIGHT_BASE
COL_R2=$(expr $COL_R1 $COL_RIGHT_ACT 6)
COL_R3=$(expr $COL_R2 $COL_RIGHT_ACT 6)
COL_R4=$(expr $COL_R3 $COL_RIGHT_ACT 6)

PROMPT="%{$fg[yellow]%}%(4~|%-1~/…/%2~|%4~) %{$fg[green]%}$ %{$reset_color%}"
RPROMPT="%{$fg[cyan]%}\$(current_branch)%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=") "

bindkey "^[Od" backward-word
bindkey "^[Oc" forward-word

# alias ghci="stack ghci"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.


if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Add Yarn
yarnbin="$( yarn global bin )"
if [ ! -z "$yarnbin" -a -d "$yarnbin" ]; then
    export PATH="$PATH:$yarnbin"
fi
unset yarnbin

if [ -d /etc/profile.d ]; then
    for i in /etc/profile.d/*.sh; do
        if [ -r $i ] && [ $i != '/etc/profile.d/bash_completion.sh' ]; then
            . $i
        fi
    done
    unset i
fi


# added by travis gem
[ -f /home/roelof/.travis/travis.sh ] && source /home/roelof/.travis/travis.sh
