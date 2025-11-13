# macOS 初期設定

## OSのクリーンインストール

- FileVault無効化
- フルネーム: yechentide
- アカウント名: tide (home directory)

## 最初の準備

- キーチェーンを確認する
- OSアップデート
- セキュリティアップデート

## 環境設定

- iCloudの設定
- システム設定
    - キーボードショートカット
- Finderの設定
- ブラウザの設定

## アプリのインストール&設定

- Xcode
- Homebrew

## dotfiles

```bash
curl -L https://api.github.com/repos/yechentide/dotfiles/zipball/main > "$HOME/dotfiles.zip"
unzip ~/dotfiles.zip -d "$HOME"
mv "$(ls $HOME | grep yechentide-dotfiles | head -n 1)" dotfiles
```
