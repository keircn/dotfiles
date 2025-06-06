# My Dotfiles

## Dependencies

I use GNU stow to manage my dots, which is a dependency. Git is obviously needed too.

```
pacman -S --needed git stow
```

## Installation

```
cd $HOME
git clone git@github.com:keircn/dotfiles.git
cd dotfiles
# then symlink the configs
stow .
```
