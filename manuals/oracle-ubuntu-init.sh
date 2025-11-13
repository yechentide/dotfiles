#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2317
set -eu

# sudo hostnamectl set-hostname xxx
sudo timedatectl set-timezone Asia/Tokyo
sudo apt update && sudo apt upgrade -y && sudo apt install -y zsh tree zip unzip
sudo passwd
sudo passwd ubuntu
sudo chsh -s "$(which zsh)" ubuntu
sudo chown -R ubuntu:ubuntu /usr/local/bin
git clone --recursive https://github.com/yechentide/dotfiles.git ~/dotfiles
~/dotfiles/02_setup_xdg_env.sh
exit

rm .bash* .profile
~/dotfiles/04_install_zinit.sh
vim "$XDG_CONFIG_HOME/zsh/.zshrc"
exit

zinit self-update
~/dotfiles/05_setup_config.sh

# Docker
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo groupadd docker
sudo usermod -aG docker "$USER"
docker --version

# Network
# sudo iptables -D INPUT 5
sudo iptables -L INPUT --line-numbers -n
sudo iptables -I INPUT 5 -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT 6 -p tcp --dport 443 -j ACCEPT
sudo iptables -I INPUT 7 -p tcp --dport 8080 -j ACCEPT
sudo netfilter-persistent save
sudo vim /etc/iptables/rules.v4
sudo iptables -F
sudo netfilter-persistent reload
sudo iptables -L INPUT --line-numbers -n
