# dotfiles

Personal dotfiles managed with [dotbot](https://github.com/anishathalye/dotbot).

## Install

```bash
git clone --recursive https://github.com/pmaloo/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install
```

## Multi-platform support

All shell configs (`zshrc`, `bashrc`, `functions`, `gitconfig`) are platform-aware using `$OSTYPE` detection. A single set of files works on both macOS and Linux — no need for separate branches or profiles.

| Concern | macOS | Linux |
|---------|-------|-------|
| Homebrew | `/opt/homebrew` | `/home/linuxbrew/.linuxbrew` |
| Opener | `open` | `xdg-open` |
| Kiro CLI | `~/Library/Application Support/kiro-cli/` | `~/.local/share/kiro-cli/` |
| Brazil | `/Users/pmaloo/.brazil_completion/` | `/home/pmaloo/.brazil_completion/` |
| Casks in Brewfile | Installed | Skipped automatically |

## What's included

| File | Purpose |
|------|---------|
| `zshrc` | ZSH config (Oh My Zsh, pyenv, mise, brew — platform-aware) |
| `bashrc` | Bash config (platform-aware) |
| `vimrc` | Vim config with vim-plug plugins |
| `aliases` | Shared shell aliases (ls, navigation, brazil) |
| `functions` | Shared shell functions (mkd, o — platform-aware) |
| `gitconfig` | Git settings (rebase, autosquash, vimdiff, gh credential) |
| `gitignore` | Global gitignore patterns |
| `Brewfile` | Homebrew packages, casks, and taps |
| `Vscodefile` | VS Code extensions |

## Plugins

| Plugin | Purpose |
|--------|---------|
| [dotbot-brew](https://github.com/d12frosted/dotbot-brew) | Install Homebrew packages/casks from `Brewfile` |
| [dotbot-vscode](https://github.com/hujianxin/dotbot-vscode) | Sync VS Code extensions from `Vscodefile` |
| [crontab-dotbot](https://github.com/fundor333/crontab-dotbot) | Manage cron jobs declaratively |

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

### Adding a Homebrew package

Add a line to `Brewfile`:

```
brew "ripgrep"
cask "iterm2"
```

Then run `./install` to install it.

### Adding a VS Code extension

```bash
code --list-extensions > ~/dotfiles/Vscodefile
./install
```

### Adding a cron job

Uncomment and edit the `crontab` section in `install.conf.yaml`:

```yaml
- crontab:
  - cron: "0 2 * * *"
    command: /path/to/backup.sh
    comment: nightly backup
```

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
