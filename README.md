# My Dotfiles

## Dependencies

I use GNU stow to symlink my dotfiles and sync them to the git repo

```
# i use arch btw
sudo pacman -S --needed go git
```

## Installation

```
git clone git@github.com:keircn/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
go build -o setup setup.go
./setup
```
