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

logger -p info 'コマンドラインツールをインストールします...'
count_down 3
brew install --formula cloc jq tealdeer tmux tree
brew install --formula fnm go shellcheck swiftlint

logger -p info 'GUIをインストールします...'
count_down 3
brew install --cask hex-fiend iterm2 itsycal keka maccy loop shottr stats visual-studio-code sf-symbols google-chrome orbstack

logger -p info '次のGUIアプリはApp Storeからインストールしてください'
color_print -n tip 'Xcode, Pixelmator, Logoist, Tunacan2, Developer, TestFlight, MotionScape, Mockview, Interactful'
