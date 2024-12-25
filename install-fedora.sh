#!/bin/bash

set -eu

sudo dnf update -y

# console utils
sudo dnf install -y stow \
    git tig \
    eza fd-find fzf tmux zoxide \
    btop htop \
    bat nano jq \
    zsh

# gui apps
sudo dnf install -y alacritty solaar

# fetch tools not present in fedora repos
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ ! -d "$HOME/.local/share/fnm" ]; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/share/fnm" --skip-shell
fi

# apply dotfiles
stow zsh \
    alacritty

# change shell
if [ ! "$SHELL" == "/usr/bin/zsh" ]; then
    chsh -s /usr/bin/zsh
fi
