#!/usr/bin/env bash
set -eu

if ! grep -sq '^ID=arch' /etc/os-release; then
  exit 1;
fi

# UEFIモードでインストールディスクを起動
# >>> Arch Linux install medium (x86_64, UEFI) を選択

# プロンプト (archiso環境) が出るまで待つ
loadkeys jp106
setfont ter-132b

# ネットワークの設定
# >>> iwctl
# >>> [iwd]# device list
# >>> [iwd]# station wlan0 scan
# >>> [iwd]# station wlan0 get-networks
# >>> [iwd]# station wlan0 connect (OvO)-2G
# >>> [iwd]# exit
ping -c 3 archlinux.jp

# システムクロックの設定
timedatectl set-ntp true
timedatectl status

# パーティションの割当
lsblk
cgdisk /dev/sda

mkfs.fat -F 32 /dev/sda1
mkfs.ext4 /dev/sda2
mkswap /dev/sda3

mount /dev/sda2 /mnt
mount --mkdir /dev/sda1 /mnt/boot
swapon /dev/sda3

# ミラーの設定
cat <(curl "https://archlinux.org/mirrorlist/?country=JP") - > /etc/pacman.d/mirrorlist
vim /etc/pacman.d/mirrorlist

# 基本パッケージのインストール
pacstrap /mnt base base-devel linux linux-firmware linux-headers
# pacstrap /mnt base linux linux-firmware
# pacstrap /mnt man-db vim zsh zsh-completions grml-zsh-config


# システム設定
genfstab -U /mnt >> /mnt/etc/fstab    # fstabは、パーティション情報等が書き込まれているファイルで、起動時にどのパーティションをマウントするかなどを指定

# インストールしたシステムにchrootで入る
arch-chroot /mnt

########## ########## ########## ########## ########## ########## ########## ########## ########## ##########

# タイムゾーンの生成
ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

# ハードウェアクロックの設定
hwclock --systohc

# ロケール設定の作成
pacman -Syyu && pacman -S vim
vim /etc/locale.gen
#ja_JP.UTF-8 UTF-8
#en_US.UTF-8 UTF-8
locale-gen
echo LANG=ja_JP.UTF-8 > /etc/locale.conf
echo KEYMAP=jp106 > /etc/vconsole.conf

# コンソールの文字を大きくする
pacman -S terminus-font
echo FONT=ter-132b > /etc/vconsole.conf

# ホスト名の設定
echo nuc > /etc/hostname
vim /etc/hosts
#127.0.0.1    localhost
#::1    localhost
#127.0.1.1    nuc.localdomain    nuc

# ブートローダーのインストール
pacman -S grub efibootmgr    # os-proberはデュアルブート時に必要
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

# ユーザーの作成
passwd
useradd -m -g users -G wheel -s /bin/bash tide
# useradd -m -G wheel neko
passwd tide
pacman -S sudo
vim /etc/sudoers

# ネットワーク設定
pacman -S networkmanager wpa_supplicant dialog
pacman -S iw dhcpcd netctl    # トラブルの際に役に立つ
systemctl enable NetworkManger

# >>> exit
# >>> reboot
# インストールディスクは抜いても大丈夫

########## ########## ########## ########## ########## ########## ########## ########## ########## ##########

# ネットワーク設定の続き
nmtui

# pacman
pacman -Syu
vim /etc/pacman.conf
#Color
#ILoveCandy

# AUR ヘルパーのインストール
sudo pacman -S git go
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
#sudo pacman -S --needed git base-devel
#git clone https://aur.archlinux.org/yay.git
#cd yay && makepkg -si

# GUI環境のインストール (KDE PlasmaとSDDM)
sudo pacman -S acpid xorg sddm plasma konsole
sudo systemctl enable sddm
reboot

# 中文配置
# https://wiki.archlinuxcn.org/wiki/Fcitx5?rdfrom=https%3A%2F%2Fwiki.archlinux.org%2Findex.php%3Ftitle%3DFcitx5_%28%25E7%25AE%2580%25E4%25BD%2593%25E4%25B8%25AD%25E6%2596%2587%29%26redirect%3Dno
# 日本語化
sudo pacman -S noto-fonts-cjk         # font
yay -S nerd-fonts-ricty nerd-fonts-noto-sans-mono ttf-meslo-nerd-font-powerlevel10k ttf-cica
sudo pacman -S fcitx5-im fcitx5-mozc  # input
vim /etc/environment
#GTK_IM_MODULE=fcitx5
#QT_IM_MODULE=fcitx5
#XMODIFIERS=@im=fcitx5

# Other
chsh -s "$(which zsh)"

yay -S openssh
ssh-keygen -t ed25519
