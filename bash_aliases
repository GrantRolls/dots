#stop ctrl-s from freezing terminal
stty -ixon

######################## git stuff from Udacity git course
GITCOL="\[\033[38;5;209m\]"
DIRCOL="\[\033[38;5;139m\]"
USERCOL="\[\033[38;5;79m\]"
RESETCOL="\[\033[0m\]"
export GIT_PS1_SHOWUPSTREAM="auto"
# Change command prompt
source ~/.git-prompt.sh
GIT_PS1="$USERCOL\u$GITCOL\$(__git_ps1)$DIRCOL \w $ $RESETCOL"
export PS1=$GIT_PS1
######################## end git stuff
