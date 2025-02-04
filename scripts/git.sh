#!/bin/bash

echo "Git の設定を適用..."

# Git ユーザー情報
git config --global user.name "Kazuma Nagano"
git config --global user.email "nagano.kazuma.na5@gmail.com"

# Git のデフォルト設定
git config --global pull.rebase true
git config --global core.editor "vim"

# Git のグローバル ignore を ~/.config/git/ignore に設置
GIT_IGNORE_PATH="$HOME/.config/git/ignore"
mkdir -p "$HOME/.config/git"  # ディレクトリがない場合は作成

if [ -f "$DOTFILES_DIR/.gitignore_global" ]; then
  echo "グローバル Git ignore を適用: $GIT_IGNORE_PATH"
  ln -sf "$DOTFILES_DIR/.gitignore_global" "$GIT_IGNORE_PATH"
  git config --global core.excludesfile "$GIT_IGNORE_PATH"
else
  echo "⚠️ .gitignore_global が見つかりません。"
fi

echo "Git の設定が完了しました！"
