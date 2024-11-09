#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2086
set -eu

########## ########## ########## ########## ########## ##########
# load constants
set +u
if [[ -z $ROOT_DIR ]]; then
    dotfiles_dir="$(cd "$(dirname "$0")"; pwd)"
    declare -r dotfiles_dir
    source "$dotfiles_dir/00_constants.sh"
    source "$dotfiles_dir/01_precheck.sh"
fi
set -u
########## ########## ########## ########## ########## ##########

# https://wiki.archlinux.org/title/XDG_Base_Directory

logger -p info 'XDGのディレクトリ群を作成します...'

if [[ $OS == 'macos' ]]; then
    sudo cp "$ROOT_DIR/config/zsh/zshenv" /etc/zshenv
elif [[ $OS == 'linux' ]]; then
    sudo cp "$ROOT_DIR/config/zsh/zshenv" ~/.zshenv
fi

if [[ ! -e $XDG_CONFIG_HOME ]]; then mkdir -p "$XDG_CONFIG_HOME"; fi
if [[ ! -e $XDG_CACHE_HOME ]]; then mkdir -p "$XDG_CACHE_HOME"; fi
if [[ ! -e $XDG_DATA_HOME ]]; then mkdir -p "$XDG_DATA_HOME"; fi

logger -p info 'ツール系の設定ファイル用ディレクトリ群を作成します...'

if [[ ! -e $XDG_CONFIG_HOME/zsh ]]; then mkdir -p "$XDG_CONFIG_HOME/zsh"; fi
if [[ ! -e $XDG_CONFIG_HOME/git ]]; then mkdir -p "$XDG_CONFIG_HOME/git"; fi
if [[ ! -e $XDG_CONFIG_HOME/tmux ]]; then mkdir -p "$XDG_CONFIG_HOME/tmux"; fi
if [[ ! -e $XDG_CONFIG_HOME/npm ]]; then mkdir -p "$XDG_CONFIG_HOME/npm"; fi

if [[ ! -e $XDG_CACHE_HOME/zsh ]]; then mkdir -p "$XDG_CACHE_HOME/zsh"; fi
if [[ ! -e $XDG_DATA_HOME/npm ]]; then mkdir -p "$XDG_DATA_HOME/npm/lib"; fi
