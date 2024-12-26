#!/bin/bash

# Tailscale
if ! command -v xcode-select -p 2>&1 >/dev/null; then
    echo "Installing XCode Commandline Tools"
    sudo xcode-select --install
else
    echo "XCode Commandline Tools are already installed"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ ! -d "/opt/homebrew" ]; then
    /bin/bash -c "NONINTERACTIVE=1 $(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

stow alacritty git zsh
brew bundle install