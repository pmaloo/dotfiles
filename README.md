# dotfiles

Personal dotfiles managed with [dotbot](https://github.com/anishathalye/dotbot).

## Install

```bash
git clone --recursive https://github.com/pmaloo/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install
```

## What's included

| File | Purpose |
|------|---------|
| `zshrc` | ZSH config (prompt, PATH, completions, mise) |
| `bashrc` | Bash config |
| `vimrc` | Vim config with vim-plug plugins |
| `aliases` | Shared shell aliases (ls, navigation, brazil) |
| `functions` | Shared shell functions (mkd, o) |
| `gitconfig` | Git settings (rebase, merge, editor) |
| `gitignore` | Global gitignore patterns |

## Update

After making changes:

```bash
cd ~/dotfiles
git add -A && git commit -m "description"
git push
```

On another machine:

```bash
cd ~/dotfiles
git pull && ./install
```
