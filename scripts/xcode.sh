#!/bin/bash

echo "Xcode のセットアップ..."

# Xcodesが使えない環境ではスキップ
# if ! xcodes list &> /dev/null; then
#   echo "⚠️ Xcodes にログインする必要があります。Xcodes.app を開いて Apple ID でログインしてください。"
#   open -a "Xcodes"
  
#   osascript -e 'tell app "System Events" to display dialog "Xcodes.app で Apple ID にログインしてください。\nログイン完了後に OK を押してください。" buttons {"OK"} default button "OK"'

#   until xcodes list &> /dev/null; do
#     echo "Xcodes にログインが完了していません。ログインを確認中..."
#     sleep 5
#   done
# fi

# xcodes update
# LATEST_XCODE=$(xcodes list --latest)
# xcodes install "$LATEST_XCODE" --experimental-unxip --latest
# xcodes select "$LATEST_XCODE"

# sudo xcodebuild -license accept
# sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# Xcode のフィンガープリント検証をスキップ
echo "Xcode のパッケージプラグイン & マクロのフィンガープリント検証をスキップ..."
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES
defaults write com.apple.dt.Xcode IDESkipMacroFingerprintValidation -bool YES

# 複数のプロジェクトを同時に開いていた際に、再起動時に前回の状態を復元されると困るので無効化
defaults write com.apple.dt.Xcode ApplePersistenceIgnoreState YES

echo "Xcode のセットアップが完了しました！"
