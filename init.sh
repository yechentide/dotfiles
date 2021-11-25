#!/usr/bin/env bash
set -u
# git clone https://github.com/yechentide/dotfiles.git

OS='unsupported'

function checkOS() {
	if [[ $(uname) == 'Darwin' ]]; then OS='MacOS'; return 0; fi

	if grep '^NAME="Ubuntu' /etc/os-release >/dev/null; then
		OS='Ubuntu'
	elif grep '^NAME="CentOS' /etc/os-release >/dev/null; then
		OS='CentOS'
	elif grep '^NAME="Amazon' /etc/os-release >/dev/null; then
		OS='Amazon Linux'
	else
		echo 'Your platform is not supported.'
		uname -a
		exit 1
	fi
}
checkOS

function install_dependencies() {
	if [[ $OS == 'MacOS' ]]; groups $(whoami) | grep admin >/dev/null; then
		if which brew >/dev/null; then
			echo 'install some tools ......'
		fi
	fi

	if [[ $OS == 'Ubuntu' ]]; groups $(whoami) | grep sudo >/dev/null; then
		sudo timedatectl set-timezone Asia/Tokyo
		sudo apt update && apt upgrade -y > /dev/null 2>&1
		sudo apt install -y zsh tree jq > /dev/null 2>&1
	fi

	if ! which zsh >/dev/null; then
		echo 'zshがインストールされていません！'
		echo '権限を確認してください！'
		exit 1
	fi
	if ! echo $SHELL | grep zsh > /dev/null 2>&1; then
		echo 'シェルをzshに変えますので、パスワードを入力してください。'
		chsh -s "$(which zsh)"
		echo "再ログインしてください"; echo ""
		exit 0
	fi
}
install_dependencies

function install_zinit_and_setup_zshrc() {
	~/dotfiles/scripts/install_zsh_plugins.sh

	sed -i -e "1i #################################   Zinit   #################################\n" ~/.zshrc
	echo '' >> ~/.zshrc
	echo '#############################################################################' >> ~/.zshrc
	echo '' >> ~/.zshrc
	echo 'source ~/dotfiles/config/zsh/zsh_history.sh' >> ~/.zshrc
	echo 'source ~/dotfiles/config/zsh/shell_alias.sh' >> ~/.zshrc
	echo 'source ~/dotfiles/config/zsh/zsh_custom.sh' >> ~/.zshrc
}
function create_symbolic_links() {
	# git config (.gitignore_global)
	ln -s ~/dotfiles/config/vim/vim_config.txt ~/.vimrc
	ln -s ~/dotfiles/config/tmux/tmux_config.txt ~/.tmux.conf
}
install_zinit_and_setup_zshrc
create_symbolic_links

echo "全ての設定が完了しました。再ログインして、以下のコマンドを実行してください。"
echo "zinit self-update"
















