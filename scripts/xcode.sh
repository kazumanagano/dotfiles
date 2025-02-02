#!/bin/bash

echo "Xcode のセットアップ..."

if ! xcodes list &> /dev/null; then
  echo "⚠️ Xcodes にログインする必要があります。Xcodes.app を開いて Apple ID でログインしてください。"
  open -a "Xcodes"
  
  osascript -e 'tell app "System Events" to display dialog "Xcodes.app で Apple ID にログインしてください。\nログイン完了後に OK を押してください。" buttons {"OK"} default button "OK"'

  until xcodes list &> /dev/null; do
    echo "Xcodes にログインが完了していません。ログインを確認中..."
    sleep 5
  done
fi

xcodes update
LATEST_XCODE=$(xcodes list --latest)
xcodes install "$LATEST_XCODE" --experimental-unxip --latest
xcodes select "$LATEST_XCODE"

sudo xcodebuild -license accept
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

echo "Xcode のセットアップが完了しました！"
