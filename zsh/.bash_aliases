# vim: set ft=sh :

alias atomhere='atom `pwd`'
alias bfg='java -jar /home/roelof/bin/bfg-1.12.15.jar'

# Use vim
export EDITOR=$( which vim )
export VISUAL=$( which vim )

# Use SSH-ident instead of SSH
SSH_IDENT_BIN=/usr/src/ssh-ident/ssh-ident

# Use ssh-ident for scp and rsyc
alias scp="BINARY_SSH=scp $SSH_IDENT_BIN" 
alias rsync="BINARY_SSH=rsync $SSH_IDENT_BIN" 

