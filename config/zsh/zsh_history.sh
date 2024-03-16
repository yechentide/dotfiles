#!/usr/bin/env bash
# shellcheck disable=SC2016,SC2086,SC2296
#################################  HISTORY  #################################

export HISTFILE=$XDG_CACHE_HOME/zsh/hisotry
zstyle :compinstall filename '$ZDOTDIR/.zshrc'

export HISTSIZE=10000                  # メモリに保存される履歴の件数
export SAVEHIST=10000                  # 履歴ファイルに保存される履歴の件数

setopt share_history            # 履歴を他のシェルとリアルタイム共有する

setopt hist_ignore_dups         # 直前と同じコマンドの場合は履歴に追加しない
setopt hist_ignore_all_dups     # ヒストリーに重複を表示しない
setopt hist_ignore_space        # 行頭がスペースのコマンドは記録しない
setopt hist_save_no_dups        # 重複するコマンドが保存されるとき、古い方を削除する。
setopt hist_reduce_blanks       # 余分なスペースを削除する
setopt hist_expire_dups_first   # HISTFILEのサイズがHISTSIZEを超える場合は、最初に重複を削除します
setopt extended_history         # コマンドのタイムスタンプをHISTFILEに記録する

autoload -Uz compinit; compinit
autoload -Uz colors; colors

## 補完候補を一覧表示したとき、Tabや矢印で選択できるようにする
zstyle ':completion:*:default' menu select=1 
## 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
### 補完方法毎にグループ化する。
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' group-name ''
# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=244"

# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt auto_param_slash
# カッコを自動補完
setopt auto_param_keys
# ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt mark_dirs
# 補完キー連打で順に補完候補を自動で補完
setopt auto_menu
# スペルミス訂正
setopt correct
# コマンドラインでも # 以降をコメントと見なす
setopt interactive_comments
# コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt magic_equal_subst
# 語の途中でもカーソル位置で補完
setopt complete_in_word
# 日本語ファイル名を表示可能にする
setopt print_eight_bit
# ディレクトリ名だけでcdする
setopt auto_cd
# ビープ音を消す
setopt no_beep

# コマンドを途中まで入力後、historyから絞り込み
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
