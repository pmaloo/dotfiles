# dotfiles

Source: https://www.atlassian.com/git/tutorials/dotfiles

Make sure to put everything particular to a system in `.extra`

**Create the repository**
```
git init --bare $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
echo "alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.bash_profile
```
**Add files**
```
config status
config add .vimrc
config commit -m "added vimrc"
config push
```
**Install on a new system**
```
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
echo ".dotfiles" >> .gitignore
git clone --bare <git-repo-url> $HOME/.dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
#backup current dotfiles (below) or remove them before checkout
config checkout  
```

**Backup current dotfiles to a folder before checkout**
```
mkdir -p .dotfiles-backup && \
config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .dotfiles-backup/{}
```
