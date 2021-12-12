#################################   ALIAS   #################################

function show-colors-combi() { clear; for fore in `seq 30 37`; do printf "\e[${fore}m \\\e[${fore}m \e[m\n"; for mode in 1 4 5; do printf "\e[${fore};${mode}m \\\e[${fore};${mode}m \e[m"; for back in `seq 40 47`; do printf "\e[${fore};${back};${mode}m \\\e[${fore};${back};${mode}m \e[m"; done; echo; done; echo; done; printf " \\\e[m\n" }
alias show-255colors="seq 0 255 | xargs -I {} printf '\033[38;5;{}m{} '"
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

alias python='python3'
alias pip='pip3'

