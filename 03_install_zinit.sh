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

logger -p info 'zinitをインストールします...'

bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
cat "$ROOT_DIR/config/zsh/zinit_plugins_and_theme.txt" >> "$XDG_CONFIG_HOME/zsh/.zshrc"

logger -p info 'ターミナルを開き直して、zinit self-update を実行してください'
