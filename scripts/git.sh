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

# GPG署名の設定
echo "GPG署名の設定を開始..."

# GPG署名を有効にする
if [ "$(git config --global commit.gpgsign)" != "true" ]; then
  git config --global commit.gpgsign true
  echo "Git コミットのGPG署名を有効にしました。"
else
  echo "Git コミットのGPG署名は既に有効です。"
fi

# GPGプログラムのパスを設定（macOSの場合）
if [[ "$OSTYPE" == "darwin"* ]]; then
  # HomebrewでインストールされたGPGのパスを設定
  if command -v gpg &> /dev/null; then
    GPG_PATH=$(which gpg)
    git config --global gpg.program "$GPG_PATH"
    echo "GPGプログラムのパスを設定しました: $GPG_PATH"
    
    # gnupgのリンクを確実にする（念のため）
    if command -v brew &> /dev/null; then
      echo "gnupgのリンクを更新..."
      brew link --overwrite gnupg 2>/dev/null || echo "gnupgのリンクは既に正しく設定されています。"
    fi
    
    # pinentry-macの設定（Brewfileでインストール済みを前提）
    if command -v pinentry-mac &> /dev/null; then
      # gpg-agent.confの設定
      mkdir -p "$HOME/.gnupg"
      chmod 700 "$HOME/.gnupg"
      
      # pinentry-programの設定を更新または追加
      PINENTRY_PATH=$(which pinentry-mac)
      AGENT_CONF="$HOME/.gnupg/gpg-agent.conf"
      
      if [ -f "$AGENT_CONF" ]; then
        # 既存の設定がある場合は更新
        if grep -q "^pinentry-program" "$AGENT_CONF"; then
          # sedを使って既存の設定を更新
          sed -i '' "s|^pinentry-program.*|pinentry-program $PINENTRY_PATH|" "$AGENT_CONF"
          echo "pinentry-programの設定を更新しました。"
        else
          # 設定がない場合は追加
          echo "pinentry-program $PINENTRY_PATH" >> "$AGENT_CONF"
          echo "pinentry-programを設定しました。"
        fi
      else
        # ファイルがない場合は新規作成
        echo "pinentry-program $PINENTRY_PATH" > "$AGENT_CONF"
        echo "gpg-agent.confを作成し、pinentry-programを設定しました。"
      fi
      
      # gpg-agentを再起動
      gpgconf --kill gpg-agent
      echo "GPG agentを再起動しました。"
    else
      echo "⚠️ pinentry-macがインストールされていません。"
      echo "  Brewfileからインストールしてください: brew bundle"
    fi
  else
    echo "⚠️ GPGがインストールされていません。"
    echo "  Brewfileからインストールしてください: brew bundle"
  fi
fi

# GPG_TTYの設定を.zshrcに追加（まだない場合）
if [[ "$OSTYPE" == "darwin"* ]] && [[ -f "$HOME/.zshrc" ]]; then
  if ! grep -q "export GPG_TTY" "$HOME/.zshrc"; then
    echo "" >> "$HOME/.zshrc"
    echo "# GPG署名のためのTTY設定" >> "$HOME/.zshrc"
    echo 'export GPG_TTY=$(tty)' >> "$HOME/.zshrc"
    echo "GPG_TTY設定を.zshrcに追加しました。"
  else
    echo "GPG_TTY設定は既に.zshrcに存在します。"
  fi
fi

# GPGキーの自動設定（gh CLIを使用）
setup_gpg_key() {
  echo ""
  echo "🔐 GPG署名キーの自動設定..."
  
  # gh CLIの認証確認
  if ! command -v gh &> /dev/null; then
    echo "⚠️ gh CLIがインストールされていません。"
    echo "  Brewfileからインストールしてください: brew bundle"
    return 1
  fi
  
  # GitHub認証の確認
  if ! gh auth status &> /dev/null; then
    echo "GitHub認証が必要です。認証を開始します..."
    gh auth login
  fi
  
  # 既存のGPGキーをチェック
  USER_EMAIL="nagano.kazuma.na5@gmail.com"
  EXISTING_KEY=$(gpg --list-secret-keys --keyid-format=long | grep -B2 "$USER_EMAIL" | grep "sec" | awk '{print $2}' | cut -d'/' -f2 | head -1)
  
  if [ -n "$EXISTING_KEY" ]; then
    echo "既存のGPGキーが見つかりました: $EXISTING_KEY"
    
    # Gitの署名キー設定
    git config --global user.signingkey "$EXISTING_KEY"
    echo "Git署名キーを設定しました: $EXISTING_KEY"
    
    # GitHubにキーが登録されているかチェック
    if ! gh gpg-key list | grep -q "$EXISTING_KEY"; then
      echo "GitHubにGPGキーを登録しています..."
      gpg --armor --export "$EXISTING_KEY" | gh gpg-key add -
      echo "✅ GitHubにGPGキーを登録しました。"
    else
      echo "✅ GPGキーは既にGitHubに登録されています。"
    fi
  else
    echo "GPGキーが見つかりません。新しいキーを作成しますか？ (y/N)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
      echo "GPGキーを作成しています..."
      
      # GPGキーの自動生成（非対話式）
      cat > /tmp/gpg_gen_key_script << EOF
%echo GPGキーを生成中...
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: Kazuma Nagano
Name-Email: $USER_EMAIL
Expire-Date: 2y
%no-protection
%commit
%echo 完了
EOF
      
      gpg --batch --generate-key /tmp/gpg_gen_key_script
      rm /tmp/gpg_gen_key_script
      
      # 作成されたキーのIDを取得
      NEW_KEY=$(gpg --list-secret-keys --keyid-format=long | grep -B2 "$USER_EMAIL" | grep "sec" | awk '{print $2}' | cut -d'/' -f2 | head -1)
      
      if [ -n "$NEW_KEY" ]; then
        echo "✅ GPGキーを作成しました: $NEW_KEY"
        
        # Gitの署名キー設定
        git config --global user.signingkey "$NEW_KEY"
        echo "Git署名キーを設定しました: $NEW_KEY"
        
        # GitHubにキーを登録
        echo "GitHubにGPGキーを登録しています..."
        gpg --armor --export "$NEW_KEY" | gh gpg-key add -
        echo "✅ GitHubにGPGキーを登録しました。"
      else
        echo "❌ GPGキーの作成に失敗しました。"
        return 1
      fi
    else
      echo "GPGキーの作成をスキップしました。"
      echo ""
      echo "📝 手動でGPGキーを設定する場合："
      echo "  1. GPGキーを作成: gpg --full-generate-key"
      echo "  2. キーIDを確認: gpg --list-secret-keys --keyid-format=long"
      echo "  3. 署名キーを設定: git config --global user.signingkey YOUR_KEY_ID"
      echo "  4. GitHubに登録: gpg --armor --export YOUR_KEY_ID | gh gpg-key add -"
    fi
  fi
  
  # 現在の設定を表示
  echo ""
  echo "📋 現在のGPG設定:"
  echo "  - 署名キー: $(git config --global user.signingkey || echo '未設定')"
  echo "  - 自動署名: $(git config --global commit.gpgsign || echo '無効')"
  if command -v gh &> /dev/null && gh auth status &> /dev/null; then
    echo "  - GitHub登録済みキー:"
    gh gpg-key list 2>/dev/null | grep -E "Key ID:|Added:" | sed 's/^/    /'
  fi
}

# GPGキーの自動設定を実行
setup_gpg_key

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

echo ""
echo "✅ Git の設定が完了しました！"
