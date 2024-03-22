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

function divider() {
    echo
    print_divider | color_print -n tip
}

divider
color_print -n tip '[CLI - インストール] '
color_print -n info 'wget   gnu-sed   neofetch   smartmontools'
color_print -n info 'moreutils   dateutils   coreutils   gnutls'
color_print -n info 'htop   ffmpeg   imagemagick   nmap   arp-scan'
color_print -n info 'termius   cmake   goose   sqlc'

divider
color_print -n tip '[CLI - 更新]'
color_print -n info 'zsh   git   rsync'

divider
color_print -n tip '[GUI - インストール]'
color_print -n info 'google-chrome   steam   iina   deepl'
color_print -n info 'orbstack   coteditor   sublime-text   boop   snipaste   rapidapi'
color_print -n info 'magicavoxel   inkscape   blender   godot   mindmaster   figma   iconizer'
color_print -n info 'keycastr   kap   balenaetcher   mediahuman-audio-converter'
color_print -n info 'wireshark   charles   teamviewer   vnc-viewer'
color_print -n info '下载器:   folx   qbittorrent   downie'
color_print -n info 'NTFS软件:   ntfstool   paragon-ntfs   tuxera-ntfs'

divider
color_print -n tip '[App Store - インストール]'
color_print -n info 'GIPHY_CAPTURE   Linearity_Curve(Vectornator)'
color_print -n info 'Xnip   白描截屏取字   PuLaoSs   Icon_Set_Creator'
color_print -n info 'DaVinci_Resolve_Studio'
