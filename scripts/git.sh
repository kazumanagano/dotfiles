#!/bin/bash

echo "Git の設定を適用..."

# Git ユーザー情報
git config --global user.name "Kazuma Nagano"
git config --global user.email "nagano.kazuma.na5@gmail.com"

# Git のデフォルト設定
git config --global pull.rebase true
git config --global core.editor "vim"

# .gitignore_global の適用
if [ -f "$DOTFILES_DIR/.gitignore_global" ]; then
  git config --global core.excludesfile "$DOTFILES_DIR/.gitignore_global"
else
  echo "⚠️ .gitignore_global が見つかりません。"
fi

echo "Git の設定が完了しました！"
