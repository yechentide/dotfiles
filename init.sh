#!/usr/bin/env bash
# command > /dev/null 2>&1
# ln -s オリジナルファイル シンボリックリンク（影分身、ポインタ）
set -u

groups $(whoami) | grep sudo > /dev/null 2>&1
if [[ $? == 1 ]]; then
	echo "権限ないのでinstallationをスキップ"
	which zsh > /dev/null 2>&1
	if [[ $? == 1 ]]; then
		echo "zshがインストールされていないので、スクリプトを中止"
		exit 1
	fi
fi
sudo timedatectl set-timezone Asia/Tokyo
sudo apt update && apt upgrade -y > /dev/null 2>&1
sudo apt install -y zsh tree jq > /dev/null 2>&1

cd ~
#git clone ......... > /dev/null 2>&1
#chmod u+x dotfiles/*.sh

echo $SHELL | grep zsh > /dev/null 2>&1
if [[ $? == 1 ]]; then
	chsh -s "$(which zsh)"
	echo "再ログインしてください"
	echo ""
	exit 1
fi
mkdir ~/.bash.bak
mv ~/.bash* ~/.bash.bak > /dev/null 2>&1
mv ~/.profile ~/.bash.bak > /dev/null 2>&1

###### Zinit
~/dotfiles/scripts/install_zinit.sh
sed -i -e "1i #################################   Zinit   #################################\n" ~/.zshrc
echo "" >> ~/.zshrc

###### .zshrc
cat ~/dotfiles/config/zsh/zsh_config.txt >> ~/.zshrc
cat ~/dotfiles/config/zsh/shell_alias.txt >> ~/.zshrc

# git config (.gitignore_global)
ln -s ~/dotfiles/config/vim/vim_config.txt ~/.vimrc
ln -s ~/dotfiles/config/tmux/tmux_config.txt ~/.tmux.conf

echo "全ての設定が完了しました。再ログインして、以下のコマンドを実行してください。"
echo "zinit self-update"
