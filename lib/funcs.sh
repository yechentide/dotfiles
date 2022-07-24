#!/usr/bin/env bash
set -eu

function install_homebrew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ $? ]]; then
        brew doctor
        brew install mas
    else
        color_print error 'Homebrewのインストールが失敗しました...'
        exit 1
    fi
}

function add_git_config() {
    git config --global user.name "yechentide"
    git config --global user.email "yechentide@gmail.com"
    git config --global core.excludesfile ~/.gitignore_global   # globalなignoreファイルへの参照
    git config --global init.defaultBranch main                 # デフォルトのブランチ名を変更
    git config --global core.autocrlf false                     # Windows/macOS/Linuxの改行コードの自動変換
    git config --global core.ignorecase false                   # ファイル名の大文字と小文字を区別する
    git config --global color.ui true                           # 文字に色をつける
    git config --global core.editor vim                         # デフォルトのエディターを変更
    git config --global core.quotepath false                    # 日本語ファイル名をエンコードしない
    git config --global fetch.prune true                        # 削除されたリモートブランチをローカルに自動的に適用する
    git config --global -l
    echo .DS_Store >> ~/.gitignore_global

    ### 設定の削除
    # git config --global --unset user.name
}

function install_basic_apps() {
    brew install --formula keka
    brew install --cask    google-chrome google-drive
    brew install --cask    qq slack discord steam qqmusic
    mas  install 539883307    # LINE
    mas  install 409201541    # Pages
    mas  install 409203825    # Numbers
    mas  install 409183694    # Keynote
}

function install_dev_apps() {
    brew install --formula git cmake tmux zsh rsync gnu-sed jq cloc
    brew install --cask    iterm2 visual-studio-code coteditor sublime-text paw postman sf-symbols boop
    mas  install 640199958    # Developer
    mas  install 899247664    # TestFlight
    mas  install 1450874784   # Transporter
    mas  install 1557247094   # HextEdit
    mas  install 1616840951   # MotionScape
    mas  install 1528095640   # Interact
}

function install_tool_apps() {
    brew install --formula wget tree neofetch tldr
    brew install --cask    iina obsidian maccy shottr snipaste hiddenbar itsycal rectangle deepl mindmaster
    mas  install 1221250572   # Xnip
    mas  install 1544899154   # 白描截屏取字
    mas  install 1531282066   # AwesomeScreenshot
    mas  install 1592987853   # Screen Recorder by Omi
}

function install_design_apps() {
    brew install --cask    figma magicavoxel iconizer
    mas  install 1289583905   # Pixelmator
    mas  install 1483204219   # PuLaoSs
    mas  install 1219074514   # Vectornator
    mas  install 668208984    # GIPHY
    mas  install 1592728145   # Mockview
    mas  install 1594063111   # Tunacan2
    mas  install 900392332    # DaVinci Resolve Studio
    mas  install 939343785    # Icon Set Creator
}

function unused_apps() {
    exit 1;
    # ほとんど使ってないアプリたち
    # brew install --formula moreutils dateutils coreutils gnutls
    # brew install --formula htop ffmpeg imagemagick nmap arp-scan
    # brew install --cask    utm docker multipass termius
    # brew install --cask    wireshark charles hex-fiend
    # brew install --cask    keycastr stats tencent-lemon kap balenaetcher
    # brew install --cask    godot mediahuman-audio-converter teamviewer vnc-viewer
    # brew install --cask    folx qbittorrent downie              # 下载器
    # brew install —-cask    ntfstool paragon-ntfs tuxera-ntfs    # NTFS软件
}

function install_zinit_and_setup_zshrc() {
    install_zinit

    sed -i -e "1i #################################   Zinit   #################################\n" ~/.zshrc
    echo '' >> ~/.zshrc
    echo '#############################################################################' >> ~/.zshrc
    echo '' >> ~/.zshrc
    echo "source $ROOT_DIR/config/zsh/zsh_history.sh" >> ~/.zshrc
    echo "source $ROOT_DIR/config/zsh/shell_alias.sh" >> ~/.zshrc
    echo "source $ROOT_DIR/config/zsh/zsh_custom.sh"  >> ~/.zshrc

    # create_symbolic_links
    ln -s $ROOT_DIR/config/vim/vim_config.txt ~/.vimrc
    ln -s $ROOT_DIR/config/tmux/tmux_config.txt ~/.tmux.conf
}
