#!/usr/bin/env bash
# shellcheck disable=SC2142
#################################   ALIAS   #################################

alias show-255colors="seq 0 255 | xargs -I {} printf '\033[38;5;{}m{} '"
alias battery-info='ioreg -c AppleSmartBattery | grep -i Capacity'
alias PlistBuddy='/usr/libexec/PlistBuddy'
alias symbolicatecrash='/Applications/Xcode.app/Contents/SharedFrameworks/DVTFoundation.framework/Versions/A/Resources/symbolicatecrash'
alias rscp='rsync -zh --progress'

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias l='clear && ls -la'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias python='python3'
alias pip='pip3'

#################################   ALIAS - Git   #################################

alias gpush='git push'
alias gpull='git pull'
alias gpullc='git pull origin $(git branch --show-current)'
alias gf='git fetch'
alias gfo='git fetch origin'

alias gs='git status'
alias gsb='git status -sb'
alias gb='git branch'
alias gba='git branch -a'
alias gbr='git branch -r'
alias gbm='git branch -m'
alias gbd='git branch -d'
alias gbD='git branch -D'
alias gbs='git switch'
alias gbb='git switch -'
alias gbc='git switch -c'

alias ga='git add'
alias gan='git add -n'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend'

alias gsl='git stash list'
alias gss='git stash save'
alias gsa='git stash apply'
alias gsp='git stash pop'
alias gsd='git stash drop'

alias gl='git log'
alias gll='git log --first-parent --graph --abbrev-commit --decorate'
alias glo='git log --oneline'

alias gd='git diff'
alias gdn2="git log -n 2 | grep '^commit' | tr '\n' ' ' | awk '{printf \"%s %s\", \$4, \$2}' | xargs git diff"

alias gr='git restore'
alias grs='git restore --staged'

alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gms='git merge --squash'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'

alias gre='git remote'
alias grev='git remote -v'
alias gres='git remote show'
alias grea='git remote add'
alias grer='git remote remove'
