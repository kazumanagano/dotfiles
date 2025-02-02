#!/bin/bash

echo "Homebrew をセットアップ..."

if [ -f "$HOME/dotfiles/Brewfile" ]; then
  brew bundle --file="$HOME/dotfiles/Brewfile"
else
  echo "⚠️ Brewfile が見つかりません。Homebrew のセットアップをスキップします。"
fi
