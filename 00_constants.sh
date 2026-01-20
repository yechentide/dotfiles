#!/usr/bin/env bash
# shellcheck disable=SC2034
set -eu

declare -r ROOT_DIR="$HOME/dotfiles"

if [[ ! -e $ROOT_DIR ]]; then
    echo "dotfilesを次の場所に置いてください: $ROOT_DIR"
    exit 1
fi

export PATH="$ROOT_DIR/bin:$PATH"

declare -r XDG_CONFIG_HOME="$HOME/.config"
declare -r XDG_CACHE_HOME="$HOME/.cache"
declare -r XDG_DATA_HOME="$HOME/.local/share"
declare -r XDG_STATE_HOME="$HOME/.local/state"
