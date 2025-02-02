#!/bin/bash

echo "Zsh の環境を強化..."

# zsh-autosuggestions のインストール
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting のインストール
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
fi

# .zshrc をシンボリックリンクで適用
echo "シンボリックリンクを設定: $HOME/.zshrc -> $HOME/dotfiles/.zshrc"
ln -sf "$HOME/dotfiles/.zshrc" "$HOME/.zshrc"

# 設定を即時適用
echo "Zsh の設定を適用..."
source "$HOME/.zshrc"

echo "Zsh の設定が完了しました！"
