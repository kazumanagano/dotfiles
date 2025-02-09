# プロンプトの設定（Git プロンプトを有効化）
setopt PROMPT_SUBST
source ~/.git-prompt.sh
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

# パスの設定（Homebrew のパスを優先）
typeset -U path PATH
path=(
    /opt/homebrew/bin(N-/)
    /usr/local/bin(N-/)
    $path
)

# `=` 記号を使った変数代入の補完
setopt magic_equal_subst

# 履歴設定
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt inc_append_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups

# Zsh プラグインの有効化
if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# git sqript
export PATH=$PATH:~/local/bin
