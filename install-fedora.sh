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

# gui DNF apps
sudo dnf install -y alacritty solaar

# fetch tools not present in fedora repos
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [ ! -d "$HOME/.local/share/fnm" ]; then
    curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir "$HOME/.local/share/fnm" --skip-shell
fi

# apply dotfiles
echo "Applying dotfiles"
stow zsh \
    alacritty

# change shell
if [ ! "$SHELL" == "/usr/bin/zsh" ]; then
    echo "Changing shell to ZSH"
    chsh -s /usr/bin/zsh
fi

# install additional apps outside of fedora repos
# VS Code
if ! command -v code -v 2>&1 >/dev/null; then
    echo "Installing VS Code"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
    dnf check-update
    sudo dnf install code
else
    echo "VS Code is already installed"
fi

# Tailscale
if ! command -v tailscale --version 2>&1 >/dev/null; then
    sudo dnf config-manager addrepo --overwrite --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
    sudo dnf install tailscale
    sudo systemctl enable --now tailscaled
    sudo tailscale up
else
    echo "Tailscale is already installed"
fi

# Zed.dev
if ! command -v zed --version 2>&1 >/dev/null; then
    curl -f https://zed.dev/install.sh | sh
else
    echo "Zed is already installed"
fi