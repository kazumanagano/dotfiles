#!/bin/bash

echo "Git の設定を適用..."

# Git ユーザー情報（既に設定されているかチェック）
if [ "$(git config --global user.name)" != "Kazuma Nagano" ]; then
  git config --global user.name "Kazuma Nagano"
  echo "Git ユーザー名を設定しました。"
else
  echo "Git ユーザー名は既に設定されています。"
fi

if [ "$(git config --global user.email)" != "nagano.kazuma.na5@gmail.com" ]; then
  git config --global user.email "nagano.kazuma.na5@gmail.com"
  echo "Git ユーザーのメールアドレスを設定しました。"
else
  echo "Git ユーザーのメールアドレスは既に設定されています。"
fi

# Git のデフォルト設定
git config --global pull.rebase true
git config --global core.editor "vim"

# Git のグローバル ignore を ~/.config/git/ignore に設置（冪等性を考慮）
GIT_IGNORE_PATH="$HOME/.config/git/ignore"
mkdir -p "$HOME/.config/git"  # ディレクトリがない場合は作成

if [ -f "$DOTFILES_DIR/.gitignore_global" ]; then
  if [ -L "$GIT_IGNORE_PATH" ]; then
    echo "Git ignore のシンボリックリンクは既に存在します。"
  else
    ln -sf "$DOTFILES_DIR/.gitignore_global" "$GIT_IGNORE_PATH"
    git config --global core.excludesfile "$GIT_IGNORE_PATH"
    echo "Git ignore を設定しました: $GIT_IGNORE_PATH"
  fi
else
  echo "⚠️ .gitignore_global が見つかりません。"
fi

echo "Git の設定が完了しました！"
