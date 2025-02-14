#!/bin/bash

echo "Zsh の環境を強化..."

# zsh-autosuggestions のインストール（すでにある場合はスキップ）
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
else
  echo "zsh-autosuggestions は既にインストールされています。"
fi

# zsh-syntax-highlighting のインストール（すでにある場合はスキップ）
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
else
  echo "zsh-syntax-highlighting は既にインストールされています。"
fi

# .zshrc をシンボリックリンクで適用（冪等性を考慮）
if [ ! -L "$HOME/.zshrc" ]; then
  ln -sf "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"
  echo "シンボリックリンクを作成: $HOME/.zshrc -> $HOME/dotfiles/.zshrc"
else
  echo ".zshrc のシンボリックリンクは既に存在します。"
fi

# 設定を即時適用
source "$HOME/.zshrc"
echo "Zsh の設定が完了しました！"
