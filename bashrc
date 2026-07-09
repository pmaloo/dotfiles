
# Kiro CLI pre block. Keep at the top of this file.
if [[ "$OSTYPE" == darwin* ]]; then
  [[ -f "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.pre.bash"
else
  [[ -f "${HOME}/.local/share/kiro-cli/shell/bashrc.pre.bash" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/bashrc.pre.bash"
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Load aliases and functions
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.functions ] && source ~/.functions

# Toolbox & Homebrew
export PATH=$PATH:$HOME/.toolbox/bin
if [[ "$OSTYPE" == darwin* ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  [[ -d /home/linuxbrew/.linuxbrew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# Brazil
if [[ "$OSTYPE" == darwin* ]]; then
  [[ -f /Users/pmaloo/.brazil_completion/bash_completion ]] && source /Users/pmaloo/.brazil_completion/bash_completion
else
  [[ -f /home/pmaloo/.brazil_completion/bash_completion ]] && source /home/pmaloo/.brazil_completion/bash_completion
  alias finch='sudo HOME=/home/pmaloo DOCKER_CONFIG=/home/pmaloo/.docker finch'
fi

# LM Studio (macOS only)
[[ "$OSTYPE" == darwin* ]] && export PATH="$PATH:$HOME/.lmstudio/bin"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"

# Added by AIM CLI
export PATH="$HOME/.aim/mcp-servers:$PATH"

# Kiro CLI post block. Keep at the bottom of this file.
if [[ "$OSTYPE" == darwin* ]]; then
  [[ -f "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.post.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.post.bash"
else
  [[ -f "${HOME}/.local/share/kiro-cli/shell/bashrc.post.bash" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/bashrc.post.bash"
fi

# Added by AIM CLI
export PATH="/local/home/pmaloo/.aim/mcp-servers:$PATH"
