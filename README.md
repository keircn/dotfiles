# My Dotfiles

## Dependencies

I use GNU stow to symlink my dotfiles and sync them to the git repo

```
# i use arch btw
sudo pacman -S --needed git stow
```

## Installation

```
git clone git@github.com:keircn/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
stow .
```
