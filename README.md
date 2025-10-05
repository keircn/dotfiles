# My Dotfiles

## Dependencies

I use GNU stow to symlink my dotfiles and sync them to the git repo

```
# i use arch btw
sudo pacman -S --needed git stow bash # these are the only required dependencies
```

## Installation

```
git clone git@github.com:keircn/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
./setup.sh
```

If you have conflicting files/directories, they will be skipped
