# dotfiles

Personal dotfiles managed with [dotbot](https://github.com/anishathalye/dotbot).

## Install

```bash
git clone --recursive https://github.com/pmaloo/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./install
brew bundle --file=~/dotfiles/Brewfile
```

## Structure

```
├── Personal (portable)
│   ├── aliases, functions, zshrc, bashrc, vimrc, tmux.conf, p10k.zsh
│   ├── gitconfig, gitignore
│   ├── Brewfile, Vscodefile
│   └── docs/mac.md
│
├── Work (unlink/delete when leaving)
│   ├── work              → ~/.work
│   ├── gitconfig-work    → ~/.gitconfig-work
│   ├── Brewfile.work
│   ├── scripts/bootstrap-cloud-desktop.sh
│   └── docs/work/
│       ├── cloud-desktop.md
│       ├── midway.md
│       └── meshclaw.md
│
└── Meta
    ├── install.conf.yaml (dotbot symlinks)
    ├── dotbot/, dotbot-brew/, dotbot-vscode/ (submodules)
    └── this README
```

## Multi-platform support

All shell configs are platform-aware using `$OSTYPE` detection. A single set of files works on both macOS and Linux.

| Concern | macOS | Linux |
|---------|-------|-------|
| Homebrew | `/opt/homebrew` | `/home/linuxbrew/.linuxbrew` |
| Opener | `open` | `xdg-open` |
| Kiro CLI | `~/Library/Application Support/kiro-cli/` | `~/.local/share/kiro-cli/` |
| Brazil completion | macOS path | Linux path |
| Casks in Brewfile | Installed | Skipped automatically |

## Cloud Desktop Bootstrap

```bash
mwinit -o && toolbox install toolbox
curl -sL https://raw.githubusercontent.com/pmaloo/dotfiles/master/scripts/bootstrap-cloud-desktop.sh | bash
```

## Portability: personal vs work

All work-specific config is isolated:

| File | Purpose | On exit |
|------|---------|---------|
| `work` → `~/.work` | Work aliases, functions, PATH | Unlink |
| `gitconfig-work` → `~/.gitconfig-work` | Work email + credentials | Unlink |
| `Brewfile.work` | Work-only brew packages | Delete |
| `scripts/` | Work bootstrap scripts | Delete |
| `docs/work/` | Work setup documentation | Delete |

Machine-specific secrets (hostnames, credentials) go in `~/.local-env` (not tracked), which `work` sources automatically.

## What's included

| File | Purpose |
|------|---------|
| `zshrc` | ZSH config (Oh My Zsh, pyenv, mise, brew — platform-aware) |
| `bashrc` | Bash config (platform-aware) |
| `vimrc` | Vim config with vim-plug plugins |
| `aliases` | Shell aliases (eza, git, navigation) |
| `functions` | Shell functions (mkd, o — platform-aware) |
| `gitconfig` | Git settings (rebase, delta, gh credential) |
| `gitignore` | Global gitignore patterns |
| `tmux.conf` | tmux config |
| `p10k.zsh` | Powerlevel10k prompt config |
| `Brewfile` | Personal Homebrew packages, casks, VS Code extensions |
| `Vscodefile` | VS Code extensions (legacy, now in Brewfile) |

## Plugins

| Plugin | Purpose |
|--------|---------|
| [dotbot-brew](https://github.com/d12frosted/dotbot-brew) | Install Homebrew packages from `Brewfile` |
| [dotbot-vscode](https://github.com/hujianxin/dotbot-vscode) | Sync VS Code extensions from `Vscodefile` |
| [crontab-dotbot](https://github.com/fundor333/crontab-dotbot) | Manage cron jobs declaratively |

## Common tasks

### Adding a new dotfile

1. Move into the repo: `cp ~/.tmux.conf ~/dotfiles/tmux.conf`
2. Add to `install.conf.yaml`: `~/.tmux.conf: tmux.conf`
3. Run `./install`

### Adding a Homebrew package

```bash
brew install <pkg>
# Add to Brewfile (personal) or Brewfile.work (work-specific)
```

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

### Update on another machine

```bash
cd ~/dotfiles && git pull && ./install
brew bundle --file=~/dotfiles/Brewfile
```

## Dotbot reference (`install.conf.yaml`)

All symlink mappings are defined in `install.conf.yaml`:

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

```yaml
- shell:
    - [git submodule update --init --recursive, Installing submodules]
    - [vim +PlugInstall +qall, Installing vim plugins]
```

Full dotbot docs: https://github.com/anishathalye/dotbot#configuration
