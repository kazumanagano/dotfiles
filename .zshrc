# =======================
# Git のプロンプト設定
# =======================

# git-prompt の読み込み
if [ -f ~/.zsh/git-prompt.sh ]; then
  source ~/.zsh/git-prompt.sh
else
  echo "⚠️ git-prompt.sh が ~/.zsh ディレクトリに見つかりません。"
fi

# git-completion の読み込み
if [ -f ~/.zsh/git-completion.bash ]; then
  fpath=(~/.zsh $fpath)
  zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
  autoload -Uz compinit && compinit
else
  echo "⚠️ git-completion.bash が ~/.zsh ディレクトリに見つかりません。"
fi

# =======================
# Git プロンプト表示設定
# =======================
setopt PROMPT_SUBST
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto

export PROMPT="%F{green}${USER}:%f%F{blue}%(5~|%-1~/…/%3~|%4~)%f%F{red}\$(__git_ps1)%f
%F{yellow}%(!.#.$) %F{white}"

# 補完機能の設定
autoload -Uz compinit && compinit -u
fpath=(~/.zsh $fpath)

# Vagrant の補完設定
fpath=(/opt/vagrant/embedded/gems/2.2.10/gems/vagrant-2.2.10/contrib/zsh $fpath)

# 大文字小文字を区別しない補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# `=` 記号を使った変数代入の補完
setopt magic_equal_subst

# 履歴設定
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups

# =======================
# プラグインの有効化 (autocompletion)
# =======================
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# git sqript
export PATH=$PATH:~/local/bin

# GPG
export GPG_TTY=$(tty)

eval "$(/opt/homebrew/bin/brew shellenv)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/kazumanagano/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/kazumanagano/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/kazumanagano/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/kazumanagano/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

. "$HOME/.local/bin/env"

# Claude Code Tip commands setup
if [ -f "$HOME/.claude/scripts/tip_commands/setup_tip_env.sh" ]; then
    source "$HOME/.claude/scripts/tip_commands/setup_tip_env.sh"
fi
