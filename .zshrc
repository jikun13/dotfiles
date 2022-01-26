export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh

# zshのフレームワーク
zplug "sorin-ionescu/prezto"
# prezto plugins
zplug "modules/environment", from:prezto
zplug "modules/terminal", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/history", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/spectrum", from:prezto
#zplug "modules/utility", from:prezto
zplug "modules/completion", from:prezto
zplug "modules/prompt", from:prezto

zplug "plugins/git", from:oh-my-zsh
 
# 履歴から補完
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2

zplug "b4b4r07/enhancd", use:init.sh

if ! zplug check --verbose; then
  printf 'Install? [y/N]: '
  if read -q; then
    echo; zplug install
  fi
fi
zplug load --verbose

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# update_ssh
update_ssh_config () {
    LF=$(printf '\\\012_');
    LF=${LF%_};
    aws ec2 describe-instances --filter "Name=instance-state-name,Values=running" | jq '.Reservations[].Instances[]  | {name: (.Tags[] | select(.Key == "Name") | .Value), ip: .PublicIpAddress} | "Host " + .name ' | sed -e "s/\"//g" | sed -e "s/\\\\r/"$LF"/g" >! ~/.ssh/hosts/instances;
    cat ~/.ssh/hosts/base ~/.ssh/hosts/instances >! ~/.ssh/config;
}

# ヒストリサイズ
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# alias
alias la='ls -a'
alias ll='ls -ltr'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
alias tmls='tmux ls'
alias tmt='tmux a -t'
alias gr='cd git-root'
alias tig='tig status'
alias gpc='git p'
alias gbr='git br -a'
alias gsm='git switch master'
alias gip='git pull'
alias gsc='git switch -c'
alias gsw='git switch'
alias dmb='git dmb'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# pyenv
#if command -v pyenv 1>/dev/null 2>&1; then
#  eval "$(pyenv init -)"
#fi

# rbenv
[[ -d ~/.rbenv  ]] && \
export PATH=${HOME}/.rbenv/bin:${PATH} && \
eval "$(rbenv init -)"

# goenv
export GOPATH="$HOME/go"
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/bin:$PATH"
eval "$(goenv init -)"
export PATH="$GOROOT/bin:$PATH"
export PATH="$PATH:$GOPATH/bin"

#[[ -d ~/go/bin  ]] && \
#  export PATH=${HOME}/go/bin:${PATH} 

export PKG_CONFIG_PATH="/opt/homebrew/opt/libffi/lib/pkgconfig"

## Android SDK location
export PATH=$PATH:/Users/junki/Library/Android/sdk/platform-tools

export PATH=$PATH:$HOME/.pub-cache/bin:/usr/local/sessionmanagerplugin/bin
eval "$(direnv hook zsh)"
