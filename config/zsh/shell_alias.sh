#################################   ALIAS   #################################

alias showall255color="seq 0 255 | xargs -I {} printf '\033[38;5;{}m{}'"
#alias ls='ls -G' # for MacOS
alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias l='clear && ls -la'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias g='git'
alias gs='git status'
alias ga='git add'
alias gan='git add -n'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gcmsg='git commit -m'
alias gc='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gf='git fetch'
alias gpu='git push'
alias gpd='git pull'

