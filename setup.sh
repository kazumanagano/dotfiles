#!/bin/bash

set -e

DOTFILES_DIR="$HOME/dotfiles"

# --- Homebrew のインストール ---
if ! command -v brew &> /dev/null; then
  echo "Homebrew をインストールします..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# --- Homebrew の PATH 設定 (Apple Silicon & Intel 両対応) ---
if [[ "$(uname -m)" == "arm64" ]]; then
  HOMEBREW_PATH="/opt/homebrew/bin/brew"
else
  HOMEBREW_PATH="/usr/local/bin/brew"
fi

echo 'eval "$('"$HOMEBREW_PATH"' shellenv)"' >> "$HOME/.zprofile"
eval "$("$HOMEBREW_PATH" shellenv)"

# --- dotfiles リポジトリのクローン ---
if [ -d "$DOTFILES_DIR" ]; then
  echo "dotfiles リポジトリが既に存在します。更新を確認します..."
  cd "$DOTFILES_DIR"

  # ローカル変更があるか確認
  if ! git diff --quiet || ! git diff --staged --quiet; then
    echo "ローカルに未コミットの変更があります。変更を一時コミットします..."
    git add .
    git commit -am "Auto-save before pull"
  fi

  # pull して最新状態に更新
  echo "リモートの最新状態を取得します..."
  git pull --rebase origin main || {
    echo "⚠️ git pull に失敗しました。変更を破棄してリセットしたい場合は以下を実行してください:"
    echo "cd $DOTFILES_DIR && git reset --hard origin/main"
    exit 1
  }

  # 変更がある場合はリモートにプッシュ
  if ! git diff --quiet origin/main; then
    echo "ローカルの変更をリモートにプッシュします..."
    git push origin main || {
      echo "⚠️ git push に失敗しました。手動でプッシュしてください。"
      exit 1
    }
  else
    echo "リモートとの差分はありません。"
  fi
else
  echo "dotfiles リポジトリをクローンします..."
  git clone https://github.com/your-username/dotfiles.git "$DOTFILES_DIR"
fi

# --- .finicky.js のシンボリックリンクを作成 ---
if [ -f "$DOTFILES_DIR/.finicky.js" ]; then
  if [ -L "$HOME/.finicky.js" ]; then
    echo ".finicky.js のシンボリックリンクは既に存在します。"
  else
    ln -sf "$DOTFILES_DIR/.finicky.js" "$HOME/.finicky.js"
    echo "シンボリックリンクを作成: $HOME/.finicky.js -> $DOTFILES_DIR/.finicky.js"
  fi
else
  echo "⚠️ .finicky.js が見つかりません。"
fi

# 各スクリプトを実行
bash "$DOTFILES_DIR/scripts/homebrew.sh"
bash "$DOTFILES_DIR/scripts/macos.sh"
bash "$DOTFILES_DIR/scripts/git.sh"
bash "$DOTFILES_DIR/scripts/zsh.sh"
bash "$DOTFILES_DIR/scripts/xcode.sh"

echo "セットアップが完了しました！ 🚀"