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

logger -p info 'Homebrewをインストールします...'
count_down 3

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
if [[ $? ]]; then
    brew doctor
else
    logger -p error 'Homebrewのインストールが失敗しました'
    exit 1
fi

logger -p info 'コマンドラインツールをインストールします...'
count_down 3
brew install --formula cloc fnm go jq shellcheck swiftlint tealdeer tmux tree

logger -p info 'GUIをインストールします...'
count_down 3
brew install --cask hex-fiend iterm2 itsycal keka maccy obsidian rectangle shottr stats visual-studio-code sf-symbols hiddenbar

logger -p info '次のGUIアプリはApp Storeからインストールしてください'
color_print -n tip 'Xcode, Pixelmator, Logoist, Tunacan2, Developer, TestFlight, MotionScape, Mockview, Interactful'
