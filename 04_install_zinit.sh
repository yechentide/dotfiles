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

logger -p info "$ROOT_DIR/config/zsh/zinit_plugins_and_theme.txt の設定を参照し、"
logger -p info "必要なものを $XDG_CONFIG_HOME/zsh/.zshrc に追記してください。"
logger -p info 'それが終わったらターミナルを開き直して、zinit self-update を実行してください'
