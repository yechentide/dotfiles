#!/usr/bin/env bash
set -u

~/dotfiles/scripts/check_environment.sh
echo $SHELL | grep zsh > /dev/null 2>&1
if [[ $? == 1 ]]; then
	chsh -s "$(which zsh)"
	echo "再ログインしてください"; echo ""
	exit 1
fi

cd ~
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
