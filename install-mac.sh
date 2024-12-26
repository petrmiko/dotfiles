#!/bin/bash

set -eu

# will do "xcode-select --install" during its install
if [ ! -d "/opt/homebrew" ]; then
    /bin/bash -c "sudo NONINTERACTIVE=1 $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

brew bundle install

git clone https://github.com/petrmiko/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
stow alacritty git zsh
