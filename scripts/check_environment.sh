# TODO: MacOS/Ubuntu
groups $(whoami) | grep sudo > /dev/null 2>&1
if [[ $? == 1 ]]; then
	echo "権限ないのでinstallationをスキップ"
	which zsh > /dev/null 2>&1
	if [[ $? == 1 ]]; then
		echo "zshがインストールされていないので、スクリプトを中止"
		exit 1
	fi
else
	sudo timedatectl set-timezone Asia/Tokyo
	sudo apt update && apt upgrade -y > /dev/null 2>&1
	sudo apt install -y zsh tree jq > /dev/null 2>&1
fi
