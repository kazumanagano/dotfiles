#!/bin/bash

set -e

DOTFILES_DIR="$HOME/dotfiles"

# Homebrew のインストール
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# dotfiles リポジトリのクローン
if [ -d "$DOTFILES_DIR" ]; then
  cd "$DOTFILES_DIR" && git pull origin main
else
  git clone https://github.com/your-username/dotfiles.git "$DOTFILES_DIR"
fi

# 各スクリプトを実行
bash "$DOTFILES_DIR/scripts/homebrew.sh"
bash "$DOTFILES_DIR/scripts/macos.sh"
bash "$DOTFILES_DIR/scripts/git.sh"
bash "$DOTFILES_DIR/scripts/zsh.sh"
bash "$DOTFILES_DIR/scripts/xcode.sh"

echo "セットアップが完了しました！ 🚀"
