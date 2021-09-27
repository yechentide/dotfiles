sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
cat ~/dotfiles/config/zsh/zinit-pluginsAndTheme.txt >> ~/.zshrc
sed -i "1d" ~/.zshrc
echo ""; echo "powerlevel10kの設定が終わったら、exitを入力してください。"; echo ""
sleep 2
exec $SHELL -l
#zinit self-update
