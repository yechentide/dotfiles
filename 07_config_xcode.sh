#!/usr/bin/env bash
# shellcheck disable=SC1091
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

declare -r src_path="$ROOT_DIR"/config/IDETemplateMacros.plist
declare -r dest_path="$HOME"/Library/Developer/Xcode/UserData/IDETemplateMacros.plist

cp "$src_path" "$dest_path"
