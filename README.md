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

## Managing symlinks (`install.conf.yaml`)

All symlink mappings are defined in `install.conf.yaml`. Dotbot reads this file and creates symlinks from your home directory to the repo.

```yaml
- defaults:
    link:
      relink: true   # replace existing symlinks pointing elsewhere
      force: true    # remove existing regular files/dirs before linking

- clean: ['~']      # remove dead symlinks in ~

- link:
    ~/.zshrc: zshrc  # target_path: source_file_in_repo

- shell:
    - [git submodule update --init --recursive, Installing submodules]
```

### Adding a new dotfile

1. Copy or move the file into the repo: `cp ~/.tmux.conf ~/dotfiles/tmux.conf`
2. Add a link entry to `install.conf.yaml`:
   ```yaml
   ~/.tmux.conf: tmux.conf
   ```
3. Run `./install` to create the symlink

### Linking a directory

```yaml
~/.config/nvim: nvim  # links entire directory
```

### Conditional links (OS-specific)

```yaml
~/.config/ghostty:
  path: ghostty
  if: '[ `uname` = Linux ]'
  force: true
```

### Shell commands

Add post-install commands under `shell`:

```yaml
- shell:
    - [git submodule update --init --recursive, Installing submodules]
    - [vim +PlugInstall +qall, Installing vim plugins]
```

### Reference

Full dotbot docs: https://github.com/anishathalye/dotbot#configuration

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
