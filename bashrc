
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/bashrc.pre.bash" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/bashrc.pre.bash"

# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions

export PATH=$HOME/.toolbox/bin:$PATH
source /home/pmaloo/.brazil_completion/bash_completion
. "$HOME/.cargo/env"
alias finch='sudo HOME=/home/pmaloo DOCKER_CONFIG=/home/pmaloo/.docker finch'

# Added by AIM CLI
export PATH="/local/home/pmaloo/.aim/mcp-servers:$PATH"


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/.local/share/kiro-cli/shell/bashrc.post.bash" ]] && builtin source "${HOME}/.local/share/kiro-cli/shell/bashrc.post.bash"
