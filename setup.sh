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

  # ローカル変更がある場合は一時保存
  if ! git diff --quiet || ! git diff --staged --quiet; then
    echo "ローカルに未コミットの変更があります。変更を一時保存して `git pull` を実行します。"
    git stash push -m "Auto stash before pull"
  fi

  # pull して最新状態に更新
  git pull origin main || {
    echo "⚠️ git pull に失敗しました。変更を破棄してリセットしたい場合は以下を実行してください:"
    echo "cd $DOTFILES_DIR && git reset --hard origin/main"
    exit 1
  }

  # 一時保存した変更を戻す
  if git stash list | grep -q "Auto stash before pull"; then
    echo "変更を元に戻します..."
    git stash pop
  fi

  # 変更がある場合は自動コミットしてリモートへ push
  if ! git diff --quiet || ! git diff --staged --quiet; then
    echo "変更をコミットしてリモートにプッシュします..."
    git add .
    git commit -m "Auto-sync: ローカルの変更をリモートに反映"
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

# 各スクリプトを実行
bash "$DOTFILES_DIR/scripts/homebrew.sh"
bash "$DOTFILES_DIR/scripts/macos.sh"
bash "$DOTFILES_DIR/scripts/git.sh"
bash "$DOTFILES_DIR/scripts/zsh.sh"
bash "$DOTFILES_DIR/scripts/xcode.sh"

echo "セットアップが完了しました！ 🚀"
