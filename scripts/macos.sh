#!/bin/bash

echo "macOS のシステム設定を適用..."

# キーボードのキーリピート速度を高速化
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

# Dock の表示/非表示を高速化
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-time-modifier -float 0.3
defaults write com.apple.dock autohide-delay -float 0
killall Dock &> /dev/null || echo "⚠️ Dock は起動していません。"

# Mission Control のアニメーションを短縮
defaults write com.apple.dock expose-animation-duration -float 0.1
killall Dock &> /dev/null || echo "⚠️ Dock は起動していません。"

# スクリーンショットの保存先を ~/Screenshots に変更
mkdir -p "$HOME/Screenshots"
defaults write com.apple.screencapture location "$HOME/Screenshots"
killall SystemUIServer

# タップでクリックを有効化
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3

echo "macOS の設定を適用しました！"
