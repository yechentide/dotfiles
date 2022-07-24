#!/usr/bin/env bash
set -eu

declare -r ROOT_DIR="$HOME/dotfiles"
declare -r CACHE_DIR="$ROOT_DIR/.cache"
declare -r ARRAY_PATH="$CACHE_DIR/array"
declare -r ANSWER_PATH="$CACHE_DIR/answer"

export PATH="$ROOT_DIR/bin:$PATH"
declare lib=''
for lib in $(ls $ROOT_DIR/lib/*.sh); do source $lib; done

##############################################################################################

if [[ $# == 0 ]]; then color_print error 'サブコマンドを指定してください!'; exit 1; fi
if [[ ! -e $CACHE_DIR ]]; then mkdir $CACHE_DIR; fi
if [[ ! -e $ARRAY_PATH ]]; then touch $ARRAY_PATH; fi
if [[ ! -e $ANSWER_PATH ]]; then touch $ANSWER_PATH; fi

case $1 in
    'apps')
        color_print info 'setup'
        if [[ ! $(uname) == 'Darwin' ]]; then color_print error "${1} 機能はMacOSのみをサポートしています..."; exit 1; fi

        install_homebrew
        install_basic_apps
        install_dev_apps
        install_tool_apps
        install_design_apps

        add_git_config
        ;;
    'shell')
        if ! which zsh >/dev/null; then
            color_print error 'zshがインストールされていません!'
            exit 1
        fi
        if ! echo $SHELL | grep zsh > /dev/null 2>&1; then
            color_print info 'シェルをzshに変えますので、パスワードを入力してください。'
            chsh -s "$(which zsh)"
            color_print info "再ログインしてください"; echo ""
            exit 0
        fi

        # For Linux:
        # sudo timedatectl set-timezone Asia/Tokyo

        install_zinit_and_setup_zshrc
        color_print success "全ての設定が完了しました。再ログインして、以下のコマンドを実行してください。"
        color_print info "zinit self-update"
        ;;
    *)
        color_print warn "サブコマンド ${1} は対応していません!"
        ;;
esac
