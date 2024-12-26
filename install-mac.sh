#!/bin/bash

set -eu

# will do "xcode-select --install" during its install
if [ ! -d "/opt/homebrew" ]; then
    echo "Installing brew"
    /bin/bash -c "sudo NONINTERACTIVE=1 $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh-My-ZSH"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# install stow and apply dotfiles
echo "Installing stow and applying dotfiles"
brew install stow
if [ -d "$HOME/.dotfiles" ]; then
    cd $HOME/.dotfiles
    git pull --rebase
else
    git clone https://github.com/petrmiko/dotfiles.git $HOME/.dotfiles
    rm $HOME/.zprofile $HOME/.zshrc || true
    cd $HOME/.dotfiles
    stow alacritty git zsh
fi

# install remaining dependencies
echo "Installing remaining brew dependencies"
brew bundle install || true

# Rust
if ! command -v rustup --version 2>&1 >/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
    echo "Rust is already installed"
fi

echo "Done. Open a new terminal to see the changes."