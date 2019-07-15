# dotfiles

Source: https://www.atlassian.com/git/tutorials/dotfiles

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
config commit -m "Add vimrc"
config push
```
**Install on a new system**
