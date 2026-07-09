# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Kiro CLI pre block. Keep at the top of this file.
if [[ "$OSTYPE" == darwin* ]]; then
  [[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
else
  [[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# fzf plugin needs FZF_BASE set before oh-my-zsh loads
if [[ "$OSTYPE" == darwin* ]]; then
  export FZF_BASE="/opt/homebrew/opt/fzf"
else
  export FZF_BASE="/home/linuxbrew/.linuxbrew/opt/fzf"
fi

plugins=(
  git
  fzf
  command-not-found
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

# Load aliases and functions
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.functions ] && source ~/.functions
[ -f ~/.work ] && source ~/.work

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

# Modern CLI tools
alias cat='bat --paging=never'
alias grep='rg'
alias find='fd'
alias diff='delta'

# zoxide (smarter cd)
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# fzf config
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "bat --style=numbers --color=always --line-range :200 {}" --bind "ctrl-/:toggle-preview"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# git-delta as git pager
export GIT_PAGER='delta'

# Kiro CLI post block. Keep at the bottom of this file.
if [[ "$OSTYPE" == darwin* ]]; then
  [[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
else
  [[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export AWS_PROFILE=notebook

# Added by AIM CLI
export PATH="/local/home/pmaloo/.aim/mcp-servers:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="/home/pmaloo/.local/node20/bin:$HOME/.toolbox/bin:$PATH"
