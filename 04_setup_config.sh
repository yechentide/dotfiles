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

{
    echo "source $ROOT_DIR/config/zsh/zsh_history.sh"
    echo "source $ROOT_DIR/config/zsh/shell_alias.sh"
    echo "source $ROOT_DIR/config/zsh/exports.sh"
    echo "source $ROOT_DIR/config/zsh/funcs.sh"
} >> "$XDG_CONFIG_HOME/zsh/.zshrc"

logger -p info 'symbolicリンクを作成します...'
ln -s "$ROOT_DIR/config/vim_config.txt" ~/.vimrc
ln -s "$ROOT_DIR/config/tmux_config.txt" "$XDG_CONFIG_HOME/tmux/tmux.conf"
ln -s "$ROOT_DIR/config/npmrc.txt" "$XDG_CONFIG_HOME/npm/npmrc"

if which git > /dev/null 2>&1; then
    logger -p info 'gitの設定を追加します...'

    git config --global user.name "yechentide"
    git config --global user.email "yechentide@gmail.com"
    git config --global push.default current                    # 現在のブランチ名と同じ名前でリモートリポジトリへpush
    git config --global init.defaultBranch main                 # デフォルトのブランチ名を変更
    git config --global core.autocrlf false                     # Windows/macOS/Linuxの改行コードの自動変換
    git config --global core.ignorecase false                   # ファイル名の大文字と小文字を区別する
    git config --global color.ui true                           # 文字に色をつける
    git config --global core.editor vim                         # デフォルトのエディターを変更
    git config --global core.quotepath false                    # 日本語ファイル名をエンコードしない
    git config --global fetch.prune true                        # 削除されたリモートブランチをローカルに自動的に適用する
    echo .DS_Store >> "$XDG_CONFIG_HOME/git/ignore"

    logger ok 'gitの設定:'
    git config --global -l

    ### 設定の削除
    # git config --global --unset user.name
    if [[ -e ~/.gitconfig ]]; then mv ~/.gitconfig "$XDG_CONFIG_HOME/git/config"; fi
    if [[ -e ~/.gitignore_global ]]; then mv ~/.gitignore_global "$XDG_CONFIG_HOME/git/ignore"; fi
else
    logger warn 'gitコマンドが見つからないので、スキップします'
fi
