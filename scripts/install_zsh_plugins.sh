sh -c "$(curl -fsSL https://git.io/zinit-install)"
cat ~/dotfiles/config/zsh/zinit-pluginsAndTheme.txt >> ~/.zshrc
sed -i "1d" ~/.zshrc
echo ''; echo 'powerlevel10kの設定が終わったら、exitを入力してください。'; echo ''
sleep 3
exec $SHELL -l
#zinit self-update