#!/usr/bin/env bash
# shellcheck disable=SC1091,SC2317
set -eu

# sudo hostnamectl set-hostname xxx
sudo timedatectl set-timezone Asia/Tokyo
sudo apt update && sudo apt upgrade -y && sudo apt install -y zsh git unzip tmux htop tree
sudo passwd
sudo passwd "$USER"
sudo chsh -s "$(which zsh)" "$USER"
sudo chown -R "$USER:$USER" /usr/local/bin
git clone --recursive https://github.com/yechentide/dotfiles.git "$HOME/dotfiles"
~/dotfiles/02_setup_xdg_env.sh
exit

rm .bash* .profile
~/dotfiles/04_install_zinit.sh
vim "$XDG_CONFIG_HOME/zsh/.zshrc"
ln -s "$HOME/dotfiles/config/zsh/starship-remote.toml" "$XDG_CONFIG_HOME/starship.toml"
exit

zinit self-update && zinit update
~/dotfiles/05_setup_config.sh
exit

OS="$(cat /etc/os-release | grep '^ID' | awk -F= '{print $2}')"
declare -r OS

# Docker
if [[ "$OS" == 'debian' || "$OS" == 'ubuntu' ]]; then
  sudo apt-get install ca-certificates curl gnupg lsb-release

  if [[ "$OS" == 'debian' ]]; then
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  fi

  if [[ "$OS" == 'ubuntu' ]]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  fi

  sudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

  sudo groupadd docker
  sudo usermod -aG docker "$USER"
  docker --version
fi

# Network (Oracle Cloud)
if [[ "$OS" == 'ubuntu' ]]; then
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
fi
