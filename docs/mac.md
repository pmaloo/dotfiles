# Mac Setup

**Platform:** macOS Apple Silicon
**Dotfiles:** https://github.com/pmaloo/dotfiles

## Bootstrap

On a fresh Mac (after Xcode CLI tools + Homebrew are installed):

```bash
git clone --recursive https://github.com/pmaloo/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install
brew bundle --file=~/dotfiles/Brewfile
```

The `./install` script (dotbot) symlinks configs:

| Symlink | Target |
|---|---|
| `~/.bashrc` | `dotfiles/bashrc` |
| `~/.zshrc` | `dotfiles/zshrc` |
| `~/.vimrc` | `dotfiles/vimrc` |
| `~/.aliases` | `dotfiles/aliases` |
| `~/.functions` | `dotfiles/functions` |
| `~/.gitconfig` | `dotfiles/gitconfig` |
| `~/.gitconfig-work` | `dotfiles/gitconfig-work` (unlink when leaving) |
| `~/.gitignore` | `dotfiles/gitignore` |
| `~/.work` | `dotfiles/work` (unlink when leaving) |
| `~/.tmux.conf` | `dotfiles/tmux.conf` |
| `~/.p10k.zsh` | `dotfiles/p10k.zsh` |
| `~/.wakeup` | `dotfiles/wakeup` (sleepwatcher hook) |

## Shell

- **zsh** with oh-my-zsh + Powerlevel10k
- Plugins: git, fzf, zsh-syntax-highlighting, zsh-autosuggestions
- Modern CLI aliases: `bat` (cat), `eza` (ls), `fd` (find), `rg` (grep), `delta` (diff), `zoxide` (cd)

## Package Management

- `brew bundle --file=~/dotfiles/Brewfile` installs everything
- After installing anything new: add to `Brewfile`, commit, push
- `pyenv` for Python versions, `rbenv` for Ruby, `mise` for polyglot runtimes
- `nvm` for Node.js versions (installed via its own curl script, not brew)

## Key Tools

| Tool | Purpose |
|---|---|
| fzf | Fuzzy finder (Ctrl+R history, Ctrl+T files) |
| bat | Syntax-highlighted cat |
| eza | Modern ls with git status |
| fd | Fast find alternative |
| ripgrep | Fast grep |
| delta | Git diff viewer |
| zoxide | Smart cd (frecency-based) |
| tmux | Terminal multiplexer |
| htop | Process viewer |
| tldr | Simplified man pages |

## VS Code

Extensions tracked in `Brewfile` (vscode entries). Install with:
```bash
brew bundle --file=~/dotfiles/Brewfile
```

## Notes

- `cat` is aliased to `bat` — use `/bin/cat` for raw output
- `grep` is aliased to `rg` — use `/usr/bin/grep` for POSIX grep
- `find` is aliased to `fd` — use `/usr/bin/find` for POSIX find
- LaunchAgents need **full paths** (no `~` or `$HOME` expansion)
- Dotbot handles symlinks idempotently — safe to re-run `./install`
