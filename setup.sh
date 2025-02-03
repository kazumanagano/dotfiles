#!/bin/bash

set -e

DOTFILES_DIR="$HOME/dotfiles"

# --- Homebrew のインストール ---
if ! command -v brew &> /dev/null; then
  echo "Homebrew をインストールします..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  # --- Homebrew の PATH 設定 (Apple Silicon & Intel 両対応) ---
  if [[ "$(uname -m)" == "arm64" ]]; then
    HOMEBREW_PATH="/opt/homebrew/bin/brew"
  else
    HOMEBREW_PATH="/usr/local/bin/brew"
  fi
  
  echo 'eval "$('"$HOMEBREW_PATH"' shellenv)"' >> "$HOME/.zprofile"
  eval "$("$HOMEBREW_PATH" shellenv)"
else
  echo "Homebrew は既にインストールされています。"
fi

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
