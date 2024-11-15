#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2034
set -eu

########## ########## ########## ########## ########## ##########
# load constants
set +u
if [[ -z $ROOT_DIR ]]; then
    dotfiles_dir="$(cd "$(dirname "$0")"; pwd)"
    declare -r dotfiles_dir
    source "$dotfiles_dir/00_constants.sh"
fi
set -u
########## ########## ########## ########## ########## ##########

if [[ $(uname) == 'Darwin' ]]; then
    logger -p info 'OS: MacOS'
    OS='macos'
elif [[ $(uname) == 'Linux' ]]; then
    logger -p info 'OS: Linux'
    OS='linux'
else
    logger -p error "このOSでは使えません: $(uname)"
    exit 1
fi
