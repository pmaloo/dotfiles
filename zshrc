
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.pre.zsh"

export BRAZIL_WORKSPACE_DEFAULT_LAYOUT=short

export AUTO_TITLE_SCREENS="NO"

# if you wish to use IMDS set AWS_EC2_METADATA_DISABLED=false
export AWS_EC2_METADATA_DISABLED=true

export PROMPT="
%{$fg[white]%}(%D %*) <%?> [%~] $program %{$fg[default]%}
%{$fg[cyan]%}%m %#%{$fg[default]%} "

export RPROMPT=

set-title() {
    echo -e "\e]0;$*\007"
}

ssh() {
    set-title $*;
    /usr/bin/ssh -2 $*;
    set-title $HOST;
}

# Load aliases and functions
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.functions ] && source ~/.functions


export PATH=$HOME/.toolbox/bin:$PATH
autoload -Uz compinit && compinit

# Set up mise for runtime management
eval "$(/home/pmaloo/.local/bin/mise activate zsh)"
source ~/.local/share/mise/completions.zsh
source /home/pmaloo/.brazil_completion/zsh_completion
alias finch='sudo HOME=/home/pmaloo DOCKER_CONFIG=/home/pmaloo/.docker finch'
export PATH=$HOME/.toolbox/bin:$PATH

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

# Added by AIM CLI
export PATH="/local/home/pmaloo/.aim/mcp-servers:$PATH"


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/zshrc.post.zsh"
