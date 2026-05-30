
# Kiro CLI pre block. Keep at the top of this file.
if [[ "$OSTYPE" == darwin* ]]; then
  [[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
else
  [[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="gozilla"

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Load aliases and functions
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.functions ] && source ~/.functions

# Terminal title helpers
set-title() {
    echo -e "\e]0;$*\007"
}

ssh() {
    set-title $*;
    /usr/bin/ssh -2 $*;
    set-title $HOST;
}

# pyenv
export PATH="$PATH:$HOME/.local/bin"
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv &>/dev/null && eval "$(pyenv init - zsh)"

# Toolbox & Homebrew
export PATH=$PATH:$HOME/.toolbox/bin
if [[ "$OSTYPE" == darwin* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  [[ -d /home/linuxbrew/.linuxbrew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

# mise
command -v mise &>/dev/null && eval "$(mise activate zsh)"

# Brazil
if [[ "$OSTYPE" == darwin* ]]; then
  [[ -f /Users/pmaloo/.brazil_completion/zsh_completion ]] && source /Users/pmaloo/.brazil_completion/zsh_completion
else
  export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short
  [[ -f /home/pmaloo/.brazil_completion/zsh_completion ]] && source /home/pmaloo/.brazil_completion/zsh_completion
fi

# Linux-specific
if [[ "$OSTYPE" != darwin* ]]; then
  export AUTO_TITLE_SCREENS="NO"
  export AWS_EC2_METADATA_DISABLED=true
  alias finch='sudo HOME=/home/pmaloo DOCKER_CONFIG=/home/pmaloo/.docker finch'
fi

# LM Studio (macOS only)
[[ "$OSTYPE" == darwin* ]] && export PATH="$PATH:$HOME/.lmstudio/bin"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Added by AIM CLI
export PATH="$HOME/.aim/mcp-servers:$PATH"

# Kiro CLI post block. Keep at the bottom of this file.
if [[ "$OSTYPE" == darwin* ]]; then
  [[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
else
  [[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh"
fi
